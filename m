From: Michael Ellerman <mpe@ellerman.id.au>
Date: Thu, 29 Jun 2017 16:29:41 +1000
Message-Id: <1498717781-29151-4-git-send-email-mpe@ellerman.id.au>
In-Reply-To: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
References: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
Subject: [kernel-hardening] [RFC PATCH 4/4] bpf: Use linux/set_memory.h
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

This header always exists, so doesn't require an ifdef around its
inclusion. When CONFIG_ARCH_HAS_SET_MEMORY=y it includes the asm header,
otherwise it provides empty versions of the set_memory_xx() routines.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 include/linux/filter.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 1fa26dc562ce..54f26e9c6472 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -16,13 +16,10 @@
 #include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/cryptohash.h>
+#include <linux/set_memory.h>
 
 #include <net/sch_generic.h>
 
-#ifdef CONFIG_ARCH_HAS_SET_MEMORY
-#include <asm/set_memory.h>
-#endif
-
 #include <uapi/linux/filter.h>
 #include <uapi/linux/bpf.h>
 
-- 
2.7.4
