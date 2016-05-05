Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu,  5 May 2016 15:13:51 -0700
Message-Id: <1462486436-3707-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1462486436-3707-1-git-send-email-keescook@chromium.org>
References: <1462486436-3707-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v6 06/11] x86/KASLR: Return earliest overlap when avoiding regions
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

In preparation for being able to detect where to split up contiguous
memory regions that overlap with memory regions to avoid, we need to
pass back what the earliest overlapping region was. This modifies the
overlap checker to return that information.

Based on a separate mem_min_overlap() implementation by Baoquan He.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index dc9ffceb556b..391960e2cb08 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -246,15 +246,24 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 #endif
 }
 
-/* Does this memory vector overlap a known avoided area? */
-static bool mem_avoid_overlap(struct mem_vector *img)
+/*
+ * Does this memory vector overlap a known avoided area? If so, record the
+ * overlap region with the lowest address.
+ */
+static bool mem_avoid_overlap(struct mem_vector *img,
+			      struct mem_vector *overlap)
 {
 	int i;
 	struct setup_data *ptr;
+	unsigned long earliest = img->start + img->size;
+	bool is_overlapping = false;
 
 	for (i = 0; i < MEM_AVOID_MAX; i++) {
-		if (mem_overlaps(img, &mem_avoid[i]))
-			return true;
+		if (mem_overlaps(img, &mem_avoid[i]) &&
+		    mem_avoid[i].start < earliest) {
+			*overlap = mem_avoid[i];
+			is_overlapping = true;
+		}
 	}
 
 	/* Avoid all entries in the setup_data linked list. */
@@ -265,13 +274,15 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 		avoid.start = (unsigned long)ptr;
 		avoid.size = sizeof(*ptr) + ptr->len;
 
-		if (mem_overlaps(img, &avoid))
-			return true;
+		if (mem_overlaps(img, &avoid) && (avoid.start < earliest)) {
+			*overlap = avoid;
+			is_overlapping = true;
+		}
 
 		ptr = (struct setup_data *)(unsigned long)ptr->next;
 	}
 
-	return false;
+	return is_overlapping;
 }
 
 static unsigned long slots[KERNEL_IMAGE_SIZE / CONFIG_PHYSICAL_ALIGN];
@@ -328,7 +339,7 @@ static void process_e820_entry(struct e820entry *entry,
 			       unsigned long minimum,
 			       unsigned long image_size)
 {
-	struct mem_vector region, img;
+	struct mem_vector region, img, overlap;
 
 	/* Skip non-RAM entries. */
 	if (entry->type != E820_RAM)
@@ -367,7 +378,7 @@ static void process_e820_entry(struct e820entry *entry,
 	for (img.start = region.start, img.size = image_size ;
 	     mem_contains(&region, &img) ;
 	     img.start += CONFIG_PHYSICAL_ALIGN) {
-		if (mem_avoid_overlap(&img))
+		if (mem_avoid_overlap(&img, &overlap))
 			continue;
 		slots_append(img.start);
 	}
-- 
2.6.3
