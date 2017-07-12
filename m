From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Jul 2017 15:44:13 +0100
Message-Id: <20170712144424.19528-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 00/10] arm64: allow virtually mapped stacks to be enabled
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
Cc: mark.rutland@arm.com, labbott@fedoraproject.org, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is a fairly quick'n'dirty attempt at enabling virtually mapped
stacks for arm64, after learning from Mark yesterday that progress
had more or less stalled on that front.

Since having actual patches to poke at is infinitely better than having
abstract discussions about how to approach it, I threw some code together
that:
1. frees up sp_el0 by promoting register x18 to 'current' pointer while in
   the kernel; flames welcome :-) (#7)
2. preparatory work to allow 1., i.e., to free up x18 and preserve/restore it
   correctly as a platform register (#2, #3, #4, #5, #6)
3. dump the entire task stack if regs->sp points elsewhere (#8)
4. add the code that checks for a stack overflow and dumps the task context
   before panic()king (#9, #10)

(#1 is an unrelated cleanup patch for copy_page())

So instead of unconditionally switching between stacks, this code simply uses
tpidrro_el0 and sp_el0 as scratch registers in the entry-from-el1 code so that
we have a couple of general purpose registers to play with.

Tested with the following hunk applied

--- a/arch/arm64/crypto/aes-cipher-core.S
+++ b/arch/arm64/crypto/aes-cipher-core.S
@@ -102,6 +102,11 @@ CPU_BE(    rev             w7, w7          )
 
        .align          5
 ENTRY(__aes_arm64_encrypt)
+       stp             x29, x30, [sp, #-400]!
+       mov             x29, sp
+
+       bl              __aes_arm64_encrypt
+
        do_crypt        fround, crypto_ft_tab, crypto_fl_tab
 ENDPROC(__aes_arm64_encrypt)
 
which produces the output below at boot (provided that CONFIG_CRYPTO_AES_ARM64=y
and CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set). Note that the call stack is
missing: I suppose it should be possible to display something meaningful if x29
still points to a valid location, but I haven't looked into it yet.

  BUG: stack guard page was hit at ffff000009bdbf90 (stack is ffff000009bdc000..ffff000009bdffff)
  Internal error: Oops: 96000047 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 0 PID: 613 Comm: cryptomgr_test Not tainted 4.12.0-rc4-00119-g1fb2159e248e-dirty #520
  Hardware name: linux,dummy-virt (DT)
  task: ffff80007c031a00 task.stack: ffff000009bdc000
  PC is at __aes_arm64_encrypt+0x0/0x440
  LR is at __aes_arm64_encrypt+0xc/0x440
  pc : [<ffff0000080c5760>] lr : [<ffff0000080c576c>] pstate: 80000145
  sp : ffff000009bdc120
  x29: ffff000009bdc120 x28: ffff80007c181c00 
  x27: 0000000000000000 x26: 0000000000000100 
  x25: ffff0000089a52e8 x24: ffff000009bdfd10 
  x23: 0000000000000001 x22: ffff0000089a5408 
  x21: 0000000000000001 x20: ffff80007c181c08 
  x19: ffff80007c220000 x18: ffff80007c031a00 
  x17: 00000000002f0000 x16: ffff80007c181d24 
  x15: ffff0000089b2a68 x14: 00000000000003be 
  x13: 0000000000000071 x12: 00000000bf5fe8a9 
  x11: 0000000000000028 x10: 000000000000002c 
  x9 : ffff80007c181d20 x8 : 000000000000001b 
  x7 : 0000000046d4609c x6 : ffff0000080c5fd8 
  x5 : 0000000000000043 x4 : 0000000046d47b87 
  x3 : 000000000000000a x2 : ffff80007c220000 
  x1 : ffff80007c220000 x0 : ffff80007c181c80 
  Process cryptomgr_test (pid: 613, stack limit = 0xffff000009bdc000)
  Stack: (0xffff000009bdc120 to 0xffff000009be0000)
  c120: ffff000009bdc2b0 ffff0000080c576c 0000000000000000 0000000000000000
  c140: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  <snipped ...>
  ffc0: 0000000000000000 0000000000000005 0000000000000000 0000000000000000
  ffe0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  Call trace:
  Exception stack(0xffff80007efd0ad0 to 0xffff80007efd0c00)
  0ac0:                                   ffff80007c220000 0001000000000000
  0ae0: ffff80007efd0ca0 ffff0000080c5760 0000000000000000 0000000000000000
  0b00: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  0b20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  0b40: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
  0b60: 0000000000000000 0000000000000000 ffff80007c181c80 ffff80007c220000
  0b80: ffff80007c220000 000000000000000a 0000000046d47b87 0000000000000043
  0ba0: ffff0000080c5fd8 0000000046d4609c 000000000000001b ffff80007c181d20
  0bc0: 000000000000002c 0000000000000028 00000000bf5fe8a9 0000000000000071
  0be0: 00000000000003be ffff0000089b2a68 ffff80007c181d24 00000000002f0000
  [<ffff0000080c5760>] __aes_arm64_encrypt+0x0/0x440
  Code: 00000000 00000000 00000000 00000000 (a9a77bfd) 
  ---[ end trace 2c6304a96ec827cb ]---

Ard Biesheuvel (10):
  arm64/lib: copy_page: use consistent prefetch stride
  arm64/lib: copy_page: avoid x18 register in assembler code
  arm64: crypto: avoid register x18 in scalar AES code
  arm64: kvm: stop treating register x18 as caller save
  arm64: kernel: avoid x18 as an arbitrary temp register
  arm64: kbuild: reserve reg x18 from general allocation by the compiler
  arm64: kernel: switch to register x18 as a task struct pointer
  arm64/kernel: dump entire stack if sp points elsewhere
  arm64: mm: add C level handling for stack overflows
  arm64: kernel: add support for virtually mapped stacks

 arch/arm64/Kconfig                   |  1 +
 arch/arm64/Makefile                  |  2 +-
 arch/arm64/crypto/aes-cipher-core.S  | 55 ++++++++---------
 arch/arm64/include/asm/asm-uaccess.h |  3 +-
 arch/arm64/include/asm/assembler.h   |  8 +--
 arch/arm64/include/asm/current.h     |  6 +-
 arch/arm64/include/asm/thread_info.h |  2 +
 arch/arm64/kernel/cpu-reset.S        |  4 +-
 arch/arm64/kernel/entry.S            | 63 ++++++++++++++++----
 arch/arm64/kernel/head.S             |  6 +-
 arch/arm64/kernel/process.c          |  2 +-
 arch/arm64/kernel/traps.c            |  9 ++-
 arch/arm64/kvm/hyp/entry.S           | 12 ++--
 arch/arm64/lib/Makefile              |  3 +-
 arch/arm64/lib/copy_page.S           | 47 ++++++++-------
 arch/arm64/mm/fault.c                | 24 ++++++++
 16 files changed, 154 insertions(+), 93 deletions(-)

-- 
2.9.3
