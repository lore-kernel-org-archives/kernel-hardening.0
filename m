Return-Path: <SRS0=9dNV=5J=lists.openwall.com=kernel-hardening-return-18178-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2348C2BAEE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:42:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AAB6620714
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 15:42:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CJXQJ93H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AAB6620714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18178-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32276 invoked by uid 550); 24 Mar 2020 15:37:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32182 invoked from network); 24 Mar 2020 15:37:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064262;
	bh=/+w15zcKOcmgqe23AgjGWFM0gT80vqtCSWcEwhZiIJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJXQJ93HTkEI4jfBGVE74y5sLzvl16jl0zlJJ3xUJDVhDNJlh/GEDLokjGDr/gn7N
	 eRkP9dyh2GgbZB1XfI1NyeCsAiboLZ524esMiPSm7+GnDsyETim7urN/ZOR8/0yC7W
	 TnXf7C4dyXu7cBjjAtiVU8kBmddt52oyrgxqHRRw=
From: Will Deacon <will@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH 21/21] lkdtm: Extend list corruption checks
Date: Tue, 24 Mar 2020 15:36:43 +0000
Message-Id: <20200324153643.15527-22-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324153643.15527-1-will@kernel.org>
References: <20200324153643.15527-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although lkdtm has a couple of simple tests for triggering list
corruption, there are plenty of things it doesn't trigger, particularly
now that we have forms of integrity checking for other list types.

Extend lkdtm to check a variety of list insertion and deletion routines.

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Will Deacon <will@kernel.org>
---
 drivers/misc/lkdtm/Makefile             |   1 +
 drivers/misc/lkdtm/bugs.c               |  68 ----
 drivers/misc/lkdtm/core.c               |  31 +-
 drivers/misc/lkdtm/list.c               | 489 ++++++++++++++++++++++++
 drivers/misc/lkdtm/lkdtm.h              |  33 +-
 tools/testing/selftests/lkdtm/tests.txt |  31 +-
 6 files changed, 579 insertions(+), 74 deletions(-)
 create mode 100644 drivers/misc/lkdtm/list.c

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index c70b3822013f..833c6f7c78a3 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -10,6 +10,7 @@ lkdtm-$(CONFIG_LKDTM)		+= rodata_objcopy.o
 lkdtm-$(CONFIG_LKDTM)		+= usercopy.o
 lkdtm-$(CONFIG_LKDTM)		+= stackleak.o
 lkdtm-$(CONFIG_LKDTM)		+= cfi.o
+lkdtm-$(CONFIG_LKDTM)		+= list.o
 
 KASAN_SANITIZE_stackleak.o	:= n
 KCOV_INSTRUMENT_rodata.o	:= n
diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index de87693cf557..de0c54c8fac3 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -6,7 +6,6 @@
  * test source files.
  */
 #include "lkdtm.h"
-#include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
@@ -16,10 +15,6 @@
 #include <asm/desc.h>
 #endif
 
