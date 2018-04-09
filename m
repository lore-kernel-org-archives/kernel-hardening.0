From: kpark3469@gmail.com
Subject: [PATCH v2 0/3] usercopy: reimplement arch_within_stack_frames
Date: Mon,  9 Apr 2018 10:06:06 +0400
Message-Id: <1523253969-31699-1-git-send-email-kpark3469@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: catalin.marinas@arm.com, keescook@chromium.org, will.deacon@arm.com, mark.rutland@arm.com, james.morse@arm.com, panand@redhat.com, keun-o.park@darkmatter.ae, psodagud@codeaurora.org, jpoimboe@redhat.com, mingo@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

This series of patches introduce the arm64 arch_within_stack_frames
implementation using stacktrace functions. Also the base code is
moved from thread_info.h to stacktrace.h. x86 code is reimplemented
to use frame pointer unwinder functions.

Note: The code is still missing in case of using x86 ORC unwinder and
guess unwinder.

v2 changes:
 - Remove 'arm64: usercopy: consider dynamic array stack variable'
 - minor fix in x86 arch_within_stack_frames code.

James Morse (1):
  arm64: usercopy: implement arch_within_stack_frames

Sahara (2):
  stacktrace: move arch_within_stack_frames from thread_info.h
  x86: usercopy: reimplement arch_within_stack_frames with unwinder

 arch/arm/kernel/stacktrace.c       |  1 -
 arch/arm64/Kconfig                 |  1 +
 arch/arm64/kernel/stacktrace.c     | 77 ++++++++++++++++++++++++++++++++-
 arch/mips/kernel/stacktrace.c      |  1 -
 arch/mips/oprofile/backtrace.c     |  1 -
 arch/sh/kernel/stacktrace.c        |  1 -
 arch/sparc/kernel/stacktrace.c     |  1 -
 arch/um/kernel/stacktrace.c        |  1 -
 arch/unicore32/kernel/process.c    |  1 -
 arch/unicore32/kernel/stacktrace.c |  2 -
 arch/x86/include/asm/thread_info.h | 51 +---------------------
 arch/x86/include/asm/unwind.h      |  5 +++
 arch/x86/kernel/Makefile           |  2 +-
 arch/x86/kernel/stacktrace.c       | 88 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/unwind_frame.c     |  4 +-
 arch/xtensa/kernel/stacktrace.c    |  1 -
 include/linux/page_ext.h           |  1 -
 include/linux/stacktrace.h         | 25 +++++++++++
 include/linux/thread_info.h        | 21 ---------
 kernel/sysctl.c                    |  1 -
 mm/usercopy.c                      |  2 +-
 21 files changed, 198 insertions(+), 90 deletions(-)

-- 
2.7.4
