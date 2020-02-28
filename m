Return-Path: <SRS0=suiG=4Q=lists.openwall.com=kernel-hardening-return-18015-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD20C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 20:51:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CCA062469F
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 20:51:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WsM/fb6y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CCA062469F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18015-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30186 invoked by uid 550); 28 Feb 2020 20:51:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30166 invoked from network); 28 Feb 2020 20:51:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SitQuWaYJYljvcCrYj4fkHHkPc4o0vcrOMkYmOvH+dg=;
        b=WsM/fb6y5CGtFjZacOBZZYlUzkSwNVN+lgzwRpeO7kE0e/83uZ2+K3ZTNKkv0Q8dSI
         a+Cugxv8TY/rUcQjCqy8r8gHFh1GeAOUAEhTpt/68gti4/raIjNU9nV6YsuYTnE1pQg4
         BjR09FkgavjN4CagxM8NdJbh77wJU1R5zT8YKoCpeYzhTXcpH67QL/XNAng5pvrnCqzW
         IlpTQwrR9LWfOP5fofMezihxVEIAGD6q+96J1skrj6gfpRAHBApVND96QkQOppRbBXCs
         AIgan+ocDu8aj28mHw/t5DZ9jenFbfBChKOdPnSbMKWlknHeyCJ9J8SDvVmB2tsmDd2F
         ZnZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SitQuWaYJYljvcCrYj4fkHHkPc4o0vcrOMkYmOvH+dg=;
        b=ZYe04Ad43yjKSVAB2oFvlL3xycd038xBqB2TXX1uiqmLMSM8TMaNvWfu4sDwBDfHTK
         0iHh+A2IlF8q85Szp/yjyVgwcqa4qcInc2DW+Wrz1ktoKPraDorwqlNxIxAZp2S05sv/
         hT+ii2laLBl15bvopo2Pu1pUwvaFlfP8DckusjVHEOGe39/0yUTdH3z6hopjpC+cgcFP
         LlLygdJdmPpLEmG9GtpDymX3SstptoqtBXLTOpBL2kZQmLpfiuurDfaTI6/XfKUcs9nc
         2/Zxw5+uSi5ai4yYih5ZnTtRmwuGtzLHY9mVb+WAdGq2UG+uDWyt4T5YAwPsDUOblbG8
         YsyA==
X-Gm-Message-State: ANhLgQ0JC3Ye/Twd0cSNi3YL7PUIB0dxHLFkC9zJySRtYKQmfC7qe6nl
	LJjXKWtidBhY3PusKNWowf9SfgZM9lsWSLjb5kfaOg==
X-Google-Smtp-Source: ADFU+vvQxOaGGrHRtQqNZNl73QRM6vi1YBVrsU8i6+lpeaELnBsJ5FIiG7kODI7N1KIXUtRDUGM7/idkISnluUIb4h8=
X-Received: by 2002:a67:fb8d:: with SMTP id n13mr309624vsr.15.1582923080404;
 Fri, 28 Feb 2020 12:51:20 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200225173933.74818-1-samitolvanen@google.com> <20200225173933.74818-11-samitolvanen@google.com>
 <56b82a54-044a-75ec-64e5-6ba25b19571f@arm.com>
In-Reply-To: <56b82a54-044a-75ec-64e5-6ba25b19571f@arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 28 Feb 2020 12:51:09 -0800
Message-ID: <CABCJKufFp=7+18-XSY3U3745FifmRNXqBWk9TeZxgZ-aWmhfHQ@mail.gmail.com>
Subject: Re: [PATCH v9 10/12] arm64: implement Shadow Call Stack
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

On Fri, Feb 28, 2020 at 8:31 AM James Morse <james.morse@arm.com> wrote:
> > +#ifndef __ASSEMBLY__
>
> As the whole file is guarded by this, why do you need to include it in assembly files at all?

True, the include in head.S is not needed. I'll remove it in the next version.

> > +static inline void scs_overflow_check(struct task_struct *tsk)
> > +{
> > +     if (unlikely(scs_corrupted(tsk)))
> > +             panic("corrupted shadow stack detected inside scheduler\n");
>
> Could this ever catch anything with CONFIG_SHADOW_CALL_STACK_VMAP?
> Wouldn't we have hit the vmalloc guard page at the point of overflow?

With CONFIG_SHADOW_CALL_STACK_VMAP, even though we allocate a full
page, SCS_SIZE is still 1k, so we should catch overflows here well
before we hit the guard page.

> It would be nice to have a per-cpu stack that we switch to when on the overflow stack.

It shouldn't be a problem to add an overflow shadow stack if you think
one is needed.

> I can't work out why this needs to be before before idle_task_exit()...
> It needs to run before init_idle(), which calls scs_task_reset(), but all that is on the
> cpu_up() path. (if it is to pair those up, any reason core code can't do both?)

At this point, the idle task's shadow stack pointer is only stored in
x18, so we need to save it again to thread_info before the CPU shuts
down, or we'll lose the pointer.

Sami
