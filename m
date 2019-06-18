From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 0/3] x86/asm: Pin sensitive CR4 and CR0 bits
Date: Mon, 17 Jun 2019 21:55:00 -0700
Message-Id: <20190618045503.39105-1-keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This updates the cr pinning series to allow for no silent papering-over
of pinning bugs (thanks to tglx to pointing out where I needed to poke
cr4 harder). I've tested with under normal boot and hibernation.

-Kees

Kees Cook (3):
  lkdtm: Check for SMEP clearing protections
  x86/asm: Pin sensitive CR4 bits
  x86/asm: Pin sensitive CR0 bits

 arch/x86/include/asm/special_insns.h | 37 +++++++++++++++-
 arch/x86/kernel/cpu/common.c         | 20 +++++++++
 arch/x86/kernel/smpboot.c            |  8 +++-
 drivers/misc/lkdtm/bugs.c            | 66 ++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c            |  1 +
 drivers/misc/lkdtm/lkdtm.h           |  1 +
 6 files changed, 130 insertions(+), 3 deletions(-)

--
2.17.1
