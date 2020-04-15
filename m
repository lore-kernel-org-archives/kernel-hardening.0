Return-Path: <SRS0=AnWs=57=lists.openwall.com=kernel-hardening-return-18511-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D91C2BA19
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Apr 2020 21:06:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 880792076D
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Apr 2020 21:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 880792076D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18511-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18377 invoked by uid 550); 15 Apr 2020 21:05:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18253 invoked from network); 15 Apr 2020 21:05:49 -0000
IronPort-SDR: UXU7sh9TZBISCCioKo8Gp+cbWZyGq9XrmyaTW9d+PYQEpsufNXBEg406Z5IfGXO6Ym3B99wI2I
 tIJKZrxwOLEA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: Pd5FXZ1DHtmqsTzzEGneI+AukZ0+A0Bf0LYvjbY9bf7SPzF4lD6SYpu82EIKfwIeloqliOo7Il
 OcGaZg3UxXyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,388,1580803200"; 
   d="scan'208";a="455035620"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com
Cc: arjan@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecomb@intel.com
Subject: [PATCH 8/9] kallsyms: hide layout
Date: Wed, 15 Apr 2020 14:04:50 -0700
Message-Id: <20200415210452.27436-9-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415210452.27436-1-kristen@linux.intel.com>
References: <20200415210452.27436-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To support finer grained kaslr (fgkaslr), we need to hide our sorted
list of symbols, since this will give away our new layout.
This patch makes /proc/kallsyms only visible to priviledged users.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 kernel/kallsyms.c | 138 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 137 insertions(+), 1 deletion(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 16c8c605f4b0..861972b6a879 100644
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
@@ -660,6 +666,121 @@ int kallsyms_show_value(void)
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
+				struct list_head *b)
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
+	(void) update_iter(&node->iter, sym_pos);
+
+	return 0;
+}
+
+static int kallsyms_sorted_open(struct inode *inode, struct file *file)
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
+
 static int kallsyms_open(struct inode *inode, struct file *file)
 {
 	/*
@@ -704,9 +825,24 @@ static const struct proc_ops kallsyms_proc_ops = {
 	.proc_release	= seq_release_private,
 };
 
+static const struct proc_ops kallsyms_sorted_proc_ops = {
+	.proc_open = kallsyms_sorted_open,
+	.proc_read = seq_read,
+	.proc_lseek = seq_lseek,
+	.proc_release = seq_release_private,
+};
+
 static int __init kallsyms_init(void)
 {
-	proc_create("kallsyms", 0444, NULL, &kallsyms_proc_ops);
+	/*
+	 * When fine grained kaslr is enabled, we need to
+	 * print out the symbols sorted by name rather than by
+	 * by address, because this reveals the randomization order.
+	 */
+	if (!IS_ENABLED(CONFIG_FG_KASLR))
+		proc_create("kallsyms", 0444, NULL, &kallsyms_proc_ops);
+	else
+		proc_create("kallsyms", 0444, NULL, &kallsyms_sorted_proc_ops);
 	return 0;
 }
 device_initcall(kallsyms_init);
-- 
2.20.1

