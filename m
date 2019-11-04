Return-Path: <SRS0=+o80=Y4=lists.openwall.com=kernel-hardening-return-17277-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A57CA9EC9
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 21:45:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9315B20869
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Nov 2019 21:45:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pHQfGMcF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9315B20869
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17277-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28080 invoked by uid 550); 4 Nov 2019 21:44:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28057 invoked from network); 4 Nov 2019 21:44:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kaXvf9wE3k9UaecG65PnRrmHU9a0z9eeJYq+CJlozEg=;
        b=pHQfGMcFvDs8Sz/sj2D9FDXz3MnOQRQu+N4CdnI6FNzotw2uFLAsGlw2AfCslqt5i1
         NhuT8B5Ezfwhp9svCCthVzKrqQzSaREP2/BOyA4VdDO3mOGFMeEnNqjZV9EKKb5BwgAH
         bM/dxgbkeGBwpw6v8NjWHN7WfR5TQqN/xXvS5kz11espcMoT6/ho31I/XOxv81JBcV1z
         GeqbggJuYjxj2QeyalY3/MCFCfCDWJn8/AxC+ZFPpCHvzX/Cpnxf1nw4yPeZBVh+ScLp
         O8nGwga8BiVRzIj9L+z7DaZgwmXUgoNZyiEQqIULFC5kXaLbkCP27rPqGbTAVSPqhK1Q
         tN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kaXvf9wE3k9UaecG65PnRrmHU9a0z9eeJYq+CJlozEg=;
        b=sk5Teb7GA0HkhrAAo6dmVGtjrctvCzgjFAgzGyO+MV8En1UElw39Rf0cpKfxLWNYTp
         RZeA8w4rBw4LHOOnRPtVYtBKYcmZn9bZShE9uGvpEWq686aOhNf2dM66/uyF3UoZ1Kau
         31TLortc8n22EYRG4BEnR7r62sGSYBacq88aYOq2Do3xIBGYl9gH6KU1N3ZNoEbuXCCg
         u8qkxZVPZErAnV+llZmkIkbwQ91Uq3ZfQk1SpSUbP4OaZzmUvJ+AbXcYLp9122T1ALgb
         h6MNDbeDs0BawnHfpeVk2+v7eMVURJ2ld2VN5dxCuCLaKLcWcom+d1StvUuO3Wgn/hEY
         fz8A==
X-Gm-Message-State: APjAAAWqy1y3gPwWOkzvMyd01alMjEoxqhTXv+2O1Hv/e4Af8C7HCSgF
	8IXiIlm3pbbpdg3rLyX2OnaV0upKkFmF0cuq2SqviA==
X-Google-Smtp-Source: APXvYqyozZ81Thh7mlXHgf1QUiqKh64ERV1FrTZSir+nNNiHAQ72oavyDPOWqxJDAI6llfn+2fNkSSVjyIyFG0syB7k=
X-Received: by 2002:ab0:5981:: with SMTP id g1mr1829842uad.98.1572903881724;
 Mon, 04 Nov 2019 13:44:41 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-4-samitolvanen@google.com>
 <20191104115138.GB45140@lakrids.cambridge.arm.com>
In-Reply-To: <20191104115138.GB45140@lakrids.cambridge.arm.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 4 Nov 2019 13:44:30 -0800
Message-ID: <CABCJKuf4wi6oUkJ68Z49UkK5q4WYYmSPt1X0pyw34ueNMkGC5Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/17] arm64: kvm: stop treating register x18 as caller save
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

On Mon, Nov 4, 2019 at 3:51 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > --- a/arch/arm64/kvm/hyp/entry.S
> > +++ b/arch/arm64/kvm/hyp/entry.S
> > @@ -23,6 +23,7 @@
> >       .pushsection    .hyp.text, "ax"
> >
>
> Could we please add a note here, e.g.
>
> /*
>  * We treat x18 as callee-saved as the host may use it as a platform
>  * register (e.g. for shadow call stack).
>  */
>
> ... as that will avoid anyone trying to optimize this away in future
> after reading the AAPCS.

Sure, that's a good idea.

> >  .macro restore_callee_saved_regs ctxt
> > +     // We assume \ctxt is not x18-x28
>
> Probably worth s/assume/require/ here.

Agreed, I'll change this in v5.

Sami