-struct lkdtm_list {
-	struct list_head node;
-};
-
 /*
  * Make sure our attempts to over run the kernel stack doesn't trigger
  * a compiler warning when CONFIG_FRAME_WARN is set. Then make sure we
@@ -175,69 +170,6 @@ void lkdtm_HUNG_TASK(void)
 	schedule();
 }
 
-void lkdtm_CORRUPT_LIST_ADD(void)
-{
-	/*
-	 * Initially, an empty list via LIST_HEAD:
-	 *	test_head.next = &test_head
-	 *	test_head.prev = &test_head
-	 */
-	LIST_HEAD(test_head);
-	struct lkdtm_list good, bad;
-	void *target[2] = { };
-	void *redirection = &target;
-
-	pr_info("attempting good list addition\n");
-
-	/*
-	 * Adding to the list performs these actions:
-	 *	test_head.next->prev = &good.node
-	 *	good.node.next = test_head.next
-	 *	good.node.prev = test_head
-	 *	test_head.next = good.node
-	 */
-	list_add(&good.node, &test_head);
-
-	pr_info("attempting corrupted list addition\n");
-	/*
-	 * In simulating this "write what where" primitive, the "what" is
-	 * the address of &bad.node, and the "where" is the address held
-	 * by "redirection".
-	 */
-	test_head.next = redirection;
-	list_add(&bad.node, &test_head);
-
-	if (target[0] == NULL && target[1] == NULL)
-		pr_err("Overwrite did not happen, but no BUG?!\n");
-	else
-		pr_err("list_add() corruption not detected!\n");
-}
-
-void lkdtm_CORRUPT_LIST_DEL(void)
-{
-	LIST_HEAD(test_head);
-	struct lkdtm_list item;
-	void *target[2] = { };
-	void *redirection = &target;
-
-	list_add(&item.node, &test_head);
-
-	pr_info("attempting good list removal\n");
-	list_del(&item.node);
-
-	pr_info("attempting corrupted list removal\n");
-	list_add(&item.node, &test_head);
-
-	/* As with the list_add() test above, this corrupts "next". */
-	item.node.next = redirection;
-	list_del(&item.node);
-
-	if (target[0] == NULL && target[1] == NULL)
-		pr_err("Overwrite did not happen, but no BUG?!\n");
-	else
-		pr_err("list_del() corruption not detected!\n");
-}
-
 /* Test if unbalanced set_fs(KERNEL_DS)/set_fs(USER_DS) check exists. */
 void lkdtm_CORRUPT_USER_DS(void)
 {
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index ee0d6e721441..28aace88474f 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -110,8 +110,6 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(EXHAUST_STACK),
 	CRASHTYPE(CORRUPT_STACK),
 	CRASHTYPE(CORRUPT_STACK_STRONG),
-	CRASHTYPE(CORRUPT_LIST_ADD),
-	CRASHTYPE(CORRUPT_LIST_DEL),
 	CRASHTYPE(CORRUPT_USER_DS),
 	CRASHTYPE(STACK_GUARD_PAGE_LEADING),
 	CRASHTYPE(STACK_GUARD_PAGE_TRAILING),
@@ -174,6 +172,35 @@ static const struct crashtype crashtypes[] = {
 #ifdef CONFIG_X86_32
 	CRASHTYPE(DOUBLE_FAULT),
 #endif
+	CRASHTYPE(LIST_ADD_NEXT_CORRUPTION),
+	CRASHTYPE(LIST_ADD_PREV_CORRUPTION),
+	CRASHTYPE(LIST_ADD_TWICE),
+	CRASHTYPE(LIST_DEL_NEXT_CORRUPTION),
+	CRASHTYPE(LIST_DEL_PREV_CORRUPTION),
+	CRASHTYPE(LIST_DEL_TWICE),
+	CRASHTYPE(HLIST_ADD_HEAD_CORRUPTION),
+	CRASHTYPE(HLIST_ADD_HEAD_TWICE),
+	CRASHTYPE(HLIST_ADD_BEFORE_CORRUPTION),
+	CRASHTYPE(HLIST_ADD_BEFORE_TWICE),
+	CRASHTYPE(HLIST_ADD_BEHIND_CORRUPTION),
+	CRASHTYPE(HLIST_ADD_BEHIND_TWICE),
+	CRASHTYPE(HLIST_DEL_PREV_CORRUPTION),
+	CRASHTYPE(HLIST_DEL_NEXT_CORRUPTION),
+	CRASHTYPE(HLIST_DEL_TWICE),
+	CRASHTYPE(HLIST_NULLS_ADD_HEAD_CORRUPTION),
+	CRASHTYPE(HLIST_NULLS_ADD_HEAD_TWICE),
+	CRASHTYPE(HLIST_NULLS_DEL_PREV_CORRUPTION),
+	CRASHTYPE(HLIST_NULLS_DEL_NEXT_CORRUPTION),
+	CRASHTYPE(HLIST_NULLS_DEL_TWICE),
+	CRASHTYPE(HLIST_BL_ADD_HEAD_UNLOCKED),
+	CRASHTYPE(HLIST_BL_ADD_HEAD_NODE_LOCKED),
+	CRASHTYPE(HLIST_BL_ADD_HEAD_CORRUPTION),
+	CRASHTYPE(HLIST_BL_ADD_HEAD_TWICE),
+	CRASHTYPE(HLIST_BL_DEL_NODE_LOCKED),
+	CRASHTYPE(HLIST_BL_DEL_NEXT_LOCKED),
+	CRASHTYPE(HLIST_BL_DEL_PREV_CORRUPTION),
+	CRASHTYPE(HLIST_BL_DEL_NEXT_CORRUPTION),
+	CRASHTYPE(HLIST_BL_DEL_TWICE),
 };
 
 
diff --git a/drivers/misc/lkdtm/list.c b/drivers/misc/lkdtm/list.c
new file mode 100644
index 000000000000..e62a7de51eac
--- /dev/null
+++ b/drivers/misc/lkdtm/list.c
@@ -0,0 +1,489 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * This is for all the tests related to list integrity checking.
+ */
+
+#include "lkdtm.h"
+#include <linux/list.h>
+
+#define LIST_REDIR_BUF(type, name)				\
+union {								\
+	type	list;						\
+	char	buf[sizeof(type)];				\
+} name = { }
+
+static void __check_list_redir_buf(const char *str, char *buf, size_t sz)
+{
+	for (; sz && !buf[sz - 1]; sz--);
+	if (sz)
+		pr_err("%s: corruption not detected!\n", str);
+	else
+		pr_err("%s: overwrite did not happen, but no BUG?!\n", str);
+}
+
+#define check_list_redir_buf(s, b)	\
+	__check_list_redir_buf((s), (b).buf, sizeof(b.buf))
+
+void lkdtm_LIST_ADD_NEXT_CORRUPTION(void)
+{
+	LIST_HEAD(head);
+	LIST_HEAD(mid);
+	LIST_HEAD(tail);
+	LIST_REDIR_BUF(struct list_head, target);
+
+	list_add(&tail, &head);
+	head.next = &target.list;
+	list_add(&mid, &head);
+	check_list_redir_buf("list_add()", target);
+}
+
+void lkdtm_LIST_ADD_PREV_CORRUPTION(void)
+{
+	LIST_HEAD(head);
+	LIST_HEAD(mid);
+	LIST_HEAD(tail);
+	LIST_REDIR_BUF(struct list_head, target);
+
+	list_add(&tail, &head);
+	tail.prev = &target.list;
+	list_add_tail(&mid, &tail);
+	check_list_redir_buf("list_add()", target);
+}
+
+void lkdtm_LIST_ADD_TWICE(void)
+{
+	LIST_HEAD(head);
+	LIST_HEAD(mid);
+	LIST_HEAD(tail);
+
+	list_add(&tail, &head);
+	mid = tail;
+	list_add(&tail, &head);
+
+	if (mid.prev != tail.prev || mid.next != tail.next)
+		pr_err("list_add(): adding twice not detected!\n");
+	else
+		pr_err("list_add(): could not add twice, but no BUG?!\n");
+}
+
+void lkdtm_LIST_DEL_NEXT_CORRUPTION(void)
+{
+	LIST_HEAD(head);
+	LIST_HEAD(mid);
+	LIST_HEAD(tail);
+	LIST_REDIR_BUF(struct list_head, target);
+
+	list_add(&tail, &head);
+	list_add(&mid, &head);
+	mid.next = &target.list;
+	list_del(&mid);
+	check_list_redir_buf("list_del()", target);
+}
+
+void lkdtm_LIST_DEL_PREV_CORRUPTION(void)
+{
+	LIST_HEAD(head);
+	LIST_HEAD(mid);
+	LIST_HEAD(tail);
+	LIST_REDIR_BUF(struct list_head, target);
+
+	list_add(&tail, &head);
+	list_add(&mid, &head);
+	mid.prev = &target.list;
+	list_del(&mid);
+	check_list_redir_buf("list_del()", target);
+}
+
+void lkdtm_LIST_DEL_TWICE(void)
+{
+	LIST_HEAD(head);
+	LIST_HEAD(tail);
+
+	list_add(&tail, &head);
+	list_del(&tail);
+
+	if (tail.prev != LIST_POISON2 || tail.next != LIST_POISON1) {
+		pr_err("list_del(): prev/next pointers not poisoned!\n");
+	} else {
+		list_del(&tail);
+		pr_err("list_del(): could not delete twice, but no BUG?!\n");
+	}
+}
+
+void lkdtm_HLIST_ADD_HEAD_CORRUPTION(void)
+{
+	HLIST_HEAD(head);
+	LIST_REDIR_BUF(struct hlist_node, target);
+	struct hlist_node mid, tail;
+
+	INIT_HLIST_NODE(&mid);
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&tail, &head);
+	head.first = &target.list;
+	hlist_add_head(&mid, &head);
+	check_list_redir_buf("hlist_add_head()", target);
+}
+
+void lkdtm_HLIST_ADD_HEAD_TWICE(void)
+{
+	HLIST_HEAD(head);
+	struct hlist_node mid, tail;
+
+	INIT_HLIST_NODE(&mid);
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&tail, &head);
+	mid = tail;
+	hlist_add_head(&tail, &head);
+
+	if (mid.next != tail.next || mid.pprev != tail.pprev)
+		pr_err("hlist_add_head(): adding twice not detected!\n");
+	else
+		pr_err("hlist_add_head(): could not add twice, but no BUG?!\n");
+}
+
+void lkdtm_HLIST_ADD_BEFORE_CORRUPTION(void)
+{
+	HLIST_HEAD(head);
+	LIST_REDIR_BUF(struct hlist_node, target);
+	struct hlist_node mid, tail;
+
+	INIT_HLIST_NODE(&mid);
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&tail, &head);
+	tail.pprev = &target.list.next;
+	hlist_add_before(&mid, &tail);
+	check_list_redir_buf("hlist_add_before()", target);
+}
+
+void lkdtm_HLIST_ADD_BEFORE_TWICE(void)
+{
+	HLIST_HEAD(head);
+	struct hlist_node mid, tail;
+
+	INIT_HLIST_NODE(&mid);
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&tail, &head);
+	mid = tail;
+	hlist_add_before(&tail, &tail);
+
+	if (mid.next != tail.next || mid.pprev != tail.pprev)
+		pr_err("hlist_add_before(): adding twice not detected!\n");
+	else
+		pr_err("hlist_add_before(): could not add twice, but no BUG?!\n");
+}
+
+void lkdtm_HLIST_ADD_BEHIND_CORRUPTION(void)
+{
+	HLIST_HEAD(head);
+	LIST_REDIR_BUF(struct hlist_node, target);
+	struct hlist_node mid, tail;
+
+	INIT_HLIST_NODE(&mid);
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&mid, &head);
+	mid.next = &target.list;
+	hlist_add_behind(&tail, &mid);
+	check_list_redir_buf("hlist_add_behind()", target);
+}
+
+void lkdtm_HLIST_ADD_BEHIND_TWICE(void)
+{
+	HLIST_HEAD(head);
+	struct hlist_node mid, tail;
+
+	INIT_HLIST_NODE(&mid);
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&tail, &head);
+	mid = tail;
+	hlist_add_behind(&tail, &tail);
+
+	if (mid.next != tail.next || mid.pprev != tail.pprev)
+		pr_err("hlist_add_behind(): adding twice not detected!\n");
+	else
+		pr_err("hlist_add_behind(): could not add twice, but no BUG?!\n");
+}
+
+void lkdtm_HLIST_DEL_PREV_CORRUPTION(void)
+{
+	HLIST_HEAD(head);
+	LIST_REDIR_BUF(struct hlist_node, target);
+	struct hlist_node mid, tail;
+
+	INIT_HLIST_NODE(&mid);
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&tail, &head);
+	hlist_add_head(&mid, &head);
+	mid.pprev = &target.list.next;
+	hlist_del(&mid);
+	check_list_redir_buf("hlist_del()", target);
+}
+
+void lkdtm_HLIST_DEL_NEXT_CORRUPTION(void)
+{
+	HLIST_HEAD(head);
+	LIST_REDIR_BUF(struct hlist_node, target);
+	struct hlist_node mid, tail;
+
+	INIT_HLIST_NODE(&mid);
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&tail, &head);
+	hlist_add_head(&mid, &head);
+	mid.next = &target.list;
+	hlist_del(&mid);
+	check_list_redir_buf("hlist_del()", target);
+}
+
+void lkdtm_HLIST_DEL_TWICE(void)
+{
+	HLIST_HEAD(head);
+	struct hlist_node tail;
+
+	INIT_HLIST_NODE(&tail);
+	hlist_add_head(&tail, &head);
+	hlist_del(&tail);
+
+	if (tail.next != LIST_POISON1 || tail.pprev != LIST_POISON2) {
+		pr_err("hlist_del(): pprev/next pointers not poisoned!\n");
+	} else {
+		hlist_del(&tail);
+		pr_err("hlist_del(): could not delete twice, but no BUG?!\n");
+	}
+}
+
+#include <linux/list_nulls.h>
+
+void lkdtm_HLIST_NULLS_ADD_HEAD_CORRUPTION(void)
+{
+	LIST_REDIR_BUF(struct hlist_nulls_node, target);
+	struct hlist_nulls_head head;
+	struct hlist_nulls_node mid, tail;
+
+	INIT_HLIST_NULLS_HEAD(&head, 0);
+	hlist_nulls_add_head(&tail, &head);
+	head.first = &target.list;
+	hlist_nulls_add_head(&mid, &head);
+	check_list_redir_buf("hlist_nulls_add_head()", target);
+}
+
+void lkdtm_HLIST_NULLS_ADD_HEAD_TWICE(void)
+{
+	struct hlist_nulls_head head;
+	struct hlist_nulls_node mid, tail;
+
+	INIT_HLIST_NULLS_HEAD(&head, 0);
+	hlist_nulls_add_head(&tail, &head);
+	mid = tail;
+	hlist_nulls_add_head(&tail, &head);
+
+	if (mid.next != tail.next || mid.pprev != tail.pprev)
+		pr_err("hlist_nulls_add_head(): adding twice not detected!\n");
+	else
+		pr_err("hlist_nulls_add_head(): could not add twice, but no BUG?!\n");
+}
+
+void lkdtm_HLIST_NULLS_DEL_PREV_CORRUPTION(void)
+{
+	LIST_REDIR_BUF(struct hlist_nulls_node, target);
+	struct hlist_nulls_head head;
+	struct hlist_nulls_node mid, tail;
+
+	INIT_HLIST_NULLS_HEAD(&head, 0);
+	hlist_nulls_add_head(&tail, &head);
+	hlist_nulls_add_head(&mid, &head);
+	mid.pprev = &target.list.next;
+	hlist_nulls_del(&mid);
+	check_list_redir_buf("hlist_nulls_del()", target);
+}
+
+void lkdtm_HLIST_NULLS_DEL_NEXT_CORRUPTION(void)
+{
+	LIST_REDIR_BUF(struct hlist_nulls_node, target);
+	struct hlist_nulls_head head;
+	struct hlist_nulls_node mid, tail;
+
+	INIT_HLIST_NULLS_HEAD(&head, 0);
+	hlist_nulls_add_head(&tail, &head);
+	hlist_nulls_add_head(&mid, &head);
+	mid.next = &target.list;
+	hlist_nulls_del(&mid);
+	check_list_redir_buf("hlist_nulls_del()", target);
+}
+
+void lkdtm_HLIST_NULLS_DEL_TWICE(void)
+{
+	struct hlist_nulls_head head;
+	struct hlist_nulls_node tail;
+
+	INIT_HLIST_NULLS_HEAD(&head, 0);
+	hlist_nulls_add_head(&tail, &head);
+	hlist_nulls_del(&tail);
+
+	if (tail.next != LIST_POISON1 || tail.pprev != LIST_POISON2) {
+		pr_err("hlist_nulls_del(): pprev/next pointers not poisoned!\n");
+	} else {
+		hlist_nulls_del(&tail);
+		pr_err("hlist_nulls_del(): could not delete twice, but no BUG?!\n");
+	}
+}
+
+#include <linux/list_bl.h>
+
+void lkdtm_HLIST_BL_ADD_HEAD_UNLOCKED(void)
+{
+	LIST_REDIR_BUF(struct hlist_bl_node, target);
+	struct hlist_bl_head head;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_add_head(&target.list, &head);
+	check_list_redir_buf("hlist_bl_add()", target);
+}
+
+void lkdtm_HLIST_BL_ADD_HEAD_NODE_LOCKED(void)
+{
+	LIST_REDIR_BUF(struct hlist_bl_node, target);
+	struct hlist_bl_head head;
+	unsigned long nval;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_lock(&head);
+	nval = (unsigned long)&target.list | LIST_BL_LOCKMASK;
+	hlist_bl_add_head((struct hlist_bl_node *)nval, &head);
+	hlist_bl_unlock(&head);
+
+	check_list_redir_buf("hlist_bl_add()", target);
+}
+
+void lkdtm_HLIST_BL_ADD_HEAD_CORRUPTION(void)
+{
+	LIST_REDIR_BUF(struct hlist_bl_node, target);
+	struct hlist_bl_head head;
+	struct hlist_bl_node mid, tail;
+	unsigned long nval;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_lock(&head);
+	hlist_bl_add_head(&tail, &head);
+	nval = (unsigned long)&target.list | LIST_BL_LOCKMASK;
+	head.first = (struct hlist_bl_node *)nval;
+	hlist_bl_add_head(&mid, &head);
+	hlist_bl_unlock(&head);
+
+	check_list_redir_buf("hlist_bl_add_head()", target);
+}
+
+void lkdtm_HLIST_BL_ADD_HEAD_TWICE(void)
+{
+	struct hlist_bl_head head;
+	struct hlist_bl_node mid, tail;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_lock(&head);
+	hlist_bl_add_head(&tail, &head);
+	mid = tail;
+	hlist_bl_add_head(&tail, &head);
+	hlist_bl_unlock(&head);
+
+	if (mid.next != tail.next || mid.pprev != tail.pprev)
+		pr_err("hlist_bl_add_head(): adding twice not detected!\n");
+	else
+		pr_err("hlist_bl_add_head(): could not add twice, but no BUG?!\n");
+}
+
+void lkdtm_HLIST_BL_DEL_NODE_LOCKED(void)
+{
+	struct hlist_bl_head head;
+	struct hlist_bl_node mid, tail;
+	unsigned long nval;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_lock(&head);
+	hlist_bl_add_head(&tail, &head);
+	hlist_bl_add_head(&mid, &head);
+	hlist_bl_unlock(&head);
+
+	nval = (unsigned long)&mid | LIST_BL_LOCKMASK;
+	/* hlist_bl_del() poisons ->next, so don't use it with a locked node */
+	__hlist_bl_del((struct hlist_bl_node *)nval);
+
+	if (head.first != &mid || tail.pprev != &mid.next)
+		pr_err("hlist_bl_del(): deleting locked node not detected!\n");
+	else
+		pr_err("hlist_bl_del(): could not delete locked node, but no BUG?!\n");
+}
+
+void lkdtm_HLIST_BL_DEL_NEXT_LOCKED(void)
+{
+	struct hlist_bl_head head;
+	struct hlist_bl_node mid, tail;
+	unsigned long nval;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_lock(&head);
+	hlist_bl_add_head(&tail, &head);
+	hlist_bl_add_head(&mid, &head);
+	hlist_bl_unlock(&head);
+
+	nval = (unsigned long)mid.next | LIST_BL_LOCKMASK;
+	mid.next = (struct hlist_bl_node *)nval;
+	hlist_bl_del(&mid);
+
+	if (head.first != &mid || tail.pprev != &mid.next)
+		pr_err("hlist_bl_del(): deleting node with locked ->next not detected!\n");
+	else
+		pr_err("hlist_bl_del(): could not delete node with locked ->next, but no BUG?!\n");
+}
+
+void lkdtm_HLIST_BL_DEL_PREV_CORRUPTION(void)
+{
+	LIST_REDIR_BUF(struct hlist_bl_node, target);
+	struct hlist_bl_head head;
+	struct hlist_bl_node mid, tail;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_lock(&head);
+	hlist_bl_add_head(&tail, &head);
+	hlist_bl_add_head(&mid, &head);
+	hlist_bl_unlock(&head);
+
+	mid.pprev = &target.list.next;
+	hlist_bl_del(&mid);
+	check_list_redir_buf("hlist_bl_del()", target);
+}
+
+void lkdtm_HLIST_BL_DEL_NEXT_CORRUPTION(void)
+{
+	LIST_REDIR_BUF(struct hlist_bl_node, target);
+	struct hlist_bl_head head;
+	struct hlist_bl_node mid, tail;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_lock(&head);
+	hlist_bl_add_head(&tail, &head);
+	hlist_bl_add_head(&mid, &head);
+	hlist_bl_unlock(&head);
+
+	mid.next = &target.list;
+	hlist_bl_del(&mid);
+	check_list_redir_buf("hlist_bl_del()", target);
+}
+
+void lkdtm_HLIST_BL_DEL_TWICE(void)
+{
+	struct hlist_bl_head head;
+	struct hlist_bl_node tail;
+
+	INIT_HLIST_BL_HEAD(&head);
+	hlist_bl_lock(&head);
+	hlist_bl_add_head(&tail, &head);
+	hlist_bl_unlock(&head);
+
+	hlist_bl_del(&tail);
+
+	if (tail.next != LIST_POISON1 || tail.pprev != LIST_POISON2) {
+		pr_err("hlist_bl_del(): pprev/next pointers not poisoned!\n");
+	} else {
+		hlist_bl_del(&tail);
+		pr_err("hlist_bl_del(): could not delete twice, but no BUG?!\n");
+	}
+}
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index c56d23e37643..b5acce183473 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -22,8 +22,6 @@ void lkdtm_SOFTLOCKUP(void);
 void lkdtm_HARDLOCKUP(void);
 void lkdtm_SPINLOCKUP(void);
 void lkdtm_HUNG_TASK(void);
