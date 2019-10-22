Return-Path: <SRS0=m2jq=YP=lists.openwall.com=kernel-hardening-return-17094-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A82CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 21:46:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 705532053B
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Oct 2019 21:46:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e7GEnWKd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 705532053B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17094-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5912 invoked by uid 550); 22 Oct 2019 21:46:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5891 invoked from network); 22 Oct 2019 21:46:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aMrKTryhNXEL/B3UTp309ZugYMIYjNFJ3JCQDb7MpUg=;
        b=e7GEnWKdbrItjF4U3+0nKF/lx06Wuk/tgdQ9ljPjtYqFQxUxKdNDAzX4a3J6VJRTNe
         fvZtiXWCwgTHkznQdje8cmtubTkLp7iAWQx8JQFReAwrsWNXsaolV9s3JWeGTMMfUgSg
         /repYwQIO6djr64TXfPZeXSpbh0xxoZWJHDJcfD+y+CBwuzbqN5LUnqOWUTiGUf9R0Qr
         mx9Cap4UGrAAnISWvG3FD7dZFNO0uJ247ZJQzIRI+2iGU4ea2aaoSxUg8M9zDlq777fS
         qDyNrdBaDb9pA7+swtiQSKBEfo7e0BGKpeLpbQo3G6PYa3kXJxBuLrIskMILqlTGUpAh
         147A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aMrKTryhNXEL/B3UTp309ZugYMIYjNFJ3JCQDb7MpUg=;
        b=IrK4g9qIEFE4msW1NDhIyUxfBeSIYtAUudVWifJI2nwq4IisLKop5Winc45MV0ewHH
         qQoW1a3of8ju4IjByLDAqs8Fpr9KO+NmE6ECwnz/hv8pBT3q0ap1sPzs11jy+sLjV5yx
         zNdY97aOJX31oNs0wFcOw4+ovePm+YPic1gSEFGWYAydgigo7dZfvvCuuqMYhH8J5plH
         s1M7XSVac2SepK4jTRrO10Y35Ah6n43l+bsx2teutQpDo/5mSC/ApCdJooJT7HLVWIK+
         /+1ZEA5TWU3i7hNa9jK+Y6SA+p2+8UmYi85OorwEBHCAur8U7G4z1e9tGBYQVaqSI6gI
         IhHw==
X-Gm-Message-State: APjAAAXckpyLqFsybh1XjwbE3UlQe2QJkqoaMSuQ+pumeiOe06UVVwQk
	vYM3gQJX/o1oKUEgQ5r7Xj30mNt+4glrC8bycyVIrg==
X-Google-Smtp-Source: APXvYqzBN7l8ISCANHOSmoQVZ7BSwt3ADui9uc+L7MwmUC/V+3k+jtXG0/+Q6ONVrUpOvA8D2yYjNueSFsMjPD9iN3Q=
X-Received: by 2002:a1f:a5d8:: with SMTP id o207mr3327674vke.81.1571780756763;
 Tue, 22 Oct 2019 14:45:56 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-4-samitolvanen@google.com> <20191022182206.0d8b2301@why>
In-Reply-To: <20191022182206.0d8b2301@why>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 22 Oct 2019 14:45:45 -0700
Message-ID: <CABCJKudSBjOkPFZ-DBFRNqQ=kx5u1Q8W6MY0VGoo=5BTakP2dg@mail.gmail.com>
Subject: Re: [PATCH 03/18] arm64: kvm: stop treating register x18 as caller save
To: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, LKML <linux-kernel@vger.kernel.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, Laura Abbott <labbott@redhat.com>, 
	Dave Martin <Dave.Martin@arm.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 22, 2019 at 10:22 AM Marc Zyngier <maz@kernel.org> wrote:
> >  .macro save_callee_saved_regs ctxt
> > +     str     x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
> >       stp     x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
> >       stp     x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
> >       stp     x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
> > @@ -38,6 +39,7 @@
> >       ldp     x25, x26, [\ctxt, #CPU_XREG_OFFSET(25)]
> >       ldp     x27, x28, [\ctxt, #CPU_XREG_OFFSET(27)]
> >       ldp     x29, lr,  [\ctxt, #CPU_XREG_OFFSET(29)]
> > +     ldr     x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
>
> There is now an assumption that ctxt is x18 (otherwise why would it be
> out of order?). Please add a comment to that effect.

> > -     // Restore guest regs x19-x29, lr
> > +     // Restore guest regs x18-x29, lr
> >       restore_callee_saved_regs x18
>
> Or you could elect another register such as x29 as the base, and keep
> the above in a reasonable order.

I'm fine with either option. Ard, any thoughts?

Sami
