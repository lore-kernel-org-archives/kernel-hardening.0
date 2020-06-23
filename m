Return-Path: <SRS0=XBoU=AE=lists.openwall.com=kernel-hardening-return-19078-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486DBC433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 17:26:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A5D23206EB
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jun 2020 17:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5D23206EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19078-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9970 invoked by uid 550); 23 Jun 2020 17:25:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9845 invoked from network); 23 Jun 2020 17:25:04 -0000
IronPort-SDR: Ns6WTfqFxKcEuErhrWkjKPjuA44FmmzxBgxyJ/AVjet6HOeRyRodzH3vbLPfJFKmFL/yKs0Gkx
 lBD+COOiniMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="162232110"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="162232110"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: /JsqC+xOr9qVvIOgw4zV7dRWJkIH9XcHNCAU30RaXLM4P/9F4El+phmSfebDGSbCXB2Bc5w+VF
 bc5torReNOjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="423080171"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de
Cc: arjan@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 09/10] kallsyms: Hide layout
Date: Tue, 23 Jun 2020 10:23:26 -0700
Message-Id: <20200623172327.5701-10-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200623172327.5701-1-kristen@linux.intel.com>
References: <20200623172327.5701-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch makes /proc/kallsyms display alphabetically by symbol
name rather than sorted by address in order to hide the newly
randomized address layout.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
---
 kernel/kallsyms.c | 128 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 16c8c605f4b0..df2b20e1b7f2 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -25,6 +25,7 @@
 #include <linux/filter.h>
 #include <linux/ftrace.h>
 #include <linux/compiler.h>
+#include <linux/list_sort.h>
 
 /*
  * These will be re-linked against their real values
@@ -446,6 +447,11 @@ struct kallsym_iter {
 	int show_value;
 };
 
+struct kallsyms_iter_list {
+	struct kallsym_iter iter;
+	struct list_head next;
+};
+
 int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
 			    char *type, char *name)
 {
@@ -660,6 +666,127 @@ int kallsyms_show_value(void)
 	}
 }
 
+static int sorted_show(struct seq_file *m, void *p)
+{
+	struct list_head *list = m->private;
+	struct kallsyms_iter_list *iter;
+	int rc;
+
+	if (list_empty(list))
+		return 0;
+
+	iter = list_first_entry(list, struct kallsyms_iter_list, next);
+
+	m->private = iter;
+	rc = s_show(m, p);
+	m->private = list;
+
+	list_del(&iter->next);
+	kfree(iter);
+
+	return rc;
+}
+
+static void *sorted_start(struct seq_file *m, loff_t *pos)
+{
+	return m->private;
+}
+
+static void *sorted_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct list_head *list = m->private;
+
+	(*pos)++;
+
+	if (list_empty(list))
+		return NULL;
+
+	return p;
+}
+
+static const struct seq_operations kallsyms_sorted_op = {
+	.start = sorted_start,
+	.next = sorted_next,
+	.stop = s_stop,
+	.show = sorted_show
+};
+
+static int kallsyms_list_cmp(void *priv, struct list_head *a,
+			     struct list_head *b)
+{
+	struct kallsyms_iter_list *iter_a, *iter_b;
+
+	iter_a = list_entry(a, struct kallsyms_iter_list, next);
+	iter_b = list_entry(b, struct kallsyms_iter_list, next);
+
+	return strcmp(iter_a->iter.name, iter_b->iter.name);
+}
+
+int get_all_symbol_name(void *data, const char *name, struct module *mod,
+			unsigned long addr)
+{
+	unsigned long sym_pos;
+	struct kallsyms_iter_list *node, *last;
+	struct list_head *head = (struct list_head *)data;
+
+	node = kmalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return -ENOMEM;
+
+	if (list_empty(head)) {
+		sym_pos = 0;
+		memset(node, 0, sizeof(*node));
+		reset_iter(&node->iter, 0);
+		node->iter.show_value = kallsyms_show_value();
+	} else {
+		last = list_first_entry(head, struct kallsyms_iter_list, next);
+		memcpy(node, last, sizeof(*node));
+		sym_pos = last->iter.pos;
+	}
+
+	INIT_LIST_HEAD(&node->next);
+	list_add(&node->next, head);
+
+	/*
+	 * update_iter returns false when at end of file
+	 * which in this case we don't care about and can
+	 * safely ignore. update_iter() will increment
+	 * the value of iter->pos, for ksymbol_core.
+	 */
+	if (sym_pos >= kallsyms_num_syms)
+		sym_pos++;
+
+	(void)update_iter(&node->iter, sym_pos);
+
+	return 0;
+}
+
+#if defined(CONFIG_FG_KASLR)
+/*
+ * When fine grained kaslr is enabled, we need to
+ * print out the symbols sorted by name rather than by
+ * by address, because this reveals the randomization order.
+ */
+static int kallsyms_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	struct list_head *list;
+
+	list = __seq_open_private(file, &kallsyms_sorted_op, sizeof(*list));
+	if (!list)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(list);
+
+	ret = kallsyms_on_each_symbol(get_all_symbol_name, list);
+	if (ret != 0)
+		return ret;
+
+	list_sort(NULL, list, kallsyms_list_cmp);
+
+	return 0;
+}
+#else
 static int kallsyms_open(struct inode *inode, struct file *file)
 {
 	/*
@@ -676,6 +803,7 @@ static int kallsyms_open(struct inode *inode, struct file *file)
 	iter->show_value = kallsyms_show_value();
 	return 0;
 }
+#endif /* CONFIG_FG_KASLR */
 
 #ifdef	CONFIG_KGDB_KDB
 const char *kdb_walk_kallsyms(loff_t *pos)
-- 
2.20.1

