Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:07 -0700
Message-Id: <1460672954-32567-15-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 14/21] x86, KASLR: Add slot_area to manage random slots
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

In order to support KASLR moving the kernel anywhere in the whole
of physical memory (could be 64T), we need to handle counting the
potential randomization locations in a more efficient manner.

In the worst case with 64T, there could be roughly 32 * 1024 * 1024
randomization slots if CONFIG_PHYSICAL_ALIGN is 0x1000000. Currently
the starting address of candidate positions is stored into the slots[]
array, one at a time.  With this method will cost too much memory and
it's also very inefficient to get and save the slot information into
slot array one by one.

This patch introduces struct slot_area to manage each contiguous region
of randomization slots. Each slot_area will contain the starting address
and how many available slots are in this area. As with the original code,
the slot_areas will be avoid the mem_avoid regions, since those areas
should be be used for the relocated position.

Since setup_data is a linked list, it could contain an unknown number
of memory regions to be avoided, which could cause us to fragment
the contiguous memory that the slot_area array is tracking. In normal
operation this fragmentation will be extremely unlikely, but choose
a suitably large value (100) for the array. If there are more slots
available beyond 100, they will be ignored for KASLR selection.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index cd261debead9..abe618d489ea 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -258,8 +258,20 @@ static bool mem_avoid_overlap(struct mem_vector *img)
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
 static void slots_append(unsigned long addr)
 {
 	/* Overflowing the slots list should be impossible. */
-- 
2.6.3
