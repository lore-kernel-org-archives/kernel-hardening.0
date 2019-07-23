Return-Path: <SRS0=NFsq=VU=lists.openwall.com=kernel-hardening-return-16551-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA94C7618E
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 12:30:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 280C6223A1
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 12:30:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 280C6223A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16551-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1343 invoked by uid 550); 23 Jul 2019 12:30:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15621 invoked from network); 23 Jul 2019 06:48:35 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cY5YICyEZTZmKAe8S+z84IVZKH+kurb4pXia9o6wuCY=;
        b=ZpN25z046BGy2LB8LO8fokreH1ZR7KovNcaiUJEIqB/WOmh7GtDQRVdpl8nbN0a1Cs
         mi9eUy8I1PBTx7h6fRQY6Qz3zpgzRNR1o6Kk+Ai+6Ss4mWDOlbSbAXHmjI7kOJ/0UtX5
         S7y4eckcEZozypBA19N3AgCraJVAxUrGK3CUDW6J7c0LB1w6cP+qxaoaQ/1GX1S76EOG
         VZOU8nC+A6Taj/2GKBi3GA8kr4L6AOTtq01WJNkqosfVp6T/p+i2EskGGP2l/uZi+C9S
         hNyeZMX+QGxuY8arnwyPB5MMJiiTBiMXFHva8xyfOJk9+Z1IDMF+p3S9HOewTm/Jis9q
         /NXw==
X-Gm-Message-State: APjAAAWBcnoiQsap7TW//KhoPNws9LSFXC9ZbSgJoVuTgDECZXP8FFsy
	SLdHLicVLqSYeKPMB/+6ApCJoYMKT4tsVZEZTlURow==
X-Google-Smtp-Source: APXvYqxsddQYVNqohu4Jb847ypd+7U9vUJnysW3/+0Sp9QkhauBUew6rE6lNs/w8PcqsF2R2eim5RvqRMoXbKMYvJEE=
X-Received: by 2002:a9d:73cd:: with SMTP id m13mr20394988otk.43.1563864503462;
 Mon, 22 Jul 2019 23:48:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190722132111.25743-1-omosnace@redhat.com> <CAFftDdqROGAUDD3wXRC-PSjnrm29B6bfsBDn8AMPKkzJ8yJ=Hg@mail.gmail.com>
In-Reply-To: <CAFftDdqROGAUDD3wXRC-PSjnrm29B6bfsBDn8AMPKkzJ8yJ=Hg@mail.gmail.com>
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Tue, 23 Jul 2019 08:48:12 +0200
Message-ID: <CAFqZXNtSVvE9XiMSFei7+PD6v-urELi=UjdOtWW8KPdM8e=Q5Q@mail.gmail.com>
Subject: Re: [PATCH] selinux: check sidtab limit before adding a new entry
To: William Roberts <bill.c.roberts@gmail.com>
Cc: SElinux list <selinux@vger.kernel.org>, Paul Moore <paul@paul-moore.com>, 
	NitinGote <nitin.r.gote@intel.com>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 22, 2019 at 4:17 PM William Roberts
<bill.c.roberts@gmail.com> wrote:
> On Mon, Jul 22, 2019 at 8:34 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> >
> > We need to error out when trying to add an entry above SIDTAB_MAX in
> > sidtab_reverse_lookup() to avoid overflow on the odd chance that this
> > happens.
> >
> > Fixes: ee1a84fdfeed ("selinux: overhaul sidtab to fix bug and improve performance")
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
> > ---
> >  security/selinux/ss/sidtab.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
> > index e63a90ff2728..54c1ba1e79ab 100644
> > --- a/security/selinux/ss/sidtab.c
> > +++ b/security/selinux/ss/sidtab.c
> > @@ -286,6 +286,11 @@ static int sidtab_reverse_lookup(struct sidtab *s, struct context *context,
> >                 ++count;
> >         }
> >
> > +       /* bail out if we already reached max entries */
> > +       rc = -ENOMEM;
>
> Wouldn't -EOVERFLOW be better?

Good point. Will change it in v2.

>
> > +       if (count == SIDTAB_MAX)
> > +               goto out_unlock;
> > +
> >         /* insert context into new entry */
> >         rc = -ENOMEM;
> >         dst = sidtab_do_lookup(s, count, 1);
> > --
> > 2.21.0
> >

Thanks,
-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
