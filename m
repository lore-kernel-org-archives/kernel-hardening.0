Return-Path: <SRS0=AChh=AF=lists.openwall.com=kernel-hardening-return-19088-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB31C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 10:22:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 093AD20706
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 10:22:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fT5Adym4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 093AD20706
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19088-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2037 invoked by uid 550); 24 Jun 2020 10:21:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 2011 invoked from network); 24 Jun 2020 10:21:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5fI5JvNK3dCwQIzTsRN6p2beN2NJgsVUVMhaeGY2KsU=;
        b=fT5Adym4xre69hOkcVWPGI4K1xA/LgbxNJYucoLJp78P0bNwaSq9tbwa8twh5QJx88
         FVard2FW47Q1I1KdgC7dGoFz4/7aq2G895BIzUH5jr3tYkKIAFo+8ZTiaU2kHLGtMl75
         t8dH/gVMs72ZlIXNlHGB7y/GT7pXj7cyiVHxsaFtG+CS4SEqdK/GiOvOp6WStU/D/WSR
         vLa+xetM7xGI4flQbZ8jQfoRSrBcKPyuO4fBvfcmZ2kOeYihytPbpOLQyX76Sw6cEuui
         zL55c/QwhiJID/eKFm58Qgxbj2u2Ay3v6cZUq7I+UMJS7MUFnHhPTbE2YXih18owzmiN
         41pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5fI5JvNK3dCwQIzTsRN6p2beN2NJgsVUVMhaeGY2KsU=;
        b=uPvXifQ7V/K/MoUGBiPApS1ZxMPKmk+rtiRDY6jl3J5pHf24ry4pu+Kvk6moXkE0Ot
         1BysdjbJQ9Qh340g3/YSclbjwv3oZqkL2nzWBRJZSAG6GsR5vqaisxO4WEvlEkTA9cpH
         vBx+uGm0VziR0YJb6tDUQNYfVbS8OKr4a98JjC6VA2Jxe2cBIGD/c3R8Vyy/AWsGAA8P
         Q7+ir3JIRZFqrkdugKf/zV5PxgWVcpn/6mQfHklVFFABG2Cm2Zl4ghdmqZZ1I5G3tbVv
         xHm5GsDIdHYdLH3s7ELKPdhOqg7sHWnWCPiWINdlKQMJ4JrX2bePOGin8NkdLcNvlaYV
         ZOPA==
X-Gm-Message-State: AOAM531t6bMGgQE9yFPzKLBz7nGAOzJgYjMSgn55XBPo0nWVPVTWUn9/
	5x0pGZvN7YFdnm1Ztwzrj/CM/6oNXuMRsLWNeLIxTQ==
X-Google-Smtp-Source: ABdhPJzqhTbhM+Cpca7ghQsFEyDBYMzsiBUAGtAdHmHboV3gJJ3Ey8yWeSz2dZ3iTM6EkO9ymQCqpPk92J7cgUlX7ug=
X-Received: by 2002:a19:4143:: with SMTP id o64mr14976844lfa.157.1592994103571;
 Wed, 24 Jun 2020 03:21:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200623172327.5701-1-kristen@linux.intel.com> <20200623172327.5701-10-kristen@linux.intel.com>
In-Reply-To: <20200623172327.5701-10-kristen@linux.intel.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 24 Jun 2020 12:21:16 +0200
Message-ID: <CAG48ez3YHoPOTZvabsNUcr=GP-rX+OXhNT54KcZT9eSQ28Fb8Q@mail.gmail.com>
Subject: Re: [PATCH v3 09/10] kallsyms: Hide layout
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Arjan van de Ven <arjan@linux.intel.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	kernel list <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Tony Luck <tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 23, 2020 at 7:26 PM Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
> This patch makes /proc/kallsyms display alphabetically by symbol
> name rather than sorted by address in order to hide the newly
> randomized address layout.
[...]
> +static int sorted_show(struct seq_file *m, void *p)
> +{
> +       struct list_head *list = m->private;
> +       struct kallsyms_iter_list *iter;
> +       int rc;
> +
> +       if (list_empty(list))
> +               return 0;
> +
> +       iter = list_first_entry(list, struct kallsyms_iter_list, next);
> +
> +       m->private = iter;
> +       rc = s_show(m, p);
> +       m->private = list;
> +
> +       list_del(&iter->next);
> +       kfree(iter);

Does anything like this kfree() happen if someone only reads the start
of kallsyms and then closes the file? IOW, does "while true; do head
-n1 /proc/kallsyms; done" leak memory?

> +       return rc;
> +}
[...]
> +static int kallsyms_list_cmp(void *priv, struct list_head *a,
> +                            struct list_head *b)
> +{
> +       struct kallsyms_iter_list *iter_a, *iter_b;
> +
> +       iter_a = list_entry(a, struct kallsyms_iter_list, next);
> +       iter_b = list_entry(b, struct kallsyms_iter_list, next);
> +
> +       return strcmp(iter_a->iter.name, iter_b->iter.name);
> +}

This sorts only by name, but kallsyms prints more information (module
names and types). This means that if there are elements whose names
are the same, but whose module names or types are different, then some
amount of information will still be leaked by the ordering of elements
with the same name. In practice, since list_sort() is stable, this
means you can see the ordering of many modules, and you can see the
ordering of symbols with same name but different visibility (e.g. "t
user_read" from security/selinux/ss/policydb.c vs "T user_read" from
security/keys/user_defined.c, and a couple other similar cases).

[...]
> +#if defined(CONFIG_FG_KASLR)
> +/*
> + * When fine grained kaslr is enabled, we need to
> + * print out the symbols sorted by name rather than by
> + * by address, because this reveals the randomization order.
> + */
> +static int kallsyms_open(struct inode *inode, struct file *file)
> +{
> +       int ret;
> +       struct list_head *list;
> +
> +       list = __seq_open_private(file, &kallsyms_sorted_op, sizeof(*list));
> +       if (!list)
> +               return -ENOMEM;
> +
> +       INIT_LIST_HEAD(list);
> +
> +       ret = kallsyms_on_each_symbol(get_all_symbol_name, list);
> +       if (ret != 0)
> +               return ret;
> +
> +       list_sort(NULL, list, kallsyms_list_cmp);

This permits running an algorithm (essentially mergesort) with
secret-dependent branches and memory addresses on essentially secret
data, triggerable and arbitrarily repeatable (although with partly
different addresses on each run) by the attacker, and probably a
fairly low throughput (comparisons go through indirect function calls,
which are slowed down by retpolines, and linked list iteration implies
slow pointer chases). Those are fairly favorable conditions for
typical side-channel attacks.

Do you have estimates of how hard it would be to leverage such side
channels to recover function ordering (both on old hardware that only
has microcode fixes for Spectre and such, and on newer hardware with
enhanced IBRS and such)?

> +       return 0;
> +}
