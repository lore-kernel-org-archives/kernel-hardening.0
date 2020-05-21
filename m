Return-Path: <SRS0=+lEO=7D=lists.openwall.com=kernel-hardening-return-18849-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3DCEC433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 21:14:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 08823208A7
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 21:14:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="B1edwXeQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08823208A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18849-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6034 invoked by uid 550); 21 May 2020 21:14:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6011 invoked from network); 21 May 2020 21:14:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XZZ5vGtImoL01xyzR64KCWDKUfIuis772xDEHmF3ldI=;
        b=B1edwXeQk42Z1UZf7gfSthKXb4bIu1l9sihaGaa2vq6i4vtytY9bF5qGzoIrZtPfQZ
         2fc1l3wCb6wiviHILp6lflGHUcIiulV00r1Ba3iJ7MdKuH2TB63+4Oojgy/ZExBIxvPi
         9W8NbphL55tG1O+Q+rdZWeUa5k2IvGMec5tmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XZZ5vGtImoL01xyzR64KCWDKUfIuis772xDEHmF3ldI=;
        b=sf7f4zZGM5OY3AoIQ68cHhkVsO3PsFwZGReb+7FnirDhKbgFY5rkD8cqL5tvGE9V4F
         p06shZRpKKBhH0KmEge3lnH+DbA7ORMoDibJfGCx8MwZgFFAORtgdxCXFEiMfAbGYL3r
         jKMWbPxvO8F8T84p+k8clqklz4hxrdNrRqAIPFHHTnnqwo9EBENsqd32Uj7VmZNU33Tm
         NiY6c975jaB4eiktvXHaoAJNEDYgLKk44JJqt9CsMCJNnaFYRhf7i0wRdy4TXh0A8lqg
         7pp7pEZ3VbrmvdG+XPX5raAKHPnDrBFe+cGDD4UcUeE2GOoW9erEOCEE35btGHYVrn77
         snYQ==
X-Gm-Message-State: AOAM532L8Nye98AdfNM+MxcrxaCXKobUrU6aAdC6A0hzaK9cEuNbIOrl
	6VsisjzLOfXnH7fBU1RDOYmq3Q==
X-Google-Smtp-Source: ABdhPJz5ZgIVwn633Wd8ontnJLCwdyIuRN7Je5MIDycy8URZX6MgTMECk1Rzp83xOtKruPX7kkcYfA==
X-Received: by 2002:a62:760e:: with SMTP id r14mr644628pfc.92.1590095650015;
        Thu, 21 May 2020 14:14:10 -0700 (PDT)
Date: Thu, 21 May 2020 14:14:08 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v2 8/9] kallsyms: Hide layout
Message-ID: <202005211409.3C314DF@keescook>
References: <20200521165641.15940-1-kristen@linux.intel.com>
 <20200521165641.15940-9-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521165641.15940-9-kristen@linux.intel.com>

