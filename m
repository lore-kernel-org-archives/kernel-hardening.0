From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [RFC PATCH] Early version of thread stack randomization
Date: Fri,  8 Feb 2019 14:15:48 +0200
Message-Id: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
To: kernel-hardening@lists.openwall.com
Cc: luto@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, peterz@infradead.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

I would really like to get an early feedback and opinions
on this stack randomization feature since there are many
ways on how this can be developed further, and I want to
hear all the opinions and objections first.

This is based on my 4.20 stable branch, compiles, boots
and can be played with.
I also have a repo for this, if it is more convenient
for anyone.


Elena Reshetova (1):
  x86/entry/64: randomize kernel stack offset upon system call

 arch/Kconfig                     | 15 +++++++++++++++
 arch/x86/Kconfig                 |  1 +
 arch/x86/entry/calling.h         |  8 ++++++++
 arch/x86/entry/common.c          | 21 +++++++++++++++++++++
 arch/x86/entry/entry_64.S        |  4 ++++
 arch/x86/include/asm/processor.h | 15 ++++++++++++---
 arch/x86/kernel/dumpstack.c      |  2 +-
 arch/x86/kernel/irq_64.c         |  2 +-
 arch/x86/kernel/process.c        |  2 +-
 include/linux/sched.h            |  3 +++
 include/linux/sched/task_stack.h | 18 +++++++++++++++++-
 kernel/fork.c                    | 10 ++++++++++
 mm/kmemleak.c                    |  2 +-
 mm/usercopy.c                    |  2 +-
 14 files changed, 96 insertions(+), 9 deletions(-)

-- 
2.7.4
