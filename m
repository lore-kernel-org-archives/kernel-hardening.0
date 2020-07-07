Return-Path: <SRS0=hlpF=AS=lists.openwall.com=kernel-hardening-return-19246-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47D5BC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 22:59:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 70A4A2065D
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 22:59:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70A4A2065D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19246-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16220 invoked by uid 550); 7 Jul 2020 22:59:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16200 invoked from network); 7 Jul 2020 22:59:23 -0000
IronPort-SDR: YhhIXfapSQm8ZS255ugjOIl+C4vRI6AYisTt4CJbThOmIqN82NyXfzXU/QOxWJ5/b6PIBFTrCn
 Oofz9MFEqLsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="145209194"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="145209194"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: zJTFtT0zBohAXOSTzQGE4XlaG93nyDVLb8PBhgXhcEd/uiDrgUyG2rAC5qqDtpygsRZLRYmLJK
 LRBohlc9fUvA==
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="305827517"
Message-ID: <f34eb868e609a1a8a7f19b77fe5d00bf3555bb00.camel@linux.intel.com>
Subject: Re: [PATCH v3 09/10] kallsyms: Hide layout
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@linux.intel.com>,
 the arch/x86 maintainers <x86@kernel.org>, kernel list
 <linux-kernel@vger.kernel.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, Tony Luck <tony.luck@intel.com>
Date: Tue, 07 Jul 2020 15:58:57 -0700
In-Reply-To: <202006240815.45AAD55@keescook>
References: <20200623172327.5701-1-kristen@linux.intel.com>
	 <20200623172327.5701-10-kristen@linux.intel.com>
	 <CAG48ez3YHoPOTZvabsNUcr=GP-rX+OXhNT54KcZT9eSQ28Fb8Q@mail.gmail.com>
	 <202006240815.45AAD55@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2020-06-24 at 08:18 -0700, Kees Cook wrote:
