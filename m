Return-Path: <SRS0=WH8+=Z4=lists.openwall.com=kernel-hardening-return-17471-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829FBC43603
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 16:35:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D09D720659
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 16:35:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MLSDZRNh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D09D720659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17471-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23890 invoked by uid 550); 6 Dec 2019 16:35:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23867 invoked from network); 6 Dec 2019 16:35:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XSkH0mMxJ0LjfyXh0N7TS7Y5Mgxh/voFS9v1bkgeE8Y=;
        b=MLSDZRNhI0hqxF9SMOVeK0bzV/j3DpCPUVJapnYSllSGN0EMupN4ZEact+yah726dW
         tgLTR2wLEun/p+pthj9h67Njj/fiNnXiCvs6Z1qMpYn2VQoO5Gx6i4nf6nzvCElH/JQF
         r4jpmSRlPHQzcb6OlXyVnXKNJEQfJOBv7GY7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XSkH0mMxJ0LjfyXh0N7TS7Y5Mgxh/voFS9v1bkgeE8Y=;
        b=T+E0P+fwwygG5T4ZMhLbkfYlesXWRU2aGPlwo5qM9mBKvVn0Qr7g4En3fNP5fAbgzV
         t+N+tym9ncoF/kmnvHYS6PCnsGYms/ruZb1di4tMu1HP5F11XTnZAIyGgNcG4AgW5LRj
         jqhDZyHllN1KpyE6n7yjdlAUc9Pxc9LzA+bSWXRliEsBBwUInHQnRgrPp37Pc7ED8r/n
         wHQ61X9GAxIA4RjBJCyAIUqdD/MOqzkN93iVGX81p6jGwsPLvzq+/8AKo3kxIFXwrLXe
         e19X/yFVqpOJ3Dc16IXBeTMS5/Ms/Wf+An6HirkVberB823L2ft8S9MY2jzgjvYed6NL
         kedA==
X-Gm-Message-State: APjAAAW5JmMNF0newtn/WkOLlm90jecjTy+3+laiQu7zZLgb50WV5EeM
	tZU2AKxxrdmmkpy2PY+hf8M70HPt6EM=
X-Google-Smtp-Source: APXvYqz1LX8+bMZQGL8/4y+xNvmhc9OJrrhicVr1oBzbUwmAh2qils2FzwoynaOFqv2rVcSDBi5BnA==
X-Received: by 2002:a17:907:42d3:: with SMTP id ng3mr16391019ejb.9.1575650123008;
        Fri, 06 Dec 2019 08:35:23 -0800 (PST)
X-Received: by 2002:a5d:494f:: with SMTP id r15mr13261474wrs.143.1575650120873;
 Fri, 06 Dec 2019 08:35:20 -0800 (PST)
MIME-Version: 1.0
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-5-thgarnie@chromium.org> <20191205090355.GC2810@hirez.programming.kicks-ass.net>
 <CAJcbSZF+vGE6ZseiQfcis2NMcimmpwvov_P-tZe--z5UxJPDdg@mail.gmail.com> <20191206102649.GC2844@hirez.programming.kicks-ass.net>
In-Reply-To: <20191206102649.GC2844@hirez.programming.kicks-ass.net>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Fri, 6 Dec 2019 08:35:09 -0800
X-Gmail-Original-Message-ID: <CAJcbSZHLcSN4BK=N7M3Kv9q-hkPe6dDxbHaRCG9v2JVwhSZxfw@mail.gmail.com>
Message-ID: <CAJcbSZHLcSN4BK=N7M3Kv9q-hkPe6dDxbHaRCG9v2JVwhSZxfw@mail.gmail.com>
Subject: Re: [PATCH v10 04/11] x86/entry/64: Adapt assembly for PIE support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 6, 2019 at 2:27 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Thu, Dec 05, 2019 at 09:01:50AM -0800, Thomas Garnier wrote:
> > On Thu, Dec 5, 2019 at 1:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Wed, Dec 04, 2019 at 04:09:41PM -0800, Thomas Garnier wrote:
> > >
> > > > @@ -1625,7 +1627,11 @@ first_nmi:
> > > >       addq    $8, (%rsp)      /* Fix up RSP */
> > > >       pushfq                  /* RFLAGS */
> > > >       pushq   $__KERNEL_CS    /* CS */
> > > > -     pushq   $1f             /* RIP */
> > > > +     pushq   $0              /* Future return address */
> > >
> > > We're building an IRET frame, the IRET frame does not have a 'future
> > > return address' field.
> >
> > I assumed that's the target RIP after iretq.
>
> It is. But it's still the (R)IP field of the IRET frame. Calling it
> anything else is just confusing. The frame is 5 words: SS, (R)SP, (R)FLAGS,
> CS, (R)IP.
>
> > > > +     pushq   %rdx            /* Save RAX */
> > > > +     leaq    1f(%rip), %rdx  /* RIP */
> > >
> > > nonsensical comment
> >
> > That was the same comment from the push $1f that I changed.
>
> Yes, but there it made sense since the PUSH actually created that field
> of the frame, here it is nonsensical. What this instruction does is put
> the address of the '1f' label into RDX, which is then stuck into the
> (R)IP field on the next instruction.

Got it, make sense. Thanks.

>
> > > > +     movq    %rdx, 8(%rsp)   /* Put 1f on return address */
> > > > +     popq    %rdx            /* Restore RAX */
