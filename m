From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/3] x86/asm: More pinning
Date: Tue, 26 Feb 2019 15:36:44 -0800
Message-Id: <20190226233647.28547-1-keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This adds CR0 pinning (for WP), and cleans up the CR4 pin to avoid
taking an exception from WARN before fixing up the desired pin.
Additionally adds lkdtm test (which depends on the CR4 patch, otherwise
I'd send it via Greg's tree).

Thanks!

-Kees

Kees Cook (3):
  x86/asm: Pin sensitive CR0 bits
  x86/asm: Avoid taking an exception before cr4 restore
  lkdtm: Check for SMEP clearing protections

 arch/x86/include/asm/special_insns.h | 33 +++++++++++++--
 drivers/misc/lkdtm/bugs.c            | 60 ++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c            |  1 +
 drivers/misc/lkdtm/lkdtm.h           |  1 +
 4 files changed, 91 insertions(+), 4 deletions(-)

-- 
2.17.1
