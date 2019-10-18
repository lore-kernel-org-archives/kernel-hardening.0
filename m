Return-Path: <SRS0=LA7O=YL=lists.openwall.com=kernel-hardening-return-17050-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06544CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:54:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4C9F6222C2
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:54:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pru8Y7xs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C9F6222C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17050-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12025 invoked by uid 550); 18 Oct 2019 17:54:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20413 invoked from network); 18 Oct 2019 17:05:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6GpsgHPaenSyC5p+IrYQknWia4lKY0B5Vf4l4gdQSw=;
        b=pru8Y7xsWSIdqZR1UXLglz64NrdFImykv1hpXma1k378qh9GF0SPliCcyZB8vMX7gE
         X3PfTswubuOthM8DCa4MKuMqqB1ZfOPHIhuEN9TMHd7OTZoscSb0DkIwcKzx/zVRsRzZ
         QpVsX696Og4ZxdvD3yeFj/AnBmqkJaxHpcBabDgxa1/06jnOKR4SPg62RTTmmQ52t+8S
         vOzXu4T6IK5JJ+sLrpw1VPCRku6gZS08n7Kckhw2KqDpdWTQICKrAUvwcmSbe2WDexT6
         KcVKUWL1M2hSYKLv2USJ9PsVEnaLnEqc22VydBFXRMPGh4AiAOA8mz7cgBZHgxDEDolP
         r6Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x6GpsgHPaenSyC5p+IrYQknWia4lKY0B5Vf4l4gdQSw=;
        b=Q2fItQw3FHhJEoySSghoIYtd5T3vL4vaFWTWnaK9K3wiMjSUo/JFRKig0A7u0prf6y
         L+saVxiqVRgWr2T7eEkLbt104QugV+JON4pHSKC0jfIAHcHXLi11m+Ol5Y/ufiaoTMBn
         QGD8qokjqN6mMHqSXPRVNK6VJlB6aBiBMsjgIz1X8BwoW0jnM/Kb6DgUQO1nl2nAZNgh
         EswbVf9RQDQyTYfG/Q17D90/nMemn8NsS0arpCXVv3r0K2JWoB+y/HQECUkkgIxwV7zW
         F946Qwixjdd9obPJFrGhTJx/tjxHNkURBZzXUIZGeuG78Eww+NfzeTf+1QDSAAllEg80
         47GA==
X-Gm-Message-State: APjAAAVyWFjv3Xu74kjvAor4BZuycBGwgOmn41KjA6x8+Qw4p7RGaoRj
	GcMMssfhK7fT+IwLGUQBi5N9ya03rrGNnAoirXxPQQ==
X-Google-Smtp-Source: APXvYqwYzSrQhNESR2odZjGb7CA2wtjkk8PIj6W3+g28TbncpOPsZUdRhuZ5AejLhrFJsW3Q8+X1IzSvMoqY0M2m7JA=
X-Received: by 2002:a67:ffc7:: with SMTP id w7mr6159173vsq.15.1571418330160;
 Fri, 18 Oct 2019 10:05:30 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-14-samitolvanen@google.com> <CAKwvOd=7g2zbGpL41KC=VgapTYYd7-XqFxf+WQUyHVVJSMq=5A@mail.gmail.com>
In-Reply-To: <CAKwvOd=7g2zbGpL41KC=VgapTYYd7-XqFxf+WQUyHVVJSMq=5A@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 18 Oct 2019 10:05:18 -0700
Message-ID: <CABCJKud7bJOQqyve9=niSP62H0WTrCk5ZAmAcD2-KR=vf_gn0Q@mail.gmail.com>
Subject: Re: [PATCH 13/18] arm64: preserve x18 when CPU is suspended
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 9:49 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> > diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
> > index fdabf40a83c8..9a8bd4bc8549 100644
> > --- a/arch/arm64/mm/proc.S
> > +++ b/arch/arm64/mm/proc.S
> > @@ -73,6 +73,9 @@ alternative_endif
> >         stp     x8, x9, [x0, #48]
> >         stp     x10, x11, [x0, #64]
> >         stp     x12, x13, [x0, #80]
> > +#ifdef CONFIG_SHADOW_CALL_STACK
> > +       stp     x18, xzr, [x0, #96]
>
> Could this be a str/ldr of just x18 rather than stp/ldp of x18 +
> garbage?  Maybe there's no real cost difference, or some kind of
> alignment invariant?

Sure, this can be changed to str/ldr. I don't think there's a
noticeable difference in cost.

Sami
