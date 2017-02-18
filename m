From: Michael Ellerman <mpe@ellerman.id.au>
Date: Sat, 18 Feb 2017 20:33:20 +1100
Message-Id: <1487410400-28313-1-git-send-email-mpe@ellerman.id.au>
Subject: [kernel-hardening] [PATCH] usercopy: Don't test 64-bit get/put_user() on 32-bit powerpc
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org
List-ID: <kernel-hardening.lists.openwall.com>

Add PPC32 to the opt-out list, otherwise it breaks the build.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 lib/test_user_copy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
index 4a79f2c1cd6e..6f335a3d4ae2 100644
--- a/lib/test_user_copy.c
+++ b/lib/test_user_copy.c
@@ -37,6 +37,7 @@
 			    !defined(CONFIG_MICROBLAZE) &&	\
 			    !defined(CONFIG_MN10300) &&		\
 			    !defined(CONFIG_NIOS2) &&		\
+			    !defined(CONFIG_PPC32) &&		\
 			    !defined(CONFIG_SUPERH))
 # define TEST_U64
 #endif
-- 
2.7.4
