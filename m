Return-Path: <SRS0=9Pq8=E2=lists.openwall.com=kernel-hardening-return-20434-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2A9C2D0E4
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:25:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 82152206FB
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 20:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nQ48JfzX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82152206FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20434-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30694 invoked by uid 550); 20 Nov 2020 20:25:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30672 invoked from network); 20 Nov 2020 20:25:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=984nJeLydsE3/GDg3HBO6Z6L/1lt0gFfqkKrV/lzSfk=;
        b=nQ48JfzXRyNDknHGCh3KFKjURhf06zzRND+V/pJL/fMRQP6lLOU4+KjKu6MWYvNGLA
         u/GGSVGE3kgxtbIMz5PxE83KRGKSZySAWIrCVeitIKgVg4oGgHd7hM0MclX/o0xA6iM7
         0TjfjF8WKDBiTvlY0PE7KxWfiT12N620kb+jYUJpJQnbHzG2Y3yDy80EStVPPkzsPuX8
         bdbm2U6exJndNtMvOE62BvjnmwhCNTdLYsvSFa7Pnlfa76FT693PoaC9m6in5Jl5pjA+
         pLXxKB786iLdW3LX7Ve2TlFLslpMT2/zDAEyjn27o3Ofet4vrVt0LEU4XrMBd4DoJ1cH
         vg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=984nJeLydsE3/GDg3HBO6Z6L/1lt0gFfqkKrV/lzSfk=;
        b=fu+V8Z5JOxtvdhh8FTqFJCo4gKWc7K+GVH9SLwyrdtuIKIBGSrVSEy/wP/sTKW/dPH
         pNcijq7v6v11NY3XuKDWBy5THwODf7UR1FjPG3u7iQNhabcRmtQBc4Y+5sONB2pa845l
         P2pqkddPEayqwb78HqjtJXXONt9wTBiUFSnVifwFcRHI73xmLuxbdo6+SFzrZ0nrrQon
         SytZgvkosQfCfXmTny5Xi7tpS2kcJ4VZOUfi3qqHoqhFJVNpAfKy+n/LS2kSVk4T8I2y
         3H164aEsCjwlU2qIQtAvOkfjNpXWbHxrZQ/CPA2XG8OqJO3c/7AJBqJOF+DarVdqJjMJ
         0HMw==
X-Gm-Message-State: AOAM530c7mwh/Hzi1BKw8pDgzuCeZFuUjtylUoluFhnaUeFuEmKamEPU
	LxOa8PTesgd6ybWT8JrGyvKCFKvZNuTqtErT4dPBjQ==
X-Google-Smtp-Source: ABdhPJxCT20kCKg82r2GF6byyQKxIJWZrkcRHsjZAfiHsHplg/RwP3f21qH6ZHRA+utWdlmz3m8dxOiRg7Ud36B+6lo=
X-Received: by 2002:a9f:2595:: with SMTP id 21mr10567817uaf.33.1605903921022;
 Fri, 20 Nov 2020 12:25:21 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com> <20201120040424.a3wctajzft4ufoiw@treble>
In-Reply-To: <20201120040424.a3wctajzft4ufoiw@treble>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 20 Nov 2020 12:25:09 -0800
Message-ID: <CABCJKueTjhjSY=oOD3bWqn7E_1X9k-MK+6r_Z35AiCKDTNK18g@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Nov 19, 2020 at 8:04 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Wed, Nov 18, 2020 at 02:07:14PM -0800, Sami Tolvanen wrote:
> > This patch series adds support for building the kernel with Clang's
> > Link Time Optimization (LTO). In addition to performance, the primary
> > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> > be used in the kernel. Google has shipped millions of Pixel devices
> > running three major kernel versions with LTO+CFI since 2018.
> >
> > Most of the patches are build system changes for handling LLVM bitcode,
> > which Clang produces with LTO instead of ELF object files, postponing
> > ELF processing until a later stage, and ensuring initcall ordering.
> >
> > Note that v7 brings back arm64 support as Will has now staged the
> > prerequisite memory ordering patches [1], and drops x86_64 while we work
> > on fixing the remaining objtool warnings [2].
>
> Sami,
>
> Here are some patches to fix the objtool issues (other than crypto which
> I'll work on next).
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objtool-vmlinux

Thanks, Josh! I can confirm that these fix all the non-crypto objtool
warnings with LTO as well.

Sami
