Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Thu, 27 Oct 2016 09:27:30 -0700
Message-Id: <1477585654-8908-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [PATCHv4 0/4] WX checking for arm64
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is v4 of the implementation to check for writable and executable pages on
arm64. This version contains a review from Ard and makes the UXN page count
a separate variable. Overall, minor changes.

Thanks,
Laura

Laura Abbott (4):
  arm64: dump: Make ptdump debugfs a separate option
  arm64: dump: Make the page table dumping seq_file optional
  arm64: dump: Remove max_addr
  arm64: dump: Add checking for writable and exectuable pages

 arch/arm64/Kconfig.debug           |  35 ++++++++++++-
 arch/arm64/include/asm/ptdump.h    |  22 +++++---
 arch/arm64/mm/Makefile             |   3 +-
 arch/arm64/mm/dump.c               | 105 +++++++++++++++++++++++++++----------
 arch/arm64/mm/mmu.c                |   2 +
 arch/arm64/mm/ptdump_debugfs.c     |  31 +++++++++++
 drivers/firmware/efi/arm-runtime.c |   4 +-
 7 files changed, 164 insertions(+), 38 deletions(-)
 create mode 100644 arch/arm64/mm/ptdump_debugfs.c

-- 
2.7.4
