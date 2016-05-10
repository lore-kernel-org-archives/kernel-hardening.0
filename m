Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 10 May 2016 10:19:14 -0700
Message-Id: <1462900755-20005-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1462900755-20005-1-git-send-email-keescook@chromium.org>
References: <1462900755-20005-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v8 3/4] x86/KASLR: Add physical address randomization >4G
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This patch exchanges the prior slots[] array for the new slot_areas[]
array, and lifts the limitation of KERNEL_IMAGE_SIZE on the physical
address offset for 64-bit. As before, process_e820_entry() walks
memory and populates slot_areas[], splitting on any detected mem_avoid
collisions.

Finally, since the slots[] array and its associated functions are not
needed any more, so they are removed.

Based on earlier patches by Baoquan He.

Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This patch is pretty noisy due to the indentation change in the
e820 walker. I couldn't find a cleaner way to do this that didn't
make the final code LESS readable, unfortunately. So, the diff is
ugly, but I think the results are clean.
---
 arch/x86/Kconfig                 |  27 +++++----
 arch/x86/boot/compressed/kaslr.c | 115 +++++++++++++++++++++++----------------
 2 files changed, 85 insertions(+), 57 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5892d549596d..bba81cf02b69 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1943,21 +1943,26 @@ config RANDOMIZE_BASE
 	  attempts relying on knowledge of the location of kernel
 	  code internals.
 
-	  The kernel physical and virtual address can be randomized
-	  from 16MB up to 1GB on 64-bit and 512MB on 32-bit. (Note that
-	  using RANDOMIZE_BASE reduces the memory space available to
-	  kernel modules from 1.5GB to 1GB.)
+	  On 64-bit, the kernel physical and virtual addresses are
+	  randomized separately. The physical address will be anywhere
+	  between 16MB and the top of physical memory (up to 64TB). The
+	  virtual address will be randomized from 16MB up to 1GB (9 bits
+	  of entropy). Note that this also reduces the memory space
+	  available to kernel modules from 1.5GB to 1GB.
+
+	  On 32-bit, the kernel physical and virtual addresses are
+	  randomized together. They will be randomized from 16MB up to
+	  512MB (8 bits of entropy).
 
 	  Entropy is generated using the RDRAND instruction if it is
 	  supported. If RDTSC is supported, its value is mixed into
 	  the entropy pool as well. If neither RDRAND nor RDTSC are
-	  supported, then entropy is read from the i8254 timer.
-
-	  Since the kernel is built using 2GB addressing, and
-	  PHYSICAL_ALIGN must be at a minimum of 2MB, only 10 bits of
-	  entropy is theoretically possible. Currently, with the
-	  default value for PHYSICAL_ALIGN and due to page table
-	  layouts, 64-bit uses 9 bits of entropy and 32-bit uses 8 bits.
+	  supported, then entropy is read from the i8254 timer. The
+	  usable entropy is limited by the kernel being built using
+	  2GB addressing, and that PHYSICAL_ALIGN must be at a
+	  minimum of 2MB. As a result, only 10 bits of entropy are
+	  theoretically possible, but the implementations are further
+	  limited due to memory layouts.
 
 	  If CONFIG_HIBERNATE is also enabled, KASLR is disabled at boot
 	  time. To enable it, boot with "kaslr" on the kernel command
diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index af92ea581b8e..d0a823df183b 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -132,17 +132,6 @@ enum mem_avoid_index {
 
 static struct mem_vector mem_avoid[MEM_AVOID_MAX];
 
-static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
-{
-	/* Item at least partially before region. */
-	if (item->start < region->start)
-		return false;
-	/* Item at least partially after region. */
-	if (item->start + item->size > region->start + region->size)
-		return false;
-	return true;
-}
-
 static bool mem_overlaps(struct mem_vector *one, struct mem_vector *two)
 {
 	/* Item one is entirely before item two. */
@@ -319,8 +308,6 @@ static bool mem_avoid_overlap(struct mem_vector *img,
 	return is_overlapping;
 }
 
-static unsigned long slots[KERNEL_IMAGE_SIZE / CONFIG_PHYSICAL_ALIGN];
-
 struct slot_area {
 	unsigned long addr;
 	int num;
@@ -351,36 +338,44 @@ static void store_slot_info(struct mem_vector *region, unsigned long image_size)
 	}
 }
 
-static void slots_append(unsigned long addr)
-{
-	/* Overflowing the slots list should be impossible. */
-	if (slot_max >= KERNEL_IMAGE_SIZE / CONFIG_PHYSICAL_ALIGN)
-		return;
-
-	slots[slot_max++] = addr;
-}
-
 static unsigned long slots_fetch_random(void)
 {
+	unsigned long slot;
+	int i;
+
 	/* Handle case of no slots stored. */
 	if (slot_max == 0)
 		return 0;
 
-	return slots[get_random_long("Physical") % slot_max];
+	slot = get_random_long("Physical") % slot_max;
+
+	for (i = 0; i < slot_area_index; i++) {
+		if (slot >= slot_areas[i].num) {
+			slot -= slot_areas[i].num;
+			continue;
+		}
+		return slot_areas[i].addr + slot * CONFIG_PHYSICAL_ALIGN;
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
-	struct mem_vector region, img, overlap;
+	struct mem_vector region, overlap;
+	struct slot_area slot_area;
+	unsigned long start_orig;
 
 	/* Skip non-RAM entries. */
 	if (entry->type != E820_RAM)
 		return;
 
-	/* Ignore entries entirely above our maximum. */
-	if (entry->addr >= KERNEL_IMAGE_SIZE)
+	/* On 32-bit, ignore entries entirely above our maximum. */
+	if (IS_ENABLED(CONFIG_X86_32) && entry->addr >= KERNEL_IMAGE_SIZE)
 		return;
 
 	/* Ignore entries entirely below our minimum. */
@@ -390,31 +385,55 @@ static void process_e820_entry(struct e820entry *entry,
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
-		if (mem_avoid_overlap(&img, &overlap))
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
+		if (!mem_avoid_overlap(&region, &overlap)) {
+			store_slot_info(&region, image_size);
+			return;
+		}
+
+		/* Store beginning of region if holds at least image_size. */
+		if (overlap.start > region.start + image_size) {
+			struct mem_vector beginning;
+
+			beginning.start = region.start;
+			beginning.size = overlap.start - region.start;
+			store_slot_info(&beginning, image_size);
+		}
+
+		/* Return if overlap extends to or past end of region. */
+		if (overlap.start + overlap.size >= region.start + region.size)
+			return;
+
+		/* Clip off the overlapping region and start over. */
+		region.size -= overlap.start - region.start + overlap.size;
+		region.start = overlap.start + overlap.size;
 	}
 }
 
@@ -431,6 +450,10 @@ static unsigned long find_random_phys_addr(unsigned long minimum,
 	for (i = 0; i < boot_params->e820_entries; i++) {
 		process_e820_entry(&boot_params->e820_map[i], minimum,
 				   image_size);
+		if (slot_area_index == MAX_SLOT_AREA) {
+			debug_putstr("Aborted e820 scan (slot_areas full)!\n");
+			break;
+		}
 	}
 
 	return slots_fetch_random();
-- 
2.6.3
