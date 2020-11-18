Return-Path: <SRS0=tjLG=EY=lists.openwall.com=kernel-hardening-return-20406-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E8CC6379F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:07:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9E5A0246F2
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FEACl+hP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E5A0246F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20406-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1151 invoked by uid 550); 18 Nov 2020 22:07:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1129 invoked from network); 18 Nov 2020 22:07:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=RLGcqGrpsLlRbzosDVd0xMcJRplKck51D58hnCA0m40=;
        b=FEACl+hPLvLCehd5Y1IKJBTJMbR0QNknmx7JyEdblpLzyJtFGWeraZl9sfry0j3+TK
         kM1Ew0qwvXu8KiNhkl6/Lts6lfNP0QOtRmYpgESW0VKFUjrDc5GbVOF5mwwP/eHkKFsy
         FofVx9oGp4zsyD83lrr4uaPQAiM/oxp3HRLr27hBWDGyYPHGds3tdIhKnE0AUSYvkx+1
         TwEFXYs+aBQvHKOt2LEYwCaN+5eXT83BFAe3QJVAC6b+iFUY+dDobgfDt2BlWuLx2V4z
         3XbU9NTi2LeOeIv8rGJ6XXsrxQN/svzHG1smnTQhehYdm8prrKq5jKeMSosG+9Wvmj5x
         VHGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=RLGcqGrpsLlRbzosDVd0xMcJRplKck51D58hnCA0m40=;
        b=dr9i2snYRTh8OcLKwp+UUYZvwTuJLfwzTH9Jp4EoQMZB5iNaQx+qMqKPumbXBL8+rK
         GgjGR+O2/WX9duyuV0Rbs9G0xi2MToswBlOkyVerfqEMXwtR+FArkiqDeIIx/FBzqc/u
         qlq+Q4zhU5A8MOnUs8IDTqWHwu4uVPoAFtkhTFgtX6mz7nCv9IzeKRNwNHJ/tggnlcvp
         9uRJEaHZCFobRmdhPJqwl6I9QgeWIAeO+Jd+DXWRYySbLJnm7hARq6aUw5uLmiDupMf/
         qv2RJRw3yNaY2TqsYF1R6ZA0wqXK4LsrlF8WQoGQI3BWT/J9vMzh4v07vnlXXVjU1t9l
         7ykg==
X-Gm-Message-State: AOAM533isffyzJ1JVHx/AmZRpzStrlDyW2p5V5I4NgG50pqCqh4oGHYB
	UlijnXGRwyOJCYOxzRWpI8cu21DmvcX0grd9HSA=
X-Google-Smtp-Source: ABdhPJweJ21RzDAwp/tDBtJMRIUdyZdQmeb2yPsOyAN1xKpWf0eVIsvADvmRn84CHCirimlOu0esu246TN+ciGuGs0Q=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:cb11:: with SMTP id
 b17mr8848931ybg.236.1605737253032; Wed, 18 Nov 2020 14:07:33 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:14 -0800
Message-Id: <20201118220731.925424-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 00/17] Add support for Clang LTO
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds support for building the kernel with Clang's
Link Time Optimization (LTO). In addition to performance, the primary
motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
be used in the kernel. Google has shipped millions of Pixel devices
running three major kernel versions with LTO+CFI since 2018.

Most of the patches are build system changes for handling LLVM bitcode,
which Clang produces with LTO instead of ELF object files, postponing
ELF processing until a later stage, and ensuring initcall ordering.

Note that v7 brings back arm64 support as Will has now staged the
prerequisite memory ordering patches [1], and drops x86_64 while we work
on fixing the remaining objtool warnings [2].

[1] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-next/lto
[2] https://lore.kernel.org/lkml/20201114004911.aip52eimk6c2uxd4@treble/

You can also pull this series from

  https://github.com/samitolvanen/linux.git lto-v7

---
Changes in v7:

  - Rebased to master again.

  - Added back arm64 patches as the prerequisites are now staged,
    and dropped x86_64 support until the remaining objtool issues
    are resolved.

  - Dropped ifdefs from module.lds.S.

Changes in v6:

  - Added the missing --mcount flag to patch 5.

  - Dropped the arm64 patches from this series and will repost them
    later.

Changes in v5:

  - Rebased on top of tip/master.

  - Changed the command line for objtool to use --vmlinux --duplicate
    to disable warnings about retpoline thunks and to fix .orc_unwind
    generation for vmlinux.o.

  - Added --noinstr flag to objtool, so we can use --vmlinux without
    also enabling noinstr validation.

  - Disabled objtool's unreachable instruction warnings with LTO to
    disable false positives for the int3 padding in vmlinux.o.

  - Added ANNOTATE_RETPOLINE_SAFE annotations to the indirect jumps
    in x86 assembly code to fix objtool warnings with retpoline.

  - Fixed modpost warnings about missing version information with
    CONFIG_MODVERSIONS.

  - Included Makefile.lib into Makefile.modpost for ld_flags. Thanks
    to Sedat for pointing this out.

  - Updated the help text for ThinLTO to better explain the trade-offs.

  - Updated commit messages with better explanations.

