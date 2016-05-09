Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon,  9 May 2016 13:22:08 -0700
Message-Id: <1462825332-10505-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1462825332-10505-1-git-send-email-keescook@chromium.org>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 5/9] x86/KASLR: Add virtual address choosing function
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

To support randomizing the kernel virtual address separately from the
physical address, this patch adds find_random_virt_addr() to choose
a slot anywhere between LOAD_PHYSICAL_ADDR and KERNEL_IMAGE_SIZE.
Since this address is virtual, not physical, we can place the kernel
anywhere in this region, as long as it is aligned and (in the case of
kernel being larger than the slot size) placed with enough room to load
the entire kernel image.

For clarity and readability, find_random_addr() is renamed to
find_random_phys_addr() and has "size" renamed to "image_size" to match
find_random_virt_addr().

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, refactor slot calculation for readability]
[kees: renamed find_random_phys_addr() and size argument]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 1c02f07ce55a..82d00282df3f 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -417,8 +417,8 @@ static void process_e820_entry(struct e820entry *entry,
 	}
 }
 
-static unsigned long find_random_addr(unsigned long minimum,
-				      unsigned long size)
+static unsigned long find_random_phys_addr(unsigned long minimum,
+					   unsigned long image_size)
 {
 	int i;
 	unsigned long addr;
@@ -428,12 +428,36 @@ static unsigned long find_random_addr(unsigned long minimum,
 
 	/* Verify potential e820 positions, appending to slots list. */
 	for (i = 0; i < boot_params->e820_entries; i++) {
-		process_e820_entry(&boot_params->e820_map[i], minimum, size);
+		process_e820_entry(&boot_params->e820_map[i], minimum,
+				   image_size);
 	}
 
 	return slots_fetch_random();
 }
 
+static unsigned long find_random_virt_addr(unsigned long minimum,
+					   unsigned long image_size)
+{
+	unsigned long slots, random_addr;
+
+	/* Make sure minimum is aligned. */
+	minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
+	/* Align image_size for easy slot calculations. */
+	image_size = ALIGN(image_size, CONFIG_PHYSICAL_ALIGN);
+
+	/*
+	 * There are how many CONFIG_PHYSICAL_ALIGN-sized slots
+	 * that can hold image_size within the range of minimum to
+	 * KERNEL_IMAGE_SIZE?
+	 */
+	slots = (KERNEL_IMAGE_SIZE - minimum - image_size) /
+		 CONFIG_PHYSICAL_ALIGN + 1;
+
+	random_addr = get_random_long() % slots;
+
+	return random_addr * CONFIG_PHYSICAL_ALIGN + minimum;
+}
+
 /*
  * Since this function examines addresses much more numerically,
  * it takes the input and output pointers as 'unsigned long'.
@@ -464,7 +488,7 @@ unsigned char *choose_random_location(unsigned long input,
 	mem_avoid_init(input, input_size, output);
 
 	/* Walk e820 and find a random address. */
-	random_addr = find_random_addr(output, output_size);
+	random_addr = find_random_phys_addr(output, output_size);
 	if (!random_addr) {
 		warn("KASLR disabled: could not find suitable E820 region!");
 		goto out;
-- 
2.6.3
