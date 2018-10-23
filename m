From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH 15/17] prmem: test cases for prlist and prhlist
Date: Wed, 24 Oct 2018 00:35:02 +0300
Message-Id: <20181023213504.28905-16-igor.stoppa@huawei.com>
In-Reply-To: <20181023213504.28905-1-igor.stoppa@huawei.com>
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Kate Stewart <kstewart@linuxfoundation.org>, Philippe Ombredanne <pombredanne@nexb.com>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Edward Cree <ecree@solarflare.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

These test cases focus on the basic operations required to operate
both prlist and prhlist data, in particular creating, growing, shrinking,
destroying.

They can also be useful as reference for practical use of write-rare lists.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
CC: Kate Stewart <kstewart@linuxfoundation.org>
CC: Philippe Ombredanne <pombredanne@nexb.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Edward Cree <ecree@solarflare.com>
CC: linux-kernel@vger.kernel.org
---
 MAINTAINERS       |   1 +
 lib/Kconfig.debug |   9 ++
 lib/Makefile      |   1 +
 lib/test_prlist.c | 252 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 263 insertions(+)
 create mode 100644 lib/test_prlist.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f5689c014e07..e7f7cb1682a6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9465,6 +9465,7 @@ F:	mm/test_write_rare.c
 F:	mm/test_pmalloc.c
 F:	Documentation/core-api/prmem.rst
 F:	include/linux/prlist.h
+F:	lib/test_prlist.c
 
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4966c4fbe7f7..40039992f05f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2034,6 +2034,15 @@ config IO_STRICT_DEVMEM
 
 	  If in doubt, say Y.
 
+config DEBUG_PRLIST_TEST
+	bool "Testcase for Protected Linked List"
+	depends on STRICT_KERNEL_RWX && PRMEM
+	help
+	  This option enables the testing of an implementation of linked
+	  list based on write rare memory.
+	  The test cases can also be used as examples for how to use the
+	  prlist data structure(s).
+
 source "arch/$(SRCARCH)/Kconfig.debug"
 
 endmenu # Kernel hacking
diff --git a/lib/Makefile b/lib/Makefile
index 423876446810..fe7200e84c5f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -270,3 +270,4 @@ obj-$(CONFIG_GENERIC_LIB_LSHRDI3) += lshrdi3.o
 obj-$(CONFIG_GENERIC_LIB_MULDI3) += muldi3.o
 obj-$(CONFIG_GENERIC_LIB_CMPDI2) += cmpdi2.o
 obj-$(CONFIG_GENERIC_LIB_UCMPDI2) += ucmpdi2.o
