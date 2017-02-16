Date: Wed, 15 Feb 2017 16:36:19 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170216003619.GA142955@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] ARM: uaccess: fix zeroing of 64-bit get_user()
To: Russell King <linux@armlinux.org.uk>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The 64-bit get_user() wasn't clearing the high word due to a typo in the
error handler. The exception handler entry was already correct, though.
Noticed during recent usercopy test additions in lib/test_user_copy.c.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/lib/getuser.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
index 8ecfd15c3a02..df73914e81c8 100644
--- a/arch/arm/lib/getuser.S
+++ b/arch/arm/lib/getuser.S
@@ -67,7 +67,7 @@ ENTRY(__get_user_4)
 ENDPROC(__get_user_4)
 
 ENTRY(__get_user_8)
-	check_uaccess r0, 8, r1, r2, __get_user_bad
+	check_uaccess r0, 8, r1, r2, __get_user_bad8
 #ifdef CONFIG_THUMB2_KERNEL
 5: TUSER(ldr)	r2, [r0]
 6: TUSER(ldr)	r3, [r0, #4]
-- 
2.7.4


-- 
Kees Cook
Pixel Security
