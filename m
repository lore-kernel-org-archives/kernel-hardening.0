Return-Path: <SRS0=gcPG=VV=lists.openwall.com=kernel-hardening-return-16578-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78689C76186
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 16:56:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C517D21841
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 16:56:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hf5QP/9G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C517D21841
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16578-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15705 invoked by uid 550); 24 Jul 2019 16:56:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15680 invoked from network); 24 Jul 2019 16:56:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lj5VxMT7ytpqUXOYqjV0SKU1nsfCOyOUOiGQpNCaobw=;
        b=Hf5QP/9Gi6ugQidFc1Hm+WBEJpAQIEtpQ7l4tIiLgRnLmI7Jh7/AM3JX+PtpswSZlp
         AVuLSWocf3cXjTCleGz9CJ4T1PqEUUx5GTyeHTNGwet7kw8n3MkOxUzEGb8QBrP2j60T
         gXknXyP8eoQbZ++rJWA2iAhdf2EOi6FDOy/V3xOwcji1yFBFBEIfQfgPI/c57puE0urV
         2c8fsxHE8iGFEyGVuQpMnRWT5/bLME98JycyzMuLxvp0AEsPpBBw44GwmbYPiBqFCDIl
         gKoV04gnZcdVMOPmVYmPiFQmgt++jK5QKoW+Yfi4Eb+FAwqch1BhT7IGNsl2BXf1KbSl
         2qXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lj5VxMT7ytpqUXOYqjV0SKU1nsfCOyOUOiGQpNCaobw=;
        b=kCoXRe2h37rsmblhxe/XD9xGiL9nCjCfA1koiRjeAjLbOs4DsyRU9jzfqfx/PnA1Iy
         G2hnKxNT1NF5G/ztEN+0e3khrDfaXN9p/xBhbGqnajzVVjsTSnt+xxEekN/P+LuM5sli
         JM3qNkwcUNtAwOb5KIwTrknXyJNhpLZSfVA8Ss+SVofwfgqfeH9hDnBe7vB3zkQTOHqP
         HLUrfIouIdVj0pbDCGoIDdlxZvLbqBp2drwd23CqO2zaCqFDALPnx0vB65Y0ftW8RXqC
         6isZQUNz5gQ3kpV+3P6u4q6ivFfFX+LS3U0Ng/O2I/WsYZXcqgPJSBItmGI2VZuQEXNw
         z/Ig==
X-Gm-Message-State: APjAAAXnMr2Ytj+r24CVkMDYnfIIyLC6W3Dl8/+FHv+81NIljdfcFmRW
	+xRzSSkR/Dv0G3y0AYn34ctd5sSCs4E2SeXohCNYwQ==
X-Google-Smtp-Source: APXvYqwh6vIcM8Jk1c4NR1KfxKt+DGUENc04BHP7lwI3tYLzzDoMhYrlgtCveTpKvh97oEm0dQAfR9WL3p/kkMmdu68=
X-Received: by 2002:a9d:774a:: with SMTP id t10mr29134096otl.228.1563987373619;
 Wed, 24 Jul 2019 09:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190722113151.1584-1-nitin.r.gote@intel.com> <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
 <CAG48ez3zRoB7awMdb-koKYJyfP9WifTLevxLxLHioLhH=itZ-A@mail.gmail.com>
 <201907231516.11DB47AA@keescook> <CAG48ez2eXJwE+vS2_ahR9Vuc3qD8O4CDZ5Lh6DcrrOq+7VKOYQ@mail.gmail.com>
 <201907240852.6D10622B2@keescook>
In-Reply-To: <201907240852.6D10622B2@keescook>
From: Jann Horn <jannh@google.com>
Date: Wed, 24 Jul 2019 18:55:47 +0200
Message-ID: <CAG48ez3-qdbnJaEooFrhfBT8czyAZNDp5YfkDRcy5mLH4BQy2g@mail.gmail.com>
Subject: Re: [PATCH] selinux: convert struct sidtab count to refcount_t
To: Kees Cook <keescook@chromium.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, NitinGote <nitin.r.gote@intel.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, 
	SElinux list <selinux@vger.kernel.org>, 
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 24, 2019 at 5:54 PM Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jul 24, 2019 at 04:28:31PM +0200, Jann Horn wrote:
> > On Wed, Jul 24, 2019 at 12:17 AM Kees Cook <keescook@chromium.org> wrote:
> > > Perhaps we need a "statistics" counter type for these kinds of counters?
> > > "counter_t"? I bet there are a lot of atomic_t uses that are just trying
> > > to be counters. (likely most of atomic_t that isn't now refcount_t ...)
> >
> > This isn't a statistics counter though; this thing needs ordered
> > memory accesses, which you wouldn't need for statistics.
>
> Okay, it'd be a "very accurate" counter type? It _could_ be used for
> statistics. I guess what I mean is that there are a lot of places using
> atomic_t just for upward counting that don't care about wrapping, etc.

(Accurate) statistics counters need RMW ops, don't need memory
ordering, usually can't be locked against writes, and may not care
about wrapping.
This thing doesn't need RMW ops, does need memory ordering, can be
locked against writes, and definitely shouldn't wrap.

I agree that there are a bunch of statistics counters in the kernel,
and it's not necessarily a bad idea to use a separate type for them;
but this is not a statistics counter.
