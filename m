Return-Path: <SRS0=NyrN=A4=lists.openwall.com=kernel-hardening-return-19384-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28D2C433E1
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 17:02:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D5A0F20704
	for <kernel-hardening@archiver.kernel.org>; Fri, 17 Jul 2020 17:02:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5A0F20704
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19384-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11624 invoked by uid 550); 17 Jul 2020 17:01:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11440 invoked from network); 17 Jul 2020 17:01:14 -0000
IronPort-SDR: cOXCi4bBw8QeDP+JbzLZvIM0YDKbFV/wYlOijBmoPmBzn9D0Qv82p47rOs+3848Lfp/ox0e1jV
 Xy6hYxEUWUfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9685"; a="137748384"
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="137748384"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: d3DDxs2KwSQhMwX1wAx9jnDX4JOWDz/pHxQmfbYvuTu0b8a/PV6r1X0hw0d2NTy2Cxh4aheTWe
 yE3Z7UCCZONw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,362,1589266800"; 
   d="scan'208";a="270862208"
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
Subject: [PATCH v4 09/10] kallsyms: Hide layout
Date: Fri, 17 Jul 2020 10:00:06 -0700
Message-Id: <20200717170008.5949-10-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200717170008.5949-1-kristen@linux.intel.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch makes /proc/kallsyms display in a random order, rather
than sorted by address in order to hide the newly randomized address
layout.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
---
 kernel/kallsyms.c | 163 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 162 insertions(+), 1 deletion(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index bb14e64f62a4..45d147f7f10e 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -446,6 +446,12 @@ struct kallsym_iter {
 	int show_value;
 };
 
+struct kallsyms_shuffled_iter {
+	struct kallsym_iter iter;
+	loff_t total_syms;
+	loff_t shuffled_index[];
+};
+
 int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
 			    char *type, char *name)
 {
@@ -661,7 +667,7 @@ bool kallsyms_show_value(const struct cred *cred)
 	}
 }
 
-static int kallsyms_open(struct inode *inode, struct file *file)
+static int __kallsyms_open(struct inode *inode, struct file *file)
 {
 	/*
 	 * We keep iterator in m->private, since normal case is to
@@ -682,6 +688,161 @@ static int kallsyms_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+/*
+ * When function granular kaslr is enabled, we need to print out the symbols
+ * at random so we don't reveal the new layout.
+ */
+#if defined(CONFIG_FG_KASLR)
+static int update_random_pos(struct kallsyms_shuffled_iter *s_iter,
+			     loff_t pos, loff_t *new_pos)
+{
+	loff_t new;
+
+	if (pos >= s_iter->total_syms)
+		return 0;
+
+	new = s_iter->shuffled_index[pos];
+
+	/*
+	 * normally this would be done as part of update_iter, however,
+	 * we want to avoid triggering this in the event that new is
+	 * zero since we don't want to blow away our pos end indicators.
+	 */
+	if (new == 0) {
+		s_iter->iter.name[0] = '\0';
+		s_iter->iter.nameoff = get_symbol_offset(new);
+		s_iter->iter.pos = new;
+	}
+
+	*new_pos = new;
+	return 1;
+}
+
+static void *shuffled_start(struct seq_file *m, loff_t *pos)
+{
+	struct kallsyms_shuffled_iter *s_iter = m->private;
+	loff_t new_pos;
+
+	if (!update_random_pos(s_iter, *pos, &new_pos))
+		return NULL;
+
+	return s_start(m, &new_pos);
+}
+
+static void *shuffled_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct kallsyms_shuffled_iter *s_iter = m->private;
+	loff_t new_pos;
+
+	(*pos)++;
+
+	if (!update_random_pos(s_iter, *pos, &new_pos))
+		return NULL;
+
+	if (!update_iter(m->private, new_pos))
+		return NULL;
+
+	return p;
+}
+
+/*
+ * shuffle_index_list()
+ * Use a Fisher Yates algorithm to shuffle a list of text sections.
+ */
+static void shuffle_index_list(loff_t *indexes, loff_t size)
+{
+	int i;
+	unsigned int j;
+	loff_t temp;
+
+	for (i = size - 1; i > 0; i--) {
+		/* pick a random index from 0 to i */
+		get_random_bytes(&j, sizeof(j));
+		j = j % (i + 1);
+
+		temp = indexes[i];
+		indexes[i] = indexes[j];
+		indexes[j] = temp;
+	}
+}
+
+static const struct seq_operations kallsyms_shuffled_op = {
+	.start = shuffled_start,
+	.next = shuffled_next,
+	.stop = s_stop,
+	.show = s_show
+};
+
+static int kallsyms_random_open(struct inode *inode, struct file *file)
+{
+	loff_t pos;
+	struct kallsyms_shuffled_iter *shuffled_iter;
+	struct kallsym_iter iter;
+	bool show_value;
+
+	/*
+	 * If privileged, go ahead and use the normal algorithm for
+	 * displaying symbols
+	 */
+	show_value = kallsyms_show_value(file->f_cred);
+	if (show_value)
+		return __kallsyms_open(inode, file);
+
+	/*
+	 * we need to figure out how many extra symbols there are
+	 * to print out past kallsyms_num_syms
+	 */
+	pos = kallsyms_num_syms;
+	reset_iter(&iter, 0);
+	do {
+		if (!update_iter(&iter, pos))
+			break;
+		pos++;
+	} while (1);
+
+	/*
+	 * add storage space for an array of loff_t equal to the size
+	 * of the total number of symbols we need to print
+	 */
+	shuffled_iter = __seq_open_private(file, &kallsyms_shuffled_op,
+					   sizeof(*shuffled_iter) +
+					   (sizeof(pos) * pos));
+	if (!shuffled_iter)
+		return -ENOMEM;
+
+	reset_iter(&shuffled_iter->iter, 0);
+	shuffled_iter->iter.show_value = show_value;
+	shuffled_iter->total_syms = pos;
+
+	/*
+	 * the existing update_iter algorithm requires that we
+	 * are either moving along increasing pos sequentially,
+	 * or that these values are correct. Since these values
+	 * were discovered above, initialize our new iter so we
+	 * can use update_iter non-sequentially.
+	 */
+	shuffled_iter->iter.pos_arch_end = iter.pos_arch_end;
+	shuffled_iter->iter.pos_mod_end = iter.pos_mod_end;
+	shuffled_iter->iter.pos_ftrace_mod_end = iter.pos_ftrace_mod_end;
+
+	/*
+	 * initialize the array with all possible pos values, then
+	 * shuffle the array so that the values will display in a random
+	 * order.
+	 */
+	for (pos = 0; pos < shuffled_iter->total_syms; pos++)
+		shuffled_iter->shuffled_index[pos] = pos;
+
+	shuffle_index_list(shuffled_iter->shuffled_index, shuffled_iter->total_syms);
+
+	return 0;
+}
+
+#define kallsyms_open kallsyms_random_open
+#else
+#define kallsyms_open __kallsyms_open
+#endif /* CONFIG_FG_KASLR */
+
 #ifdef	CONFIG_KGDB_KDB
 const char *kdb_walk_kallsyms(loff_t *pos)
 {
-- 
2.20.1