-void lkdtm_CORRUPT_LIST_ADD(void);
-void lkdtm_CORRUPT_LIST_DEL(void);
 void lkdtm_CORRUPT_USER_DS(void);
 void lkdtm_STACK_GUARD_PAGE_LEADING(void);
 void lkdtm_STACK_GUARD_PAGE_TRAILING(void);
@@ -102,4 +100,35 @@ void lkdtm_STACKLEAK_ERASING(void);
 /* cfi.c */
 void lkdtm_CFI_FORWARD_PROTO(void);
 
+/* list.c */
+void lkdtm_LIST_ADD_NEXT_CORRUPTION(void);
+void lkdtm_LIST_ADD_PREV_CORRUPTION(void);
+void lkdtm_LIST_ADD_TWICE(void);
+void lkdtm_LIST_DEL_NEXT_CORRUPTION(void);
+void lkdtm_LIST_DEL_PREV_CORRUPTION(void);
+void lkdtm_LIST_DEL_TWICE(void);
+void lkdtm_HLIST_ADD_HEAD_CORRUPTION(void);
+void lkdtm_HLIST_ADD_HEAD_TWICE(void);
+void lkdtm_HLIST_ADD_BEFORE_CORRUPTION(void);
+void lkdtm_HLIST_ADD_BEFORE_TWICE(void);
+void lkdtm_HLIST_ADD_BEHIND_CORRUPTION(void);
+void lkdtm_HLIST_ADD_BEHIND_TWICE(void);
+void lkdtm_HLIST_DEL_PREV_CORRUPTION(void);
+void lkdtm_HLIST_DEL_NEXT_CORRUPTION(void);
+void lkdtm_HLIST_DEL_TWICE(void);
+void lkdtm_HLIST_NULLS_ADD_HEAD_CORRUPTION(void);
+void lkdtm_HLIST_NULLS_ADD_HEAD_TWICE(void);
+void lkdtm_HLIST_NULLS_DEL_PREV_CORRUPTION(void);
+void lkdtm_HLIST_NULLS_DEL_NEXT_CORRUPTION(void);
+void lkdtm_HLIST_NULLS_DEL_TWICE(void);
+void lkdtm_HLIST_BL_ADD_HEAD_UNLOCKED(void);
+void lkdtm_HLIST_BL_ADD_HEAD_NODE_LOCKED(void);
+void lkdtm_HLIST_BL_ADD_HEAD_CORRUPTION(void);
+void lkdtm_HLIST_BL_ADD_HEAD_TWICE(void);
+void lkdtm_HLIST_BL_DEL_NODE_LOCKED(void);
+void lkdtm_HLIST_BL_DEL_NEXT_LOCKED(void);
+void lkdtm_HLIST_BL_DEL_PREV_CORRUPTION(void);
+void lkdtm_HLIST_BL_DEL_NEXT_CORRUPTION(void);
+void lkdtm_HLIST_BL_DEL_TWICE(void);
+
 #endif
