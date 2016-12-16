Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 16 Dec 2016 13:06:59 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20161216210659.GA85702@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] latent_entropy: fix ARM build error on earlier gcc
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

This fixes build errors seen on gcc-4.9.3 or gcc-5.3.1 for an ARM:

arm-soc/init/initramfs.c: In function 'error':
arm-soc/init/initramfs.c:50:1: error: unrecognizable insn:
 }
 ^
(insn 26 25 27 5 (set (reg:SI 111 [ local_entropy.243 ])
        (rotatert:SI (reg:SI 116 [ local_entropy.243 ])
            (const_int -30 [0xffffffffffffffe2]))) -1
     (nil))

Patch from PaX Team <pageexec@freemail.hu>

Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Brad Spengler <spender@grsecurity.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/latent_entropy_plugin.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index ff1939b804ae..eb1964084ccd 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -328,9 +328,9 @@ static enum tree_code get_op(tree *rhs)
 			op = LROTATE_EXPR;
 			/*
 			 * This code limits the value of random_const to
-			 * the size of a wide int for the rotation
+			 * the size of a long for the rotation
 			 */
-			random_const &= HOST_BITS_PER_WIDE_INT - 1;
+			random_const %= TYPE_PRECISION(long_unsigned_type_node);
 			break;
 		}
 
-- 
2.7.4


-- 
Kees Cook
Nexus Security
