Return-Path: <SRS0=xp24=DQ=lists.openwall.com=kernel-hardening-return-20161-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8334C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:30:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B29A82227F
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Oct 2020 16:30:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hEJDk5aB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B29A82227F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20161-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17948 invoked by uid 550); 9 Oct 2020 16:30:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17910 invoked from network); 9 Oct 2020 16:30:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=2Gc2VbZdU1IXiw57R85Qt4LavpkHTDXOYsNp+15DYcg=;
        b=hEJDk5aBM0OyqBiz/S2cVXzsuVix3FYn+kcS8O/nMkNrXwfPu3otjRaoP9O72rYi1n
         VjYgucLsJp3Z0hR/a2uaU9ns3nc7w4a7XUDetwg855x7SSC1DCcnd4EuUhQ8JwrBIpux
         s5MK022NgE0jxmvV9srK5hu5hnQSALf/i/ahx+83zw85cza0K01ntWXWSsjiEWgsaL+F
         LCVUVda2u45vCa63xSh7XUKzTMLwA/RY9xZ7HLgC18IHAvuO7h7GmXOuV1rPbw01inLF
         75zwGqlQi0C/qZRRfmtw3sj/uucK+NkR6M9+b6Grz2pok1SOVBvXn5qCWkT6jYv5rCc3
         qTSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=2Gc2VbZdU1IXiw57R85Qt4LavpkHTDXOYsNp+15DYcg=;
        b=e+qSVsHCUgk06uWiDH4wKj72nG9OGrHVf3kRdwdmBICLkQrbumri9+YrwaXaEnHfIK
         A+tQV3EljlFUCHrQPUY1jAR1RjhL3/I9l460Er54bD3r54JUkqNl3fLMU77AQvzWJ4iG
         pluMbbSXRQ/8hHhKUgDKcflXogzKLz9Bd82fDRtJ0tPjUbHsc8QZS3hsZ4R7mfvXTTn+
         m1HiVsfAtMGXQdjrSanpCFuoUQUwUbu9+/pH5lOcT5a+5pjxtea3KwU1Fso5D0OqGDC8
         JwuDacJQEb/4Y0fDm7ALR2bUmjeXBFh1yp+qyAk/Pb8Sfd0elqunY41NF5wnziVcolAV
         5dLg==
X-Gm-Message-State: AOAM532DPMiXnJcEfGiw2cXUlXCuSlSNIM4OFYL5WTBP/9V8nqdbZJOx
	KKK1VL8WgDxHvajA00jxqQyP0BbeFwmNzxAYkBU=
X-Google-Smtp-Source: ABdhPJwBFeZdsljqopYTCCei86vRF8PIXqbXb7fERVj0i5Cq3wzs1MXDtB1itEnSoiXD6rCUYCsGvFHBayZUFIR0ZXw=
X-Received: by 2002:a92:7f05:: with SMTP id a5mr11486123ild.112.1602261037165;
 Fri, 09 Oct 2020 09:30:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Fri, 9 Oct 2020 18:30:24 +0200
Message-ID: <CA+icZUVWdRWfhPhPy79Hpjmqbfw+n8xsgMKv_RU+hoh1bphXdg@mail.gmail.com>
Subject: Re: [PATCH v5 00/29] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 9, 2020 at 6:13 PM 'Sami Tolvanen' via Clang Built Linux
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
> Note that this version is based on tip/master to reduce the number
> of prerequisite patches, and to make it easier to manage changes to
> objtool. Patch 1 is from Masahiro's kbuild tree, and while it's not
> directly related to LTO, it makes the module linker script changes
> cleaner.
>
> Furthermore, patches 2-6 include Peter's patch for generating
> __mcount_loc with objtool, and build system changes to enable it on
> x86. With these patches, we no longer need to annotate functions
> that have non-call references to __fentry__ with LTO, which greatly
> simplifies supporting dynamic ftrace.
>
> You can also pull this series from
>
>   https://github.com/samitolvanen/linux.git lto-v5
>
> ---
> Changes in v5:
>
>   - Rebased on top of tip/master.
>

What are the plans to get this into mainline?
Linux v5.10 :-) too early - needs more review/testing?

Will clang-cfi be based on this, too?

