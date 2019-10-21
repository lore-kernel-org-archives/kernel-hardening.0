Return-Path: <SRS0=VE1Q=YO=lists.openwall.com=kernel-hardening-return-17083-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CBA6CA9EAF
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 22:43:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B373F2089C
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 22:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b7OnnKII"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B373F2089C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17083-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21566 invoked by uid 550); 21 Oct 2019 22:43:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21548 invoked from network); 21 Oct 2019 22:43:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8E0A8Vlgzb4xSRYYj/bS6TXPUSZill0B9wa3qYYw0E=;
        b=b7OnnKIICEZMVXFl1NmYOdDcFZHXchQiF9AA/1N5pJuawnuvHkVE1IlsM/lRRh2pOy
         +tASGs8d3rjxlFCky/tFGjrZodoX0p4Deov9tvP++w+7DeZr8MYEjdMkf7sAhwlH6Gxc
         WJv6o+CSvqzoTlGP8vtZanFkkIcmQzBroXGREgjwNEhr/HuPvHIR+xU/UJcSYgDti2V1
         r1cQGVXNTkoPdaT2rZPVCTE/vqwrjXU7v+mianqUEVDhMJMb0ii90mYChlbeJqqrrVsO
         xszro/NyKQZOLCMnYcBtQPbBwGcEqBHnQ5xmgMZkhV8tOojOjuh3cxC3jt2Py6yycBJU
         fm5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8E0A8Vlgzb4xSRYYj/bS6TXPUSZill0B9wa3qYYw0E=;
        b=lZSBtd4GYKuQVbXR3CsU0b7qKnoPhmv3xnn57187F6ddaJQEhCpXfo6batyzLySZbv
         QaDpBjTeBhYGy+t5uSQ/nbAq2b5n6VHI9BJIJs6BCitmptahv7xuRTjI9Dd3iI2Itv/w
         CSmPH3aWdSS1xaNpEAHDHcCZmg5Yw+PqlBvYFdOMyyEgoxKORVlu55hbblhRn9Wmd/2d
         habBJt1QgQ3fkripF+h2Omq/YVMDeSUwR13qb9Xtwk9e4/lLqS8x59kt7TjvPDtXEDA2
         HShZNHmE4Oov/QIoGfJxIcQUseP9O9aAvbTkAVdUfZMONNsTj+lrnQbN6dKyDbk2hYFZ
         Zn5Q==
X-Gm-Message-State: APjAAAUQ3sCu+gGPH92yPSMpRltOvwCcqKT9/4dIFPehgdAdHUgwUw94
	DzPNeJjTvFuWTR7YRCL2SotZ4QDjwew5ug5gItinzA==
X-Google-Smtp-Source: APXvYqxm3g+B4XpEPIU+7n7e+ETZjean8RmHMKds1LlOCp+Q7indJHinK9NpFNA5K8TZ8NnejNJPfqBCKWSQ8YgLxPA=
X-Received: by 2002:a67:fb44:: with SMTP id e4mr113225vsr.112.1571697806489;
 Mon, 21 Oct 2019 15:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-14-samitolvanen@google.com> <20191021165649.GE56589@lakrids.cambridge.arm.com>
In-Reply-To: <20191021165649.GE56589@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 21 Oct 2019 15:43:14 -0700
Message-ID: <CABCJKucm2ETxe2dgJhb4Ruzq72psFMGsx=0D6TVnJ-_DL2FgfA@mail.gmail.com>
Subject: Re: [PATCH 13/18] arm64: preserve x18 when CPU is suspended
To: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Oct 21, 2019 at 9:56 AM Mark Rutland <mark.rutland@arm.com> wrote:
> This should have a corresponding change to cpu_suspend_ctx in
> <asm/suspend.h>. Otherwise we're corrupting a portion of the stack.

Ugh, correct. I'll fix this in the next version. Thanks.

Sami
