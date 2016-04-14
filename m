Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:12 -0700
Message-Id: <1460672954-32567-20-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 19/21] x86, KASLR: Add physical address randomization >4G
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

This patch exchanges the prior slots[] array for the new slot_areas[]
array, and lifts the limitation of KERNEL_IMAGE_SIZE on the physical
address offset for 64-bit. As before, process_e820_entry walks memory and
populates slot_areas[], splitting on any detected mem_avoid collisions.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, refactored goto into while, limit 32-bit to 1G]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 92 ++++++++++++++++++++++++++++++-----------
 1 file changed, 68 insertions(+), 24 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 53ceaa0a08b9..0587eac3e05d 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -335,25 +335,42 @@ static void slots_append(unsigned long addr)
 
 static unsigned long slots_fetch_random(void)
 {
+	unsigned long random;
+	int i;
+
 	/* Handle case of no slots stored. */
 	if (slot_max == 0)
 		return 0;
 
-	return slots[get_random_long("Physical") % slot_max];
+	random = get_random_long("Physical") % slot_max;
+
+	for (i = 0; i < slot_area_index; i++) {
+		if (random >= slot_areas[i].num) {
+			random -= slot_areas[i].num;
+			continue;
+		}
+		return slot_areas[i].addr + random * CONFIG_PHYSICAL_ALIGN;
+	}
+
+	if (i == slot_area_index)
+		debug_putstr("slots_fetch_random() failed!?\n");
+	return 0;
 }
 
 static void process_e820_entry(struct e820entry *entry,
 			       unsigned long minimum,
 			       unsigned long image_size)
 {
-	struct mem_vector region, img;
+	struct mem_vector region, out;
+	struct slot_area slot_area;
+	unsigned long min, start_orig;
 
 	/* Skip non-RAM entries. */
 	if (entry->type != E820_RAM)
 		return;
 
-	/* Ignore entries entirely above our maximum. */
-	if (entry->addr >= KERNEL_IMAGE_SIZE)
+	/* On 32-bit, ignore entries entirely above our maximum. */
+	if (IS_ENABLED(CONFIG_X86_32) && entry->addr >= KERNEL_IMAGE_SIZE)
 		return;
 
 	/* Ignore entries entirely below our minimum. */
@@ -363,31 +380,54 @@ static void process_e820_entry(struct e820entry *entry,
 	region.start = entry->addr;
 	region.size = entry->size;
 
-	/* Potentially raise address to minimum location. */
-	if (region.start < minimum)
-		region.start = minimum;
+	/* Give up if slot area array is full. */
+	while (slot_area_index < MAX_SLOT_AREA) {
+		start_orig = region.start;
 
-	/* Potentially raise address to meet alignment requirements. */
-	region.start = ALIGN(region.start, CONFIG_PHYSICAL_ALIGN);
+		/* Potentially raise address to minimum location. */
+		if (region.start < minimum)
+			region.start = minimum;
 
-	/* Did we raise the address above the bounds of this e820 region? */
-	if (region.start > entry->addr + entry->size)
-		return;
+		/* Potentially raise address to meet alignment needs. */
+		region.start = ALIGN(region.start, CONFIG_PHYSICAL_ALIGN);
 
-	/* Reduce size by any delta from the original address. */
-	region.size -= region.start - entry->addr;
+		/* Did we raise the address above this e820 region? */
+		if (region.start > entry->addr + entry->size)
+			return;
 
-	/* Reduce maximum size to fit end of image within maximum limit. */
-	if (region.start + region.size > KERNEL_IMAGE_SIZE)
-		region.size = KERNEL_IMAGE_SIZE - region.start;
+		/* Reduce size by any delta from the original address. */
+		region.size -= region.start - start_orig;
 
-	/* Walk each aligned slot and check for avoided areas. */
-	for (img.start = region.start, img.size = image_size ;
-	     mem_contains(&region, &img) ;
-	     img.start += CONFIG_PHYSICAL_ALIGN) {
-		if (mem_avoid_overlap(&img))
-			continue;
-		slots_append(img.start);
+		/* On 32-bit, reduce region size to fit within max size. */
+		if (IS_ENABLED(CONFIG_X86_32) &&
+		    region.start + region.size > KERNEL_IMAGE_SIZE)
+			region.size = KERNEL_IMAGE_SIZE - region.start;
+
+		/* Return if region can't contain decompressed kernel */
+		if (region.size < image_size)
+			return;
+
+		/* If nothing overlaps, store the region and return. */
+		if (!mem_avoid_overlap(&region)) {
+			store_slot_info(&region, image_size);
+			return;
+		}
+
+		/* Other wise, find the lowest overlap. */
+		min = mem_min_overlap(&region, &out);
+
+		/* Store the region if it can hold at least image_size. */
+		if (min > region.start + image_size) {
+			struct mem_vector tmp;
+
+			tmp.start = region.start;
+			tmp.size = min - region.start;
+			store_slot_info(&tmp, image_size);
+		}
+
+		/* Clip off the overlapping region and start over. */
+		region.size -= out.start - region.start + out.size;
+		region.start = out.start + out.size;
 	}
 }
 
@@ -403,6 +443,10 @@ static unsigned long find_random_phy_addr(unsigned long minimum,
 	/* Verify potential e820 positions, appending to slots list. */
 	for (i = 0; i < real_mode->e820_entries; i++) {
 		process_e820_entry(&real_mode->e820_map[i], minimum, size);
+		if (slot_area_index == MAX_SLOT_AREA) {
+			debug_putstr("Aborted e820 scan (slot_areas full)!\n");
+			break;
+		}
 	}
 
 	return slots_fetch_random();
-- 
2.6.3
