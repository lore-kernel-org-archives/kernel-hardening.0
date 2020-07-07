Return-Path: <SRS0=iddh=AS=lists.openwall.com=kernel-hardening-return-19225-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54740C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 16:05:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A39F220738
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Jul 2020 16:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kh7nComz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A39F220738
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19225-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5802 invoked by uid 550); 7 Jul 2020 16:05:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5770 invoked from network); 7 Jul 2020 16:05:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BauIxngYcl8jd5OtL8hzkCrhdMv4YPyYU2tM2gh0/zA=;
        b=Kh7nComzMNl6xsg1nwO6fTiV+447hKNoK6M36Sv6NGey7FnS2nbTYWy8lHEpSDOcWo
         4SZpHdhE0vPOCZrLWLvUJOXmOSR8Gz0owQI+bbcY+s+LsNbCgXfdxmGINNOc3+OKJSEQ
         2u6uTR/n4oEx4IA4WPkbLFvCRTsqJQgdkA4/RHz0JUrD5DCmtPUS6lEOlEKwOu+XAqvh
         gr91UwjGRhE2Bo40UIkl4Z5vIAwl8OKTz32MsAM4e2vgnAlsinZ/e9QSyBdyERrQzk4E
         y2Omj76am6hjUTfQD5hz2Tiyvs2LsHeHNRlGxwsexsoYrijIaIiXs/D6btrWCA81JdA6
         s9vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BauIxngYcl8jd5OtL8hzkCrhdMv4YPyYU2tM2gh0/zA=;
        b=TQLhLesu7UXcxR1pm25Zgns1ehSJdIgUHYyRvSz7J/3OXvs1Hix3QfKqAXi9iAYjQe
         mPllQLj4NUXsI1lxtkr68xe41FU+hzmxrQggqf3zdaMjbLYKJO9gBO6NHYoHdJO0wDli
         4/2OLn6kcqWI80K9z+027JrLl1JMbSqp7Gy+4lQ6URjdrVNZqTdojdlHh82vP9kSgaOA
         l71eYagRBii8OXY6wI20LKG5jPBw2z27amjWfSUOSFbj2hVOUFwuL1C33RDjSjzJP7lo
         nslc9uE/DswJ4t228b1zM94fs9zBF2sVXsNo0WKpx4W59d89eZjaeWMSoEHvNoFfuCs5
         DmRg==
X-Gm-Message-State: AOAM532jPVXgqxd2DD6WGPnGUGUPsXTrtJVCAI2GeGq6eSFZwFzokmtd
	1+L0rtIw/TTKVbU/auwS4bHn7Q==
X-Google-Smtp-Source: ABdhPJzJoQVw/SVeuV11W977gCqEtq+6LHotqK+2sy2PsCIQUHIzgnZiA2b8Kfx/70bokWXpdDZzGg==
X-Received: by 2002:a63:5110:: with SMTP id f16mr44344138pgb.377.1594137935802;
        Tue, 07 Jul 2020 09:05:35 -0700 (PDT)
Date: Tue, 7 Jul 2020 09:05:28 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200707160528.GA1300535@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com>
 <20200629232059.GA3787278@google.com>
 <20200707155107.GA3357035@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707155107.GA3357035@google.com>

On Tue, Jul 07, 2020 at 08:51:07AM -0700, Sami Tolvanen wrote:
> After spending some time debugging this with Nick, it looks like the
> error is caused by a recent optimization change in LLVM, which together
> with the inlining of ur_load_imm_any into jeq_imm, changes a runtime
> check in FIELD_FIT that would always fail, to a compile-time check that
> breaks the build. In jeq_imm, we have:
> 
>     /* struct bpf_insn: _s32 imm */
>     u64 imm = insn->imm; /* sign extend */
>     ...
>     if (imm >> 32) { /* non-zero only if insn->imm is negative */
>     	/* inlined from ur_load_imm_any */
> 	u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
> 
>         /*
> 	 * __imm has a value known at compile-time, which means
> 	 * __builtin_constant_p(__imm) is true and we end up with
> 	 * essentially this in __BF_FIELD_CHECK:
> 	 */
> 	if (__builtin_constant_p(__imm) && __imm <= 255)

Should be __imm > 255, of course, which means the compiler will generate
a call to __compiletime_assert.

> Jiong, Jakub, do you see any issues here?

(Jiong's email bounced, so removing from the recipient list.)

Sami
