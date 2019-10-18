Return-Path: <SRS0=isdz=YL=lists.openwall.com=kernel-hardening-return-17053-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5403DCA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:55:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A04F121835
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:55:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vsQmN/Ap"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A04F121835
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17053-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13753 invoked by uid 550); 18 Oct 2019 17:54:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26540 invoked from network); 18 Oct 2019 17:19:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0HIzf5D0wGbvpmxHvIyOvn+49UWE2lHPyTZCg3y02sw=;
        b=vsQmN/ApjkODa5g1BT612x/4GGL20gZVZE8EGaFhwsXbdCcFD/fycGlyho4gxOJTFH
         UNt9ub/I4P/h809X5D4yAx7rCwQfs1BEVFWXiVYtxsoUMxjlzIEJPcfVyB8tF344B2aC
         FjFd1SH8THaH/Pw81yxXP9FQn01T7I+/YsrNyL9mssL2T1CuwuFiQluKl0/fFUrg4HLq
         GlWt1dVIFhyf7eCqu7QIp5RVLWS2ZUOsoD7wzE3W1jtwUAY4NHDTbaS0+XPgu0S1K6/l
         VhJ5hk4oAgFzg9fAGqgifT4d4FsvndIJvJc42Q3EHtKExcLFN4z8Qliw6bt6wkdvd8lR
         FnJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0HIzf5D0wGbvpmxHvIyOvn+49UWE2lHPyTZCg3y02sw=;
        b=ZNKranOj1EHzul61xMHbomJ6+ZtPZVZEWzs971jMNZLGX4wBJZclEP9FoBRGqsFNwj
         T0wHt95xiq7Z16Qwl8rAhfArMAl1MHhVD+9aTmObiB+Qol6jnk5u2myXQHI4eh3gVXoO
         hfvnARsTskZYF5SgGGDUc0DyXFTJFG3Rqe3SJ1VQXBwYmjayEw+jb12TAEzqWk5pCmJR
         Ped3IT0g15SXoN8PwcrmMMuctOzKOJ2hTXGMq5mUktgzNsp1iyypKWs0ZIAOyOZ2on3n
         e5uHi8xn3oHEM3YFAXRVxGDGlDRukJ2qRBSy2BxgnveZGT+qGhh7l6w9PWsMl4HgKwPo
         Getg==
X-Gm-Message-State: APjAAAV7nq0/yH67ZbeqBAsnAkvBnzH9u2xOefy/mAMzVA6DncM39lo2
	8vnVcu50F4Be0Vd5pih8yKCxaZ2ZhoVS+xVGpfPFYw==
X-Google-Smtp-Source: APXvYqz95u8SOpZ8CKpbA/DJiP9eST+uXrcgaIItAAur7JD+mN8MzKVC12sI0+N58LUhcO4C5kYwuTsqYm/TbJd/HRQ=
X-Received: by 2002:ab0:6387:: with SMTP id y7mr6108565uao.110.1571419131321;
 Fri, 18 Oct 2019 10:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-19-samitolvanen@google.com> <CAG48ez2Z8=0__eoQ+Ekp=EApawZXR4ec_xd2TVPQExLoyMwtRQ@mail.gmail.com>
In-Reply-To: <CAG48ez2Z8=0__eoQ+Ekp=EApawZXR4ec_xd2TVPQExLoyMwtRQ@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 18 Oct 2019 10:18:40 -0700
Message-ID: <CABCJKudM-Jupwj9eMMjg3rb1=6rTDBEcWi-KkzPSeSGd8tSxGg@mail.gmail.com>
Subject: Re: [PATCH 18/18] arm64: implement Shadow Call Stack
To: Jann Horn <jannh@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 10:13 AM Jann Horn <jannh@google.com> wrote:
> These things should probably be __always_inline or something like
> that? If the compiler decides not to inline them (e.g. when called
> from scs_thread_switch()), stuff will blow up, right?

Correct. I'll change these to __always_inline in v2. I think there
might be other places in the kernel where not inlining a static inline
function would break things, but there's no need to add more.

> This is different from the intended protection level according to
> <https://clang.llvm.org/docs/ShadowCallStack.html#security>, which
> talks about "a runtime that avoids exposing the address of the shadow
> call stack to attackers that can read arbitrary memory". Of course,
> that's extremely hard to implement in the context of the kernel, where
> you can see all the memory management data structures and all physical
> memory.

Yes, the security guarantees in the kernel are different as hiding
shadow stack pointers is more challenging.

> You might want to write something in the cover letter about what the
> benefits of this mechanism compared to STACKPROTECTOR are in the
> context of the kernel, including a specific description of which types
> of attacker capabilities this is supposed to defend against.

Sure, I'll add something about that in v2. Thanks.

Sami
