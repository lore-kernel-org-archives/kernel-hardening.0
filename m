Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu,  3 Oct 2013 13:53:23 -0700
Message-Id: <1380833605-26313-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1380833605-26313-1-git-send-email-keescook@chromium.org>
References: <1380833605-26313-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 5/7] x86, kaslr: select memory region from e820 maps
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Counts available alignment positions across all e820 maps, and chooses
one randomly for the new kernel base address.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
 - make sure to exclude e820 regions outside the 32-bit memory range.
---
 arch/x86/boot/compressed/aslr.c |  140 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 130 insertions(+), 10 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 5bb7c63..83aee8b 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -2,6 +2,7 @@
 
 #ifdef CONFIG_RANDOMIZE_BASE
 #include <asm/msr.h>
+#include <asm/e820.h>
 #include <asm/archrandom.h>
 
 #define I8254_PORT_CONTROL	0x43
@@ -102,6 +103,130 @@ static unsigned long find_minimum_location(unsigned long input,
 	return output;
 }
 
+/*
+ * This routine is used to count how many aligned slots that can hold the
+ * kernel exist across all e820 entries. It is called in two phases, once
+ * to count valid memory regions available for the kernel image, and a
+ * second time to select one from those seen.
+ *
+ * It is first called with "counting" set to true, where it expects to be
+ * called once for each e820 entry. In this mode, it will update *count
+ * with how many slots are available in the given e820 entry. Once the walk
+ * across all e820 entries has finished, the caller will have a total count
+ * of all valid memory regions available for the kernel image.
+ *
+ * Once the first pass of entry walking is finished, the caller selects one
+ * of the possible slots (stored in *count), and performs a second walk,
+ * with "counting" set to false. In this mode, *count is decremented until
+ * the corresponding slot is found in a specific e820 region, at which
+ * point, the function returns that address, and the walk terminates.
+ */
+static unsigned long process_e820_entry(struct e820entry *entry, bool counting,
+					unsigned long minimum,
+					unsigned long image_size,
+					unsigned long *count)
+{
+	u64 addr, size;
+	unsigned long alignments;
+
+	/* Skip non-RAM entries. */
+	if (entry->type != E820_RAM)
+		return 0;
+
+	/* Ignore entries entirely above our maximum. */
+	if (entry->addr >= CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+		return 0;
+
+	/* Ignore entries entirely below our minimum. */
+	if (entry->addr + entry->size < minimum)
+		return 0;
+
+	size = entry->size;
+	addr = entry->addr;
+
+	/* Potentially raise address to minimum location. */
+	if (addr < minimum)
+		addr = minimum;
+
+	/* Potentially raise address to meet alignment requirements. */
+	addr = ALIGN(addr, CONFIG_PHYSICAL_ALIGN);
+
+	/* Did we raise the address above the bounds of this e820 region? */
+	if (addr > entry->addr + entry->size)
+		return 0;
+
+	/* Reduce size by any delta from the original address. */
+	size -= addr - entry->addr;
+
+	/* Reduce maximum image starting location to maximum limit. */
+	if (addr + size > CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
+		size = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - addr;
+
+	/* Ignore entries that cannot hold even a single kernel image. */
+	if (size < image_size)
+		return 0;
+
+	/*
+	 * Reduce size by kernel image size so we can see how many aligned
+	 * starting addresses will fit without running past the end of a
+	 * region. XXX: adjacent e820 regions are not detected, so up to
+	 * image_size / CONFIG_PHYSICAL_ALIGN slots may go unused across
+	 * adjacent regions.
+	 */
+	size -= image_size;
+
+	/* Now we know how many aligned slots can contain the image. */
+	alignments = (size / CONFIG_PHYSICAL_ALIGN) + 1;
+
+	/* In the first pass, just counting all the e820 entries? */
+	if (counting) {
+		*count += alignments;
+		return 0;
+	}
+
+	/* Otherwise we're counting down to find a specific aligned slot. */
+	if (*count < alignments) {
+		/* Desired region is in this entry. */
+		return addr + (CONFIG_PHYSICAL_ALIGN * *count);
+	} else {
+		/* Desired region is beyond this entry. */
+		*count -= alignments;
+		return 0;
+	}
+}
+
+static unsigned long find_random_e820(unsigned long minimum,
+				      unsigned long size)
+{
+	int i;
+	unsigned long addr, count;
+
+	/* Make sure minimum is aligned. */
+	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
+
+	/* Verify potential e820 positions. */
+	count = 0;
+	for (i = 0; i < real_mode->e820_entries; i++) {
+		process_e820_entry(&real_mode->e820_map[i], true, minimum,
+				   size, &count);
+	}
+
+	/* Handle crazy case of nothing fitting. */
+	if (count == 0)
+		return 0;
+
+	count = get_random_long() % count;
+
+	/* Select desired e820 position. */
+	for (i = 0; i < real_mode->e820_entries; i++) {
+		addr = process_e820_entry(&real_mode->e820_map[i], false,
+					  minimum, size, &count);
+		if (addr)
+			return addr;
+	}
+	return 0;
+}
+
 unsigned char *choose_kernel_location(unsigned char *input,
 				      unsigned long input_size,
 				      unsigned char *output,
@@ -118,16 +243,11 @@ unsigned char *choose_kernel_location(unsigned char *input,
 	choice = find_minimum_location((unsigned long)input, input_size,
 				       (unsigned long)output, output_size);
 
-	/* XXX: Find an appropriate E820 hole, instead of adding offset. */
-	random = get_random_long();
-
-	/* Clip off top of the range. */
-	random &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
-	while (random + output_size > CONFIG_RANDOMIZE_BASE_MAX_OFFSET)
-		random >>= 1;
-
-	/* Clip off bottom of range. */
-	random &= ~(choice - 1);
+	random = find_random_e820(choice, output_size);
+	if (!random) {
+		debug_putstr("KASLR could not find suitable E820 region...\n");
+		goto out;
+	}
 
 	/* Always enforce the minimum. */
 	if (random < choice)
-- 
1.7.9.5
