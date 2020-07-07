Return-Path: <SRS0=qzsi=AS=lists.openwall.com=kernel-hardening-return-19227-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EA5C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 17:17:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 131D6206C3
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 17:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p+taEDuk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 131D6206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19227-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32403 invoked by uid 550); 7 Jul 2020 17:17:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32371 invoked from network); 7 Jul 2020 17:17:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1l5foeggCPnvjxEutFU8wFN3OGjiNb8LVGar6Q0E2bk=;
        b=p+taEDukDZunYk2YVvDirVBFCS5gqPr2R9RnKJfnddhTGc20YU572SKyACE7vpcaTR
         F5HFH2fMBR8VjtEEwiyQ74CmsVRSj4Ad4FLU1To0K6z4ULdO3jvbHZeeGBHBRmSu0PTW
         UbccsCiQebhN4H0b9EnPYPa5Ai8Ws0KmyU4TI5o1FFt5ZLgZIreDV3fb67rOGyWIfR6/
         oou2xq9qwW2pgE28CTCAGQHvyAbBx2Fzy3ylMs664PbsO+zz4aI2MU8QtAAJwDXtirLI
         6B9dfNDIOTNJp7sWV70NHM21ivLgatQ2mrd5vfPNJba12U8BMEgM7EeQ3t2Y2FedZETc
         ViTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1l5foeggCPnvjxEutFU8wFN3OGjiNb8LVGar6Q0E2bk=;
        b=JXUNdf4i7FbSylD6wOTwq69Lzc88WMG+GTZl0o3xGWehQvg1zHEycFQW/q/FLHDmVj
         gNZS/gQlgIDj+P0DYBD/gNRJ7nd6NtRDIPUSBRNFSv4u8wQoq7pqL26MNGTicPQeVNmJ
         H4SICGlFYn5gj38lR1CsAWYtFbgctXcCMJvUvyCOzLgTBwtcJaT2sqx2TIK7jrTgCEzj
         Awiy62h1hN6Lb5zT6xvXa6Avy6oOIpwK/OKpf8E5JgA7vn1G5ALfoqY5Nvsr6xXJmbN1
         NModnGWNqWpvepayt4NtWZOfYRTEPsmnXgSHZdMJ+ftntZ1pRrdpyE0xXSES6flrvc94
         ZTkg==
X-Gm-Message-State: AOAM530UUtooeS7ka88gHAIeaFrqPDaZfzDu7+gp6qoiYA/+ndh5+u1d
	rbVV1ikgWXDhMNYrv88Pu1L50jJ1cQStWp0kK5bv7g==
X-Google-Smtp-Source: ABdhPJzimEYKgjGUXrlBaLBBjIq4MiI2yDdoA4ahjq7vNkr0ok0O/VlCBrFDIeS1Bs6yHN7Uv+XaLt7SQoM3eHhtWPo=
X-Received: by 2002:a17:90a:21ef:: with SMTP id q102mr5585509pjc.101.1594142256771;
 Tue, 07 Jul 2020 10:17:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com>
 <20200629232059.GA3787278@google.com> <20200707155107.GA3357035@google.com>
 <20200707160528.GA1300535@google.com> <20200707095651.422f0b22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200707095651.422f0b22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 7 Jul 2020 10:17:25 -0700
Message-ID: <CAKwvOd=z0n2+1voMCzC6Hft9EBdLM+6PUi9qBVTVvea_3kM91w@mail.gmail.com>
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: Jakub Kicinski <kuba@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org, 
	X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 7, 2020 at 9:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> > On Tue, Jul 07, 2020 at 08:51:07AM -0700, Sami Tolvanen wrote:
> > > After spending some time debugging this with Nick, it looks like the
> > > error is caused by a recent optimization change in LLVM, which together
> > > with the inlining of ur_load_imm_any into jeq_imm, changes a runtime
> > > check in FIELD_FIT that would always fail, to a compile-time check that
> > > breaks the build. In jeq_imm, we have:
> > >
> > >     /* struct bpf_insn: _s32 imm */
> > >     u64 imm = insn->imm; /* sign extend */
> > >     ...
> > >     if (imm >> 32) { /* non-zero only if insn->imm is negative */
> > >             /* inlined from ur_load_imm_any */
> > >     u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
> > >
> > >         /*
> > >      * __imm has a value known at compile-time, which means
> > >      * __builtin_constant_p(__imm) is true and we end up with
> > >      * essentially this in __BF_FIELD_CHECK:
> > >      */
> > >     if (__builtin_constant_p(__imm) && __imm > 255)
>
> I think FIELD_FIT() should not pass the value into __BF_FIELD_CHECK().
>
> So:
>
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index 48ea093ff04c..4e035aca6f7e 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -77,7 +77,7 @@
>   */
>  #define FIELD_FIT(_mask, _val)                                         \
>         ({                                                              \
> -               __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");     \
> +               __BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");     \
>                 !((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
>         })
>
> It's perfectly legal to pass a constant which does not fit, in which
> case FIELD_FIT() should just return false not break the build.
>
> Right?

I see the value of the __builtin_constant_p check; this is just a very
interesting case where rather than an integer literal appearing in the
source, the compiler is able to deduce that the parameter can only
have one value in one case, and allows __builtin_constant_p to
evaluate to true for it.

I had definitely asked Sami about the comment above FIELD_FIT:
"""
 76  * Return: true if @_val can fit inside @_mask, false if @_val is
too big.
"""
in which FIELD_FIT doesn't return false if @_val is too big and a
compile time constant. (Rather it breaks the build).

Of the 14 expansion sites of FIELD_FIT I see in mainline, it doesn't
look like any integral literals are passed, so maybe the compile time
checks of _val are of little value for FIELD_FIT.

So I think your suggested diff is the most concise fix.
-- 
Thanks,
~Nick Desaulniers
