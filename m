Return-Path: <SRS0=/hBU=YS=lists.openwall.com=kernel-hardening-return-17105-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56808CA9EA0
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:27:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6E6532084C
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 09:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pogRYPkg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E6532084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17105-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30148 invoked by uid 550); 25 Oct 2019 09:27:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18224 invoked from network); 24 Oct 2019 22:51:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oWllzh5vaeGWMmnhX95Qs3eA6Ovd/Uui8NGiRBr6Pe0=;
        b=pogRYPkg/nve1M3OiYY4Wag+d2PGWQPzsdNXcqTuKY+rlnlmqz5dwAwrmMzYU1Szy1
         cm3n9fGnSJHilO5kqRF1Hs+N3EvXjbaFF2Cv3P+ZXK2S2z4DYn0/FcnJWOUW/H+Voyvy
         HDH8+0v+N6O/QC3DxHUDMt+9LIDK3IZ8+bxwsdl47cLyCTOi/ERhIGmwc3aKkvyHKFjV
         2F524csUpsJCv7iZZ3N88FVs6h2ebq5zpzvbkSMUPzlNsczLyDlVkytRU8OSMDg0vyx/
         /i4vK/102Dp6GDDm4BCbIIW1M1ufCgWsVxgKP+feminwGyUvIq1wApA9zsM54kuRfZcS
         YnMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oWllzh5vaeGWMmnhX95Qs3eA6Ovd/Uui8NGiRBr6Pe0=;
        b=uRXE0BuAjs92f28zySZFQWdL5QQ/lWpRtlQ30ErVMnIBlpdclOgsbwleB4Q4ktpqac
         Qotu3TEXjWoG0JvIzTWzUVU9EyfD6HszQFycvYtgaSkZGwJuIOhGjIF3EwGsFJx6RKvJ
         UhN6vhsYx6+WLJCrw3bcF/MymU1i7BO5ulb1J7MNG/CH1askslTJyQ3R7OybhJ/46qgd
         evU1Vj0WXY+i/7y0NEZepE71f9TKODbz4K+1boGQ7KdNJkhSqtyIk1SVbQE33WcupDc5
         Ul7r66UFV9f/1svr+sa4FklrNulgKSjR611HeNFALyPKlBiAYA1gFjVzcZgaNpQP2j8u
         JOQg==
X-Gm-Message-State: APjAAAUxO2b6ev424lycOd+MPYN+r9atmH74r15JoyVsWYnQ6DCpHm0R
	WngiZnCT/onHBkRU6DFJv1y+MapMp4rcEpw1MYk=
X-Google-Smtp-Source: APXvYqy2KwvYNP2JqDo6REYpoD752JF/rXPe0p7AxMxmFNVZPrCd+i7RIFwlPKqpkKy5vtu6yuCaVfarLiMcqAZvOds=
X-Received: by 2002:a63:6f02:: with SMTP id k2mr494747pgc.163.1571957496395;
 Thu, 24 Oct 2019 15:51:36 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:15 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-1-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 00/17] add support for Clang's Shadow Call Stack
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds support for Clang's Shadow Call Stack
(SCS) mitigation, which uses a separately allocated shadow stack
to protect against return address overwrites. More information
can be found here:

  https://clang.llvm.org/docs/ShadowCallStack.html

SCS provides better protection against traditional buffer
overflows than CONFIG_STACKPROTECTOR_*, but it should be noted
that SCS security guarantees in the kernel differ from the ones
documented for user space. The kernel must store addresses of
shadow stacks used by other tasks and interrupt handlers in
memory, which means an attacker capable reading and writing
arbitrary memory may be able to locate them and hijack control
flow by modifying shadow stacks that are not currently in use.

SCS is currently supported only on arm64, where the compiler
requires the x18 register to be reserved for holding the current
task's shadow stack pointer. Because of this, the series includes
patches from Ard to remove x18 usage from assembly code.

With -fsanitize=shadow-call-stack, the compiler injects
instructions to all non-leaf C functions to store the return
address to the shadow stack, and unconditionally load it again
before returning. As a result, SCS is currently incompatible
with features that rely on modifying function return addresses
to alter control flow, such as function graph tracing and
kretprobes, although it may be possible to later change these
feature to modify the shadow stack instead. A copy of the return
address is still kept in the kernel stack for compatibility with
stack unwinding, for example.

SCS has a minimal performance overhead, but allocating
shadow stacks increases kernel memory usage. The feature is
therefore mostly useful on hardware that lacks support for PAC
instructions.

