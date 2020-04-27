Return-Path: <SRS0=X12h=6L=lists.openwall.com=kernel-hardening-return-18660-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA802C81CFF
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 22:10:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 14AAA2078C
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 22:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="axOblyzY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14AAA2078C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18660-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17555 invoked by uid 550); 27 Apr 2020 22:10:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17529 invoked from network); 27 Apr 2020 22:10:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Xe8RUkEJu/E4jWUvQIevudFni0eW89aFKGU5bjDlftc=;
        b=axOblyzYYZwm23zJs/yIhW4AiXhyGbo1u4AhSQWZk6aCS3SbgYhrO3uxU/GIgXJe+R
         lZFY51Gu9ZAm1+Wx8ojNeFt262o3xlrjkkPW0UDsqW7aQHJ1kxx3GUTkZZ+SHEwEx4sj
         qIXCdTHxBwmKDJGtD8EE1vu3RoM8rdzvr7zJDbahVKaFbLW3BvoGBtbrg30QQDm9ZjL4
         NPsfDMvwSpCub92zGM4zYe+Jb2mMQ9YPQ+DnbHm8ALegArlm8BVMTVmhVxMj9B3OIDe9
         C66WGlEQ/5l6bbT1mq3LFfU7EdwlU0npz53O3fl3EQgOzkoYeSp2jk4DOPWs1j31cN1R
         XZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Xe8RUkEJu/E4jWUvQIevudFni0eW89aFKGU5bjDlftc=;
        b=g7y8gRRTZ97d0pWFJjjRzsRnXWRHs9GoicT+MLvRpuAQLtRI08zdOZAQ+GmmfGRS5N
         82Bqam6DywSvslUv/FI0LSWyaEs/eHZdzNnYSvxXwG/r9uKmg8aCuq9GjWz68a61kHOj
         lugvXTvEmm9ScyD5S7L2wpI2RN8CYp6XPF33jwbAjsOcI6JIzu+5Iy0IvA0el/hjzh+f
         3xFZdXms3X5zqMMTraFUuvnX3iOXLmM0SeBkjjvbLiEsU9T7Cj9NNb85W4vARjMFpCFq
         F1Z0p0h/Ckn1CCkFwNtHGBirligv0aO+19Naq7I+NiJ+eIAbkuNOHHGxqk44C0OHSdwS
         dAjg==
X-Gm-Message-State: AGi0PuYNbcDXbjjeNq4cG39YpIJp8B7ccRREV9NuUhUyolxxpH7AY95M
	AThr2abtuQdoKANbitbXt3f8Xg==
X-Google-Smtp-Source: APiQypJpQnaMid4q4FwB9UWWT+cZC0Q4L77KS//F8Pl43k21RxaiBYMIK3X+fVPtnLNFejOX3p7P2Q==
X-Received: by 2002:aa7:951a:: with SMTP id b26mr25384503pfp.44.1588025389927;
        Mon, 27 Apr 2020 15:09:49 -0700 (PDT)
Date: Mon, 27 Apr 2020 15:09:42 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
	Marc Zyngier <maz@kernel.org>, kernel-hardening@lists.openwall.com,
	Nick Desaulniers <ndesaulniers@google.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Laura Abbott <labbott@redhat.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v13 00/12] add support for Clang's Shadow Call Stack
Message-ID: <20200427220942.GB80713@google.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200427160018.243569-1-samitolvanen@google.com>
 <CAMj1kXGASSCjTjvXJh=_iPwEPG50_pVRe2QO1hoRW+KHtugFVQ@mail.gmail.com>
 <CAMj1kXFYv6YQJ0KGnFh=d6_K-39PYW+2bUj9TDnutA04czhOjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFYv6YQJ0KGnFh=d6_K-39PYW+2bUj9TDnutA04czhOjQ@mail.gmail.com>

On Mon, Apr 27, 2020 at 10:50:34PM +0200, Ard Biesheuvel wrote:
> > OK, so one thing that came up in an offline discussion about SCS is
> > the way it interacts with the vmap'ed stack.
> >
> > The vmap'ed stack is great for robustness, but it only works if things
> > don't explode for other reasons in the mean time. This means the
> > ordinary-to-shadow-call-stack size ratio should be chosen such that it
> > is *really* unlikely you could ever overflow the shadow call stack and
> > corrupt another task's call stack before hitting the vmap stack's
> > guard region.
> >
> > Alternatively, I wonder if there is a way we could let the SCS and
> > ordinary stack share the [bottom of] the vmap'ed region. That would
> > give rather nasty results if the ordinary stack overflows into the
> > SCS, but for cases where we really recurse out of control, we could
> > catch this occurrence on either stack, whichever one occurs first. And
> > the nastiness -when it does occur- will not corrupt any state beyond
> > the stack of the current task.
> 
> Hmm, I guess that would make it quite hard to keep the SCS address
> secret though :-(

Yes, and the stack potentially overflowing into the SCS sort of defeats
the purpose. I'm fine with increasing the SCS size to something safer,
but using a vmapped shadow stack seems like the correct solution to this
problem, at least on devices where allocating a full page isn't an issue.

Sami
