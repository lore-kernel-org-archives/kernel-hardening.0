Return-Path: <SRS0=kWJ4=AF=lists.openwall.com=kernel-hardening-return-19106-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE8CC433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 15:18:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DB3FE2076E
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 15:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CH4kMR5I"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB3FE2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19106-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5961 invoked by uid 550); 24 Jun 2020 15:18:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5938 invoked from network); 24 Jun 2020 15:18:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RgJ5KQQgdze1Er7yT6oG3OjYmr8lm8UCuoB+oNW30KA=;
        b=CH4kMR5Icue6l7XK6pIFfSYjVQ5WkzRDoGH+TWwCrL7w2COxwqeOUoBa/4iQarmDBH
         iAo8lBWn1tCcw6vScNAuFoZi/1CBw/St5Xwp2qD0ZWwbUCAQr4ESbIJZKurIxMd47X38
         zfnwiJ49xx7O1RVasJK7rT7e7T9+JmOGX/PGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RgJ5KQQgdze1Er7yT6oG3OjYmr8lm8UCuoB+oNW30KA=;
        b=KeN6PAYljk+2E6/WkOBFD7hifvwJRAwdOBdrTgWsU9lXipXrYby0OGL9rAWWPTTAr8
         xvE/gGIeRbAnF3p3I1HSu2fkmkAkoxwgMhv7yLwp0EKpNH+fRk72D0qa2+kUzvw37AvK
         4kslxUhDg8DPq8xJuFaZMwFUGHPvOs4E8Ec8ERBDwiDQenlr3jjUETPysVIpYCF9TBuA
         utg1DEICcmKVnYk0/AbtHpnpJt3lXovEySnyr/aEhjmtfi8NBHnj3xSuZmT5zLOP0Y0T
         3JZnOxYYPaujwpctgtZJNuUvlOry1Q4bm7z+/ZDW0ciY+ttGPk2lEP+RiCnaQkzVOsbW
         +Z0Q==
X-Gm-Message-State: AOAM531bQf+DV7rc7+hdaZ2m2f6EQJU/2thUpovGugQE9AAHTe8cEF+s
	Dis6pQYcNI0TW/NlmMSq/JEuVA==
X-Google-Smtp-Source: ABdhPJz/jvQlWnIJQ+/9RcU2vwsimI8dKzBUFnjr+tVzjSz4qWsGj4+kxN9Be7V2A/bW/LFFoMcIeA==
X-Received: by 2002:a17:902:b906:: with SMTP id bf6mr8910774plb.323.1593011895106;
        Wed, 24 Jun 2020 08:18:15 -0700 (PDT)
Date: Wed, 24 Jun 2020 08:18:13 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Arjan van de Ven <arjan@linux.intel.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 09/10] kallsyms: Hide layout
Message-ID: <202006240815.45AAD55@keescook>
References: <20200623172327.5701-1-kristen@linux.intel.com>
 <20200623172327.5701-10-kristen@linux.intel.com>
 <CAG48ez3YHoPOTZvabsNUcr=GP-rX+OXhNT54KcZT9eSQ28Fb8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3YHoPOTZvabsNUcr=GP-rX+OXhNT54KcZT9eSQ28Fb8Q@mail.gmail.com>

On Wed, Jun 24, 2020 at 12:21:16PM +0200, Jann Horn wrote:
> On Tue, Jun 23, 2020 at 7:26 PM Kristen Carlson Accardi
> <kristen@linux.intel.com> wrote:
> > This patch makes /proc/kallsyms display alphabetically by symbol
> > name rather than sorted by address in order to hide the newly
> > randomized address layout.
> [...]
> > +static int sorted_show(struct seq_file *m, void *p)
> > +{
> > +       struct list_head *list = m->private;
> > +       struct kallsyms_iter_list *iter;
> > +       int rc;
> > +
> > +       if (list_empty(list))
> > +               return 0;
> > +
> > +       iter = list_first_entry(list, struct kallsyms_iter_list, next);
> > +
> > +       m->private = iter;
> > +       rc = s_show(m, p);
> > +       m->private = list;
> > +
> > +       list_del(&iter->next);
> > +       kfree(iter);
> 
> Does anything like this kfree() happen if someone only reads the start
> of kallsyms and then closes the file? IOW, does "while true; do head
> -n1 /proc/kallsyms; done" leak memory?

Oop, nice catch. It seems the list would need to be walked on s_stop.

> 
> > +       return rc;
> > +}
> [...]
> > +static int kallsyms_list_cmp(void *priv, struct list_head *a,
> > +                            struct list_head *b)
> > +{
> > +       struct kallsyms_iter_list *iter_a, *iter_b;
> > +
> > +       iter_a = list_entry(a, struct kallsyms_iter_list, next);
> > +       iter_b = list_entry(b, struct kallsyms_iter_list, next);
> > +
> > +       return strcmp(iter_a->iter.name, iter_b->iter.name);
> > +}
> 
> This sorts only by name, but kallsyms prints more information (module
> names and types). This means that if there are elements whose names
> are the same, but whose module names or types are different, then some
> amount of information will still be leaked by the ordering of elements
> with the same name. In practice, since list_sort() is stable, this
> means you can see the ordering of many modules, and you can see the
> ordering of symbols with same name but different visibility (e.g. "t
> user_read" from security/selinux/ss/policydb.c vs "T user_read" from
> security/keys/user_defined.c, and a couple other similar cases).

i.e. sub-sort by visibility?

> 
> [...]
> > +#if defined(CONFIG_FG_KASLR)
> > +/*
> > + * When fine grained kaslr is enabled, we need to
> > + * print out the symbols sorted by name rather than by
> > + * by address, because this reveals the randomization order.
> > + */
> > +static int kallsyms_open(struct inode *inode, struct file *file)
> > +{
> > +       int ret;
> > +       struct list_head *list;
> > +
> > +       list = __seq_open_private(file, &kallsyms_sorted_op, sizeof(*list));
> > +       if (!list)
> > +               return -ENOMEM;
> > +
> > +       INIT_LIST_HEAD(list);
> > +
> > +       ret = kallsyms_on_each_symbol(get_all_symbol_name, list);
> > +       if (ret != 0)
> > +               return ret;
> > +
> > +       list_sort(NULL, list, kallsyms_list_cmp);
> 
> This permits running an algorithm (essentially mergesort) with
> secret-dependent branches and memory addresses on essentially secret
> data, triggerable and arbitrarily repeatable (although with partly
> different addresses on each run) by the attacker, and probably a
> fairly low throughput (comparisons go through indirect function calls,
> which are slowed down by retpolines, and linked list iteration implies
> slow pointer chases). Those are fairly favorable conditions for
> typical side-channel attacks.
> 
> Do you have estimates of how hard it would be to leverage such side
> channels to recover function ordering (both on old hardware that only
> has microcode fixes for Spectre and such, and on newer hardware with
> enhanced IBRS and such)?

I wonder, instead, if sorting should be just done once per module
load/unload? That would make the performance and memory management
easier too.

-- 
Kees Cook
