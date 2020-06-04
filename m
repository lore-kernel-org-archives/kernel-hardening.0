Return-Path: <SRS0=zuWN=7R=lists.openwall.com=kernel-hardening-return-18927-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1139C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 14:15:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2B891207D8
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Jun 2020 14:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EEECY9X2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B891207D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18927-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9351 invoked by uid 550); 4 Jun 2020 14:14:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9328 invoked from network); 4 Jun 2020 14:14:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JFfRFTCW6FlgjlqwGn/P6j5CtXdNMxPx5d48a8cUyd4=;
        b=EEECY9X2ZdOdKHgdpzGf+DMwJvZiLd517zxt2dbS2nKm3skzGPqTgtp413UgMfvu0Z
         ySVazhwi/YFYlUV4XnFzNegdZNUnbuIoZjvesCvFjNLr65TFhoUJDtKunjSbLIdKe1Ij
         T9U0pl+DeA8gNiHYV54V1mtUWojw8ar7qhEqIKQJkpZOJbirv3Ko8C7M9ApwFuifCCyM
         2BCbFSH7yCa2YARYKYiQjagjZ6ntYCRHhZ+z6FtDWrarTmrlseFb6Ofe5PTMn80MgGMT
         w8bNH0WNfPllBGNPWsHRyTCLuuEd5VP4NkFuiuk4k8s1Iz/61glv2Kv2yiGh6FU/aHnF
         JmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JFfRFTCW6FlgjlqwGn/P6j5CtXdNMxPx5d48a8cUyd4=;
        b=kfGhnolPqB32/+40sMdoW61Xy26F/fHvCOorG8McLXY4341MHpyp4xMHFBmicRN4cK
         mX9myDQ27a52HRs2bdGA3IcjE4ATMnKz6tXJOYvPN/yCTd2uTncHswNgSnkKwthMbC/+
         2o6Og1Lr94I2smme5zn164EyDZN507if/00hUSCakQrROC7d9dK9ZEl7hCMTCiHD4FTy
         n8J7Ige+BKJqnlaluKKJoH0OSDEwtMaxYpiiOQAZEMwj46hUNULatRl3oF1laEXD179X
         2AGVCWWQmMMphCMXpr+RTHRJGiWXxDixUj0igsl6qk29zB70xESoVpMT2oRxqrJQiO82
         3h5w==
X-Gm-Message-State: AOAM531uCdDdYMQvvgkoPB68rHx3MNjOseVtDqaPMB32qtWFxzWGkvu2
	PAgUfnbMBDXIrvxn515rDjo1VU5jjsqEg+gaB8Sj0Q==
X-Google-Smtp-Source: ABdhPJwh9Avfez2jE0mRwOtdOdTV4d94V9o8AmvMHNcT4N8KwBQZsul+bYwmwvBngke6YqzEcWV2C1L9uJeApYHNb1k=
X-Received: by 2002:a2e:541e:: with SMTP id i30mr2143909ljb.156.1591280081782;
 Thu, 04 Jun 2020 07:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200604134957.505389-1-alex.popov@linux.com> <20200604134957.505389-6-alex.popov@linux.com>
 <20200604135806.GA3170@willie-the-truck>
In-Reply-To: <20200604135806.GA3170@willie-the-truck>
From: Jann Horn <jannh@google.com>
Date: Thu, 4 Jun 2020 16:14:15 +0200
Message-ID: <CAG48ez0H_+EBd1wekk2oddSzLsgzincyZb_dB+s5atudB23YyA@mail.gmail.com>
Subject: Re: [PATCH 5/5] gcc-plugins/stackleak: Don't instrument
 vgettimeofday.c in arm64 VDSO
To: Will Deacon <will@kernel.org>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, 
	Emese Revfy <re.emese@gmail.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Thiago Jung Bauermann <bauerman@linux.ibm.com>, Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>, 
	Sven Schnelle <svens@stackframe.org>, Iurii Zaikin <yzaikin@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Peter Collingbourne <pcc@google.com>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Alexander Monakov <amonakov@ispras.ru>, Mathias Krause <minipli@googlemail.com>, 
	PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, 
	Laura Abbott <labbott@redhat.com>, Florian Weimer <fweimer@redhat.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kbuild@vger.kernel.org, 
	"the arch/x86 maintainers" <x86@kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel list <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 4, 2020 at 3:58 PM Will Deacon <will@kernel.org> wrote:
> On Thu, Jun 04, 2020 at 04:49:57PM +0300, Alexander Popov wrote:
> > Don't try instrumenting functions in arch/arm64/kernel/vdso/vgettimeofday.c.
> > Otherwise that can cause issues if the cleanup pass of stackleak gcc plugin
> > is disabled.
> >
> > Signed-off-by: Alexander Popov <alex.popov@linux.com>
> > ---
> >  arch/arm64/kernel/vdso/Makefile | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
> > index 3862cad2410c..9b84cafbd2da 100644
> > --- a/arch/arm64/kernel/vdso/Makefile
> > +++ b/arch/arm64/kernel/vdso/Makefile
> > @@ -32,7 +32,8 @@ UBSAN_SANITIZE                      := n
> >  OBJECT_FILES_NON_STANDARD    := y
> >  KCOV_INSTRUMENT                      := n
> >
> > -CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables
> > +CFLAGS_vgettimeofday.o = -O2 -mcmodel=tiny -fasynchronous-unwind-tables \
> > +             $(DISABLE_STACKLEAK_PLUGIN)
>
> I can pick this one up via arm64, thanks. Are there any other plugins we
> should be wary of? It looks like x86 filters out $(GCC_PLUGINS_CFLAGS)
> when building the vDSO.

Maybe at some point we should replace exclusions based on
GCC_PLUGINS_CFLAGS and KASAN_SANITIZE and UBSAN_SANITIZE and
OBJECT_FILES_NON_STANDARD and so on with something more generic...
something that says "this file will not be built into the normal
kernel, it contains code that runs in realmode / userspace / some
similarly weird context, and none of our instrumentation
infrastructure is available there"...