diff --git a/tools/testing/selftests/lkdtm/tests.txt b/tools/testing/selftests/lkdtm/tests.txt
index 92ca32143ae5..93901506a72f 100644
--- a/tools/testing/selftests/lkdtm/tests.txt
+++ b/tools/testing/selftests/lkdtm/tests.txt
@@ -7,8 +7,6 @@ EXCEPTION
 #EXHAUST_STACK Corrupts memory on failure
 #CORRUPT_STACK Crashes entire system on success
 #CORRUPT_STACK_STRONG Crashes entire system on success
-CORRUPT_LIST_ADD list_add corruption
-CORRUPT_LIST_DEL list_del corruption
 CORRUPT_USER_DS Invalid address limit on user-mode return
 STACK_GUARD_PAGE_LEADING
 STACK_GUARD_PAGE_TRAILING
@@ -69,3 +67,32 @@ USERCOPY_KERNEL
 USERCOPY_KERNEL_DS
 STACKLEAK_ERASING OK: the rest of the thread stack is properly erased
 CFI_FORWARD_PROTO
+LIST_ADD_NEXT_CORRUPTION list_add corruption: next->prev should be prev
+LIST_ADD_PREV_CORRUPTION list_add corruption: prev->next should be next
+LIST_ADD_TWICE list_add double add:
+LIST_DEL_NEXT_CORRUPTION list_del corruption: next->prev should be
+LIST_DEL_PREV_CORRUPTION list_del corruption: prev->next should be
+LIST_DEL_TWICE list_del corruption:
+HLIST_ADD_HEAD_CORRUPTION hlist_add_head corruption: first->pprev should be &head->first
+HLIST_ADD_HEAD_TWICE hlist_add_head double add:
+HLIST_ADD_BEFORE_CORRUPTION hlist_add corruption: prev->next should be next
+HLIST_ADD_BEFORE_TWICE hlist_add double add:
+HLIST_ADD_BEHIND_CORRUPTION hlist_add corruption: next->pprev should be &prev->next
+HLIST_ADD_BEHIND_TWICE hlist_add double add:
+HLIST_DEL_PREV_CORRUPTION hlist_del corruption: prev->next should be
+HLIST_DEL_NEXT_CORRUPTION hlist_del corruption: next->pprev should be
+HLIST_DEL_TWICE hlist_del corruption:
+HLIST_NULLS_ADD_HEAD_CORRUPTION hlist_nulls_add_head corruption: first->pprev should be &head->first
+HLIST_NULLS_ADD_HEAD_TWICE hlist_nulls_add_head double add:
+HLIST_NULLS_DEL_PREV_CORRUPTION hlist_nulls_del corruption: prev->next should be
+HLIST_NULLS_DEL_NEXT_CORRUPTION hlist_nulls_del corruption: next->pprev should be
+HLIST_NULLS_DEL_TWICE hlist_nulls_del corruption:
+HLIST_BL_ADD_HEAD_UNLOCKED hlist_bl_add_head: head is unlocked
+#HLIST_BL_ADD_HEAD_NODE_LOCKED Corrupts memory on failure
+HLIST_BL_ADD_HEAD_CORRUPTION hlist_bl_add_head corruption: first->pprev should be &head->first
+HLIST_BL_ADD_HEAD_TWICE hlist_bl_add_head double add:
+#HLIST_BL_DEL_NODE_LOCKED Corrupts memory on failure
+#HLIST_BL_DEL_NEXT_LOCKED Corrupts memory on failure
+HLIST_BL_DEL_PREV_CORRUPTION hlist_bl_del corruption: prev->next should be
+HLIST_BL_DEL_NEXT_CORRUPTION hlist_bl_del corruption: next->pprev should be
+HLIST_BL_DEL_TWICE hlist_bl_del corruption:
-- 
2.20.1

