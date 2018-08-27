Date: Mon, 27 Aug 2018 20:56:24 +0200
Message-Id: <20180827185631.163506-1-jannh@google.com>
Mime-Version: 1.0
Subject: [PATCH v2 0/7] x86: BUG() on #GP / kernel #PF in uaccess
From: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, jannh@google.com
Cc: linux-kernel@vger.kernel.org, dvyukov@google.com, linux-edac@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This is the second version of "[RFC PATCH 1/2] x86: WARN() when uaccess
helpers fault on kernel addresses".

See patch 6/7 ("x86: BUG() when uaccess helpers fault on kernel
addresses") for a description of the motivation for this series.

Patches 1 and 2 are cleanups that I did while working on this
series, but the series doesn't depend on them. (I first thought these
cleanups were necessary for the rest of the series, then noticed that
they actually aren't, but decided to keep them since cleanups are good
anyway.)

Patches 3, 4 and 5 are prep work; 4 and 5 are loosely based on code
from the v1 patch. They've changed quite a bit though.

Patch 6 is the main semantic change.

Patch 7 is a small testcase for verifying that patch 6 works.

Jann Horn (7):
  x86: refactor kprobes_fault() like kprobe_exceptions_notify()
  x86: inline kprobe_exceptions_notify() into do_general_protection()
  x86: stop calling fixup_exception() from kprobe_fault_handler()
  x86: introduce _ASM_EXTABLE_UA for uaccess fixups
  x86: plumb error code and fault address through to fault handlers
  x86: BUG() when uaccess helpers fault on kernel addresses
  lkdtm: test copy_to_user() on bad kernel pointer under KERNEL_DS

 arch/x86/include/asm/asm.h          |  10 ++-
 arch/x86/include/asm/extable.h      |   3 +-
 arch/x86/include/asm/fpu/internal.h |   2 +-
 arch/x86/include/asm/futex.h        |   6 +-
 arch/x86/include/asm/ptrace.h       |   2 +
 arch/x86/include/asm/uaccess.h      |  22 ++---
 arch/x86/kernel/cpu/mcheck/mce.c    |   2 +-
 arch/x86/kernel/kprobes/core.c      |  38 +--------
 arch/x86/kernel/traps.c             |  16 +++-
 arch/x86/lib/checksum_32.S          |   4 +-
 arch/x86/lib/copy_user_64.S         |  90 ++++++++++----------
 arch/x86/lib/csum-copy_64.S         |   8 +-
 arch/x86/lib/getuser.S              |  12 +--
 arch/x86/lib/putuser.S              |  10 +--
 arch/x86/lib/usercopy_32.c          | 126 ++++++++++++++--------------
 arch/x86/lib/usercopy_64.c          |   4 +-
 arch/x86/mm/extable.c               | 104 +++++++++++++++++++----
 arch/x86/mm/fault.c                 |  21 ++---
 drivers/misc/lkdtm/core.c           |   1 +
 drivers/misc/lkdtm/lkdtm.h          |   1 +
 drivers/misc/lkdtm/usercopy.c       |  13 +++
 include/linux/sched.h               |   6 ++
 mm/maccess.c                        |   6 ++
 23 files changed, 297 insertions(+), 210 deletions(-)

-- 
2.19.0.rc0.228.g281dcd1b4d0-goog
