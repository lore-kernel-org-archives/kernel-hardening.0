From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 0/2] Stackleak for arm64
Date: Wed, 18 Jul 2018 14:10:11 -0700
Message-Id: <20180718211013.14512-1-labbott@redhat.com>
In-Reply-To: <1531341400-12077-1-git-send-email-alex.popov@linux.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is the new version of stackleak for arm64 to go with v14 of the
series for x86. I have a cover letter and few more cc's to go along with
some of the prep work.

I also apologize for terrible versioning on these series. Usually I try
to just reply to the top level patch with this addition and not actually
put a version on it. I negelcted to do that last time but as mentioned
this is inteded to go with v14.

Laura Abbott (2):
  arm64: Introduce current_stack_type
  arm64: Clear the stack

 arch/arm64/Kconfig                    |  1 +
 arch/arm64/include/asm/processor.h    | 17 +++++
 arch/arm64/include/asm/sdei.h         |  8 ++-
 arch/arm64/include/asm/stacktrace.h   | 94 ++++++++++++++++++++++-----
 arch/arm64/kernel/entry.S             |  7 ++
 arch/arm64/kernel/process.c           | 32 +++++++++
 arch/arm64/kernel/ptrace.c            |  2 +-
 arch/arm64/kernel/sdei.c              | 21 +++++-
 arch/arm64/kvm/hyp/Makefile           |  3 +-
 drivers/firmware/efi/libstub/Makefile |  3 +-
 include/linux/stackleak.h             |  1 +
 11 files changed, 165 insertions(+), 24 deletions(-)

-- 
2.17.1
