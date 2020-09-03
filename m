Return-Path: <SRS0=9pbe=CM=lists.openwall.com=kernel-hardening-return-19748-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAA3C43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:45:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8A207206D4
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="O5o59mUd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A207206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19748-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32609 invoked by uid 550); 3 Sep 2020 21:44:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32577 invoked from network); 3 Sep 2020 21:44:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wkni4eXx9E7Yx63VN0+vnviLhaoHNM+yB8xZjp7w5hM=;
        b=O5o59mUdRprA27/bBNjMETG5FChmb/k7jW6G/CEqPxqkNExuhCDFNEGkwkwsAAOk9B
         S/ND1TkN2Kb21Yt+dermQ1eJzMamhppfZcA/5BLAHvK0xooF6lH1S7/GgEK+o+mFn5sC
         Q+9Q6xNOHekU+wFfZY8e2e5GVn6y3TV0ytjI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wkni4eXx9E7Yx63VN0+vnviLhaoHNM+yB8xZjp7w5hM=;
        b=TQZkQDP4wSOJOLQShZ6LpCqNgF/MZB5FBH5V7qV2JIl6OWvhYRytprPd5XJsjm5D6V
         1Hw2N2EwIkxlxrWjywLtW+dxpeu9n1lWWcHS2GDje500I5yJyq+gTc65JYSpetaFKwue
         1d8ORDGUu92vkMVBUurZFa7/11Y5qaU2XlSLFOPtN+kX6El5bAUSZtElFjGPpIG7PYUU
         /rz+1Dtl29niXQzxY5EZQOZKjYYZ67/gVcV61s3ELxHPrYsnpGyqhTA43boUDjZ/Ii2R
         x8S6mc+1d2PziFR0X8iNkaY3YTqmR3ORndfJSFdhr9q69KxkKAveVvEhfEGb46TsOZuo
         pAIg==
X-Gm-Message-State: AOAM530v9HDoce7PxmAZLx+IGmdYTTtxBgAvhUBGxK7gRU9EhfLoX9bv
	nhYrsdbUG0lRFYMa7QYXiu0Smg==
X-Google-Smtp-Source: ABdhPJzAv2fIwHx5fjsh6FyQ4DUXacQqnpd1HrcO3mYGfEva7Q9zQka0PVlCAE3Ap8Ww7DWt19mfFg==
X-Received: by 2002:a62:1809:: with SMTP id 9mr5726960pfy.217.1599169483379;
        Thu, 03 Sep 2020 14:44:43 -0700 (PDT)
Date: Thu, 3 Sep 2020 14:44:41 -0700
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
Subject: Re: [PATCH v2 01/28] x86/boot/compressed: Disable relocation
 relaxation
Message-ID: <202009031444.F2ECA89E@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-2-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-2-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:26PM -0700, Sami Tolvanen wrote:
> From: Arvind Sankar <nivedita@alum.mit.edu>
> 
> The x86-64 psABI [0] specifies special relocation types
> (R_X86_64_[REX_]GOTPCRELX) for indirection through the Global Offset
> Table, semantically equivalent to R_X86_64_GOTPCREL, which the linker
> can take advantage of for optimization (relaxation) at link time. This
> is supported by LLD and binutils versions 2.26 onwards.
> 
> The compressed kernel is position-independent code, however, when using
> LLD or binutils versions before 2.27, it must be linked without the -pie
> option. In this case, the linker may optimize certain instructions into
> a non-position-independent form, by converting foo@GOTPCREL(%rip) to $foo.
> 
> This potential issue has been present with LLD and binutils-2.26 for a
> long time, but it has never manifested itself before now:
> - LLD and binutils-2.26 only relax
> 	movq	foo@GOTPCREL(%rip), %reg
>   to
> 	leaq	foo(%rip), %reg
>   which is still position-independent, rather than
> 	mov	$foo, %reg
>   which is permitted by the psABI when -pie is not enabled.
> - gcc happens to only generate GOTPCREL relocations on mov instructions.
> - clang does generate GOTPCREL relocations on non-mov instructions, but
>   when building the compressed kernel, it uses its integrated assembler
>   (due to the redefinition of KBUILD_CFLAGS dropping -no-integrated-as),
>   which has so far defaulted to not generating the GOTPCRELX
>   relocations.
> 
> Nick Desaulniers reports [1,2]:
>   A recent change [3] to a default value of configuration variable
>   (ENABLE_X86_RELAX_RELOCATIONS OFF -> ON) in LLVM now causes Clang's
>   integrated assembler to emit R_X86_64_GOTPCRELX/R_X86_64_REX_GOTPCRELX
>   relocations. LLD will relax instructions with these relocations based
>   on whether the image is being linked as position independent or not.
>   When not, then LLD will relax these instructions to use absolute
>   addressing mode (R_RELAX_GOT_PC_NOPIC). This causes kernels built with
>   Clang and linked with LLD to fail to boot.
> 
> Patch series [4] is a solution to allow the compressed kernel to be
> linked with -pie unconditionally, but even if merged is unlikely to be
> backported. As a simple solution that can be applied to stable as well,
> prevent the assembler from generating the relaxed relocation types using
> the -mrelax-relocations=no option. For ease of backporting, do this
> unconditionally.
> 
> [0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
> [1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
> [2] https://github.com/ClangBuiltLinux/linux/issues/1121
> [3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
> [4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/
> 
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
