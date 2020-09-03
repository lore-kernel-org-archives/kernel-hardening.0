Return-Path: <SRS0=DnyL=CM=lists.openwall.com=kernel-hardening-return-19719-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97559C2D0E1
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:31:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C215320684
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 20:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="h0+Pz1Cs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C215320684
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19719-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16068 invoked by uid 550); 3 Sep 2020 20:31:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16036 invoked from network); 3 Sep 2020 20:31:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=nGr4msUS0dEW75ogQM/nhSlm97UUOCMWXorkodmMp40=;
        b=h0+Pz1CszWOumbWEcLmAC3O2sDpreVbpYTU/LLeX71N9riUhico9+tp5lrxUEUaJUq
         9/9jya3977ohpQ/UFatz+tG09iq0m7MVC3DPVvg75x+pJc1eEY0ZcnS0k1+FD0W4xfb0
         0s+GpFY0ECMdosU7iEgPv+ytcGRd+QAMRWGomwTGMAF/oKYGdOMzrdSAXUCcyTbSDzPs
         dbV5UeBXLgGB51pRx1q2svY0VUeB76G3YYFH4HGDmwpMrISfVfQK8Ou5NlhZ+ph++gno
         1f2227PbyNuZ6U1XezgTQhhRcqLNB/aPe/L1HXGAltrVeTWBZQOgom9iMWye5PZNH9er
         DUZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nGr4msUS0dEW75ogQM/nhSlm97UUOCMWXorkodmMp40=;
        b=ICY5hJtHEWUEwlBQivyUPlDHRO1loNyb0UiL4Y0sAm3+F0U5bwi5a8kHvjK3n6Zdnp
         thxKIVXBOIqqlvWa0NqKvYXk+VqZ688t0alwxwlLQPPE28Hk3YzBCgi/b4U/vyOkbvGm
         60ZgVtIn2I9Zod/ThXXyiawMDn3E5X46yzkcpbd5hog7UPRd6MDCJg+gSfAkqxBMSs2o
         8VIpjOnonQcx3Uuif/nF+aCeCtAGWmHf5DYWhm+hAkdPe+OVzaOyOBCGGVsNDp6ovSL1
         TQP2aOQUW0dzIjcSwoVi7O4Eu1Ysk8aa5HBGRhcqMIUyWrzLWf+Cs2XH6U1eQbnqIQEE
         UQGg==
X-Gm-Message-State: AOAM532tJpvuOB/w3GP/0oKal0AIDiO85FmfBqD4sKz2l4Y5MvWT9gsz
	Gsm28YQKOznTWg+00qH+gGN61A5iSRAcUhnFSao=
X-Google-Smtp-Source: ABdhPJxH0RX0szKuHKPur3enUKVPJmiZ5UDvXRtv8sxJrR42cHWJcizyyc12gG2V+M5Plv1Dslq7MnG2DtQcSDaz1iU=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:d803:: with SMTP id
 h3mr3572282qvj.0.1599165054814; Thu, 03 Sep 2020 13:30:54 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:25 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-1-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 00/28] Add support for Clang LTO
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds support for building x86_64 and arm64 kernels
with Clang's Link Time Optimization (LTO).

In addition to performance, the primary motivation for LTO is
to allow Clang's Control-Flow Integrity (CFI) to be used in the
kernel. Google has shipped millions of Pixel devices running three
major kernel versions with LTO+CFI since 2018.

Most of the patches are build system changes for handling LLVM
bitcode, which Clang produces with LTO instead of ELF object files,
postponing ELF processing until a later stage, and ensuring initcall
ordering.

Note that patches 1-4 are not directly related to LTO, but are
needed to compile LTO kernels with ToT Clang, so I'm including them
in the series for your convenience:

 - Patches 1-3 are required for building the kernel with ToT Clang,
   and IAS, and patch 4 is needed to build allmodconfig with LTO.

 - Patches 3-4 are already in linux-next, but not yet in 5.9-rc.

---
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


Arvind Sankar (2):
  x86/boot/compressed: Disable relocation relaxation
  x86/asm: Replace __force_order with memory clobber

Luca Stefani (1):
  RAS/CEC: Fix cec_init() prototype

Nick Desaulniers (1):
  lib/string.c: implement stpcpy

Peter Zijlstra (1):
  objtool: Add a pass for generating __mcount_loc

Sami Tolvanen (23):
  objtool: Don't autodetect vmlinux.o
  kbuild: add support for objtool mcount
  x86, build: use objtool mcount
  kbuild: add support for Clang LTO
  kbuild: lto: fix module versioning
  kbuild: lto: postpone objtool
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
  arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
  arm64: vdso: disable LTO
  KVM: arm64: disable LTO for the nVHE directory
  arm64: allow LTO_CLANG and THINLTO to be selected
  x86, vdso: disable LTO only for vDSO
  x86, relocs: Ignore L4_PAGE_OFFSET relocations
  x86, build: allow LTO_CLANG and THINLTO to be selected

 .gitignore                            |   1 +
 Makefile                              |  65 ++++++-
 arch/Kconfig                          |  67 +++++++
 arch/arm64/Kconfig                    |   2 +
 arch/arm64/Makefile                   |   1 +
 arch/arm64/kernel/vdso/Makefile       |   4 +-
 arch/arm64/kvm/hyp/nvhe/Makefile      |   4 +-
 arch/x86/Kconfig                      |   3 +
 arch/x86/Makefile                     |   5 +
 arch/x86/boot/compressed/Makefile     |   2 +
 arch/x86/boot/compressed/pgtable_64.c |   9 -
 arch/x86/entry/vdso/Makefile          |   5 +-
 arch/x86/include/asm/special_insns.h  |  28 +--
 arch/x86/kernel/cpu/common.c          |   4 +-
 arch/x86/tools/relocs.c               |   1 +
 drivers/firmware/efi/libstub/Makefile |   2 +
 drivers/misc/lkdtm/Makefile           |   1 +
 drivers/ras/cec.c                     |   9 +-
 include/asm-generic/vmlinux.lds.h     |  11 +-
 include/linux/init.h                  |  79 +++++++-
 include/linux/pci.h                   |  19 +-
 kernel/trace/Kconfig                  |   5 +
 lib/string.c                          |  24 +++
 scripts/Makefile.build                |  55 +++++-
 scripts/Makefile.lib                  |   6 +-
 scripts/Makefile.modfinal             |  31 ++-
 scripts/Makefile.modpost              |  26 ++-
 scripts/generate_initcall_order.pl    | 270 ++++++++++++++++++++++++++
 scripts/link-vmlinux.sh               |  94 ++++++++-
 scripts/mod/Makefile                  |   1 +
 scripts/mod/modpost.c                 |  16 +-
 scripts/mod/modpost.h                 |   9 +
 scripts/mod/sumversion.c              |   6 +-
 scripts/module-lto.lds                |  26 +++
 tools/objtool/builtin-check.c         |  13 +-
 tools/objtool/builtin.h               |   2 +-
 tools/objtool/check.c                 |  83 ++++++++
 tools/objtool/check.h                 |   1 +
 tools/objtool/objtool.h               |   1 +
 39 files changed, 883 insertions(+), 108 deletions(-)
 create mode 100755 scripts/generate_initcall_order.pl
 create mode 100644 scripts/module-lto.lds


base-commit: e28f0104343d0c132fa37f479870c9e43355fee4
-- 
2.28.0.402.g5ffc5be6b7-goog

