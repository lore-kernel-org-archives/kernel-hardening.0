From: kpark3469@gmail.com
Subject: [PATCH 0/4] usercopy: reimplement arch_within_stack_frames
Date: Thu,  1 Mar 2018 14:19:47 +0400
Message-Id: <1519899591-29761-1-git-send-email-kpark3469@gmail.com>
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, james.morse@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, mark.rutland@arm.com, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

From: Sahara <keun-o.park@darkmatter.ae>

This series of patches introduce the arm64 arch_within_stack_frames
implementation using stacktrace functions. Also the base code is
moved from thread_info.h to stacktrace.h. x86 code is reimplemented
to use frame pointer unwinder functions.

Note: The code is still missing in case of using x86 ORC unwinder and
guess unwinder.

James Morse (1):
  arm64: usercopy: implement arch_within_stack_frames

Sahara (3):
  stacktrace: move arch_within_stack_frames from thread_info.h
  arm64: usercopy: consider dynamic array stack variable
  x86: usercopy: reimplement arch_within_stack_frames with unwinder

 arch/arm/kernel/stacktrace.c       |  1 -
 arch/arm64/Kconfig                 |  1 +
 arch/arm64/kernel/stacktrace.c     | 82 +++++++++++++++++++++++++++++++++++++-
 arch/cris/kernel/stacktrace.c      |  1 -
 arch/metag/kernel/stacktrace.c     |  2 -
 arch/mips/kernel/stacktrace.c      |  1 -
 arch/sh/kernel/stacktrace.c        |  1 -
 arch/sparc/kernel/stacktrace.c     |  1 -
 arch/um/kernel/stacktrace.c        |  1 -
 arch/unicore32/kernel/process.c    |  1 -
 arch/unicore32/kernel/stacktrace.c |  2 -
 arch/x86/include/asm/thread_info.h | 51 +-----------------------
 arch/x86/include/asm/unwind.h      |  5 +++
 arch/x86/kernel/Makefile           |  2 +-
 arch/x86/kernel/stacktrace.c       | 81 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/unwind_frame.c     |  4 +-
 arch/xtensa/kernel/stacktrace.c    |  1 -
 include/linux/page_ext.h           |  1 -
 include/linux/stacktrace.h         | 25 ++++++++++++
 include/linux/thread_info.h        | 21 ----------
 kernel/sysctl.c                    |  1 -
 mm/usercopy.c                      |  2 +-
 22 files changed, 196 insertions(+), 92 deletions(-)

-- 
2.7.4
