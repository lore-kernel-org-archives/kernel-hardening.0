Return-Path: <SRS0=gURq=WB=lists.openwall.com=kernel-hardening-return-16714-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A97C433FF
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 17:51:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C4CBB216B7
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 17:51:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lcMh40MT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4CBB216B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16714-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11837 invoked by uid 550); 5 Aug 2019 17:50:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11819 invoked from network); 5 Aug 2019 17:50:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cudx4Ed0VrEgvxeqYlvplwj7CuqSGFqTGqW93wYT0ZA=;
        b=lcMh40MTEhDqcDc/Gwizp4DJq1zLgs29VTl8B1MgV0gn6732Zykhw5rk/hpfE/bZdg
         Z858446bKNZEhHdaqVDwdaAsKxo6RjEGO70Kjc0YCdzO2WCfu8gWMDnBHRY7Wsqazeyi
         upx6pi+/qoF7JyIsV5gcZruSS8VvqmZ+kjsTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cudx4Ed0VrEgvxeqYlvplwj7CuqSGFqTGqW93wYT0ZA=;
        b=ivGrkz96y7OM0Ycq0iISFvZU0DbqjEfD6JYOm/dXYOt1nLYokrAuTyba04o1VF1iT5
         tDyMdz9WTzDpZ/HG+ERLEAekuZm7PjVjRsowahfdcCbXl3wki1XZnvgOhYWKSC4FjG9p
         csSdQ/AZr+94B9Zyd9CtxI89XzwF3t8hqe5J/w30co1iDjbD6n6ipIqC5iPifvf6EamJ
         SAcs/fvdey+Omy3LSV9gBr311g0PpLYVVst1GAQh40H8/DZkZp89J0acngK5NX4K2a0C
         eZSW3J8e2wLhFFZzIIJaW3h/qsVs7yh6oSNEHuJ4nsiLm0FdQn51/OnMTyzTKnFi+lGK
         rDOw==
X-Gm-Message-State: APjAAAXHx4uDRyaxDn7yaqSGUtglulgUvt7GUWjOii0zLngA0BJCV8Fl
	2nN4EuYwEhywlwZuKzb2r587MdiJ4yY=
X-Google-Smtp-Source: APXvYqzufYIR6HcfuB62ET5RBMeanWcySsgYg6IJPJPstN3348FtSK4nmwWxFWT8eb96XyRWNO+QxA==
X-Received: by 2002:a50:871c:: with SMTP id i28mr135558266edb.29.1565027443377;
        Mon, 05 Aug 2019 10:50:43 -0700 (PDT)
X-Received: by 2002:adf:f40b:: with SMTP id g11mr11766296wro.81.1565027441769;
 Mon, 05 Aug 2019 10:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-5-thgarnie@chromium.org> <20190805172854.GF18785@zn.tnic>
In-Reply-To: <20190805172854.GF18785@zn.tnic>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Mon, 5 Aug 2019 10:50:30 -0700
X-Gmail-Original-Message-ID: <CAJcbSZGedSfZZ5rveH2+_3q7pvmMyDGLxmZU41Nno=ZBX8kN=w@mail.gmail.com>
Message-ID: <CAJcbSZGedSfZZ5rveH2+_3q7pvmMyDGLxmZU41Nno=ZBX8kN=w@mail.gmail.com>
Subject: Re: [PATCH v9 04/11] x86/entry/64: Adapt assembly for PIE support
To: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, "the arch/x86 maintainers" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 5, 2019 at 10:28 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Jul 30, 2019 at 12:12:48PM -0700, Thomas Garnier wrote:
> > Change the assembly code to use only relative references of symbols for the
> > kernel to be PIE compatible.
> >
> > Position Independent Executable (PIE) support will allow to extend the
> > KASLR randomization range below 0xffffffff80000000.
> >
> > Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > ---
> >  arch/x86/entry/entry_64.S | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> > index 3f5a978a02a7..4b588a902009 100644
> > --- a/arch/x86/entry/entry_64.S
> > +++ b/arch/x86/entry/entry_64.S
> > @@ -1317,7 +1317,8 @@ ENTRY(error_entry)
> >       movl    %ecx, %eax                      /* zero extend */
> >       cmpq    %rax, RIP+8(%rsp)
> >       je      .Lbstep_iret
> > -     cmpq    $.Lgs_change, RIP+8(%rsp)
> > +     leaq    .Lgs_change(%rip), %rcx
> > +     cmpq    %rcx, RIP+8(%rsp)
> >       jne     .Lerror_entry_done
> >
> >       /*
> > @@ -1514,10 +1515,10 @@ ENTRY(nmi)
> >        * resume the outer NMI.
> >        */
> >
> > -     movq    $repeat_nmi, %rdx
> > +     leaq    repeat_nmi(%rip), %rdx
> >       cmpq    8(%rsp), %rdx
> >       ja      1f
> > -     movq    $end_repeat_nmi, %rdx
> > +     leaq    end_repeat_nmi(%rip), %rdx
> >       cmpq    8(%rsp), %rdx
> >       ja      nested_nmi_out
> >  1:
> > @@ -1571,7 +1572,8 @@ nested_nmi:
> >       pushq   %rdx
> >       pushfq
> >       pushq   $__KERNEL_CS
> > -     pushq   $repeat_nmi
> > +     leaq    repeat_nmi(%rip), %rdx
> > +     pushq   %rdx
> >
> >       /* Put stack back */
> >       addq    $(6*8), %rsp
> > @@ -1610,7 +1612,11 @@ first_nmi:
> >       addq    $8, (%rsp)      /* Fix up RSP */
> >       pushfq                  /* RFLAGS */
> >       pushq   $__KERNEL_CS    /* CS */
> > -     pushq   $1f             /* RIP */
> > +     pushq   $0              /* Future return address */
> > +     pushq   %rax            /* Save RAX */
> > +     leaq    1f(%rip), %rax  /* RIP */
> > +     movq    %rax, 8(%rsp)   /* Put 1f on return address */
> > +     popq    %rax            /* Restore RAX */
>
> Can't you just use a callee-clobbered reg here instead of preserving
> %rax?

I saw that %rdx was used for temporary usage and restored before the
end so I assumed that it was not an option.

>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
