From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv3 0/2] Stackleak for arm64
Date: Fri, 20 Jul 2018 14:41:52 -0700
Message-Id: <20180720214154.2940-1-labbott@redhat.com>
In-Reply-To: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is the version of stackleak for arm64, hopefully ready for queueing

Laura Abbott (2):
  arm64: Add stack information to on_accessible_stack
  arm64: Add support for STACKLEAK gcc plugin

 arch/arm64/Kconfig                    |  1 +
 arch/arm64/include/asm/processor.h    | 15 ++++++
 arch/arm64/include/asm/sdei.h         |  9 ++--
 arch/arm64/include/asm/stacktrace.h   | 73 ++++++++++++++++++++++-----
 arch/arm64/kernel/entry.S             |  7 +++
 arch/arm64/kernel/process.c           | 22 ++++++++
 arch/arm64/kernel/ptrace.c            |  2 +-
 arch/arm64/kernel/sdei.c              | 51 ++++++++++++++++---
 arch/arm64/kernel/stacktrace.c        |  2 +-
 arch/arm64/kvm/hyp/Makefile           |  3 +-
 drivers/firmware/efi/libstub/Makefile |  3 +-
 11 files changed, 161 insertions(+), 27 deletions(-)

-- 
2.17.1
