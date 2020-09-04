Return-Path: <SRS0=uWqG=CN=lists.openwall.com=kernel-hardening-return-19782-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A85C433E2
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 07:54:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0500220748
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 07:54:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nq2T1guw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0500220748
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19782-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30537 invoked by uid 550); 4 Sep 2020 07:54:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30502 invoked from network); 4 Sep 2020 07:54:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ocqyzNbaVOZzIdeNzDcK80VX4YtlWAaQQv8brVA+uok=;
        b=Nq2T1guwkVW6AjrlGB9fPWghdM0XIdzmNU+vWvRDonxY/2F48APQtj4A9ML40oPSWE
         gNy8jSSGdU/uh49Nuan13e7J01chRakHa4cvFV++kD5GeMvnRK1PDFvkGNc11TFwom7Y
         X9gk1f6AN8nHnX/8jO+ovjwlYDnt3SAXJthIpS7uYfZmc8twAz/gjOTHw685POv0Jv7t
         oLDono45aa0F3e/AIav+77dHNgpenH801GxKxi70IabKBrJOGTmp5Z8C8a62JfBwA/NG
         vIKTVveaTADqVm296iwl2bKAzCQxo7MrtbLxsNRjrVkJS+tWusn1LVp3UFBKfFzXbACg
         fq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ocqyzNbaVOZzIdeNzDcK80VX4YtlWAaQQv8brVA+uok=;
        b=jajzeqAoIWV5IRz0ETXcg+VLQ3FDFj9qaTPxKvxCbltcTBaEBBYnyn8nEWEBlgvLnk
         S3PO1vntXUbBAfPsh6NjVpkCUySMxeXnXe5w931BJSjpKKtxEqqLwoxQ52+62hmQT4nA
         qaSFMpbjUbF/nYDxaaIFrF/vNtLEznSozP2BdJSeFXI6Caw3AaxeMkBExPiVxx004NWA
         byGFwqZNzGIHzcyV9EAqvRAXbPw7K7M+3IkvOnOXocziZstvV6ODfRofAZpqnaUsQ1+m
         2LpFNNZNWY3s/7GlIYsZEa20k3/A0mxoGm5DqhjIkQ+Xsa8NSp8xUfOgG/BXDO32YBvM
         i4kA==
X-Gm-Message-State: AOAM532j76hC2DC6c4cryg0BKUEb8gak4i9SiBPlC/2Eqy1QZZjURLYo
	Lrm+Omz9a6w7pSsfkbxz28gm7BrAvkMO8DAl5Fk=
X-Google-Smtp-Source: ABdhPJx8Fu6Q8WDEpmADLpI04M/+EN/6EVFvaEQovvgjSVbHG1rjYRSusAY1dEH9lP0YugsHKl4rs5v2AOHao6YXKcg=
X-Received: by 2002:a9d:7656:: with SMTP id o22mr4302332otl.109.1599206029992;
 Fri, 04 Sep 2020 00:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Fri, 4 Sep 2020 09:53:38 +0200
Message-ID: <CA+icZUW_=L5n4gAPV_sL+TaLJ0SMZOWHSNOpWD9M3fSLDCv_kw@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 3, 2020 at 10:30 PM 'Sami Tolvanen' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> This patch series adds support for building x86_64 and arm64 kernels
> with Clang's Link Time Optimization (LTO).
>
> In addition to performance, the primary motivation for LTO is
> to allow Clang's Control-Flow Integrity (CFI) to be used in the
> kernel. Google has shipped millions of Pixel devices running three
> major kernel versions with LTO+CFI since 2018.
>
> Most of the patches are build system changes for handling LLVM
> bitcode, which Clang produces with LTO instead of ELF object files,
> postponing ELF processing until a later stage, and ensuring initcall
> ordering.
>
> Note that patches 1-4 are not directly related to LTO, but are
> needed to compile LTO kernels with ToT Clang, so I'm including them
> in the series for your convenience:
>
>  - Patches 1-3 are required for building the kernel with ToT Clang,
>    and IAS, and patch 4 is needed to build allmodconfig with LTO.
>
>  - Patches 3-4 are already in linux-next, but not yet in 5.9-rc.
>

I jumped to Sami's clang-cfi Git tree which includes clang-lto v2.

My LLVM toolchain is version 11.0.0.0-rc2+ more precisely git
97ac9e82002d6b12831ca2c78f739cca65a4fa05.

If this is OK, feel free to add my...

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -

[1] https://github.com/samitolvanen/linux/commits/clang-cfi

