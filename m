From: Laura Abbott <labbott@redhat.com>
Subject: [PATCH 0/2] Stackleak for arm64
Date: Wed,  2 May 2018 13:33:24 -0700
Message-Id: <20180502203326.9491-1-labbott@redhat.com>
In-Reply-To: <1523024546-6150-1-git-send-email-alex.popov@linux.com>
To: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This is an extension of the arm64 stackleak plugin, based on top of the
v11 version for x86. The biggest change from the previous version is the
conversion from assembly to C. It's mostly taken straight from the x86
version modulo a few cleanups and seems to work just fine. If this gets
Acks, I'd like Kees to start carrying in his tree for -next.

Laura Abbott (2):
  stackleak: Update for arm64
  arm64: Clear the stack

 arch/arm64/Kconfig                     |  1 +
 arch/arm64/include/asm/processor.h     |  6 ++++
 arch/arm64/kernel/Makefile             |  3 ++
 arch/arm64/kernel/entry.S              |  6 ++++
 arch/arm64/kernel/erase.c              | 55 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c            | 16 ++++++++++
 drivers/firmware/efi/libstub/Makefile  |  3 +-
 scripts/Makefile.gcc-plugins           |  5 +++-
 scripts/gcc-plugins/stackleak_plugin.c |  4 +++
 9 files changed, 97 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kernel/erase.c

-- 
2.14.3
