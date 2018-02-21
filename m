From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 0/2] Stackleak for arm64
Date: Tue, 20 Feb 2018 17:13:01 -0800
Message-Id: <20180221011303.20392-1-labbott@redhat.com>
In-Reply-To: <dc76a745-3fa7-4023-dcc1-3df18c9461a6@redhat.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This is the arm64 version of the STACKLEAK plugin originall from
grsecurity. See
https://marc.info/?l=kernel-hardening&m=151880470609808 for the
full x86 version. This is based on top of Kees' branch for stackleak
and has been cleaned up to use a few macros from that branch.

Comments welcome, if there are no major objections Kees will queue this
up to get some CI testing. This passed both of the LKDTM tests.

Laura Abbott (2):
  stackleak: Update for arm64
  arm64: Clear the stack

 arch/arm64/Kconfig                     |   1 +
 arch/arm64/include/asm/processor.h     |   6 ++
 arch/arm64/kernel/asm-offsets.c        |   3 +
 arch/arm64/kernel/entry.S              | 108 +++++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c            |  16 +++++
 drivers/firmware/efi/libstub/Makefile  |   3 +-
 scripts/Makefile.gcc-plugins           |   5 +-
 scripts/gcc-plugins/stackleak_plugin.c |   5 ++
 8 files changed, 145 insertions(+), 2 deletions(-)

-- 
2.14.3
