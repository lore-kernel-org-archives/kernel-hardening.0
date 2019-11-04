Return-Path: <SRS0=dOby=Y4=lists.openwall.com=kernel-hardening-return-17275-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EA6CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 21:36:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BD90B20663
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 21:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WQqOCU6q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD90B20663
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17275-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22071 invoked by uid 550); 4 Nov 2019 21:35:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22048 invoked from network); 4 Nov 2019 21:35:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+iM6UF9mA8yEqKM2m+szbX2ng9KhnEZYRb5X/ojWJG0=;
        b=WQqOCU6qrDuZG8nuHgiV+CHsG7gWSoR72oOp+M0wKsltRJK+cGqjt2t0ZxI2LM6V8C
         1RQXAzRnu6jhZem6MHYFf5TI8O0Eb0LMsQH/RUeNBQLsild5ptqHR2+8pjmiMbj3JxhX
         gRUGg1RmBpVc1Q1nhoC4mIIl7umwH3N3gETvGBsHefq3zid8veGm9BMAaqqXtchvboU3
         oe82rt/ua0dQOwqs4AcW0tswAhd4f8FEmYPR+Wai5JGF1id5ch5hL+dBrDB6AtOUJFPg
         GiGCKXyOExBSa2rtb1uirhcrkQbT6A5dkDAwpPptAzVGzCMyH1PZXR7LWJ4+2g7vZ1c1
         epJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+iM6UF9mA8yEqKM2m+szbX2ng9KhnEZYRb5X/ojWJG0=;
        b=osWYieTtCJnURKEzSBDABDnD5hJgzGGViPtbXzOhY4L3c+LSmVJDtEJXcVTEQJTkN3
         y59VokBqtAZqNwOg4Q4DrO+iHIslKwJUPi/Yal/03GNynspitl0pXBIEctqEzNCW7OTk
         8eOikMrTRKTEOxhew8AYHn4TaTuGPFGlC5vIBLDGWrsxa+CyeufXwlEpO8lFXCGSRrv/
         uHabir0JP6vNL5O8SHndNNifu2YbSAW1rCf5hKbjzc3fUObGkCs7evjL/4CflhZyP9yE
         JrK5UsKxLMmKhEhevjoVyTUAoO6ooIoQs5K+A1dTCe0aX3us+lsHqZWGnqG4vdzRtub+
         Agog==
X-Gm-Message-State: APjAAAWaXoDB2PFN/XfAc2mGXPVVrQdaIT767mBiGwqlmWKvLHQi2QU5
	QQewu/0y6lTJAD3WzTqMC6Ue0bIlojLfg/2lMiHkAg==
X-Google-Smtp-Source: APXvYqw2qurgJaO5Z50222coqPPYraifWu1WpUrqJjCs3EdmK1uhIyv2tT4xgK/tp1HQy+BY+QUyECFV9cgzh+9tP6o=
X-Received: by 2002:a05:6102:36a:: with SMTP id f10mr9282538vsa.44.1572903339925;
 Mon, 04 Nov 2019 13:35:39 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-8-samitolvanen@google.com>
 <20191104124017.GD45140@lakrids.cambridge.arm.com>
In-Reply-To: <20191104124017.GD45140@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 13:35:28 -0800
Message-ID: <CABCJKueoJs7hS7VrVoz6CY_oAjTGcV-W61v9GAdwg+zk0W5ErA@mail.gmail.com>
Subject: Re: [PATCH v4 07/17] scs: add support for stack usage debugging
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

On Mon, Nov 4, 2019 at 4:40 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > +#ifdef CONFIG_DEBUG_STACK_USAGE
> > +static inline unsigned long scs_used(struct task_struct *tsk)
> > +{
> > +     unsigned long *p = __scs_base(tsk);
> > +     unsigned long *end = scs_magic(tsk);
> > +     uintptr_t s = (uintptr_t)p;
>
> As previously, please use unsigned long for consistency.

Ack.

> > +     while (p < end && *p)
> > +             p++;
>
> I think this is the only place where we legtimately access the shadow
> call stack directly.

There's also scs_corrupted, which checks that the end magic is intact.

> When using SCS and KASAN, are the
> compiler-generated accesses to the SCS instrumented?
>
> If not, it might make sense to make this:
>
>         while (p < end && READ_ONCE_NOCKECK(*p))
>
> ... and poison the allocation from KASAN's PoV, so that we can find
> unintentional accesses more easily.

Sure, that makes sense. I can poison the allocation for the
non-vmalloc case, I'll just need to refactor scs_set_magic to happen
before the poisoning.

Sami
