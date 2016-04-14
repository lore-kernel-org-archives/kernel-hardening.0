Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:08 -0700
Message-Id: <1460672954-32567-16-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 15/21] x86, KASLR: Add slot_area support functions
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

The function store_slot_info() is used to calculate the slot info of the
passed-in memory region and stores it into slot_areas[] after adjusting
for alignment and size requirements.

The function mem_min_overlap() is used to iterate over all mem_avoid
regions to find the earliest mem_avoid address that conflicts with the
given memory region. (For example, with the region [1024M, 2048M), if
there is a mem_avoid of [1536M, 1664M), this returns 1536M.) This can
be used to split memory regions when building the slot_area array.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index abe618d489ea..b06618000732 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -257,6 +257,40 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 	return false;
 }
 
+static unsigned long
+mem_min_overlap(struct mem_vector *img, struct mem_vector *out)
+{
+	int i;
+	struct setup_data *ptr;
+	unsigned long min = img->start + img->size;
+
+	for (i = 0; i < MEM_AVOID_MAX; i++) {
+		if (mem_overlaps(img, &mem_avoid[i]) &&
+			(mem_avoid[i].start < min)) {
+			*out = mem_avoid[i];
+			min = mem_avoid[i].start;
+		}
+	}
+
+	/* Check all entries in the setup_data linked list. */
+	ptr = (struct setup_data *)(unsigned long)real_mode->hdr.setup_data;
+	while (ptr) {
+		struct mem_vector avoid;
+
+		avoid.start = (unsigned long)ptr;
+		avoid.size = sizeof(*ptr) + ptr->len;
+
+		if (mem_overlaps(img, &avoid) && (avoid.start < min)) {
+			*out = avoid;
+			min = avoid.start;
+		}
+
+		ptr = (struct setup_data *)(unsigned long)ptr->next;
+	}
+
+	return min;
+}
+
 static unsigned long slots[KERNEL_IMAGE_SIZE / CONFIG_PHYSICAL_ALIGN];
 
 struct slot_area {
@@ -272,6 +306,23 @@ static unsigned long slot_max;
 
 static unsigned long slot_area_index;
 
+static void store_slot_info(struct mem_vector *region, unsigned long image_size)
+{
+	struct slot_area slot_area;
+
+	slot_area.addr = region->start;
+	if (image_size <= CONFIG_PHYSICAL_ALIGN)
+		slot_area.num = region->size / CONFIG_PHYSICAL_ALIGN;
+	else
+		slot_area.num = (region->size - image_size) /
+				CONFIG_PHYSICAL_ALIGN + 1;
+
+	if (slot_area.num > 0) {
+		slot_areas[slot_area_index++] = slot_area;
+		slot_max += slot_area.num;
+	}
+}
+
 static void slots_append(unsigned long addr)
 {
 	/* Overflowing the slots list should be impossible. */
-- 
2.6.3
