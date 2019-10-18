Return-Path: <SRS0=cAPz=YL=lists.openwall.com=kernel-hardening-return-17045-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62131CA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:32:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AC4E4222C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:32:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q2GrSm+O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC4E4222C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17045-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32305 invoked by uid 550); 18 Oct 2019 17:32:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32284 invoked from network); 18 Oct 2019 17:32:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LUCkDiO1QUpPk5cl+dZgUeLa1d4lsLLAG2MEy31ElWU=;
        b=Q2GrSm+Odfy9jVEDqMmfnpv1JF6tDvJ9iXYBvf5rjH3en0ATo4AgQjw2pQDojlKoaS
         9fBS4aMFJ5dZwD9OigzTjU849InPSdBgGRC+uZEt3xD+a4RKHVALWELFRgwg2SA4Hrzq
         zb2RgQ0REmeyvR9a4FeSiZ73kVsr69wvb6c31MRdP3Bvd2XsEJze6gbRaEFiobpWXpeP
         Jy5YplzkCXmKDyVKqgUBpRu2Xoxis9XWxkxStyjOq8Q2jrPByqwE/lIB22HRWbIoxhAw
         w2b9PGOjxqmyIOBybNGNqSsdSOP6Tyg2PirfWZOi7lJ8gecCO3g1JCJKWpU8SIivdJr/
         RIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LUCkDiO1QUpPk5cl+dZgUeLa1d4lsLLAG2MEy31ElWU=;
        b=PUOMSlK6FMHz4c+/tH+YJH5uSzcDaO1jaDxLTciufSqgGT0P5nMU1rnb1+QhvtTk2y
         pEN1nXHHAGU5yU+y4uDAb2FJ/hLPVEea0SocTzMniTZBqGOjNXK4eCfU4wKRx4pFCaYN
         ANDpyd1wSfxEmXmASV961eTmMCPiqRbEM+tQoLMBKibGYg4wef4RxutsQ1vTEoNC/0go
         GADISy9tB+Q1QuoBzdrb5CwJ3BIzzpxS1GRgA4N+/0e0sP4Bh2SDZ3imdJzj/ECRMhno
         IAtqm/nrRZTiRXXH+K91/rKGP8+91mrBNrBwUf3iKAklhwHTkzG+ZrwF3VxVR+g0NoLr
         FHAw==
X-Gm-Message-State: APjAAAV/NIIEbT+EPgP5TGTun1TufXFIaO0QalJCV+MopHH3R67090ZH
	5XSqKtFS0i4ZQPgl/TLb6LKOKmJD4UzUlFAXoWX4WA==
X-Google-Smtp-Source: APXvYqyiP1Zzh4FMjPyyDPFh7Wpil1drk2/6fs3Sl6Id4xkJb/P7azXpHLFJ3B/tWIF35J82NWyTkkF5okrslIJan50=
X-Received: by 2002:a63:5448:: with SMTP id e8mr11186188pgm.10.1571419951879;
 Fri, 18 Oct 2019 10:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191018161033.261971-6-samitolvanen@google.com>
In-Reply-To: <20191018161033.261971-6-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 18 Oct 2019 10:32:20 -0700
Message-ID: <CAKwvOd=SZ+f6hiLb3_-jytcKMPDZ77otFzNDvbwpOSsNMnifSg@mail.gmail.com>
Subject: Re: [PATCH 05/18] arm64: kbuild: reserve reg x18 from general
 allocation by the compiler
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 9:11 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Before we can start using register x18 for a special purpose (as permitted
> by the AAPCS64 ABI), we need to tell the compiler that it is off limits
> for general allocation. So tag it as 'fixed',

yep, but...

> and remove the mention from
> the LL/SC compiler flag override.

was that cut/dropped from this patch?

>
> Link: https://patchwork.kernel.org/patch/9836881/

^ Looks like it. Maybe it doesn't matter, but if sending a V2, maybe
the commit message to be updated?

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

If sending a V2 with the above cleaned up, you may also include:
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

I like how this does not conditionally reserve it based on the CONFIG
for SCS.  Hopefully later patches don't wrap it, but I haven't looked
through all of them yet.

> ---
>  arch/arm64/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 2c0238ce0551..1c7b276bc7c5 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -55,7 +55,7 @@ endif
>
>  KBUILD_CFLAGS  += -mgeneral-regs-only $(lseinstr) $(brokengasinst)     \
>                    $(compat_vdso) $(cc_has_k_constraint)
> -KBUILD_CFLAGS  += -fno-asynchronous-unwind-tables
> +KBUILD_CFLAGS  += -fno-asynchronous-unwind-tables -ffixed-x18
>  KBUILD_CFLAGS  += $(call cc-disable-warning, psabi)
>  KBUILD_AFLAGS  += $(lseinstr) $(brokengasinst) $(compat_vdso)
>
> --
> 2.23.0.866.gb869b98d4c-goog
>


-- 
Thanks,
~Nick Desaulniers
