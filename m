Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 14 Apr 2016 15:29:13 -0700
Message-Id: <1460672954-32567-21-git-send-email-keescook@chromium.org>
In-Reply-To: <1460672954-32567-1-git-send-email-keescook@chromium.org>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 20/21] x86, KASLR: Remove unused slot tracking code
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Baoquan He <bhe@redhat.com>

Since struct slot_area and its new algorithm are used to track and select
memory ranges, the slots[] array and its associated functions are not
needed any more. This patch removes them.

Signed-off-by: Baoquan He <bhe@redhat.com>
[kees: rewrote changelog]
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/boot/compressed/aslr.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 0587eac3e05d..e83d3bb3808b 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -113,17 +113,6 @@ struct mem_vector {
 #define MEM_AVOID_MAX 4
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
@@ -292,8 +281,6 @@ mem_min_overlap(struct mem_vector *img, struct mem_vector *out)
 	return min;
 }
 
-static unsigned long slots[KERNEL_IMAGE_SIZE / CONFIG_PHYSICAL_ALIGN];
-
 struct slot_area {
 	unsigned long addr;
 	int num;
@@ -324,15 +311,6 @@ static void store_slot_info(struct mem_vector *region, unsigned long image_size)
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
 	unsigned long random;
-- 
2.6.3
