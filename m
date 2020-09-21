Return-Path: <SRS0=OMcC=C6=lists.openwall.com=kernel-hardening-return-19954-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA64BC43466
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Sep 2020 15:54:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B1FFB22574
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Sep 2020 15:54:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wS3DJbGh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1FFB22574
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19954-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9630 invoked by uid 550); 21 Sep 2020 15:54:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9592 invoked from network); 21 Sep 2020 15:54:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fn5z5p0KWkT8F7kdqXLtUSD00/eNhULjEnaQyt7HO3c=;
        b=wS3DJbGh/toEWGHMWfIYAyfl62a2xPnkTm7cNhPym3mzQxK28qL+kZCrSZggBSROXa
         NIIsRsLPprRNfrNxq/O7SgGIAQv+11RPoBUmYfVay0H+wQrvpSFqZGCCwczoE0PI3NwM
         BajK6bGuvdWSOxCULPkkElyJinqDQbfrg3BX4qxe0nSoLtxoqCUZ4DYY8jlgM9XNnsxV
         m952IZLwDFx/YDBae5MI6BosCFQlIVPnADU67SRlbPRPa3XZPP99q/tE/mqTrWmaFUGB
         Cr7PUOGoUwpYEL9jPXyQWHhnShzEybRi2A7whxiV331Jx4G8BVdc/1kDmDMbH8AHeYn9
         IaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fn5z5p0KWkT8F7kdqXLtUSD00/eNhULjEnaQyt7HO3c=;
        b=SETKaZGsVTI0oHYWTFE6Wtlt2VQIeoO/7oMayLX9N6vwcvo73UsYnRq7of0FwT+sOK
         YTWQE+SGQHUNze67HL/zr0AVOwVjkRo8AQ2Q6HMMEAq6+XP+N0g6AlAN8MIRUwRsVtF3
         PqsOXVVi1it5uK8qKNbMFIVNbH2SdN6QIdzUCMREixKQS0HWrHn/buUol58I80PA+LLh
         u8sl4TyR+mvwThvj19/+9+w9IKW+cPHDI0NY6eAPcZIPE2+8OKRmB5fSu65S+EXqaaIm
         Lj5ZTxPfD/LjmJsqnxZHUvJ+2RONzuNb9g7qNECZhaNH59JgbPvMyO8NkAapo5kBymyZ
         ZdeQ==
X-Gm-Message-State: AOAM531ts9SVpxn6USewoLdaMe/lTyJn+5OKnkNi80H3oq1Li5VC2zxu
	5wOU2wS5HUFfou9CjroLaR/sa0SrPgJPCSbmsPyEyw==
X-Google-Smtp-Source: ABdhPJxEx7C1NCFiroHZ1htfv1qkh42nY8oGzcnOH06wOhFq2SsYUT8w4mdvW5J7C4BtXsEWH+72M+TnlFjXmM5sSRs=
X-Received: by 2002:a17:90b:889:: with SMTP id bj9mr28426pjb.101.1600703630255;
 Mon, 21 Sep 2020 08:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com> <20200918201436.2932360-4-samitolvanen@google.com>
In-Reply-To: <20200918201436.2932360-4-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 21 Sep 2020 08:53:39 -0700
Message-ID: <CAKwvOdk7pR5dK0ynxPOWHVYVWLMF1CUn6c=_GvpF-80YHNhQEQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/30] x86/boot/compressed: Disable relocation relaxation
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, Arvind Sankar <nivedita@alum.mit.edu>
Content-Type: text/plain; charset="UTF-8"

It looks like this just hit mainline over the weekend. FWIW. EOM.

On Fri, Sep 18, 2020 at 1:14 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
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
>         movq    foo@GOTPCREL(%rip), %reg
>   to
>         leaq    foo(%rip), %reg
>   which is still position-independent, rather than
>         mov     $foo, %reg
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
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Cc: stable@vger.kernel.org
> ---
>  arch/x86/boot/compressed/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 3962f592633d..ff7894f39e0e 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -43,6 +43,8 @@ KBUILD_CFLAGS += -Wno-pointer-sign
>  KBUILD_CFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
>  KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
>  KBUILD_CFLAGS += -D__DISABLE_EXPORTS
> +# Disable relocation relaxation in case the link is not PIE.
> +KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mrelax-relocations=no)
>
>  KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
>  GCOV_PROFILE := n
> --
> 2.28.0.681.g6f77f65b4e-goog
>


-- 
Thanks,
~Nick Desaulniers
