Return-Path: <SRS0=KZgG=EY=lists.openwall.com=kernel-hardening-return-20425-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-28.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3287C6379F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 23:42:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 87070246EB
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 23:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IclJMrJ5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87070246EB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20425-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25889 invoked by uid 550); 18 Nov 2020 23:42:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25869 invoked from network); 18 Nov 2020 23:42:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wc0yNJXcZws+WRwhlcA3oBkHhr2WzmzBrEHEaOZzgXc=;
        b=IclJMrJ5opPwCE1rcdJf4I1hVcoa1v9GarCIyOZzoGXdL8EK93b5DecDyW/5Li0ZuO
         pFHos7s4G2KiBuUV/rqU8ftvuuh/wH/Z3tMjjFAUGX/BVS4jjId6+0JGL3TmEpI80vHO
         BASC+2TbtDk7cT/XSOjzilJ55GHnsPdaDuUI73vTuM6zHKiXJ6VSCa6Ud9kSPotuedA7
         B+Lt2CGHGO7QTceBkb25zm0C3UbDab5TPqDbWPdQKztDIZCp90rzzlLQHUMkxifdzAj6
         EOE55PrNGpj79f5v2Gl50MCuAJSuKJ5153VqIsHVliX9P+Aa+Iqc/e4SxgcRDTQnn1v3
         GBwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wc0yNJXcZws+WRwhlcA3oBkHhr2WzmzBrEHEaOZzgXc=;
        b=fnQtpppr5xS5EJHui8Do+7ckt4MXxEjLTAEVfj05ViFMKpPUvusEON0gVT3re3MThh
         TFpxLNXvMYrHYXbyz06AyZvoJyI10EGdqnNzCylq8rqEtRuexGRuFH+X6UZvT9SdX4VT
         JdA/gfrWoefd6vs7bU49umlsvJ2uuTB0R2TLgaLl8FH9PE+B2Zf3hW1sC6fbb39i10/J
         UF3q4APFDuobTiMyXBuB9UK0rXQWOxQNAZQsWnfYsziv8wi9XCyWxOkm5hPGRLtR6jJ5
         HaV03usHpTOJlUIv1DC6HoqfZ0JSqLWaRvKan+8sINomNqFP1Y1Cr/7E85rN9A9PrX1R
         TzsQ==
X-Gm-Message-State: AOAM5338YbGZNp+l9szys/26s8Q8/hPWbfjSACJs0TRPVF1El40jFO1s
	HrFcS/oYp4G11O6Hg80v0G/jMbYSAoqZ/KOWlh+vPA==
X-Google-Smtp-Source: ABdhPJxcOWPX+u5MiJTivd9DIhdri4QSEH+qEts8glczJpZeUd9rmQ+KPTuGSQ3hl2iDg12MMXMBxFIsnSVwVTMw3Ls=
X-Received: by 2002:a17:90a:6b04:: with SMTP id v4mr1413363pjj.101.1605742937385;
 Wed, 18 Nov 2020 15:42:17 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 18 Nov 2020 15:42:05 -0800
Message-ID: <CAKwvOd=5PhCTZ-yHr08gPYNEsGEjZa=rDY0-unhkhofjXhqwLQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 18, 2020 at 2:07 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> This patch series adds support for building the kernel with Clang's
> Link Time Optimization (LTO). In addition to performance, the primary
> motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> be used in the kernel. Google has shipped millions of Pixel devices
> running three major kernel versions with LTO+CFI since 2018.
>
> Most of the patches are build system changes for handling LLVM bitcode,
> which Clang produces with LTO instead of ELF object files, postponing
> ELF processing until a later stage, and ensuring initcall ordering.
>
> Note that v7 brings back arm64 support as Will has now staged the
> prerequisite memory ordering patches [1], and drops x86_64 while we work
> on fixing the remaining objtool warnings [2].
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-next/lto
> [2] https://lore.kernel.org/lkml/20201114004911.aip52eimk6c2uxd4@treble/
>
> You can also pull this series from
>
>   https://github.com/samitolvanen/linux.git lto-v7

Thanks for continuing to drive this series Sami.  For the series,

Tested-by: Nick Desaulniers <ndesaulniers@google.com>

I did virtualized boot tests with the series applied to aarch64
defconfig without CONFIG_LTO, with CONFIG_LTO_CLANG, and a third time
with CONFIG_THINLTO.  If you make changes to the series in follow ups,
please drop my tested by tag from the modified patches and I'll help
re-test.  Some minor feedback on the Kconfig change, but I'll post it
off of that patch.

>
> ---
> Changes in v7:
>
>   - Rebased to master again.
>
>   - Added back arm64 patches as the prerequisites are now staged,
>     and dropped x86_64 support until the remaining objtool issues
>     are resolved.
>
>   - Dropped ifdefs from module.lds.S.
>
> Changes in v6:
>
>   - Added the missing --mcount flag to patch 5.
>
>   - Dropped the arm64 patches from this series and will repost them
>     later.
>
> Changes in v5:
>
>   - Rebased on top of tip/master.
>
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
> Sami Tolvanen (17):
>   tracing: move function tracer options to Kconfig
>   kbuild: add support for Clang LTO
>   kbuild: lto: fix module versioning
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
>
>  .gitignore                            |   1 +
>  Makefile                              |  45 +++--
>  arch/Kconfig                          |  74 +++++++
>  arch/arm64/Kconfig                    |   4 +
>  arch/arm64/kernel/vdso/Makefile       |   3 +-
>  arch/arm64/kvm/hyp/nvhe/Makefile      |   4 +-
>  drivers/firmware/efi/libstub/Makefile |   2 +
>  drivers/misc/lkdtm/Makefile           |   1 +
>  include/asm-generic/vmlinux.lds.h     |  11 +-
>  include/linux/init.h                  |  79 +++++++-
>  include/linux/pci.h                   |  19 +-
>  kernel/trace/Kconfig                  |  16 ++
>  scripts/Makefile.build                |  50 ++++-
>  scripts/Makefile.lib                  |   6 +-
>  scripts/Makefile.modfinal             |   9 +-
>  scripts/Makefile.modpost              |  25 ++-
>  scripts/generate_initcall_order.pl    | 270 ++++++++++++++++++++++++++
>  scripts/link-vmlinux.sh               |  70 ++++++-
>  scripts/mod/Makefile                  |   1 +
>  scripts/mod/modpost.c                 |  16 +-
>  scripts/mod/modpost.h                 |   9 +
>  scripts/mod/sumversion.c              |   6 +-
>  scripts/module.lds.S                  |  24 +++
>  23 files changed, 677 insertions(+), 68 deletions(-)
>  create mode 100755 scripts/generate_initcall_order.pl
>
>
> base-commit: 0fa8ee0d9ab95c9350b8b84574824d9a384a9f7d
> --
> 2.29.2.299.gdc1121823c-goog
>


-- 
Thanks,
~Nick Desaulniers
