From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 28 Jan 2018 10:38:48 -0800
Message-Id: <cover.1517164461.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 0/3] x86/pti-ish syscall cleanups
To: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Three changes in here:
 - Get rid of the SYSCALL64 fast path as suggested by Linus.

 - Move TS_COMPAT into the same cacheline as thread_info::flags, also
   suggested by Linus.

 - Document SYSCALL_DEFINE a bit better.

Andy Lutomirski (3):
  x86/entry/64: Remove the SYSCALL64 fast path
  x86/asm: Move 'status' from thread_struct to thread_info
  syscalls: Add a bit of documentation to __SYSCALL_DEFINE

 arch/x86/entry/common.c            |   4 +-
 arch/x86/entry/entry_64.S          | 127 ++-----------------------------------
 arch/x86/entry/syscall_64.c        |   7 +-
 arch/x86/include/asm/processor.h   |   2 -
 arch/x86/include/asm/syscall.h     |   6 +-
 arch/x86/include/asm/thread_info.h |   3 +-
 arch/x86/kernel/process_64.c       |   4 +-
 arch/x86/kernel/ptrace.c           |   2 +-
 arch/x86/kernel/signal.c           |   2 +-
 include/linux/syscalls.h           |  10 +++
 10 files changed, 30 insertions(+), 137 deletions(-)

-- 
2.14.3
