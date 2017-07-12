From: Mark Rutland <mark.rutland@arm.com>
Date: Wed, 12 Jul 2017 23:32:57 +0100
Message-Id: <1499898783-25732-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 0/6] arm64: alternative VMAP_STACK implementation
To: ard.biesheuvel@linaro.org, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: akashi.takahiro@linaro.org, catalin.marinas@arm.com, dave.martin@arm.com, james.morse@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, keescook@chromium.org, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

While reviewing Ard's VMAP_STACK series [1], I tried to put together some notes
based on my prior aborted attempts, and tricked myself into turning them into
this series. I suspect we'll want bits of both.

Like Ard's series, this doesn't use EL1t mode, and instead performs a check
early in el1_sync. However, there are a few differences:

* This series frees up SP_EL0, and inverts the current<->percpu relationship
  rather than using a GPR for current.

* The out-of-bounds detection *only* considers the SP. Stray accesses below the
  SP will be handled as regular faults, unless handling these triggers a stack
  overflow. 

* There is a dedicated handler for the stack out-of-bounds case (as with x86),
  rather than piggy-backing on the usual fault handling code.

* The overflow checks consider IRQ stacks, by keeping track of which stack a
  task is currently using. This assumes all stacks are the same size (which
  happens to be true today), but we should make that explicit by using common
  definitions. Thanks to James Morse for pointing out that we need to handle
  this.

Currently the IRQ stacks don't have a guaranteed guard pages, as they're
regular compile-time percpu reservations. We'll want to rework those so that
they have guards.

I haven't audited the backtracing code, but I suspect we'll need to fix up any
stack walking code up so that it understands there are now three possible
stacks that a task may be using, and so that we can walk emergency->irq->task
stack traces.

Otherwise, this series is rough around the seams, and has seen only the most
trivial of testing on a Juno platform (booting 4K and 64K kernels with and
without a deliberate overflow).

I've pushed the series out to my git repo as arm64/vmap-stack [2].

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-July/518368.html
[2] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/vmap-stack

Mark Rutland (6):
  arm64: use tpidr_el1 for current, free sp_el0
  arm64: avoid open-coding THREAD_SIZE{,_ORDER}
  arm64: pad stacks to PAGE_SIZE for VMAP_STACK
  arm64: pass stack base to secondary_start_kernel
  arm64: keep track of current stack
  arm64: add VMAP_STACK and detect out-of-bounds SP

 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/assembler.h   | 11 +++++--
 arch/arm64/include/asm/current.h     |  6 ++--
 arch/arm64/include/asm/percpu.h      | 15 +++------
 arch/arm64/include/asm/thread_info.h | 22 ++++++++++---
 arch/arm64/kernel/asm-offsets.c      |  4 +++
 arch/arm64/kernel/entry.S            | 61 ++++++++++++++++++++++++++++++------
 arch/arm64/kernel/head.S             | 13 ++++++--
 arch/arm64/kernel/process.c          | 20 +++++-------
 arch/arm64/kernel/smp.c              |  2 +-
 arch/arm64/kernel/traps.c            | 21 +++++++++++++
 11 files changed, 130 insertions(+), 46 deletions(-)

-- 
1.9.1