>   - Changed the command line for objtool to use --vmlinux --duplicate
>     to disable warnings about retpoline thunks and to fix .orc_unwind
>     generation for vmlinux.o.
>
>   - Added --noinstr flag to objtool, so we can use --vmlinux without
>     also enabling noinstr validation.
>
>   - Disabled objtool's unreachable instruction warnings with LTO to
>     disable false positives for the int3 padding in vmlinux.o.
>
>   - Added ANNOTATE_RETPOLINE_SAFE annotations to the indirect jumps
>     in x86 assembly code to fix objtool warnings with retpoline.
>
>   - Fixed modpost warnings about missing version information with
>     CONFIG_MODVERSIONS.
>
>   - Included Makefile.lib into Makefile.modpost for ld_flags. Thanks
>     to Sedat for pointing this out.
>

That was a long way to detect this as I had very big Debian Linux
debug packages generated with CONFIG_DEBUG_INFO_COMPRESSED=y.

Thanks for v5 of clang-lto.

- Sedat -

[1] https://github.com/ClangBuiltLinux/linux/issues/1086#issuecomment-705754002

>   - Updated the help text for ThinLTO to better explain the trade-offs.
>
>   - Updated commit messages with better explanations.
>
> Changes in v4:
>
>   - Fixed a typo in Makefile.lib to correctly pass --no-fp to objtool.
>
>   - Moved ftrace configs related to generating __mcount_loc to Kconfig,
>     so they are available also in Makefile.modfinal.
>
>   - Dropped two prerequisite patches that were merged to Linus' tree.
>
> Changes in v3:
>
>   - Added a separate patch to remove the unused DISABLE_LTO treewide,
>     as filtering out CC_FLAGS_LTO instead is preferred.
>
>   - Updated the Kconfig help to explain why LTO is behind a choice
>     and disabled by default.
>
>   - Dropped CC_FLAGS_LTO_CLANG, compiler-specific LTO flags are now
>     appended directly to CC_FLAGS_LTO.
>
>   - Updated $(AR) flags as KBUILD_ARFLAGS was removed earlier.
>
>   - Fixed ThinLTO cache handling for external module builds.
>
>   - Rebased on top of Masahiro's patch for preprocessing modules.lds,
>     and moved the contents of module-lto.lds to modules.lds.S.
>
>   - Moved objtool_args to Makefile.lib to avoid duplication of the
>     command line parameters in Makefile.modfinal.
>
>   - Clarified in the commit message for the initcall ordering patch
>     that the initcall order remains the same as without LTO.
>
>   - Changed link-vmlinux.sh to use jobserver-exec to control the
>     number of jobs started by generate_initcall_ordering.pl.
>
>   - Dropped the x86/relocs patch to whitelist L4_PAGE_OFFSET as it's
>     no longer needed with ToT kernel.
>
>   - Disabled LTO for arch/x86/power/cpu.c to work around a Clang bug
>     with stack protector attributes.
>
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
> Masahiro Yamada (1):
>   kbuild: preprocess module linker script
>
> Peter Zijlstra (1):
>   objtool: Add a pass for generating __mcount_loc
>
> Sami Tolvanen (27):
>   objtool: Don't autodetect vmlinux.o
>   tracing: move function tracer options to Kconfig
>   tracing: add support for objtool mcount
>   x86, build: use objtool mcount
>   treewide: remove DISABLE_LTO
>   kbuild: add support for Clang LTO
>   kbuild: lto: fix module versioning
>   objtool: Split noinstr validation from --vmlinux
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
>   arm64: vdso: disable LTO
>   KVM: arm64: disable LTO for the nVHE directory
>   arm64: disable recordmcount with DYNAMIC_FTRACE_WITH_REGS
>   arm64: allow LTO_CLANG and THINLTO to be selected
>   x86/asm: annotate indirect jumps
>   x86, vdso: disable LTO only for vDSO
>   x86, cpu: disable LTO for cpu.c
>   x86, build: allow LTO_CLANG and THINLTO to be selected
>
>  .gitignore                                    |   1 +
>  Makefile                                      |  68 +++--
>  arch/Kconfig                                  |  74 +++++
>  arch/arm/Makefile                             |   4 -
>  .../module.lds => include/asm/module.lds.h}   |   2 +
>  arch/arm64/Kconfig                            |   4 +
>  arch/arm64/Makefile                           |   4 -
>  .../module.lds => include/asm/module.lds.h}   |   2 +
>  arch/arm64/kernel/vdso/Makefile               |   4 +-
>  arch/arm64/kvm/hyp/nvhe/Makefile              |   4 +-
>  arch/ia64/Makefile                            |   1 -
>  .../{module.lds => include/asm/module.lds.h}  |   0
>  arch/m68k/Makefile                            |   1 -
>  .../module.lds => include/asm/module.lds.h}   |   0
>  arch/powerpc/Makefile                         |   1 -
>  .../module.lds => include/asm/module.lds.h}   |   0
>  arch/riscv/Makefile                           |   3 -
>  .../module.lds => include/asm/module.lds.h}   |   3 +-
>  arch/sparc/vdso/Makefile                      |   2 -
>  arch/um/include/asm/Kbuild                    |   1 +
>  arch/x86/Kconfig                              |   3 +
>  arch/x86/Makefile                             |   5 +
>  arch/x86/entry/vdso/Makefile                  |   5 +-
>  arch/x86/kernel/acpi/wakeup_64.S              |   2 +
>  arch/x86/platform/pvh/head.S                  |   2 +
>  arch/x86/power/Makefile                       |   4 +
>  arch/x86/power/hibernate_asm_64.S             |   3 +
>  drivers/firmware/efi/libstub/Makefile         |   2 +
>  drivers/misc/lkdtm/Makefile                   |   1 +
>  include/asm-generic/Kbuild                    |   1 +
>  include/asm-generic/module.lds.h              |  10 +
>  include/asm-generic/vmlinux.lds.h             |  11 +-
>  include/linux/init.h                          |  79 ++++-
>  include/linux/pci.h                           |  19 +-
>  kernel/Makefile                               |   3 -
>  kernel/trace/Kconfig                          |  29 ++
>  scripts/.gitignore                            |   1 +
>  scripts/Makefile                              |   3 +
>  scripts/Makefile.build                        |  69 +++--
>  scripts/Makefile.lib                          |  17 +-
>  scripts/Makefile.modfinal                     |  29 +-
>  scripts/Makefile.modpost                      |  25 +-
>  scripts/generate_initcall_order.pl            | 270 ++++++++++++++++++
>  scripts/link-vmlinux.sh                       |  98 ++++++-
>  scripts/mod/Makefile                          |   1 +
>  scripts/mod/modpost.c                         |  16 +-
>  scripts/mod/modpost.h                         |   9 +
>  scripts/mod/sumversion.c                      |   6 +-
>  scripts/{module-common.lds => module.lds.S}   |  31 ++
>  scripts/package/builddeb                      |   2 +-
>  tools/objtool/builtin-check.c                 |  10 +-
>  tools/objtool/check.c                         |  84 +++++-
>  tools/objtool/include/objtool/builtin.h       |   2 +-
>  tools/objtool/include/objtool/check.h         |   1 +
>  tools/objtool/include/objtool/objtool.h       |   1 +
>  tools/objtool/objtool.c                       |   1 +
>  56 files changed, 903 insertions(+), 131 deletions(-)
>  rename arch/arm/{kernel/module.lds => include/asm/module.lds.h} (72%)
>  rename arch/arm64/{kernel/module.lds => include/asm/module.lds.h} (76%)
>  rename arch/ia64/{module.lds => include/asm/module.lds.h} (100%)
>  rename arch/m68k/{kernel/module.lds => include/asm/module.lds.h} (100%)
>  rename arch/powerpc/{kernel/module.lds => include/asm/module.lds.h} (100%)
>  rename arch/riscv/{kernel/module.lds => include/asm/module.lds.h} (84%)
>  create mode 100644 include/asm-generic/module.lds.h
>  create mode 100755 scripts/generate_initcall_order.pl
>  rename scripts/{module-common.lds => module.lds.S} (59%)
>
>
> base-commit: 80396d76da65fc8b82581c0260c25a6aa0a495a3
> --
> 2.28.0.1011.ga647a8990f-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20201009161338.657380-1-samitolvanen%40google.com.
