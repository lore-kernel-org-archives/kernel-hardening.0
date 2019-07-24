Return-Path: <SRS0=m2KX=VV=lists.openwall.com=kernel-hardening-return-16575-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D7BC7618B
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 15:19:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D315021738
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 15:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="0k7Z49ri"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D315021738
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=paul-moore.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16575-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12240 invoked by uid 550); 24 Jul 2019 15:19:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12222 invoked from network); 24 Jul 2019 15:19:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LpXolAHctxURYJH2swPfpOApJw1r/Z/fMpwYwxp3zGA=;
        b=0k7Z49rieTQwEYn+pr4ZHWNBM0O21n3yf2nlUkT8AyS4yH7VycqvzHIhe/JyJieTKI
         oi53O2LPyMYJn1+Jq1kn/0yO5wmdOrBNObCEGsQ842AXuewmMZomee1Ib246RM30LMXE
         GMkMpu+6s3vTQgdH8RAZXoL/50V8NNUiFybZdJnUtObKEH+FiOm9NoXJoI3Fqvz6w7BQ
         dEMOZSTDMLyXhCBu6oj+BxtLeEjCYQfg5tbLuX8GjM/W72xdn5P413p1ctJETpdWI4FE
         dfbuFbIQ4guXvBmR9sf/uB3DwuKq1JVh9FepFPkwUXHSPAaVsh+ZLpmxOABNua/iAEHd
         GW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LpXolAHctxURYJH2swPfpOApJw1r/Z/fMpwYwxp3zGA=;
        b=jMTsXykazTh63ufA51I2ju8ZBvD2dcfuPY2CsN1JCQlMmFLAwfjz22rcN/EcAzu6ra
         a1xXwi/YQDVAv9xF7PAcgBkNuX0P0MbhLcls3vj8QvI77MSp0+3ooMgMEG38g/VYGkdG
         i7vYzxpbB+nCiZB6kui5ohcesAOvkDL/kDKKPFMgN8edJmnszCW0aBM8XgVccs4Y+Fnz
         lx+obY6qfW5g0cE+ZVbADdC8AMOhtwO5tF3lSyv+Hq9FiN1Qk7DxX/4u2Ds8TegW3nio
         oU0mipzaQFEJ+jESxJsclePaHCwnuPp49hCORl0cINQm1e9I5BAkFRLAWZ2mA3rLMM18
         IrIw==
X-Gm-Message-State: APjAAAVluJuDeGMdkaSui1u9H5FoBwCTK0i8atwOTqWBuMjjPessfnEi
	glzhPe+tGp0UpozmPEWDFSbez8JmYATLyLrmHw==
X-Google-Smtp-Source: APXvYqwDjCAXKNSCf9phgA2WwAHJa/9JlFijDL24t5LipVWCXhUs6WP4GSNOBAr8FzaiofEf4kATiZe8URpDTgSXrEY=
X-Received: by 2002:a19:8093:: with SMTP id b141mr39572283lfd.137.1563981533496;
 Wed, 24 Jul 2019 08:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190723065059.30101-1-omosnace@redhat.com>
In-Reply-To: <20190723065059.30101-1-omosnace@redhat.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 24 Jul 2019 11:18:41 -0400
Message-ID: <CAHC9VhSmcGoaDzOp7xbwvh2pYusMS-ReBC5Nrqi5eZYCuZpR7g@mail.gmail.com>
Subject: Re: [PATCH v2] selinux: check sidtab limit before adding a new entry
To: Ondrej Mosnacek <omosnace@redhat.com>
Cc: selinux@vger.kernel.org, NitinGote <nitin.r.gote@intel.com>, 
	kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, 
	William Roberts <bill.c.roberts@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 23, 2019 at 2:51 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> We need to error out when trying to add an entry above SIDTAB_MAX in
> sidtab_reverse_lookup() to avoid overflow on the odd chance that this
> happens.
>
> Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  security/selinux/ss/sidtab.c | 5 +++++
>  1 file changed, 5 insertions(+)

Thanks.  This looks like -stable material to me so I've marked it as
such and merged it into selinux/stable-5.3; assuming it passes
testing, and as long as I don't hear any objections, I'll send it up
to Linus later this week.

> diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> index e63a90ff2728..1f0a6eaa2d6a 100644
> --- a/security/selinux/ss/sidtab.c
> +++ b/security/selinux/ss/sidtab.c
> @@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
>                 ++count;
>         }
>
> +       /* bail out if we already reached max entries */
> +       rc = -EOVERFLOW;
> +       if (count >= SIDTAB_MAX)
> +               goto out_unlock;
> +
>         /* insert context into new entry */
>         rc = -ENOMEM;
>         dst = sidtab_do_lookup(s, count, 1);
> --
> 2.21.0

-- 
paul moore
www.paul-moore.com