Changes in v4:

  - Fixed a typo in Makefile.lib to correctly pass --no-fp to objtool.

  - Moved ftrace configs related to generating __mcount_loc to Kconfig,
    so they are available also in Makefile.modfinal.

  - Dropped two prerequisite patches that were merged to Linus' tree.

Changes in v3:

  - Added a separate patch to remove the unused DISABLE_LTO treewide,
    as filtering out CC_FLAGS_LTO instead is preferred.

  - Updated the Kconfig help to explain why LTO is behind a choice
    and disabled by default.

  - Dropped CC_FLAGS_LTO_CLANG, compiler-specific LTO flags are now
    appended directly to CC_FLAGS_LTO.

  - Updated $(AR) flags as KBUILD_ARFLAGS was removed earlier.

  - Fixed ThinLTO cache handling for external module builds.

  - Rebased on top of Masahiro's patch for preprocessing modules.lds,
    and moved the contents of module-lto.lds to modules.lds.S.

  - Moved objtool_args to Makefile.lib to avoid duplication of the
    command line parameters in Makefile.modfinal.

  - Clarified in the commit message for the initcall ordering patch
    that the initcall order remains the same as without LTO.

  - Changed link-vmlinux.sh to use jobserver-exec to control the
    number of jobs started by generate_initcall_ordering.pl.

  - Dropped the x86/relocs patch to whitelist L4_PAGE_OFFSET as it's
    no longer needed with ToT kernel.

  - Disabled LTO for arch/x86/power/cpu.c to work around a Clang bug
    with stack protector attributes.

Changes in v2:

  - Fixed -Wmissing-prototypes warnings with W=1.

  - Dropped cc-option from -fsplit-lto-unit and added .thinlto-cache
    scrubbing to make distclean.

  - Added a comment about Clang >=11 being required.

  - Added a patch to disable LTO for the arm64 KVM nVHE code.

  - Disabled objtool's noinstr validation with LTO unless enabled.

  - Included Peter's proposed objtool mcount patch in the series
    and replaced recordmcount with the objtool pass to avoid
    whitelisting relocations that are not calls.

  - Updated several commit messages with better explanations.


Sami Tolvanen (17):
  tracing: move function tracer options to Kconfig
  kbuild: add support for Clang LTO
  kbuild: lto: fix module versioning
  kbuild: lto: limit inlining
  kbuild: lto: merge module sections
  kbuild: lto: remove duplicate dependencies from .mod files
  init: lto: ensure initcall ordering
  init: lto: fix PREL32 relocations
  PCI: Fix PREL32 relocations for LTO
  modpost: lto: strip .lto from module names
  scripts/mod: disable LTO for empty.c
  efi/libstub: disable LTO
  drivers/misc/lkdtm: disable LTO for rodata.o
  arm64: vdso: disable LTO
  KVM: arm64: disable LTO for the nVHE directory
  arm64: disable recordmcount with DYNAMIC_FTRACE_WITH_REGS
  arm64: allow LTO_CLANG and THINLTO to be selected

 .gitignore                            |   1 +
 Makefile                              |  45 +++--
 arch/Kconfig                          |  74 +++++++
 arch/arm64/Kconfig                    |   4 +
 arch/arm64/kernel/vdso/Makefile       |   3 +-
 arch/arm64/kvm/hyp/nvhe/Makefile      |   4 +-
 drivers/firmware/efi/libstub/Makefile |   2 +
 drivers/misc/lkdtm/Makefile           |   1 +
 include/asm-generic/vmlinux.lds.h     |  11 +-
 include/linux/init.h                  |  79 +++++++-
 include/linux/pci.h                   |  19 +-
 kernel/trace/Kconfig                  |  16 ++
 scripts/Makefile.build                |  50 ++++-
 scripts/Makefile.lib                  |   6 +-
 scripts/Makefile.modfinal             |   9 +-
 scripts/Makefile.modpost              |  25 ++-
 scripts/generate_initcall_order.pl    | 270 ++++++++++++++++++++++++++
 scripts/link-vmlinux.sh               |  70 ++++++-
 scripts/mod/Makefile                  |   1 +
 scripts/mod/modpost.c                 |  16 +-
 scripts/mod/modpost.h                 |   9 +
 scripts/mod/sumversion.c              |   6 +-
 scripts/module.lds.S                  |  24 +++
 23 files changed, 677 insertions(+), 68 deletions(-)
 create mode 100755 scripts/generate_initcall_order.pl


base-commit: 0fa8ee0d9ab95c9350b8b84574824d9a384a9f7d
-- 
2.29.2.299.gdc1121823c-goog