Changes in v2:
 - Changed Ard's KVM patch to use x29 instead of x18 for the
   guest context, which makes restore_callee_saved_regs cleaner
 - Updated help text (and commit messages) to point out
   differences in security properties compared to user space SCS
 - Cleaned up config options: removed the ROP protection choice,
   replaced the CC_IS_CLANG dependency with an arch-specific
   cc-option test, and moved disabling of incompatible config
   options to an arch-specific Kconfig
 - Added CC_FLAGS_SCS, which are filtered out where needed
   instead of using DISABLE_SCS
 - Added a __has_feature guard around __noscs for older clang
   versions
 - Changed the shadow stack overflow check for vmapped SCS to
   use SCS_SIZE to avoid surprises when changing configs
 - Renamed SCS_GFP to GFP_SCS
 - Dropped the patch to reserve x18 unconditionally, it's now
   only reserved with SCS
 - Added a clarification why restoring x18 in the EFI RT
   wrapper is safe
 - Added a missing change to arch/arm64/include/asm/suspend.h,
   and a comment to arch/arm64/mm/proc.S to remind that struct
   cpu_suspend_ctx must be kept in sync with the code
 - Moved x18 loading/storing during a context switch to
   cpu_switch_to(), renamed scs_thread_switch() to
   scs_overflow_check(), and removed the now unused scs_load()
 - Added compile-time initialization for init_shadow_call_stack
   and removed scs_set_init_magic()


Ard Biesheuvel (2):
  arm64/lib: copy_page: avoid x18 register in assembler code
  arm64: kernel: avoid x18 as an arbitrary temp register

Sami Tolvanen (15):
  arm64: mm: don't use x18 in idmap_kpti_install_ng_mappings
  arm64: kvm: stop treating register x18 as caller save
  add support for Clang's Shadow Call Stack (SCS)
  scs: add accounting
  scs: add support for stack usage debugging
  kprobes: fix compilation without CONFIG_KRETPROBES
  arm64: disable function graph tracing with SCS
  arm64: disable kretprobes with SCS
  arm64: reserve x18 from general allocation with SCS
  arm64: preserve x18 when CPU is suspended
  arm64: efi: restore x18 if it was corrupted
  arm64: vdso: disable Shadow Call Stack
  arm64: kprobes: fix kprobes without CONFIG_KRETPROBES
  arm64: disable SCS for hypervisor code
  arm64: implement Shadow Call Stack

 Makefile                             |   6 +
 arch/Kconfig                         |  33 +++++
 arch/arm64/Kconfig                   |   9 +-
 arch/arm64/Makefile                  |   4 +
 arch/arm64/include/asm/scs.h         |  45 ++++++
 arch/arm64/include/asm/stacktrace.h  |   4 +
 arch/arm64/include/asm/suspend.h     |   2 +-
 arch/arm64/include/asm/thread_info.h |   3 +
 arch/arm64/kernel/Makefile           |   1 +
 arch/arm64/kernel/asm-offsets.c      |   3 +
 arch/arm64/kernel/cpu-reset.S        |   4 +-
 arch/arm64/kernel/efi-rt-wrapper.S   |   7 +-
 arch/arm64/kernel/entry.S            |  28 ++++
 arch/arm64/kernel/head.S             |   9 ++
 arch/arm64/kernel/irq.c              |   2 +
 arch/arm64/kernel/probes/kprobes.c   |   2 +
 arch/arm64/kernel/process.c          |   2 +
 arch/arm64/kernel/scs.c              |  39 +++++
 arch/arm64/kernel/smp.c              |   4 +
 arch/arm64/kernel/vdso/Makefile      |   2 +-
 arch/arm64/kvm/hyp/Makefile          |   3 +
 arch/arm64/kvm/hyp/entry.S           |  41 +++--
 arch/arm64/lib/copy_page.S           |  38 ++---
 arch/arm64/mm/proc.S                 |  72 +++++----
 drivers/base/node.c                  |   6 +
 fs/proc/meminfo.c                    |   4 +
 include/linux/compiler-clang.h       |   6 +
 include/linux/compiler_types.h       |   4 +
 include/linux/mmzone.h               |   3 +
 include/linux/scs.h                  |  78 ++++++++++
 init/init_task.c                     |   8 +
 kernel/Makefile                      |   1 +
 kernel/fork.c                        |   9 ++
 kernel/kprobes.c                     |  38 ++---
 kernel/sched/core.c                  |   2 +
 kernel/sched/sched.h                 |   1 +
 kernel/scs.c                         | 214 +++++++++++++++++++++++++++
 mm/page_alloc.c                      |   6 +
 mm/vmstat.c                          |   3 +
 39 files changed, 649 insertions(+), 97 deletions(-)
 create mode 100644 arch/arm64/include/asm/scs.h
 create mode 100644 arch/arm64/kernel/scs.c
 create mode 100644 include/linux/scs.h
 create mode 100644 kernel/scs.c

-- 
2.24.0.rc0.303.g954a862665-goog