+obj-$(CONFIG_DEBUG_PRLIST_TEST) += test_prlist.o
diff --git a/lib/test_prlist.c b/lib/test_prlist.c
new file mode 100644
index 000000000000..8ee46795d72a
--- /dev/null
+++ b/lib/test_prlist.c
@@ -0,0 +1,252 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * test_prlist.c: Test cases for protected doubly linked list
+ *
+ * (C) Copyright 2018 Huawei Technologies Co. Ltd.
+ * Author: Igor Stoppa <igor.stoppa@huawei.com>
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/bug.h>
+#include <linux/prlist.h>
+
+
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+static struct pmalloc_pool *pool;
+
+static PRLIST_HEAD(test_prlist_head);
+
+/* ---------------------- prlist test functions ---------------------- */
+static bool test_init_prlist_head(void)
+{
+	if (WARN(test_prlist_head.prev != &test_prlist_head ||
+		 test_prlist_head.next != &test_prlist_head,
+		 "static initialization of static prlist_head failed"))
+		return false;
+	wr_ptr(&test_prlist_head.next, NULL);
+	wr_ptr(&test_prlist_head.prev, NULL);
+	if (WARN(test_prlist_head.prev || test_prlist_head.next,
+		 "resetting of static prlist_head failed"))
+		return false;
+	INIT_PRLIST_HEAD(&test_prlist_head);
+	if (WARN(test_prlist_head.prev != &test_prlist_head ||
+		 test_prlist_head.next != &test_prlist_head,
+		 "initialization of static prlist_head failed"))
+		return false;
+	pr_info("initialization of static prlist_head passed");
+	return true;
+}
+
+struct prlist_data {
+	int d_int;
+	union prlist_head node;
+	unsigned long long d_ulonglong;
+};
+
+
+#define LIST_INTERVAL 5
+#define LIST_INTERVALS 3
+#define LIST_NODES (LIST_INTERVALS * LIST_INTERVAL)
+static bool test_build_prlist(void)
+{
+	short i;
+	struct prlist_data *data;
+	int delta;
+
+	pool = prlist_create_pool();
+	if (WARN(!pool, "could not create pool"))
+		return false;
+
+	for (i = 0; i < LIST_NODES; i++) {
+		data = (struct prlist_data *)pmalloc(pool, sizeof(*data));
+		if (WARN(!data, "Failed to allocate prlist node"))
+			goto out;
+		wr_int(&data->d_int, i);
+		wr_ulonglong(&data->d_ulonglong, i);
+		prlist_add_tail(&data->node, &test_prlist_head);
+	}
+	for (i = 1; i < LIST_NODES; i++) {
+		data = (struct prlist_data *)pmalloc(pool, sizeof(*data));
+		if (WARN(!data, "Failed to allocate prlist node"))
+			goto out;
+		wr_int(&data->d_int, i);
+		wr_ulonglong(&data->d_ulonglong, i);
+		prlist_add(&data->node, &test_prlist_head);
+	}
+	i = LIST_NODES;
+	delta = -1;
+	list_for_each_entry(data, &test_prlist_head, node) {
+		i += delta;
+		if (!i)
+			delta = 1;
+		if (WARN(data->d_int != i || data->d_ulonglong != i,
+			 "unexpected value in prlist, build test failed"))
+			goto out;
+	}
+	pr_info("build prlist test passed");
+	return true;
+out:
+	pmalloc_destroy_pool(pool);
+	return false;
+}
+
+static bool test_teardown_prlist(void)
+{
+	short i;
+
+	for (i = 0; !list_empty(&test_prlist_head.list); i++)
+		prlist_del(test_prlist_head.next);
+	if (WARN(i != LIST_NODES * 2 - 1, "teardown prlist test failed"))
+		return false;
+	pmalloc_destroy_pool(pool);
+	pr_info("teardown prlist test passed");
+	return true;
+}
+
+static bool test_prlist(void)
+{
+	if (WARN(!(test_init_prlist_head() &&
+		   test_build_prlist() &&
+		   test_teardown_prlist()),
+		 "prlist test failed"))
+		return false;
+	pr_info("prlist test passed");
+	return true;
+}
+
+/* ---------------------- prhlist test functions ---------------------- */
+static PRHLIST_HEAD(test_prhlist_head);
+
+static bool test_init_prhlist_head(void)
+{
+	if (WARN(test_prhlist_head.first,
+		 "static initialization of static prhlist_head failed"))
+		return false;
+	wr_ptr(&test_prhlist_head.first, (void *)-1);
+	if (WARN(!test_prhlist_head.first,
+		 "resetting of static prhlist_head failed"))
+		return false;
+	INIT_PRHLIST_HEAD(&test_prhlist_head);
+	if (WARN(!test_prlist_head.prev,
+		 "initialization of static prhlist_head failed"))
+		return false;
+	pr_info("initialization of static prlist_head passed");
+	return true;
+}
+
+struct prhlist_data {
+	int d_int;
+	union prhlist_node node;
+	unsigned long long d_ulonglong;
+};
+
+static bool test_build_prhlist(void)
+{
+	short i;
+	struct prhlist_data *data;
+	union prhlist_node *anchor;
+
+	pool = prhlist_create_pool();
+	if (WARN(!pool, "could not create pool"))
+		return false;
+
+	for (i = 2 * LIST_INTERVAL - 1; i >= LIST_INTERVAL; i--) {
+		data = (struct prhlist_data *)pmalloc(pool, sizeof(*data));
+		if (WARN(!data, "Failed to allocate prhlist node"))
+			goto out;
+		wr_int(&data->d_int, i);
+		wr_ulonglong(&data->d_ulonglong, i);
+		prhlist_add_head(&data->node, &test_prhlist_head);
+	}
+	anchor = test_prhlist_head.first;
+	for (i = 0; i < LIST_INTERVAL; i++) {
+		data = (struct prhlist_data *)pmalloc(pool, sizeof(*data));
+		if (WARN(!data, "Failed to allocate prhlist node"))
+			goto out;
+		wr_int(&data->d_int, i);
+		wr_ulonglong(&data->d_ulonglong, i);
+		prhlist_add_before(&data->node, anchor);
+	}
+	hlist_for_each_entry(data, &test_prhlist_head, node)
+		if (!data->node.next)
+			anchor = &data->node;
+	for (i = 3 * LIST_INTERVAL - 1; i >= 2 * LIST_INTERVAL; i--) {
+		data = (struct prhlist_data *)pmalloc(pool, sizeof(*data));
+		if (WARN(!data, "Failed to allocate prhlist node"))
+			goto out;
+		wr_int(&data->d_int, i);
+		wr_ulonglong(&data->d_ulonglong, i);
+		prhlist_add_behind(&data->node, anchor);
+	}
+	i = 0;
+	hlist_for_each_entry(data, &test_prhlist_head, node) {
+		if (WARN(data->d_int != i || data->d_ulonglong != i,
+			 "unexpected value in prhlist, build test failed"))
+			goto out;
+		i++;
+	}
+	if (WARN(i != LIST_NODES,
+		 "wrong number of nodes: %d, expectd %d", i, LIST_NODES))
+		goto out;
+	pr_info("build prhlist test passed");
+	return true;
+out:
+	pmalloc_destroy_pool(pool);
+	return false;
+}
+
+static bool test_teardown_prhlist(void)
+{
+	union prhlist_node **pnode;
+	bool retval = false;
+
+	for (pnode = &test_prhlist_head.first->next; *pnode;) {
+		if (WARN(*(*pnode)->pprev != *pnode,
+			 "inconsistent pprev value, delete test failed"))
+			goto err;
+		prhlist_del(*pnode);
+	}
+	prhlist_del(test_prhlist_head.first);
+	if (WARN(!hlist_empty(&test_prhlist_head.head),
+		 "prhlist is not empty, delete test failed"))
+		goto err;
+	pr_info("deletion of prhlist passed");
+	retval = true;
+err:
+	pmalloc_destroy_pool(pool);
+	return retval;
+}
+
+static bool test_prhlist(void)
+{
+	if (WARN(!(test_init_prhlist_head() &&
+		   test_build_prhlist() &&
+		   test_teardown_prhlist()),
+		 "prhlist test failed"))
+		return false;
+	pr_info("prhlist test passed");
+	return true;
+}
+
+static int __init test_prlists_init_module(void)
+{
+	if (WARN(!(test_prlist() &&
+		   test_prhlist()),
+		 "protected lists test failed"))
+		return -EFAULT;
+	pr_info("protected lists test passed");
+	return 0;
+}
+
+module_init(test_prlists_init_module);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Igor Stoppa <igor.stoppa@huawei.com>");
+MODULE_DESCRIPTION("Test module for protected doubly linked list.");
-- 
2.17.1
