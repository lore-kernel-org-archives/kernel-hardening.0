From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 16/17] prmem: pratomic-long
Date: Wed, 24 Oct 2018 00:35:03 +0300
Message-Id: <20181023213504.28905-17-igor.stoppa@huawei.com>
In-Reply-To: <20181023213504.28905-1-igor.stoppa@huawei.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Minimalistic functionality for having the write rare version of
atomic_long_t data.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>
CC: linux-arch@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 MAINTAINERS                   |  1 +
 include/linux/pratomic-long.h | 73 +++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)
 create mode 100644 include/linux/pratomic-long.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e7f7cb1682a6..9d72688d00a3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9466,6 +9466,7 @@ F:	mm/test_pmalloc.c
 F:	Documentation/core-api/prmem.rst
 F:	include/linux/prlist.h
 F:	lib/test_prlist.c
+F:	include/linux/pratomic-long.h
 
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
diff --git a/include/linux/pratomic-long.h b/include/linux/pratomic-long.h
new file mode 100644
index 000000000000..8f1408593733
--- /dev/null
+++ b/include/linux/pratomic-long.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Atomic operations for write rare memory */
+#ifndef _LINUX_PRATOMIC_LONG_H
+#define _LINUX_PRATOMIC_LONG_H
+#include <linux/prmem.h>
+#include <linux/compiler.h>
+#include <asm-generic/atomic-long.h>
+
+struct pratomic_long_t {
+	atomic_long_t l __aligned(sizeof(atomic_long_t));
+} __aligned(sizeof(atomic_long_t));
+
+#define PRATOMIC_LONG_INIT(i)	{	\
+	.l = ATOMIC_LONG_INIT((i)),	\
+}
+
+static __always_inline
+bool __pratomic_long_op(bool inc, struct pratomic_long_t *l)
+{
+	struct page *page;
+	uintptr_t base;
+	uintptr_t offset;
+	unsigned long flags;
+	size_t size = sizeof(*l);
+	bool is_virt = __is_wr_after_init(l, size);
+
+	if (WARN(!(is_virt || likely(__is_wr_pool(l, size))),
+		 WR_ERR_RANGE_MSG))
+		return false;
+	local_irq_save(flags);
+	if (is_virt)
+		page = virt_to_page(l);
+	else
+		vmalloc_to_page(l);
+	offset = (~PAGE_MASK) & (uintptr_t)l;
+	base = (uintptr_t)vmap(&page, 1, VM_MAP, PAGE_KERNEL);
+	if (WARN(!base, WR_ERR_PAGE_MSG)) {
+		local_irq_restore(flags);
+		return false;
+	}
+	if (inc)
+		atomic_long_inc((atomic_long_t *)(base + offset));
+	else
+		atomic_long_dec((atomic_long_t *)(base + offset));
+	vunmap((void *)base);
+	local_irq_restore(flags);
+	return true;
+
+}
+
+/**
+ * pratomic_long_inc - atomic increment of rare write long
+ * @l: address of the variable of type struct pratomic_long_t
+ *
+ * Return: true on success, false otherwise
+ */
+static __always_inline bool pratomic_long_inc(struct pratomic_long_t *l)
+{
+	return __pratomic_long_op(true, l);
+}
+
+/**
+ * pratomic_long_inc - atomic decrement of rare write long
+ * @l: address of the variable of type struct pratomic_long_t
+ *
+ * Return: true on success, false otherwise
+ */
+static __always_inline bool pratomic_long_dec(struct pratomic_long_t *l)
+{
+	return __pratomic_long_op(false, l);
+}
+
+#endif
-- 
2.17.1
