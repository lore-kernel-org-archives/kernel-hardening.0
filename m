Return-Path: <SRS0=Ac+z=ZH=lists.openwall.com=kernel-hardening-return-17393-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2824C432C3
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 20:19:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 113CA2073B
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2019 20:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sz3oYsEy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 113CA2073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17393-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15589 invoked by uid 550); 15 Nov 2019 20:19:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15567 invoked from network); 15 Nov 2019 20:19:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JGaDR9v43Zv6SHpEarxzzn1nbL46+U2IHPBI4tRr2qU=;
        b=sz3oYsEy6H86AvsBzq8AbZKdjQSN7okat4NCYezwXYe4Nn3roLSKspibusFC5eHUf/
         XOZxYpYgje1RauUONtlip6AndrCc1FzEjmqFuEXf/69rqOVa2UBWi0fKU+Kei4F8RfQX
         +7+vOdylQ6Vj7DNMXqMEOg93IKnt/XFB5vW7yWtdoQvsrjLwYpphuYBP9e1+Qbw3HkGs
         UbQW5JMFNZJhDACwQBzv7KE+82hTDuxWS8H3YU+Y4iLbH+MU9i1tI1p103NI8UckIlSi
         o8zaOjuCB9CXHD9+Ooztaj1GSDDxopXYagZX0MrPMJY7b/8XydSkeYdBXQfkOH969mBK
         m3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JGaDR9v43Zv6SHpEarxzzn1nbL46+U2IHPBI4tRr2qU=;
        b=KdkH8JnAppVJlEsAXzw2a5M2ozjEsl5UeoxioSZwkOwIO+oO3e8+yeTpoBbg3AOvTt
         ez+9OWts6w8TEvm0wpcD0FJHrT0bSoh7SB2Ol7RnJt5BoVrCGUVmZeY35TVSozeTr3uG
         ZouzFzx7rX8D/LgeIp5cPPG/10m/Bgbw/Aq5jbUOa7x//3GnOiOkLoIIV1HUXgDXInwR
         B8OcmSKXPjbBA7PLBbLuohJeDY9BENTPaae+eqCnNmeTMxu2x8mN2HrECmoAwko7KPGh
         NVnpvMKs9F9Is/wLZ2jXx6KLDcbZBs5M8Kp9ayACY/VcFXRFwj+PwQ9Mwl/s78Z6xebt
         Bx/Q==
X-Gm-Message-State: APjAAAXIyPgxc2LXdsmex6dkbvpQZxpNDROBuUGameAqpko3+NqMScxP
	nBdKjGCDthBByQ+5hL3qqNomfDNJhprJY4qIVI3Z5A==
X-Google-Smtp-Source: APXvYqyJJAtOC9yDRTQtthbybCklKzAJjxRAZgrd64ZfvgQMG7E3ZVIDa8qPXRTRklTlBbwY1FtJCZyMYntSX38nxGA=
X-Received: by 2002:a67:db10:: with SMTP id z16mr6607389vsj.5.1573849174709;
 Fri, 15 Nov 2019 12:19:34 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191105235608.107702-1-samitolvanen@google.com> <20191105235608.107702-15-samitolvanen@google.com>
 <20191115152047.GI41572@lakrids.cambridge.arm.com>
In-Reply-To: <20191115152047.GI41572@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 15 Nov 2019 12:19:20 -0800
Message-ID: <CABCJKudm28QaKRxPHWgKuEfRvm=EvuUEmcAVOnNkbxBCJcYX5A@mail.gmail.com>
Subject: Re: [PATCH v5 14/14] arm64: implement Shadow Call Stack
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 15, 2019 at 7:20 AM Mark Rutland <mark.rutland@arm.com> wrote:
>
> On Tue, Nov 05, 2019 at 03:56:08PM -0800, Sami Tolvanen wrote:
> > This change implements shadow stack switching, initial SCS set-up,
> > and interrupt shadow stacks for arm64.
>
> Each CPU also has an overflow stack, and two SDEI stacks, which should
> presumably be given their own SCS. SDEI is effectively a software-NMI,
> so it should almost certainly have the same treatement as IRQ.

Makes sense. I'll take a look at adding shadow stacks for the SDEI handler.

> Can we please fold this comment into the one above, and have:
>
>         /*
>          * The callee-saved regs (x19-x29) should be preserved between
>          * irq_stack_entry and irq_stack_exit.
>          */
>         .macro irq_stack_exit
>         mov     sp, x19
> #ifdef CONFIG_SHADOW_CALL_STACK
>         mov     x18, x20
> #endif
>         .endm

Sure, I'll change this in the next version.

Sami
