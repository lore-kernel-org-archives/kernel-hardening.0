From: Alexander Popov <alex.popov@linux.com>
Date: Sun, 22 Oct 2017 03:22:48 +0300
Message-Id: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
Subject: [kernel-hardening] [PATCH RFC v5 0/5] Introduce the STACKLEAK feature and a test for it
To: kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, x86@kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

This is the 5th version of the patch series introducing STACKLEAK to the
mainline kernel. STACKLEAK is a security feature developed by Grsecurity/PaX
(kudos to them), which:
 - reduces the information that can be revealed through kernel stack leak bugs;
 - blocks some uninitialized stack variable attacks (e.g. CVE-2010-2963);
 - introduces some runtime checks for kernel stack overflow detection.

STACKLEAK instrumentation statistics
====================================

These numbers were obtained for the 4th version of the patch series.

Size of vmlinux (x86_64_defconfig):
 file size:
  - STACKLEAK disabled: 35014784 bytes
  - STACKLEAK enabled: 35044952 bytes (+0.086%)
 .text section size (calculated by size utility):
  - STACKLEAK disabled: 10752983
  - STACKLEAK enabled: 11062221 (+2.876%)

The readelf utility shows 45602 functions in vmlinux. The STACKLEAK gcc plugin
inserted 36 check_alloca() calls and 1265 track_stack() calls (42274 calls are
inserted during GIMPLE pass and 41009 calls are deleted during RTL pass).
So 2.853% of functions are instrumented.

Further work
=============

 - Think of erasing stack on the way out of exception handlers (idea by
   Andy Lutomirski).
 - Rewrite erase_kstack() in C (if Ingo Molnar insists).
 - Think of erasing the kernel stack after invoking EFI runtime services
   (idea by Mark Rutland).
 - Try to port STACKLEAK to arm64 (Laura Abbott is working on it).

Changes in v5 (mostly according to the feedback from Ingo Molnar)
=================================================================

1. Introduced the CONFIG_STACKLEAK_METRICS providing STACKLEAK information
   about tasks via the /proc file system. That information can be useful for
   estimating the STACKLEAK performance impact for different workloads.
   In particular, /proc/<pid>/lowest_stack shows the current lowest_stack
   value and its final value from the previous syscall.

2. Introduced a single check_alloca() implementation working for both
   x86_64 and x86_32.

3. Fixed coding style issues and did some refactoring in the STACKLEAK
   gcc plugin.

4. Put the gcc plugin and the kernel stack erasing into separate (working)
   patches.

Changes in v4
=============

1. Introduced the CONFIG_STACKLEAK_TRACK_MIN_SIZE parameter instead of
   hard-coded track-lowest-sp.

2. Carefully looked into the assertions in track_stack() and check_alloca().
    - Fixed the incorrect BUG() condition in track_stack(), thanks to Tycho
       Andersen. Also disabled that check if CONFIG_VMAP_STACK is enabled.
    - Fixed the surplus and erroneous code for calculating stack_left in
       check_alloca() on x86_64. That code repeats the work which is already
       done in get_stack_info() and it misses the fact that different
       exception stacks on x86_64 have different size.

3. Introduced two lkdtm tests for the STACKLEAK feature (developed together
   with Tycho Andersen).

4. Added info about STACKLEAK to Documentation/security/self-protection.rst.

5. Improved the comments.

6. Decided not to change "unsigned long sp = (unsigned long)&sp" to
   current_stack_pointer. The original variant is more platform independent
   since current_stack_pointer has different type on x86 and arm.

Changes in v3
=============

1. Added the detailed comments describing the STACKLEAK gcc plugin.
   Read the plugin from the bottom up, like you do for Linux kernel drivers.
   Additional information:
    - gcc internals documentation available from gcc sources;
    - wonderful slides by Diego Novillo
       https://www.airs.com/dnovillo/200711-GCC-Internals/
    - nice introduction to gcc plugins at LWN
       https://lwn.net/Articles/457543/

2. Improved the commit message and Kconfig description according to the
   feedback from Kees Cook. Also added the original notice describing
   the performance impact of the STACKLEAK feature.

3. Removed the arch-specific ix86_cmodel check in stackleak_track_stack_gate().
   It caused skipping the kernel code instrumentation for i386.

4. Fixed a minor mistake in stackleak_tree_instrument_execute().
   First versions of the plugin used ENTRY_BLOCK_PTR_FOR_FN(cfun)->next_bb
   to get the basic block with the function prologue. That was not correct
   since the control flow graph edge from ENTRY_BLOCK_PTR doesn't always
   go to that basic block.

   So later it was changed to single_succ(ENTRY_BLOCK_PTR_FOR_FN(cfun)),
   but not completely. next_bb was still used for entry_bb assignment,
   which could cause the wrong value of the prologue_instrumented variable.

   I've reported this issue to Grsecurity and proposed the fix for it, but
   unfortunately didn't get any reply.

5. Introduced the STACKLEAK_POISON macro and renamed the config option
   according to the feedback from Kees Cook.


Alexander Popov (5):
  x86/entry: Add STACKLEAK erasing the kernel stack at the end of
    syscalls
  gcc-plugins: Add STACKLEAK plugin for tracking the kernel stack
  lkdtm: Add a test for STACKLEAK
  fs/proc: Show STACKLEAK metrics in the /proc file system
  doc: self-protection: Add information about STACKLEAK feature

 Documentation/security/self-protection.rst |  23 +-
 arch/Kconfig                               |  50 +++
 arch/x86/Kconfig                           |   1 +
 arch/x86/entry/common.c                    |  17 +-
 arch/x86/entry/entry_32.S                  |  73 +++++
 arch/x86/entry/entry_64.S                  |  99 ++++++
 arch/x86/entry/entry_64_compat.S           |   8 +
 arch/x86/include/asm/processor.h           |   7 +
 arch/x86/kernel/asm-offsets.c              |  12 +
 arch/x86/kernel/dumpstack.c                |  15 +
 arch/x86/kernel/process_32.c               |   8 +
 arch/x86/kernel/process_64.c               |   8 +
 drivers/misc/Makefile                      |   3 +
 drivers/misc/lkdtm.h                       |   4 +
 drivers/misc/lkdtm_core.c                  |   2 +
 drivers/misc/lkdtm_stackleak.c             | 139 +++++++++
 fs/exec.c                                  |  30 ++
 fs/proc/base.c                             |  14 +
 include/linux/compiler.h                   |   4 +
 scripts/Makefile.gcc-plugins               |   3 +
 scripts/gcc-plugins/stackleak_plugin.c     | 470 +++++++++++++++++++++++++++++
 21 files changed, 978 insertions(+), 12 deletions(-)
 create mode 100644 drivers/misc/lkdtm_stackleak.c
 create mode 100644 scripts/gcc-plugins/stackleak_plugin.c

-- 
2.7.4
