Return-Path: <SRS0=lQqO=YZ=lists.openwall.com=kernel-hardening-return-17228-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB2FCA9ECF
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 16:33:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 66119217D9
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 16:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mVdZ7udl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66119217D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17228-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17416 invoked by uid 550); 1 Nov 2019 16:33:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16372 invoked from network); 1 Nov 2019 16:33:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5WHWvyJ9Hz5kosmku4ReDEqbYSNCjtYvPAtQ8gov0w=;
        b=mVdZ7udliBm1Ah/0SRYlDf6bwEJ6TL7x3JmnofXlcyZOXqi5Q9VBuiMbpvt9qFtviY
         O1dg12Mx/ZqNCdmPnMehixCUQwwDXQwkP8easpaC7ETmB8M+bGzkf5mtTCIfXJepYgXQ
         UpEXv0+Y/8IRh6Bt9tXSt5I5dm6Naa/8+P0Gfr7zVhf9zJ0enNNpTxkLjpUS3Y3FM1TQ
         K14mAw/P1HzmMF2Q3lOwbI6KFmRqbDNTH4h5du1QpSKj0tUoB4V/KntCBftt2t3ivGyo
         CvnopvuGe8ctEsWcfBzhSVdFtD8ECLxaPGft365BahwUkKRXVOufpCDz3m9fqW+WiVMo
         c2IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5WHWvyJ9Hz5kosmku4ReDEqbYSNCjtYvPAtQ8gov0w=;
        b=BHFqY0CjJtwpYJqQ2J7s2UXHBYO+0iUgsSwY8x6qQpHXZJOXvY4gmDvAfVD7rH+4wV
         SVQ+Hp8HcoSBwFA7h8YzBlJU5cMPAMOjVTjmJavDLauYQR4D/O/REti4dZ2I1aDFzEhU
         C0dMyXWPrkXTNZkCBIfTd4qz0KIuDUizUeE9uE7SS4R90XdVomVRAIYmo/B08tKo/q8B
         sMnP8U9yLn/+GVRWN8J53HcFhfOClUtvvjUdARLaRIbYc0/AhAkkSML1rqMvUVAK0nMl
         kHuQqkK/8N28mcNcA27X84JWpzSLRzFAF4aYqSTnQZivB8FUeaeBPnRLT0SXNeTQptjs
         mntQ==
X-Gm-Message-State: APjAAAURet70wvJq8Hlbr/0NZVFnsT90/7EemOR4AHeftg5JbRPi929U
	6HkmIEuPQ4f/emJW+fgc8YUssnGIEOZjAMe/cGpDDw==
X-Google-Smtp-Source: APXvYqyUC2VNoK3kn3nz3vybeugE+sMvvcm2WU0gwrr3Eljqv0y0V3sHBklXl+ihwCVizGZj+lsXZashNS/ogzG8fqQ=
X-Received: by 2002:a05:6102:36a:: with SMTP id f10mr1696654vsa.44.1572625985166;
 Fri, 01 Nov 2019 09:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-8-samitolvanen@google.com>
 <201910312054.3064999E@keescook>
In-Reply-To: <201910312054.3064999E@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 1 Nov 2019 09:32:54 -0700
Message-ID: <CABCJKueAf3f-rHw8AXJKKi=kfnh+nBMpJP2Vb2DVqLUWZVmFqQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/17] scs: add support for stack usage debugging
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 31, 2019 at 8:55 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Oct 31, 2019 at 09:46:27AM -0700, samitolvanen@google.com wrote:
> > Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks.
>
> Did I miss it, or is there no Kconfig section for this? I just realized
> I can't find it. I was going to say "this commit log should explain
> why/when this option is used", but then figured it might be explained in
> the Kconfig ... but I couldn't find it. ;)

It's in lib/Kconfig.debug. But yes, I will add a commit message in v4.

Sami
