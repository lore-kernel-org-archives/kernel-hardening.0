Return-Path: <SRS0=srET=Y5=lists.openwall.com=kernel-hardening-return-17296-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818BDC5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 22:06:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B3A9921D6C
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 22:06:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="khVLBRWV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3A9921D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17296-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23913 invoked by uid 550); 5 Nov 2019 22:06:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23893 invoked from network); 5 Nov 2019 22:06:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BNIM3D66/Azg3YbAGxb2zW1QAG5fW9Q4vvlsSYbe2Go=;
        b=khVLBRWVxusf3aE0M5MrKx62Oe++CuRS+KMSKCuHE7JSxqPvv2VfNvIiZ4cxk9GprW
         abw7Gs5M44bJuTVgw8PeUbndm2GiKrPoGbtyG/1HyRFaCzIOPEvYaVpS47QGYbLxkN1k
         EhThQrckqd60eakMb3jq5ZvCpR+VWe7Rej+ktXn0G3ta4gTbl/rrlXA8Y/44FW6JNSva
         pXUTC0+JvRcq9/KOBxri17FvlBBWvc82WQme0i84hDJ6MCbHKa3Oj1yxPUj03p0Jrm+P
         ZOG1XOCcRDguAkyTbMvWk3Kc/XSmYgXExORncmzkrxKjVxBgHL6PNlkGOiIRVmIy3BXP
         G/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BNIM3D66/Azg3YbAGxb2zW1QAG5fW9Q4vvlsSYbe2Go=;
        b=U/vTWK7czZHt6SZFXKSaS4RkVPYeoZDsHxJAE8fUL+lzanHV807seiDYTo+Z07EQCr
         Q9XVt720sUnc1aAl5uiEV8Z5JWV9DlFIiNXWGtb1j0jtY/yRDBG8z3QSZT7cTH3b5hQQ
         o1Czym1FHfxBHM6h0LZELw4oLR/eNwq7pXmBdScr8Du/c/JmpMOpGO5JTsovjaxpwk2h
         bPBlzMlDwuHLbvDCd5AieU9RFZrwX9V0UkOrMRZ7nN+vS49w6o/tBP+IGh1PKPt1nw8e
         2CJY6Q1GtpLKbW1x9y+pxT2ZRLbZQTpTqrTlnEhlRSfli0odZ+6+k2AoHPgTGW9bOiW7
         F9Aw==
X-Gm-Message-State: APjAAAXTO0jKbdnz7FUb7Y2BPmtffKo7Ze56p/6emTLLFyYeLvb9CiU1
	lqnuMa1KlNmWdovxCdpie8SqxBR3CLBS7OS50OnNZg==
X-Google-Smtp-Source: APXvYqwEQ6fUE/r/RBzQgo3NUh3rdxSMFsh6pO692U/wnlkZClRp5BWs9eC7JOzQ6JAatKP0Y4DV4dBp0zEFlBlcc28=
X-Received: by 2002:a05:6102:36a:: with SMTP id f10mr116554vsa.44.1572991551050;
 Tue, 05 Nov 2019 14:05:51 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-12-samitolvanen@google.com>
 <20191104171132.GB2024@lakrids.cambridge.arm.com> <CABCJKufDnLjP9vA-wSW0gSY05Cbr=NOpJ-WCh-bdj2ZNq7VNXw@mail.gmail.com>
 <20191105091301.GB4743@lakrids.cambridge.arm.com>
In-Reply-To: <20191105091301.GB4743@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 5 Nov 2019 14:05:39 -0800
Message-ID: <CABCJKufpgoqo84GvV42bO-LVPZ4morV=OhscTNwaBpv-RSwXUw@mail.gmail.com>
Subject: Re: [PATCH v4 11/17] arm64: disable function graph tracing with SCS
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

On Tue, Nov 5, 2019 at 11:55 AM Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Nov 04, 2019 at 03:44:39PM -0800, Sami Tolvanen wrote:
> > Sure, I'll add a better description in v5. In this case, the return
> > address is modified in the kernel stack, which means the changes are
> > ignored with SCS.
>
> Ok, that makes sense to me. I'd suggest something like:
>
> | The graph tracer hooks returns by modifying frame records on the
> | (regular) stack, but with SCS the return address is taken from the
> | shadow stack, and the value in the frame record has no effect. As we
> | don't currently have a mechanism to determine the corresponding slot
> | on the shadow stack (and to pass this through the ftrace
> | infrastructure), for now let's disable the graph tracer when SCS is
> | enabled.
>
> ... as I suspect with some rework of the trampoline and common ftrace
> code we'd be able to correctly manipulate the shadow stack for this.
> Similarly, if clang gained -fpatchable-funciton-etnry, we'd get that for
> free.

That sounds good to me. Thanks, Mark.

Sami
