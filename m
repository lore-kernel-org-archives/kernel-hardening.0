Return-Path: <SRS0=Yh6n=YO=lists.openwall.com=kernel-hardening-return-17068-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B6ACA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 06:12:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 49BDB2084B
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 06:12:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qTUTQ4ZT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49BDB2084B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17068-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25752 invoked by uid 550); 21 Oct 2019 06:12:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25734 invoked from network); 21 Oct 2019 06:12:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=azBxEHDWCdsU7wz/faY/PPe9l3d9cjGBlYkkkxlsXNw=;
        b=qTUTQ4ZTdm9DHInhDE6X3VmBqT/KyH/eg44Ie2ZyppNJ+Mq7Gzf0scMCqvZQU3nPkq
         9RuuuXt9ohJ5GGZ8h2flwhyvHo+h+mwCU3HJf+NkGF1ALj5/Q88VB5OWwPcY/IliqH+l
         L56F8Nihrbg51/Fsns1XWsTOeLYFw3fUNOlGzbLGBm3uO+epkCWsGR+NC1kxNQYUTroR
         SzEk6Ha++yb8a85i+5pTuUxz2bAL3RQbU/K5HeDKEBB8dlhFE55Qgv18UJrCUJZZh8vr
         uJ/G08ebShEM/n6IRWP8xr4T4msq/l2sffgnnJdXZSAWT/ipDYKo74mYhYFdnpTIOzIk
         VfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=azBxEHDWCdsU7wz/faY/PPe9l3d9cjGBlYkkkxlsXNw=;
        b=Wkyq4nKrPixTMTiX8y1LLE9pYuQmjXTsNX/9ahqpfgbbsGgKBJsyu3OsEB9VZeC4pz
         /7dt1BU1VQToLx7ndHS8cbqh32JHEyPHh72kymFq0b7pUTNUCtVDXN11ZnD+y9JTlvAC
         waWgtYfSvzfmnVJx1LlyaB59PKcNefZHd198beXDCGZmRKsNlkJ584oAx4rWtJkWwqaQ
         MLRZB1JH1LytQ1W0c7EYAWIeR83TKOyI7Kg47C/Zkt5DUwUtFhl/5wOdri6Lna1SEnZB
         sXl5wXN5hzsHprxM77Mh8VoVFDwhkJFME5JmvyswygVAd8Puf61haS4HBGYZgDLYGUE/
         MTmw==
X-Gm-Message-State: APjAAAW5KAWpS1YDcPkET9bcGSCgoU2vSwHwKFq4ymcHSFZE5cPmVzhL
	ohnOykNVewFAQ4s3Tg3JBsTTPzBuCu2XEpdQeBso/Q==
X-Google-Smtp-Source: APXvYqxnJb93TF5nD3jcoXnbupalitg5Dj+VYy2V93E3Z3QMw/jysu5nCOppGEaOWgZsmIzV8081S3I2H2bbczBjiHs=
X-Received: by 2002:a5d:6b0a:: with SMTP id v10mr17063430wrw.32.1571638357257;
 Sun, 20 Oct 2019 23:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-6-samitolvanen@google.com> <CAKwvOd=SZ+f6hiLb3_-jytcKMPDZ77otFzNDvbwpOSsNMnifSg@mail.gmail.com>
 <CABCJKuf1cTHqvAC2hyCWjQbNEdGjx8dtfHGWwEvrEWzv+f7vZg@mail.gmail.com>
In-Reply-To: <CABCJKuf1cTHqvAC2hyCWjQbNEdGjx8dtfHGWwEvrEWzv+f7vZg@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 21 Oct 2019 08:12:26 +0200
Message-ID: <CAKv+Gu92eR81+W1iXOXZHWgub-fNPcKaa+NCpGS_Yy4K4=7t+Q@mail.gmail.com>
Subject: Re: [PATCH 05/18] arm64: kbuild: reserve reg x18 from general
 allocation by the compiler
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Oct 2019 at 21:00, Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Fri, Oct 18, 2019 at 10:32 AM 'Nick Desaulniers' via Clang Built
> Linux <clang-built-linux@googlegroups.com> wrote:
> > > and remove the mention from
> > > the LL/SC compiler flag override.
> >
> > was that cut/dropped from this patch?
> >
> > >
> > > Link: https://patchwork.kernel.org/patch/9836881/
> >
> > ^ Looks like it. Maybe it doesn't matter, but if sending a V2, maybe
> > the commit message to be updated?
>
> True. The original patch is from 2017 and the relevant part of
> arm64/lib/Makefile no longer exists. I'll update this accordingly.
>
> > I like how this does not conditionally reserve it based on the CONFIG
> > for SCS.  Hopefully later patches don't wrap it, but I haven't looked
> > through all of them yet.
>
> In a later patch x18 is only reserved with SCS. I'm fine with dropping
> that patch and reserving it always, but wouldn't mind hearing thoughts
> from the maintainers about this first.
>

Why would you reserve x18 if SCS is disabled? Given that this is a
choice that is made at code generation time, there is no justification
for always reserving it, since it will never be used for anything. (Of
course, this applies to generated code only - .S files should simply
be updated to avoid x18 altogether)

Also, please combine this patch with the one that reserves it
conditionally, no point in having both in the same series.
