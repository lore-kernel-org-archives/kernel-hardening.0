From: Daniel Axtens <dja@axtens.net>
Date: Mon, 22 May 2017 11:32:32 +1000
Message-Id: <20170522013233.21780-2-dja@axtens.net>
In-Reply-To: <20170522013233.21780-1-dja@axtens.net>
References: <20170522013233.21780-1-dja@axtens.net>
Subject: [kernel-hardening] [PATCH 1/2] powerpc: Don't fortify prom_init
To: kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
Cc: Daniel Axtens <dja@axtens.net>, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

prom_init is a bit special; in theory it should be able to be
linked separately to the kernel. To keep this from getting too
complex, the symbols that prom_init.c uses are checked.

Fortification adds symbols, and it gets quite messy as it includes
things like panic(). So just don't fortify prom_init.c for now.

Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Daniel Axtens <dja@axtens.net>

---

This will need to go in before the main fortify support, but it
doesn't make any sense in the absence of fortify. I think it would
make most sense for Kees to queue this up with the main fortify patch,
with an Ack from mpe?

---
 arch/powerpc/kernel/prom_init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index dd8a04f3053a..613f79f03877 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -15,6 +15,9 @@
 
 #undef DEBUG_PROM
 
+/* we cannot use FORTIFY as it brings in new symbols */
+#define __NO_FORTIFY
+
 #include <stdarg.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-- 
2.11.0
