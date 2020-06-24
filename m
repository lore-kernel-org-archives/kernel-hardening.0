Return-Path: <SRS0=bkWK=AF=lists.openwall.com=kernel-hardening-return-19108-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4E3C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:33:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E226320836
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 20:33:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Uawx1Hym"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E226320836
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19108-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26286 invoked by uid 550); 24 Jun 2020 20:32:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26253 invoked from network); 24 Jun 2020 20:32:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=geZqQu8Pc2IZyEmyfjSbirVoyCHoNCVPX8WSrD5/a0I=;
        b=Uawx1HymTuOmFuIsE6m0edc2JOJkrIL4ohCvAqVmbJ8lL51+F8GFU8Edzr7cqZcv2w
         HodyjPnW3CEUXq8PkZVULO6ZyoUtxp9+p+vdtGUCMz8qqae3fj+ztQ8oZGg5KLQxzxtv
         WsCNEibFNfuA+bNlcIR8b4sSEDOv2SkH85c5Dy7chvY+wP/aaRR1NsYEhp1bKM54GsoI
         2QcLu0Jhfop40Tu+FeyQ89Qe5QVYishLUcPnbhRan/pilxFWfHclHWVyGJPxpvvrwTh0
         JNHLSYYTI2a6tpFbw45+Zc3Ez5EH+jMImL6HifoQ7sZW+Y10m8LKlencaSHV2sNpKm9n
         vXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=geZqQu8Pc2IZyEmyfjSbirVoyCHoNCVPX8WSrD5/a0I=;
        b=gzz2rhZspUuoGFmHc+JSZi0LY/8/utNFZUkqE3/nAOQla2g6f9Gb9A+yw/aTHOaFZ0
         TqFXMC9XkeRGW2dVnV4wU1HR9ZdlM0o8ZhWpgZEoqcUHNkH9B2OtjHzcmkehXAxq3cq9
         0AfFrv/MD6FFa9dthFXxsQLcHdERVPkJ54rBBexz/VH7OPlE4/rzni6XvypSUSqSIOkV
         OEZXKue+NXGVWJlJrnLavtLNGK+j8LOK+6oq2gp9Bl7IRUpJo2jWFKi/iqTiU8c47XsN
         ob0Qe1eb2S8DxK9brEbWrhgEqr0aNp6FTY6iV49xCmZ2j6oFL52oXaCz7ODXmdgFw7Ab
         kNIw==
X-Gm-Message-State: AOAM533oemc+hIkynptJFe4pIEr05+XvViTPIiJbwpbff3Keex1v6UAZ
	r9kLonSKlLGdcSwGyicFxZn9dMrWj2HzOigsHwM=
X-Google-Smtp-Source: ABdhPJxWR9GEuM9Xe3hags9/hH99MHEAXvV4G6BQoWnGF1JJpG+hf2xaFzi6meCZqAzm99eCovUBw+L4m3sg7uT3BU4=
X-Received: by 2002:a25:3342:: with SMTP id z63mr44129932ybz.200.1593030767109;
 Wed, 24 Jun 2020 13:32:47 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:38 -0700
Message-Id: <20200624203200.78870-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 00/22] add support for Clang LTO
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds support for building x86_64 and arm64 kernels
with Clang's Link Time Optimization (LTO).

In addition to performance, the primary motivation for LTO is to allow
Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
Pixel devices have shipped with LTO+CFI kernels since 2018.

Most of the patches are build system changes for handling LLVM bitcode,
which Clang produces with LTO instead of ELF object files, postponing
ELF processing until a later stage, and ensuring initcall ordering.

Note that first objtool patch in the series is already in linux-next,
but as it's needed with LTO, I'm including it also here to make testing
easier.

Sami Tolvanen (22):
  objtool: use sh_info to find the base for .rela sections
  kbuild: add support for Clang LTO
  kbuild: lto: fix module versioning
  kbuild: lto: fix recordmcount
  kbuild: lto: postpone objtool
  kbuild: lto: limit inlining
  kbuild: lto: merge module sections
  kbuild: lto: remove duplicate dependencies from .mod files
  init: lto: ensure initcall ordering
  init: lto: fix PREL32 relocations
  pci: lto: fix PREL32 relocations
  modpost: lto: strip .lto from module names
  scripts/mod: disable LTO for empty.c
  efi/libstub: disable LTO
  drivers/misc/lkdtm: disable LTO for rodata.o
  arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
  arm64: vdso: disable LTO
  arm64: allow LTO_CLANG and THINLTO to be selected
  x86, vdso: disable LTO only for vDSO
  x86, ftrace: disable recordmcount for ftrace_make_nop
  x86, relocs: Ignore L4_PAGE_OFFSET relocations
  x86, build: allow LTO_CLANG and THINLTO to be selected

 .gitignore                            |   1 +
 Makefile                              |  27 ++-
 arch/Kconfig                          |  65 +++++++
 arch/arm64/Kconfig                    |   2 +
 arch/arm64/Makefile                   |   1 +
 arch/arm64/kernel/vdso/Makefile       |   4 +-
 arch/x86/Kconfig                      |   2 +
 arch/x86/Makefile                     |   5 +
 arch/x86/entry/vdso/Makefile          |   5 +-
 arch/x86/kernel/ftrace.c              |   1 +
 arch/x86/tools/relocs.c               |   1 +
 drivers/firmware/efi/libstub/Makefile |   2 +
 drivers/misc/lkdtm/Makefile           |   1 +
 include/asm-generic/vmlinux.lds.h     |  12 +-
 include/linux/compiler-clang.h        |   4 +
 include/linux/compiler.h              |   2 +-
 include/linux/compiler_types.h        |   4 +
 include/linux/init.h                  |  78 +++++++-
 include/linux/pci.h                   |  15 +-
 kernel/trace/ftrace.c                 |   1 +
 lib/Kconfig.debug                     |   2 +-
 scripts/Makefile.build                |  55 +++++-
 scripts/Makefile.lib                  |   6 +-
 scripts/Makefile.modfinal             |  40 +++-
 scripts/Makefile.modpost              |  26 ++-
 scripts/generate_initcall_order.pl    | 270 ++++++++++++++++++++++++++
 scripts/link-vmlinux.sh               | 100 +++++++++-
 scripts/mod/Makefile                  |   1 +
 scripts/mod/modpost.c                 |  16 +-
 scripts/mod/modpost.h                 |   9 +
 scripts/mod/sumversion.c              |   6 +-
 scripts/module-lto.lds                |  26 +++
 scripts/recordmcount.c                |   3 +-
 tools/objtool/elf.c                   |   2 +-
 34 files changed, 737 insertions(+), 58 deletions(-)
 create mode 100755 scripts/generate_initcall_order.pl
 create mode 100644 scripts/module-lto.lds


base-commit: 26e122e97a3d0390ebec389347f64f3730fdf48f
-- 
2.27.0.212.ge8ba1cc988-goog

