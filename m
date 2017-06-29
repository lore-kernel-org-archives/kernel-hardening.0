From: Michael Ellerman <mpe@ellerman.id.au>
Date: Thu, 29 Jun 2017 16:29:40 +1000
Message-Id: <1498717781-29151-3-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
References: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
Subject: [kernel-hardening] [RFC PATCH 3/4] module: Use linux/set_memory.h
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

This header always exists, so doesn't require an ifdef around its
inclusion. When CONFIG_ARCH_HAS_SET_MEMORY=y it includes the asm header,
otherwise it provides empty versions of the set_memory_xx() routines.

The usages of set_memory_xx() are still guarded by CONFIG_STRICT_MODULE_RWX.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 kernel/module.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index d0a723ebe75c..e7696b25db30 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -49,9 +49,7 @@
 #include <linux/rculist.h>
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
-#ifdef CONFIG_STRICT_MODULE_RWX
-#include <asm/set_memory.h>
-#endif
+#include <linux/set_memory.h>
 #include <asm/mmu_context.h>
 #include <linux/license.h>
 #include <asm/sections.h>
-- 
2.7.4
