Return-Path: <SRS0=VF3R=VT=lists.openwall.com=kernel-hardening-return-16518-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671E9C76194
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 13:44:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D52221955
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 13:44:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D52221955
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16518-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6097 invoked by uid 550); 22 Jul 2019 13:44:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19996 invoked from network); 22 Jul 2019 13:18:20 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46nBGTq9+Y+lM2ciGt7IuascVvvL7sVLuW7aSWfz9iM=;
        b=cGLrDYqHWD7hCV/eHrB+lXCDd/fF5xLMdrgfWSIhiORJkGGqZrzJ7Lr4KLKVC5A09p
         8DDhN5qpKFg+lsPlpjNOou2kKJw1JYx3bGPa73zhX0eHA3ovcrjc+xN1QA3aadhZwizJ
         vmxNvlDGLuErbNldzTtLWtlXWL8QG+y0an2yWybJtfTfQEv3+q+7secrkezkbijZc2Mt
         l1dYAYu2wPaRE/m0gdoZ8zDMePOchnDzAd3B8BibpvgCqAFJ9NbFhYP5QHvJRcKikXQ5
         5vicRDq1quMhZpkYdzYSk1OS4HBQe+mUpYTfTONOho196GJ7V2/Z+TfBJjNl3OdeURNe
         NT4A==
X-Gm-Message-State: APjAAAXqWkJ48jfYGM4niBkvhN10ZqWk6ewWnhm7UkSLVHwMPXpfY50a
	ZjH1vVm2no7HJi24Zw0gOBR6McvI5sFta6oppPuqug==
X-Google-Smtp-Source: APXvYqzRZs+3+1ucKSe3yuFeprYfsp9QaDCtvH5/kJtEexcbwdxJf8ovuT4RA2eMigFLBlO8RDkEYxRd3eoVi7kF/P8=
X-Received: by 2002:a9d:4c17:: with SMTP id l23mr7097454otf.367.1563801488453;
 Mon, 22 Jul 2019 06:18:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190722113151.1584-1-nitin.r.gote@intel.com>
In-Reply-To: <20190722113151.1584-1-nitin.r.gote@intel.com>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Mon, 22 Jul 2019 15:17:57 +0200
Message-ID: <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
Subject: Re: [PATCH] selinux: convert struct sidtab count to refcount_t
To: NitinGote <nitin.r.gote@intel.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, 
	Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, 
	Eric Paris <eparis@parisplace.org>, SElinux list <selinux@vger.kernel.org>, 
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 22, 2019 at 1:35 PM NitinGote <nitin.r.gote@intel.com> wrote:
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.
>
> Signed-off-by: NitinGote <nitin.r.gote@intel.com>

Nack.

The 'count' variable is not used as a reference counter here. It
tracks the number of entries in sidtab, which is a very specific
lookup table that can only grow (the count never decreases). I only
made it atomic because the variable is read outside of the sidtab's
spin lock and thus the reads and writes to it need to be guaranteed to
be atomic. The counter is only updated under the spin lock, so
insertions do not race with each other.

Your patch, however, lead me to realize that I forgot to guard against
overflow above SIDTAB_MAX when a new entry is being inserted. It is
extremely unlikely to happen in practice, but should be fixed anyway.
I'll send a patch shortly.

> ---
>  security/selinux/ss/sidtab.c | 16 ++++++++--------
>  security/selinux/ss/sidtab.h |  2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> index e63a90ff2728..20fe235c6c71 100644
> --- a/security/selinux/ss/sidtab.c
> +++ b/security/selinux/ss/sidtab.c
> @@ -29,7 +29,7 @@ int sidtab_init(struct sidtab *s)
>         for (i = 0; i < SECINITSID_NUM; i++)
>                 s->isids[i].set = 0;
>
> -       atomic_set(&s->count, 0);
> +       refcount_set(&s->count, 0);
>
>         s->convert = NULL;
>
> @@ -130,7 +130,7 @@ static struct context *sidtab_do_lookup(struct sidtab *s, u32 index, int alloc)
>
>  static struct context *sidtab_lookup(struct sidtab *s, u32 index)
>  {
> -       u32 count = (u32)atomic_read(&s->count);
> +       u32 count = refcount_read(&s->count);
>
>         if (index >= count)
>                 return NULL;
> @@ -245,7 +245,7 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
>                                  u32 *index)
>  {
>         unsigned long flags;
> -       u32 count = (u32)atomic_read(&s->count);
> +       u32 count = (u32)refcount_read(&s->count);
>         u32 count_locked, level, pos;
>         struct sidtab_convert_params *convert;
>         struct context *dst, *dst_convert;
> @@ -272,7 +272,7 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
>         spin_lock_irqsave(&s->lock, flags);
>
>         convert = s->convert;
> -       count_locked = (u32)atomic_read(&s->count);
> +       count_locked = (u32)refcount_read(&s->count);
>         level = sidtab_level_from_count(count_locked);
>
>         /* if count has changed before we acquired the lock, then catch up */
> @@ -315,7 +315,7 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
>                 }
>
>                 /* at this point we know the insert won't fail */
> -               atomic_set(&convert->target->count, count + 1);
> +               refcount_set(&convert->target->count, count + 1);
>         }
>
>         if (context->len)
> @@ -328,7 +328,7 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
>         /* write entries before writing new count */
>         smp_wmb();
>
> -       atomic_set(&s->count, count + 1);
> +       refcount_set(&s->count, count + 1);
>
>         rc = 0;
>  out_unlock:
> @@ -418,7 +418,7 @@ int sidtab_convert(struct sidtab *s, struct sidtab_convert_params *params)
>                 return -EBUSY;
>         }
>
> -       count = (u32)atomic_read(&s->count);
> +       count = (u32)refcount_read(&s->count);
>         level = sidtab_level_from_count(count);
>
>         /* allocate last leaf in the new sidtab (to avoid race with
> @@ -431,7 +431,7 @@ int sidtab_convert(struct sidtab *s, struct sidtab_convert_params *params)
>         }
>
>         /* set count in case no new entries are added during conversion */
> -       atomic_set(&params->target->count, count);
> +       refcount_set(&params->target->count, count);
>
>         /* enable live convert of new entries */
>         s->convert = params;
> diff --git a/security/selinux/ss/sidtab.h b/security/selinux/ss/sidtab.h
> index bbd5c0d1f3bd..68dd96a5beba 100644
> --- a/security/selinux/ss/sidtab.h
> +++ b/security/selinux/ss/sidtab.h
> @@ -70,7 +70,7 @@ struct sidtab_convert_params {
>
>  struct sidtab {
>         union sidtab_entry_inner roots[SIDTAB_MAX_LEVEL + 1];
> -       atomic_t count;
> +       refcount_t count;
>         struct sidtab_convert_params *convert;
>         spinlock_t lock;
>
> --
> 2.17.1
>

Thanks,

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
