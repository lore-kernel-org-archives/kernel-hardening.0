From: kpark3469@gmail.com
Subject: [PATCH v4 0/3] usercopy: reimplement arch_within_stack_frames
Date: Tue, 10 Apr 2018 11:30:44 +0400
Message-Id: <1523345447-10725-1-git-send-email-kpark3469@gmail.com>
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
v3 changes:
 - Fix build problem caused by circular inclusion of header in x86 UP config
v4 changes:
 - Fix build problem caused by page_ext.h change

James Morse (1):
  arm64: usercopy: implement arch_within_stack_frames

Sahara (2):
  stacktrace: move arch_within_stack_frames from thread_info.h
  x86: usercopy: reimplement arch_within_stack_frames with unwinder

 arch/arm64/Kconfig                 |  1 +
 arch/arm64/kernel/stacktrace.c     | 76 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/thread_info.h | 51 +---------------------
 arch/x86/include/asm/unwind.h      |  5 +++
 arch/x86/kernel/Makefile           |  2 +-
 arch/x86/kernel/stacktrace.c       | 87 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/unwind_frame.c     |  4 +-
 include/linux/stacktrace.h         | 24 +++++++++++
 include/linux/thread_info.h        | 21 ---------
 mm/usercopy.c                      |  2 +-
 10 files changed, 197 insertions(+), 76 deletions(-)

-- 
2.7.4
