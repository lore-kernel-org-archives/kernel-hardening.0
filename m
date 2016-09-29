Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@redhat.com>
Date: Thu, 29 Sep 2016 14:32:54 -0700
Message-Id: <20160929213257.30505-1-labbott@redhat.com>
Subject: [kernel-hardening] [PATCH 0/3] WX Checking for arm64
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


Hi,

This is an implementation to check for writable and executable pages on arm64.
This is heavily based on the x86 version which uses the existing page table
dumping code to do the checking. Some notes:

- The W^X checking is important so this option should become defaut eventually.
  To make this feasible, the debugfs functionality has been split out as a
  separate option. I didn't see a good way to make it modular like x86 but
  an option should be good enough.
- This checks all page tables registered with ptdump_register. I don't see this
  being called elsewhere right now though.
- Once this is merged, I'd like to see about moving DEBUG_WX to the top level
  instead of having each arch call it in mark_rodata.

Laura Abbott (3):
  arm64: dump: Make ptdump debugfs a separate option
  arm64: dump: Make the page table dumping seq_file optional
  arm64: dump: Add checking for writable and exectuable pages

 arch/arm64/Kconfig.debug        | 34 ++++++++++++++-
 arch/arm64/include/asm/ptdump.h | 25 ++++++++++-
 arch/arm64/mm/Makefile          |  3 +-
 arch/arm64/mm/dump.c            | 92 ++++++++++++++++++++++++++++-------------
 arch/arm64/mm/mmu.c             |  2 +
 arch/arm64/mm/ptdump_debugfs.c  | 33 +++++++++++++++
 6 files changed, 157 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/mm/ptdump_debugfs.c

-- 
2.10.0