On Thu, May 21, 2020 at 09:56:39AM -0700, Kristen Carlson Accardi wrote:
> This patch makes /proc/kallsyms display alphabetically by symbol
> name rather than sorted by address in order to hide the newly
> randomized address layout.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> ---
>  kernel/kallsyms.c | 138 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 137 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 16c8c605f4b0..558963b275ec 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -25,6 +25,7 @@
>  #include <linux/filter.h>
>  #include <linux/ftrace.h>
>  #include <linux/compiler.h>
> +#include <linux/list_sort.h>
>  
>  /*
>   * These will be re-linked against their real values
> @@ -446,6 +447,11 @@ struct kallsym_iter {
>  	int show_value;
>  };
>  
> +struct kallsyms_iter_list {
> +	struct kallsym_iter iter;
> +	struct list_head next;
> +};
> +
>  int __weak arch_get_kallsym(unsigned int symnum, unsigned long *value,
>  			    char *type, char *name)
>  {
> @@ -660,6 +666,121 @@ int kallsyms_show_value(void)
>  	}
>  }
>  
> +static int sorted_show(struct seq_file *m, void *p)
> +{
> +	struct list_head *list = m->private;
> +	struct kallsyms_iter_list *iter;
> +	int rc;
> +
> +	if (list_empty(list))
> +		return 0;
> +
> +	iter = list_first_entry(list, struct kallsyms_iter_list, next);
> +
> +	m->private = iter;
> +	rc = s_show(m, p);
> +	m->private = list;
> +
> +	list_del(&iter->next);
> +	kfree(iter);
> +
> +	return rc;
> +}
> +
> +static void *sorted_start(struct seq_file *m, loff_t *pos)
> +{
> +	return m->private;
> +}
> +
> +static void *sorted_next(struct seq_file *m, void *p, loff_t *pos)
> +{
> +	struct list_head *list = m->private;
> +
> +	(*pos)++;
> +
> +	if (list_empty(list))
> +		return NULL;
> +
> +	return p;
> +}
> +
> +static const struct seq_operations kallsyms_sorted_op = {
> +	.start = sorted_start,
> +	.next = sorted_next,
> +	.stop = s_stop,
> +	.show = sorted_show
> +};
> +
> +static int kallsyms_list_cmp(void *priv, struct list_head *a,
> +			     struct list_head *b)
> +{
> +	struct kallsyms_iter_list *iter_a, *iter_b;
> +
> +	iter_a = list_entry(a, struct kallsyms_iter_list, next);
> +	iter_b = list_entry(b, struct kallsyms_iter_list, next);
> +
> +	return strcmp(iter_a->iter.name, iter_b->iter.name);
> +}
> +
> +int get_all_symbol_name(void *data, const char *name, struct module *mod,
> +			unsigned long addr)
> +{
> +	unsigned long sym_pos;
> +	struct kallsyms_iter_list *node, *last;
> +	struct list_head *head = (struct list_head *)data;
> +
> +	node = kmalloc(sizeof(*node), GFP_KERNEL);
> +	if (!node)
> +		return -ENOMEM;
> +
> +	if (list_empty(head)) {
> +		sym_pos = 0;
> +		memset(node, 0, sizeof(*node));
> +		reset_iter(&node->iter, 0);
> +		node->iter.show_value = kallsyms_show_value();
> +	} else {
> +		last = list_first_entry(head, struct kallsyms_iter_list, next);
> +		memcpy(node, last, sizeof(*node));
> +		sym_pos = last->iter.pos;
> +	}
> +
> +	INIT_LIST_HEAD(&node->next);
> +	list_add(&node->next, head);
> +
> +	/*
> +	 * update_iter returns false when at end of file
> +	 * which in this case we don't care about and can
> +	 * safely ignore. update_iter() will increment
> +	 * the value of iter->pos, for ksymbol_core.
> +	 */
> +	if (sym_pos >= kallsyms_num_syms)
> +		sym_pos++;
> +
> +	(void)update_iter(&node->iter, sym_pos);
> +
> +	return 0;
> +}
> +
> +static int kallsyms_sorted_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	struct list_head *list;
> +
> +	list = __seq_open_private(file, &kallsyms_sorted_op, sizeof(*list));
> +	if (!list)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(list);
> +
> +	ret = kallsyms_on_each_symbol(get_all_symbol_name, list);
> +	if (ret != 0)
> +		return ret;
> +
> +	list_sort(NULL, list, kallsyms_list_cmp);
> +
> +	return 0;
> +}
> +
>  static int kallsyms_open(struct inode *inode, struct file *file)
>  {
>  	/*
> @@ -704,9 +825,24 @@ static const struct proc_ops kallsyms_proc_ops = {
>  	.proc_release	= seq_release_private,
>  };
>  
> +static const struct proc_ops kallsyms_sorted_proc_ops = {
> +	.proc_open = kallsyms_sorted_open,
> +	.proc_read = seq_read,
> +	.proc_lseek = seq_lseek,
> +	.proc_release = seq_release_private,
> +};
> +
>  static int __init kallsyms_init(void)
>  {
> -	proc_create("kallsyms", 0444, NULL, &kallsyms_proc_ops);
> +	/*
> +	 * When fine grained kaslr is enabled, we need to
> +	 * print out the symbols sorted by name rather than by
> +	 * by address, because this reveals the randomization order.
> +	 */
> +	if (!IS_ENABLED(CONFIG_FG_KASLR))
> +		proc_create("kallsyms", 0444, NULL, &kallsyms_proc_ops);
> +	else
> +		proc_create("kallsyms", 0444, NULL, &kallsyms_sorted_proc_ops);
>  	return 0;

Since this is compile-time selected, instead of the separate name and
test here, how about just redefine kallsyms_open initializer instead?

#ifdef CONFIG_FG_KASLR
...sorting routines...
static int kallsyms_open(struct inode *inode, struct file *file)
{ ... sorted version ... }
#else
static int kallsyms_open(struct inode *inode, struct file *file)
{ ... normal version ... }
#endif

(And then just move the comment to the sorted open version.)

-- 
Kees Cook
