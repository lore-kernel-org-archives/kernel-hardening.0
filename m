From: Michael Ellerman <mpe@ellerman.id.au>
Date: Thu, 29 Jun 2017 16:29:39 +1000
Message-Id: <1498717781-29151-2-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
References: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
Subject: [kernel-hardening] [RFC PATCH 2/4] PM / hibernate: Use linux/set_memory.h
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

This header always exists, so doesn't require an ifdef around its
inclusion. When CONFIG_ARCH_HAS_SET_MEMORY=y it includes the asm header,
otherwise it provides empty versions of the set_memory_xx() routines.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 kernel/power/snapshot.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index b7708e319941..222317721c5a 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -30,15 +30,13 @@
 #include <linux/slab.h>
 #include <linux/compiler.h>
 #include <linux/ktime.h>
+#include <linux/set_memory.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/io.h>
-#ifdef CONFIG_ARCH_HAS_SET_MEMORY
-#include <asm/set_memory.h>
-#endif
 
 #include "power.h"
 
-- 
2.7.4