> On Wed, Jun 24, 2020 at 12:21:16PM +0200, Jann Horn wrote:
> > On Tue, Jun 23, 2020 at 7:26 PM Kristen Carlson Accardi
> > <kristen@linux.intel.com> wrote:
> > > This patch makes /proc/kallsyms display alphabetically by symbol
> > > name rather than sorted by address in order to hide the newly
> > > randomized address layout.
> > [...]
> > > +static int sorted_show(struct seq_file *m, void *p)
> > > +{
> > > +       struct list_head *list = m->private;
> > > +       struct kallsyms_iter_list *iter;
> > > +       int rc;
> > > +
> > > +       if (list_empty(list))
> > > +               return 0;
> > > +
> > > +       iter = list_first_entry(list, struct kallsyms_iter_list,
> > > next);
> > > +
> > > +       m->private = iter;
> > > +       rc = s_show(m, p);
> > > +       m->private = list;
> > > +
> > > +       list_del(&iter->next);
> > > +       kfree(iter);
> > 
> > Does anything like this kfree() happen if someone only reads the
> > start
> > of kallsyms and then closes the file? IOW, does "while true; do
> > head
> > -n1 /proc/kallsyms; done" leak memory?
> 
> Oop, nice catch. It seems the list would need to be walked on s_stop.
> 
> > > +       return rc;
> > > +}
> > [...]
> > > +static int kallsyms_list_cmp(void *priv, struct list_head *a,
> > > +                            struct list_head *b)
> > > +{
> > > +       struct kallsyms_iter_list *iter_a, *iter_b;
> > > +
> > > +       iter_a = list_entry(a, struct kallsyms_iter_list, next);
> > > +       iter_b = list_entry(b, struct kallsyms_iter_list, next);
> > > +
> > > +       return strcmp(iter_a->iter.name, iter_b->iter.name);
> > > +}
> > 
> > This sorts only by name, but kallsyms prints more information
> > (module
> > names and types). This means that if there are elements whose names
> > are the same, but whose module names or types are different, then
> > some
> > amount of information will still be leaked by the ordering of
> > elements
> > with the same name. In practice, since list_sort() is stable, this
> > means you can see the ordering of many modules, and you can see the
> > ordering of symbols with same name but different visibility (e.g.
> > "t
> > user_read" from security/selinux/ss/policydb.c vs "T user_read"
> > from
> > security/keys/user_defined.c, and a couple other similar cases).
> 
> i.e. sub-sort by visibility?
> 
> > [...]
> > > +#if defined(CONFIG_FG_KASLR)
> > > +/*
> > > + * When fine grained kaslr is enabled, we need to
> > > + * print out the symbols sorted by name rather than by
> > > + * by address, because this reveals the randomization order.
> > > + */
> > > +static int kallsyms_open(struct inode *inode, struct file *file)
> > > +{
> > > +       int ret;
> > > +       struct list_head *list;
> > > +
> > > +       list = __seq_open_private(file, &kallsyms_sorted_op,
> > > sizeof(*list));
> > > +       if (!list)
> > > +               return -ENOMEM;
> > > +
> > > +       INIT_LIST_HEAD(list);
> > > +
> > > +       ret = kallsyms_on_each_symbol(get_all_symbol_name, list);
> > > +       if (ret != 0)
> > > +               return ret;
> > > +
> > > +       list_sort(NULL, list, kallsyms_list_cmp);
> > 
> > This permits running an algorithm (essentially mergesort) with
> > secret-dependent branches and memory addresses on essentially
> > secret
> > data, triggerable and arbitrarily repeatable (although with partly
> > different addresses on each run) by the attacker, and probably a
> > fairly low throughput (comparisons go through indirect function
> > calls,
> > which are slowed down by retpolines, and linked list iteration
> > implies
> > slow pointer chases). Those are fairly favorable conditions for
> > typical side-channel attacks.
> > 
> > Do you have estimates of how hard it would be to leverage such side
> > channels to recover function ordering (both on old hardware that
> > only
> > has microcode fixes for Spectre and such, and on newer hardware
> > with
> > enhanced IBRS and such)?
> 
> I wonder, instead, if sorting should be just done once per module
> load/unload? That would make the performance and memory management
> easier too.
> 

I've been thinking about something like the below instead - I was
thinking that there was no reason to sort kallsyms at all, so instead I
just randomly shuffle an index list. Do you see any issues with this
approach? (I guess I need to rename my functions at least...)

From 2e8eb63c957f469af047dd4b056e54aa93f6fe35 Mon Sep 17 00:00:00 2001
From: Kristen Carlson Accardi <kristen@linux.intel.com>
Date: Mon, 3 Feb 2020 12:06:44 -0800
Subject: [PATCH 1/2] kallsyms: Hide layout

This patch makes /proc/kallsyms display in a random order, rather
than sorted by address in order to hide the newly randomized address
layout.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Tony Luck <tony.luck@intel.com>
---
 kernel/kallsyms.c | 117 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 16c8c605f4b0..7e4939b9ed61 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -25,6 +25,7 @@
 #include <linux/filter.h>
 #include <linux/ftrace.h>
 #include <linux/compiler.h>
+#include <linux/list_sort.h>
 
 /*
  * These will be re-linked against their real values
@@ -446,6 +447,17 @@ struct kallsym_iter {
 	int show_value;
 };
 
+struct kallsyms_iter_list {
+	struct kallsym_iter iter;
+	struct list_head next;
+};
+
+struct kallsyms_sorted_iter {
+	struct kallsym_iter iter;
+	loff_t total_syms;
+	loff_t shuffled_index[];
+};
+
 int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
 			    char *type, char *name)
 {
@@ -660,6 +672,110 @@ int kallsyms_show_value(void)
 	}
 }
 
+static void *sorted_start(struct seq_file *m, loff_t *pos)
+{
+	struct kallsyms_sorted_iter *s_iter = m->private;
+
+	if (*pos >= s_iter->total_syms)
+		return NULL;
+
+	return s_start(m, &s_iter->shuffled_index[*pos]);
+}
+
+static void *sorted_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	struct kallsyms_sorted_iter *s_iter = m->private;
+
+	(*pos)++;
+
+	if (*pos >= s_iter->total_syms)
+		return NULL;
+
+	if (!update_iter(m->private, s_iter->shuffled_index[*pos]))
+		return NULL;
+
+	return p;
+}
+
+static const struct seq_operations kallsyms_sorted_op = {
+	.start = sorted_start,
+	.next = sorted_next,
+	.stop = s_stop,
+	.show = s_show
+};
+
+/*
+ * shuffle_text_list()
+ * Use a Fisher Yates algorithm to shuffle a list of text sections.
+ */
+static void shuffle_index_list(loff_t *indexes, int size)
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
+#if defined(CONFIG_FG_KASLR)
+/*
+ * When fine grained kaslr is enabled, we need to
+ * print out the symbols sorted by name rather than by
+ * by address, because this reveals the randomization order.
+ */
+static int kallsyms_open(struct inode *inode, struct file *file)
+{
+	loff_t pos;
+	struct kallsyms_sorted_iter *sorted_iter;
+	struct kallsym_iter iter;
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
+	sorted_iter = __seq_open_private(file, &kallsyms_sorted_op,
+					 sizeof(*sorted_iter) +
+					 (sizeof(pos) * pos));
+	if (!sorted_iter)
+		return -ENOMEM;
+
+	reset_iter(&sorted_iter->iter, 0);
+	sorted_iter->iter.show_value = kallsyms_show_value();
+	sorted_iter->total_syms = pos;
+
+	/*
+	 * initialize the array with all possible pos values, then
+	 * shuffle the array so that the values will display in a
random
+	 * order.
+	 */
+	for (pos = 0; pos < sorted_iter->total_syms; pos++)
+		sorted_iter->shuffled_index[pos] = pos;
+
+	shuffle_index_list(sorted_iter->shuffled_index, sorted_iter-
>total_syms);
+
+	return 0;
+}
+#else
 static int kallsyms_open(struct inode *inode, struct file *file)
 {
 	/*
@@ -676,6 +792,7 @@ static int kallsyms_open(struct inode *inode,
struct file *file)
 	iter->show_value = kallsyms_show_value();
 	return 0;
 }
+#endif /* CONFIG_FG_KASLR */
 
 #ifdef	CONFIG_KGDB_KDB
 const char *kdb_walk_kallsyms(loff_t *pos)
-- 
2.20.1


