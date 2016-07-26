Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2016 22:36:40 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160726223640.fe5ae5cff05ff12faf26ff44@gmail.com>
In-Reply-To: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
References: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 1/7] Move type casts into is_kernel_rodata
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

so that its parameter can be marked as nocapture.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 mm/util.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 662cddf..d95f10b 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -17,10 +17,10 @@
 
 #include "internal.h"
 
-static inline int is_kernel_rodata(unsigned long addr)
+static inline int is_kernel_rodata(const void *addr)
 {
-	return addr >= (unsigned long)__start_rodata &&
-		addr < (unsigned long)__end_rodata;
+	return (unsigned long)addr >= (unsigned long)__start_rodata &&
+		(unsigned long)addr < (unsigned long)__end_rodata;
 }
 
 /**
@@ -31,7 +31,7 @@ static inline int is_kernel_rodata(unsigned long addr)
  */
 void kfree_const(const void *x)
 {
-	if (!is_kernel_rodata((unsigned long)x))
+	if (!is_kernel_rodata(x))
 		kfree(x);
 }
 EXPORT_SYMBOL(kfree_const);
@@ -68,7 +68,7 @@ EXPORT_SYMBOL(kstrdup);
  */
 const char *kstrdup_const(const char *s, gfp_t gfp)
 {
-	if (is_kernel_rodata((unsigned long)s))
+	if (is_kernel_rodata(s))
 		return s;
 
 	return kstrdup(s, gfp);
-- 
2.8.1
