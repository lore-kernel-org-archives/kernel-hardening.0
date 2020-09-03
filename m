Return-Path: <SRS0=Y3n+=CM=lists.openwall.com=kernel-hardening-return-19749-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99ED4C43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:46:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D5F0520658
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EFlB8L34"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5F0520658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19749-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1801 invoked by uid 550); 3 Sep 2020 21:46:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1769 invoked from network); 3 Sep 2020 21:46:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=88UAUo6RYF27MUEaYZE9R7HTuO6mGUyasahfv8EZhB8=;
        b=EFlB8L3484X2NUQ2w9kQvBk3L+1RDvCzNz+1QFX1Nm3dCNte5YHScmXG1pqmo0J2+E
         C6Clco3P/dWY6iT/m+OtQJLLVltMdhY68a4RYVvEYy7d7wz05uOxuTBRrPhAf9vZulwq
         OT1t8R0KPmtqqUOLIMHdbCPWYgvYCgeGDAsFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=88UAUo6RYF27MUEaYZE9R7HTuO6mGUyasahfv8EZhB8=;
        b=twiBo//X3NDqrN+GnyfAP2YuYEppvXDZ/8XsV0FYLv+RDf+dOcVZVvwjaaGK1mjpKZ
         rUDrsDyIRzlrupaC4pQLTsPgMOFdSG9ZT+nlN6ainE6qszZ+Emwb0a+6pZlmTqr7LpCw
         45Y0T5RVyntgQvHXcpt2KU3SX9Cg7gOM8MvGYOOF8vJn91Fc0b7ojRt10ZgSp0Jl1OhR
         8S1+p82dlp43pUmyZTLzN7e/AI6T83IRCkKwEjh7GZFLCPAPBe72IPMGSYs9Hp/4coFd
         W5pcDMchOPugqISlVK5+a4vfk2dDRKyc/VC2Jv2xukfRyLanxSHLJFOiRynyxOYm6P5p
         hv3g==
X-Gm-Message-State: AOAM532jtiUPvNtm1fSd+4geRa2+gY/DPVNQPbsoJ1VX7fPIeAABICAp
	QqhsDx/UZ63sbaG2RILtrHY0Tg==
X-Google-Smtp-Source: ABdhPJyg0lgZlgBi8/Irq6grlvy58EaMpaSg/pdagWK+0tWzLnV3KOczUO8JKY6Ln9M1KxRZgEWLVw==
X-Received: by 2002:a17:902:7b83:: with SMTP id w3mr6022860pll.28.1599169555661;
        Thu, 03 Sep 2020 14:45:55 -0700 (PDT)
Date: Thu, 3 Sep 2020 14:45:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 02/28] x86/asm: Replace __force_order with memory
 clobber
Message-ID: <202009031445.807B55E@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-3-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-3-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:27PM -0700, Sami Tolvanen wrote:
> From: Arvind Sankar <nivedita@alum.mit.edu>
> 
> The CRn accessor functions use __force_order as a dummy operand to
> prevent the compiler from reordering CRn reads/writes with respect to
> each other.
> 
> The fact that the asm is volatile should be enough to prevent this:
> volatile asm statements should be executed in program order. However GCC
> 4.9.x and 5.x have a bug that might result in reordering. This was fixed
> in 8.1, 7.3 and 6.5. Versions prior to these, including 5.x and 4.9.x,
> may reorder volatile asm statements with respect to each other.
> 
> There are some issues with __force_order as implemented:
> - It is used only as an input operand for the write functions, and hence
>   doesn't do anything additional to prevent reordering writes.
> - It allows memory accesses to be cached/reordered across write
>   functions, but CRn writes affect the semantics of memory accesses, so
>   this could be dangerous.
> - __force_order is not actually defined in the kernel proper, but the
>   LLVM toolchain can in some cases require a definition: LLVM (as well
>   as GCC 4.9) requires it for PIE code, which is why the compressed
>   kernel has a definition, but also the clang integrated assembler may
>   consider the address of __force_order to be significant, resulting in
>   a reference that requires a definition.
> 
> Fix this by:
> - Using a memory clobber for the write functions to additionally prevent
>   caching/reordering memory accesses across CRn writes.
> - Using a dummy input operand with an arbitrary constant address for the
>   read functions, instead of a global variable. This will prevent reads
>   from being reordered across writes, while allowing memory loads to be
>   cached/reordered across CRn reads, which should be safe.
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

In the primary thread for this patch I sent a Reviewed tag, but for good
measure, here it is again:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
