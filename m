From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 10 May 2017 13:44:41 -0400
Message-Id: <20170510174441.26163-1-danielmicay@gmail.com>
Subject: [kernel-hardening] [PATCH] mark protection_map as __ro_after_init
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

The protection map is only modified by per-arch init code so it can be
protected from writes after the init code runs.

This change was extracted from PaX where it's part of KERNEXEC.

Signed-off-by: Daniel Micay <danielmicay@gmail.com>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index f82741e199c0..3bd5ecd20d4d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -94,7 +94,7 @@ static void unmap_region(struct mm_struct *mm,
  *								w: (no) no
  *								x: (yes) yes
  */
-pgprot_t protection_map[16] = {
+pgprot_t protection_map[16] __ro_after_init = {
 	__P000, __P001, __P010, __P011, __P100, __P101, __P110, __P111,
 	__S000, __S001, __S010, __S011, __S100, __S101, __S110, __S111
 };
-- 
2.12.2
