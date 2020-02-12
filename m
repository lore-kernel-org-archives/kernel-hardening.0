Return-Path: <SRS0=ixzM=4A=lists.openwall.com=kernel-hardening-return-17806-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DBBEC352A4
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 20:59:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5EE70206D7
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 20:59:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hqtkQWWM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EE70206D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17806-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17559 invoked by uid 550); 12 Feb 2020 20:59:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17539 invoked from network); 12 Feb 2020 20:59:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dNT84lBczGzzOgb9OnM5Fdxg6SAeViGOzJlzxW7UwtM=;
        b=hqtkQWWMamX0OQO403fEmerDtGachsfSTpAQbGxOovOjrH4I6JJGU7ulCB6ab4JoT3
         KAyC6liLk8dJENInpS9tXLd0C/e4cO0xsfrq3v5JmxMDWdQPH4RtbIyUaPUEmFFncsnu
         NTRkAxc5qKDuK8ZfwFSsDYyfi27+i3eqlWyAZMw88Gui9+TfOwUOVnUpQC+aVOuJacyq
         8T1BF/3aw0pTkYZ2HCojO8/QDLI6PFgcL/LPPiCxdXK9F4wYD6vIQ7uMQfgPEsyj2YE5
         xyfVe+8nvsIELQ09/BO6sp4lG11/JqoDsbV7KjcyH1H3MR+bLO9ZJQVegNEKcfhvaktJ
         6iJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNT84lBczGzzOgb9OnM5Fdxg6SAeViGOzJlzxW7UwtM=;
        b=QE1DTvvAmbiOuwtl1kkXUlDWhwWJ6QCX7vd6O7uwJxro8CAMDujF2CVrFlfiwmcEwZ
         8+WQatQHyw6NR2gggP0b5BHoK3jHNRY1kFTxXIq3LGmDpsGR4gPmQFiHchthsIB6iM8g
         ytnlx3sB8zyHmu1fHaci/Nhf/EJDscLxhOyeerQZqkMPlbjVBmXhbmcbauTDrFRd6boO
         jiYDwGt9ixOHnR8qKMdaO/ZZeuKdScY9DHgO0wM634qZsR3i4BeZGq/fFz3hIohdn7Pd
         A1fdH9xMGPe12bpHF0xL7Ky3uJ/wzfqQZFOlAKygQ80pulhvKpML2GZ8/JF6Lvq2FlvO
         5F3g==
X-Gm-Message-State: APjAAAWYt4F3MaAnLPwqS+KdnjUILpEb78zSZ8teekDhOOk5ZoAtVAvT
	nII1vQvyMD+6eddPulqpbnC0EG+BkV9Sf6/EmjdLUQ==
X-Google-Smtp-Source: APXvYqwlqtMeW4JdpzouZL0DVTK633mlJLfXjD51WE9+E3ZvoUcyD8yDdtL0O1xkdRc9tJh+2nQxwQKr0i+z+9CR1Hg=
X-Received: by 2002:a67:2c15:: with SMTP id s21mr298736vss.104.1581541173587;
 Wed, 12 Feb 2020 12:59:33 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200128184934.77625-1-samitolvanen@google.com> <20200128184934.77625-12-samitolvanen@google.com>
 <dbb090ae-d1ec-cb1a-0710-e1d3cfe762b9@arm.com>
In-Reply-To: <dbb090ae-d1ec-cb1a-0710-e1d3cfe762b9@arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 12 Feb 2020 12:59:22 -0800
Message-ID: <CABCJKudpeTDa4Ro1aCsCJ-=x97SG0qu5LGpj9ywj1aLOtboNkQ@mail.gmail.com>
Subject: Re: [PATCH v7 11/11] arm64: scs: add shadow stacks for SDEI
To: James Morse <james.morse@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 11, 2020 at 5:57 AM James Morse <james.morse@arm.com> wrote:
>
> Hi Sami,
>
> On 28/01/2020 18:49, Sami Tolvanen wrote:
> > This change adds per-CPU shadow call stacks for the SDEI handler.
> > Similarly to how the kernel stacks are handled, we add separate shadow
> > stacks for normal and critical events.
>
> Reviewed-by: James Morse <james.morse@arm.com>
> Tested-by: James Morse <james.morse@arm.com>

Thank you for taking the time to test this, James!

> > diff --git a/arch/arm64/kernel/scs.c b/arch/arm64/kernel/scs.c
> > index eaadf5430baa..dddb7c56518b 100644
> > --- a/arch/arm64/kernel/scs.c
> > +++ b/arch/arm64/kernel/scs.c
>
> > +static int scs_alloc_percpu(unsigned long * __percpu *ptr, int cpu)
> > +{
> > +     unsigned long *p;
> > +
> > +     p = __vmalloc_node_range(PAGE_SIZE, SCS_SIZE,
> > +                              VMALLOC_START, VMALLOC_END,
> > +                              GFP_SCS, PAGE_KERNEL,
> > +                              0, cpu_to_node(cpu),
> > +                              __builtin_return_address(0));
>
> (What makes this arch specific? arm64 has its own calls like this for the regular vmap
> stacks because it plays tricks with the alignment. Here the alignment requirement comes
> from the core SCS code... Would another architecture implement these
> scs_alloc_percpu()/scs_free_percpu() differently?)

You are correct, these aren't necessarily specific to arm64. However,
right now, we are not allocating per-CPU shadow stacks anywhere else,
so this was a natural place for the helper functions. Would you prefer
me to move these to kernel/scs.c instead?

Sami
