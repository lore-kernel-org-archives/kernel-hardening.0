Return-Path: <SRS0=q1uv=Z3=lists.openwall.com=kernel-hardening-return-17468-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C86C43603
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 17:02:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 215012464D
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 17:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="CQZLI6wt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 215012464D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17468-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30556 invoked by uid 550); 5 Dec 2019 17:02:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30533 invoked from network); 5 Dec 2019 17:02:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b6Cleg5skflMZ2QyscwPTbAfaq7s15gQy2+Wa63ePv0=;
        b=CQZLI6wt3BWIFwogUddoJz9QqvrbKWRIopyGCyDrGA9nQMZHfK7H4mUfhrGcoYLVlj
         XXoESTgdX3I9QBOgJ1TEy89MFt9aHu26uD/5Vde3hun5CJ24nbIh7zF+Kz0IvIqjAwI5
         wA/Wnb+K1WmVLGz1uG6SDCt/9hsYhFuVNGpvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b6Cleg5skflMZ2QyscwPTbAfaq7s15gQy2+Wa63ePv0=;
        b=oZTtN+ojeNJ8dt4kMokrO3CLsvBWGTcUdOGsXzTL+AY1TO1CqmcKDR8FiGD4Ukds3Q
         CBaHO5gsJAbNybBaGWu4b59okHU4QkrXR2B87sbqaWufIHn4ZZYXJ1c8ezbUB1EXiaJb
         VhyDYp13gYf3pmKjJvHKRNi1ASmBkyRNrkUE6LoYClXj0X1tr8QnT6FtA+q1ag6F0/sB
         pf6mZ0YroeoTgVbxEaGiupLa0qxHSr4aq40Mquy5mS5bjPhZh8wcXILEkKYN3z0Z3iTj
         cqr1xrljp3mwn48LC7Y/u6ghrE5Iu+tZL2ztuo2wZJkLLDpGDfcWnkLxao9W98VSf1Tj
         6kAg==
X-Gm-Message-State: APjAAAWbzYI0p6Tk1llOW8aLywx25xF/GUMquVCqOmc0W7Bn/WwFPCTc
	5f3VDuTZ5Xx8atCNrNJMCRH7t8nXi/A=
X-Google-Smtp-Source: APXvYqzmsdRaP63mqOoGL1kanl6luMX4n0XInBgqhzIqs/j3fc3eJjM+lvPpKstBt834pLiQrLKALg==
X-Received: by 2002:a17:906:ad96:: with SMTP id la22mr10459789ejb.84.1575565323833;
        Thu, 05 Dec 2019 09:02:03 -0800 (PST)
X-Received: by 2002:a7b:c3c6:: with SMTP id t6mr6222539wmj.106.1575565321736;
 Thu, 05 Dec 2019 09:02:01 -0800 (PST)
MIME-Version: 1.0
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-5-thgarnie@chromium.org> <20191205090355.GC2810@hirez.programming.kicks-ass.net>
In-Reply-To: <20191205090355.GC2810@hirez.programming.kicks-ass.net>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Thu, 5 Dec 2019 09:01:50 -0800
X-Gmail-Original-Message-ID: <CAJcbSZF+vGE6ZseiQfcis2NMcimmpwvov_P-tZe--z5UxJPDdg@mail.gmail.com>
Message-ID: <CAJcbSZF+vGE6ZseiQfcis2NMcimmpwvov_P-tZe--z5UxJPDdg@mail.gmail.com>
Subject: Re: [PATCH v10 04/11] x86/entry/64: Adapt assembly for PIE support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 5, 2019 at 1:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Dec 04, 2019 at 04:09:41PM -0800, Thomas Garnier wrote:
>
> > @@ -1625,7 +1627,11 @@ first_nmi:
> >       addq    $8, (%rsp)      /* Fix up RSP */
> >       pushfq                  /* RFLAGS */
> >       pushq   $__KERNEL_CS    /* CS */
> > -     pushq   $1f             /* RIP */
> > +     pushq   $0              /* Future return address */
>
> We're building an IRET frame, the IRET frame does not have a 'future
> return address' field.

I assumed that's the target RIP after iretq.

>
> > +     pushq   %rdx            /* Save RAX */
>
> fail..

Yes, sorry. I was asked to switch from RAX to RDX and missed the comment.

>
> > +     leaq    1f(%rip), %rdx  /* RIP */
>
> nonsensical comment

That was the same comment from the push $1f that I changed.

>
> > +     movq    %rdx, 8(%rsp)   /* Put 1f on return address */
> > +     popq    %rdx            /* Restore RAX */
>
> fail..

I will change in next iteration.

>
> >       iretq                   /* continues at repeat_nmi below */
> >       UNWIND_HINT_IRET_REGS
> >  1:
> > --
> > 2.24.0.393.g34dc348eaf-goog
> >
