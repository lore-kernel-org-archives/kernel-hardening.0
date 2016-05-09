Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Mon,  9 May 2016 13:22:06 -0700
Message-Id: <1462825332-10505-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1462825332-10505-1-git-send-email-keescook@chromium.org>
References: <1462825332-10505-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 3/9] x86/KASLR: Add slot_area to manage random_addr slots
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

In order to support KASLR moving the kernel anywhere in physical memory
(which could be up to 64TB), we need to handle counting the potential
randomization locations in a more efficient manner.

In the worst case with 64TB, there could be roughly 32 * 1024 * 1024
randomization slots if CONFIG_PHYSICAL_ALIGN is 0x1000000. Currently
the starting address of candidate positions is stored into the slots[]
array, one at a time. This method would cost too much memory and it's
also very inefficient to get and save the slot information into the slot
array one by one.

This patch introduces struct slot_area to manage each contiguous region
of randomization slots. Each slot_area will contain the starting address
and how many available slots are in this area. As with the original code,
the slot_areas will avoid the mem_avoid regions.

Since setup_data is a linked list, it could contain an unknown number
of memory regions to be avoided, which could cause us to fragment
the contiguous memory that the slot_area array is tracking. In normal
operation this level of fragmentation will be extremely rare, but we
choose a suitably large value (100) for the array. If setup_data forces
the slot_area array to become highly fragmented and there are more
slots available beyond the first 100 found, the rest will be ignored
for KASLR selection.

The function store_slot_info() is used to calculate the number of slots
available in the passed-in memory region and stores it into slot_areas[]
after adjusting for alignment and size requirements.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog, squash with new functions]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/kaslr.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index 3f0692dcd30d..89f0148e3e84 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -308,8 +308,37 @@ static bool mem_avoid_overlap(struct mem_vector *img)
 }
 
 static unsigned long slots[KERNEL_IMAGE_SIZE / CONFIG_PHYSICAL_ALIGN];
+
+struct slot_area {
+	unsigned long addr;
+	int num;
+};
+
+#define MAX_SLOT_AREA 100
+
+static struct slot_area slot_areas[MAX_SLOT_AREA];
+
 static unsigned long slot_max;
 
+static unsigned long slot_area_index;
+
+static void store_slot_info(struct mem_vector *region, unsigned long image_size)
+{
+	struct slot_area slot_area;
+
+	if (slot_area_index == MAX_SLOT_AREA)
+		return;
+
+	slot_area.addr = region->start;
+	slot_area.num = (region->size - image_size) /
+			CONFIG_PHYSICAL_ALIGN + 1;
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
