Return-Path: <SRS0=u9MX=Y5=lists.openwall.com=kernel-hardening-return-17281-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5BB0CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 00:02:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 168F320848
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 00:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A/SrpqmE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 168F320848
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17281-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9892 invoked by uid 550); 5 Nov 2019 00:02:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9872 invoked from network); 5 Nov 2019 00:02:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wgpWA2jEqJlvczDoO9RtXFfmusK0XNDziQd8UVfs11k=;
        b=A/SrpqmEvJhiTvT76G/tSSPqak6qEdOAyAD0F4wbDPWu94/+f0jv3efhmZsUUXe6qq
         CybWZB2b/qOXaj/r1Nbyes7WY8VgUjIelgdCzOnhxzWtIMGBD3T63FRfkZ2BE6eRGZIr
         i+vb47qqghQKbHOImu5dkJFEY1uT2BH1eHjRTifgfw5MuC7sgilYydbBLxES9g+KuSIL
         L1WK07dG7pk4sigbooRRP48Y+8xvQtnMOXhJZ3I7J9ghmadqrbCv75YuBU7BR9vJzSEx
         yswAlaOaltIuwCoBGp+vRv4vjVT08L2K0P3ry0DuYv+zs81b3l/ZkUjrhpODm7ydYXfj
         xzig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wgpWA2jEqJlvczDoO9RtXFfmusK0XNDziQd8UVfs11k=;
        b=G4f97cpvZPl4bZpyDkc1mIvoi0xvLw4IBxYRr6U+DndF5uSdEqcgJ/TVjS6N2s2ANu
         mnwjjzkGkrMsLDjaMC1KSzXeLhmWNOColEQthc2y7cFxoI1ibeeQUZia9LA4AD5yE4dn
         jiTlsW9SPVFNSI4sTJRy3Ja8mD9C7JzU52MiQX1qNdcwsJdp3LZkaKKZOhWDSzGJZEe0
         btsSn7tp4rEjqju1Alfvj6TjZeM2LhrNxxnmmiUk35veybkXT/S+MrVGOQa8cUx9SRCk
         AkzTI1MBKHudbvmN7al1D32LJn93LXoMuxYBpNq0uDhKBQ/Bj3EiWTwQxf2vIMx4/CA0
         xGiA==
X-Gm-Message-State: APjAAAXj196niryKHGESeOhN4dbzzNa32GfYE7EQkBLlYpxNtwziMo53
	Qnq65+QKPmjv5sBjPoRuz5VPgat1XvlW4Qh40/1SaA==
X-Google-Smtp-Source: APXvYqxDpgmQ9n/cnDstvJ7riCGFej5xZ9eZp7xC3KSVKRHhU1yTfVmSiCTnVQNCB9cZ2N32DJmU1C4HUXLbveOO274=
X-Received: by 2002:a9f:3772:: with SMTP id a47mr13452102uae.53.1572912151471;
 Mon, 04 Nov 2019 16:02:31 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-14-samitolvanen@google.com>
 <02c56a5273f94e9d832182f1b3cb5097@www.loen.fr> <CABCJKucVON6uUMH6hVP7RODqH8u63AP3SgTCBWirrS30yDOmdA@mail.gmail.com>
 <CAKwvOdkDbX4zLChH_DKrnOah1sJjTA-e3uZOXUP6nUs-EaJreg@mail.gmail.com>
In-Reply-To: <CAKwvOdkDbX4zLChH_DKrnOah1sJjTA-e3uZOXUP6nUs-EaJreg@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 16:02:16 -0800
Message-ID: <CABCJKueN+Op8xm+L3aSFgCL9BLC8b-WHj3oBYhf1W=OcX2aqCg@mail.gmail.com>
Subject: Re: [PATCH v4 13/17] arm64: preserve x18 when CPU is suspended
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <dave.martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 4, 2019 at 1:59 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Mon, Nov 4, 2019 at 1:38 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Mon, Nov 4, 2019 at 5:20 AM Marc Zyngier <maz@kernel.org> wrote:
> > > >  ENTRY(cpu_do_suspend)
> > > >       mrs     x2, tpidr_el0
> > > > @@ -73,6 +75,9 @@ alternative_endif
> > > >       stp     x8, x9, [x0, #48]
> > > >       stp     x10, x11, [x0, #64]
> > > >       stp     x12, x13, [x0, #80]
> > > > +#ifdef CONFIG_SHADOW_CALL_STACK
> > > > +     str     x18, [x0, #96]
> > > > +#endif
> > >
> > > Do we need the #ifdefery here? We didn't add that to the KVM path,
> > > and I'd feel better having a single behaviour, specially when
> > > NR_CTX_REGS is unconditionally sized to hold 13 regs.
> >
> > I'm fine with dropping the ifdefs here in v5 unless someone objects to this.
>
> Oh, yeah I guess it would be good to be consistent.  Rather than drop
> the ifdefs, would you (Marc) be ok with conditionally setting
> NR_CTX_REGS based on CONFIG_SHADOW_CALL_STACK, and doing so in KVM?
> (So 3 ifdefs, rather than 0)?
>
> Without any conditionals or comments, it's not clear why x18 is being
> saved and restored (unless git blame survives, or a comment is added
> in place of the ifdefs in v6).

True. Clearing the sleep state buffer in cpu_do_resume is also
pointless without CONFIG_SHADOW_CALL_STACK, so if the ifdefs are
removed, some kind of an explanation is needed there.

Sami
