Return-Path: <SRS0=NuLy=AF=lists.openwall.com=kernel-hardening-return-19085-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB53EC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 07:21:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0E58520720
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 07:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="LM+9Emsg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E58520720
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19085-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7340 invoked by uid 550); 24 Jun 2020 07:21:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7317 invoked from network); 24 Jun 2020 07:21:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=pjnQ7WBzCOByclYff5fag1J6k77rRFjTJeOwwIhXIsI=;
        b=LM+9Emsg/Bnt9ZPqcCtr1BIO53wrwaXkstgGZO8mwi6wqv0h60blnansku5od/fTJN
         owpxS2UsG0aNQ+ZThFnv5sjD8qtDr2g6ICUJoExlIp4x+ifOT9hyUOwAARo7C4YxFk1b
         ruSfG+DQPOplV5fZHpAsmSK1cGDsDRMt9v2fw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pjnQ7WBzCOByclYff5fag1J6k77rRFjTJeOwwIhXIsI=;
        b=tReQhWY0/s9FA069WgdKgjB+SB24ryU1pZgOayflKsuaJn0E3kpX5JAwUzMv7sQtTf
         Q0j2CFoiz0D7bJylJngokRJsRzQ1zFfKEfcXiB/JGO7PGs14eWzWg3v0KLeV/qC1Fb3r
         gIPcVgerrYJt2pPcYi8k5hzOvj/3KSUAxpCji53srU0TnPuEagEpvnIQcdfWljbvru+E
         1jZB0N2Esw+pqFSRVjWvQ24OzqqhpH/XjMPunOWPCnDZQn3561LGy5k1Ojd6ecBVLjPH
         Ak/1pN8mW8jDMcewI8utmNA1C57uTYxg0rjW9uzAvHMSr6sWuE5K1+ZPrBt9/xyvNbwc
         3aWg==
X-Gm-Message-State: AOAM531GDDTwFUakBqOV/P9ZqX0ZFgKFzQmsYibTixsxXyXDj9iOZXtL
	rwTBZXsiruOYbsB4swXG3rMoMA==
X-Google-Smtp-Source: ABdhPJx0mccfQsquGoFKjKPiTC10fC3qOuSqvdb6OgKAmDilcLtaiwiVyjw/1caXio4aFtntnNK1MQ==
X-Received: by 2002:a17:902:bd0b:: with SMTP id p11mr26994367pls.91.1592983258898;
        Wed, 24 Jun 2020 00:20:58 -0700 (PDT)
Date: Wed, 24 Jun 2020 00:20:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 09/10] kallsyms: Hide layout
Message-ID: <202006240013.7806A28435@keescook>
References: <20200623172327.5701-1-kristen@linux.intel.com>
 <20200623172327.5701-10-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200623172327.5701-10-kristen@linux.intel.com>

On Tue, Jun 23, 2020 at 10:23:26AM -0700, Kristen Carlson Accardi wrote:
> This patch makes /proc/kallsyms display alphabetically by symbol
> name rather than sorted by address in order to hide the newly
> randomized address layout.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> Tested-by: Tony Luck <tony.luck@intel.com>
> ---
>  kernel/kallsyms.c | 128 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 128 insertions(+)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 16c8c605f4b0..df2b20e1b7f2 100644
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
> @@ -660,6 +666,127 @@ int kallsyms_show_value(void)
>  	}
>  }

The #ifdef can be moved up to here:

#ifdef CONFIG_FG_KASLR

Otherwise without CONFIG_FG_KASLR, I get:

kernel/kallsyms.c:714:12: warning: ‘kallsyms_list_cmp’ defined but not used [-Wunused-function]
  714 | static int kallsyms_list_cmp(void *priv, struct list_head *a,
      |            ^~~~~~~~~~~~~~~~~


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

This can be static too.

Otherwise, looks good!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