> ---
> Changes in v2:
>
>   - Fixed -Wmissing-prototypes warnings with W=1.
>
>   - Dropped cc-option from -fsplit-lto-unit and added .thinlto-cache
>     scrubbing to make distclean.
>
>   - Added a comment about Clang >=11 being required.
>
>   - Added a patch to disable LTO for the arm64 KVM nVHE code.
>
>   - Disabled objtool's noinstr validation with LTO unless enabled.
>
>   - Included Peter's proposed objtool mcount patch in the series
>     and replaced recordmcount with the objtool pass to avoid
>     whitelisting relocations that are not calls.
>
>   - Updated several commit messages with better explanations.
>
>
> Arvind Sankar (2):
>   x86/boot/compressed: Disable relocation relaxation
>   x86/asm: Replace __force_order with memory clobber
>
> Luca Stefani (1):
>   RAS/CEC: Fix cec_init() prototype
>
> Nick Desaulniers (1):
>   lib/string.c: implement stpcpy
>
> Peter Zijlstra (1):
>   objtool: Add a pass for generating __mcount_loc
>
> Sami Tolvanen (23):
>   objtool: Don't autodetect vmlinux.o
>   kbuild: add support for objtool mcount
>   x86, build: use objtool mcount
>   kbuild: add support for Clang LTO
>   kbuild: lto: fix module versioning
>   kbuild: lto: postpone objtool
>   kbuild: lto: limit inlining
>   kbuild: lto: merge module sections
>   kbuild: lto: remove duplicate dependencies from .mod files
>   init: lto: ensure initcall ordering
>   init: lto: fix PREL32 relocations
>   PCI: Fix PREL32 relocations for LTO
>   modpost: lto: strip .lto from module names
>   scripts/mod: disable LTO for empty.c
>   efi/libstub: disable LTO
>   drivers/misc/lkdtm: disable LTO for rodata.o
>   arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
>   arm64: vdso: disable LTO
>   KVM: arm64: disable LTO for the nVHE directory
>   arm64: allow LTO_CLANG and THINLTO to be selected
>   x86, vdso: disable LTO only for vDSO
>   x86, relocs: Ignore L4_PAGE_OFFSET relocations
>   x86, build: allow LTO_CLANG and THINLTO to be selected
>
>  .gitignore                            |   1 +
>  Makefile                              |  65 ++++++-
>  arch/Kconfig                          |  67 +++++++
>  arch/arm64/Kconfig                    |   2 +
>  arch/arm64/Makefile                   |   1 +
>  arch/arm64/kernel/vdso/Makefile       |   4 +-
>  arch/arm64/kvm/hyp/nvhe/Makefile      |   4 +-
>  arch/x86/Kconfig                      |   3 +
>  arch/x86/Makefile                     |   5 +
>  arch/x86/boot/compressed/Makefile     |   2 +
>  arch/x86/boot/compressed/pgtable_64.c |   9 -
>  arch/x86/entry/vdso/Makefile          |   5 +-
>  arch/x86/include/asm/special_insns.h  |  28 +--
>  arch/x86/kernel/cpu/common.c          |   4 +-
>  arch/x86/tools/relocs.c               |   1 +
>  drivers/firmware/efi/libstub/Makefile |   2 +
>  drivers/misc/lkdtm/Makefile           |   1 +
>  drivers/ras/cec.c                     |   9 +-
>  include/asm-generic/vmlinux.lds.h     |  11 +-
>  include/linux/init.h                  |  79 +++++++-
>  include/linux/pci.h                   |  19 +-
>  kernel/trace/Kconfig                  |   5 +
>  lib/string.c                          |  24 +++
>  scripts/Makefile.build                |  55 +++++-
>  scripts/Makefile.lib                  |   6 +-
>  scripts/Makefile.modfinal             |  31 ++-
>  scripts/Makefile.modpost              |  26 ++-
>  scripts/generate_initcall_order.pl    | 270 ++++++++++++++++++++++++++
>  scripts/link-vmlinux.sh               |  94 ++++++++-
>  scripts/mod/Makefile                  |   1 +
>  scripts/mod/modpost.c                 |  16 +-
>  scripts/mod/modpost.h                 |   9 +
>  scripts/mod/sumversion.c              |   6 +-
>  scripts/module-lto.lds                |  26 +++
>  tools/objtool/builtin-check.c         |  13 +-
>  tools/objtool/builtin.h               |   2 +-
>  tools/objtool/check.c                 |  83 ++++++++
>  tools/objtool/check.h                 |   1 +
>  tools/objtool/objtool.h               |   1 +
>  39 files changed, 883 insertions(+), 108 deletions(-)
>  create mode 100755 scripts/generate_initcall_order.pl
>  create mode 100644 scripts/module-lto.lds
>
>
> base-commit: e28f0104343d0c132fa37f479870c9e43355fee4
> --
> 2.28.0.402.g5ffc5be6b7-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200903203053.3411268-1-samitolvanen%40google.com.
