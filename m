From: Laura Abbott <labbott@redhat.com>
Date: Mon, 10 Jul 2017 15:04:41 -0700
Message-Id: <1499724283-30719-1-git-send-email-labbott@redhat.com>
In-Reply-To: <2ade4e6b-fb40-091e-28eb-343a08925649@redhat.com>
Subject: [kernel-hardening] [RFC][PATCH 0/2] draft of stack clearing for arm64
To: Kees Cook <keescook@chromium.org>, Alex Popov <alex.popov@linux.com>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

I made an attempt at implementing stack clearing for arm64 using roughly
the same algorithm as x86. It passes some level of basic tests but it definitely
needs more careful review and thought ("submit early and often").

As an added follow up, self-protection.rst should also be updated with some
details about how stackleak actually works for people who want to follow on
for other arches.

Laura Abbott (2):
  stackleak: Update for arm64
  arm64: Clear the stack

 arch/arm64/Kconfig                     |  1 +
 arch/arm64/include/asm/processor.h     |  3 ++
 arch/arm64/kernel/asm-offsets.c        |  3 ++
 arch/arm64/kernel/entry.S              | 92 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/process.c            | 18 +++++++
 drivers/firmware/efi/libstub/Makefile  |  3 +-
 scripts/Makefile.gcc-plugins           |  5 +-
 scripts/gcc-plugins/stackleak_plugin.c | 25 +++++++--
 8 files changed, 143 insertions(+), 7 deletions(-)

-- 
2.7.5
