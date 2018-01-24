From: Igor Stoppa <igor.stoppa@huawei.com>
Date: Wed, 24 Jan 2018 19:56:31 +0200
Message-ID: <20180124175631.22925-7-igor.stoppa@huawei.com>
In-Reply-To: <20180124175631.22925-1-igor.stoppa@huawei.com>
References: <20180124175631.22925-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [PATCH 6/6] Pmalloc: self-test
To: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org
Cc: cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

Add basic self-test functionality for pmalloc.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
---
 mm/Kconfig            |  7 ++++++
 mm/Makefile           |  1 +
 mm/pmalloc-selftest.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/pmalloc-selftest.h | 30 ++++++++++++++++++++++++
 mm/pmalloc.c          |  3 +++
 5 files changed, 106 insertions(+)
 create mode 100644 mm/pmalloc-selftest.c
 create mode 100644 mm/pmalloc-selftest.h

diff --git a/mm/Kconfig b/mm/Kconfig
index c782e8f..1de6ea6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -760,3 +760,10 @@ config GUP_BENCHMARK
 	  performance of get_user_pages_fast().
 
 	  See tools/testing/selftests/vm/gup_benchmark.c
+
+config PROTECTABLE_MEMORY_SELFTEST
+	bool "Run self test for pmalloc memory allocator"
+	default n
+	help
+	  Tries to verify that pmalloc works correctly and that the memory
+	  is effectively protected.
diff --git a/mm/Makefile b/mm/Makefile
index a6a47e1..1e76a9b 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
 obj-$(CONFIG_SLOB) += slob.o
 obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o
 obj-$(CONFIG_ARCH_HAS_SET_MEMORY) += pmalloc.o
+obj-$(CONFIG_PROTECTABLE_MEMORY_SELFTEST) += pmalloc-selftest.o
 obj-$(CONFIG_KSM) += ksm.o
 obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_SLAB) += slab.o
diff --git a/mm/pmalloc-selftest.c b/mm/pmalloc-selftest.c
new file mode 100644
index 0000000..1c025f3
--- /dev/null
+++ b/mm/pmalloc-selftest.c
@@ -0,0 +1,65 @@
+/*
+ * pmalloc-selftest.c
+ *
+ * (C) Copyright 2018 Huawei Technologies Co. Ltd.
+ * Author: Igor Stoppa <igor.stoppa@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/pmalloc.h>
+#include <linux/mm.h>
+
+
+#define SIZE_1 (PAGE_SIZE * 3)
+#define SIZE_2 1000
+
+#define validate_alloc(expected, variable, size)	\
+	pr_notice("must be " expected ": %s",		\
+		  is_pmalloc_object(variable, size) > 0 ? "ok" : "no")
+
+#define is_alloc_ok(variable, size)	\
+	validate_alloc("ok", variable, size)
+
+#define is_alloc_no(variable, size)	\
+	validate_alloc("no", variable, size)
+
+void pmalloc_selftest(void)
+{
+	struct gen_pool *pool_unprot;
+	struct gen_pool *pool_prot;
+	void *var_prot, *var_unprot, *var_vmall;
+
+	pr_notice("pmalloc self-test");
+	pool_unprot = pmalloc_create_pool("unprotected", 0);
+	pool_prot = pmalloc_create_pool("protected", 0);
+	BUG_ON(!(pool_unprot && pool_prot));
+
+	var_unprot = pmalloc(pool_unprot,  SIZE_1 - 1, GFP_KERNEL);
+	var_prot = pmalloc(pool_prot,  SIZE_1, GFP_KERNEL);
+	var_vmall = vmalloc(SIZE_2);
+	is_alloc_ok(var_unprot, 10);
+	is_alloc_ok(var_unprot, SIZE_1);
+	is_alloc_ok(var_unprot, PAGE_SIZE);
+	is_alloc_no(var_unprot, SIZE_1 + 1);
+	is_alloc_no(var_vmall, 10);
+
+
+	pfree(pool_unprot, var_unprot);
+	vfree(var_vmall);
+
+	pmalloc_protect_pool(pool_prot);
+
+	/* This will intentionally trigger a WARN because the pool being
+	 * destroyed is not protected, which is unusual and should happen
+	 * on error paths only, where probably other warnings are already
+	 * displayed.
+	 */
+	pmalloc_destroy_pool(pool_unprot);
+
+	/* This must not cause WARNings */
+	pmalloc_destroy_pool(pool_prot);
+}
diff --git a/mm/pmalloc-selftest.h b/mm/pmalloc-selftest.h
new file mode 100644
index 0000000..3673d23
--- /dev/null
+++ b/mm/pmalloc-selftest.h
@@ -0,0 +1,30 @@
+/*
+ * pmalloc-selftest.h
+ *
+ * (C) Copyright 2018 Huawei Technologies Co. Ltd.
+ * Author: Igor Stoppa <igor.stoppa@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+
+#ifndef __PMALLOC_SELFTEST_H__
+#define __PMALLOC_SELFTEST_H__
+
+
+#ifdef CONFIG_PROTECTABLE_MEMORY_SELFTEST
+
+#include <linux/pmalloc.h>
+
+void pmalloc_selftest(void);
+
+#else
+
+static inline void pmalloc_selftest(void){};
+
+#endif
+
+#endif
diff --git a/mm/pmalloc.c b/mm/pmalloc.c
index a64ac49..a722d7b 100644
--- a/mm/pmalloc.c
+++ b/mm/pmalloc.c
@@ -25,6 +25,8 @@
 #include <asm/cacheflush.h>
 #include <asm/page.h>
 
+#include "pmalloc-selftest.h"
+
 /**
  * pmalloc_data contains the data specific to a pmalloc pool,
  * in a format compatible with the design of gen_alloc.
@@ -508,6 +510,7 @@ static int __init pmalloc_late_init(void)
 		}
 	}
 	mutex_unlock(&pmalloc_mutex);
+	pmalloc_selftest();
 	return 0;
 }
 late_initcall(pmalloc_late_init);
-- 
2.9.3
