From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 1/7] powerpc: Add framework for Kernel Userspace Protection
Date: Thu, 21 Feb 2019 20:35:55 +1100
Message-Id: <20190221093601.27920-2-ruscur@russell.cc>
In-Reply-To: <20190221093601.27920-1-ruscur@russell.cc>
References: <20190221093601.27920-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

From: Christophe Leroy <christophe.leroy@c-s.fr>

This patch adds a skeleton for Kernel Userspace Protection
functionnalities like Kernel Userspace Access Protection and
Kernel Userspace Execution Prevention

The subsequent implementation of KUAP for radix makes use of a MMU
feature in order to patch out assembly when KUAP is disabled or
unsupported.  This won't work unless there's an entry point for
KUP support before the feature magic happens, so for PPC64
setup_kup() is called early in setup.

On PPC32, feature_fixup is done too early to allow the same.

Suggested-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/include/asm/kup.h | 11 +++++++++++
 arch/powerpc/kernel/setup_64.c |  7 +++++++
 arch/powerpc/mm/init-common.c  |  5 +++++
 arch/powerpc/mm/init_32.c      |  3 +++
 4 files changed, 26 insertions(+)
 create mode 100644 arch/powerpc/include/asm/kup.h

diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
new file mode 100644
index 000000000000..7a88b8b9b54d
--- /dev/null
+++ b/arch/powerpc/include/asm/kup.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_KUP_H_
+#define _ASM_POWERPC_KUP_H_
+
+#ifndef __ASSEMBLY__
+
+void setup_kup(void);
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* _ASM_POWERPC_KUP_H_ */
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 236c1151a3a7..771f280a6bf6 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -68,6 +68,7 @@
 #include <asm/cputhreads.h>
 #include <asm/hw_irq.h>
 #include <asm/feature-fixups.h>
+#include <asm/kup.h>
 
 #include "setup.h"
 
@@ -331,6 +332,12 @@ void __init early_setup(unsigned long dt_ptr)
 	 */
 	configure_exceptions();
 
+	/*
+	 * Configure Kernel Userspace Protection. This needs to happen before
+	 * feature fixups for platforms that implement this using features.
+	 */
+	setup_kup();
+
 	/* Apply all the dynamic patching */
 	apply_feature_fixups();
 	setup_feature_keys();
diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
index 1e6910eb70ed..36d28e872289 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -24,6 +24,11 @@
 #include <linux/string.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
+#include <asm/kup.h>
+
+void __init setup_kup(void)
+{
+}
 
 #define CTOR(shift) static void ctor_##shift(void *addr) \
 {							\
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 3e59e5d64b01..93cfa8cf015d 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -45,6 +45,7 @@
 #include <asm/tlb.h>
 #include <asm/sections.h>
 #include <asm/hugetlb.h>
+#include <asm/kup.h>
 
 #include "mmu_decl.h"
 
@@ -182,6 +183,8 @@ void __init MMU_init(void)
 	btext_unmap();
 #endif
 
+	setup_kup();
+
 	/* Shortly after that, the entire linear mapping will be available */
 	memblock_set_current_limit(lowmem_end_addr);
 }
-- 
2.20.1
