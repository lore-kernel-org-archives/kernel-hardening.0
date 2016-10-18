Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Tue, 18 Oct 2016 15:01:27 -0700
Message-Id: <1476828091-17802-1-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] [PATCHv3 0/4] WX checking for arm64
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is v3 of the implementation to check for writable and executable pages on
arm64. This is a basically a rebase + acks.

Laura Abbott (4):
  arm64: dump: Make ptdump debugfs a separate option
  arm64: dump: Make the page table dumping seq_file optional
  arm64: dump: Remove max_addr
  arm64: dump: Add checking for writable and exectuable pages

 arch/arm64/Kconfig.debug           |  35 ++++++++++++-
 arch/arm64/include/asm/ptdump.h    |  22 +++++---
 arch/arm64/mm/Makefile             |   3 +-
 arch/arm64/mm/dump.c               | 104 +++++++++++++++++++++++++++----------
 arch/arm64/mm/mmu.c                |   2 +
 arch/arm64/mm/ptdump_debugfs.c     |  31 +++++++++++
 drivers/firmware/efi/arm-runtime.c |   5 +-
 7 files changed, 163 insertions(+), 39 deletions(-)
 create mode 100644 arch/arm64/mm/ptdump_debugfs.c

-- 
2.7.4
