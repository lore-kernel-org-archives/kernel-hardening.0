From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH v11 0/6] Introduce the STACKLEAK feature and a test for it
Date: Fri,  6 Apr 2018 17:22:20 +0300
Message-Id: <1523024546-6150-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, x86@kernel.org, linux-kernel@vger.kernel.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

This is the 11th version of the patch series introducing STACKLEAK to the
mainline kernel. The 9th version raised a fervent discussion[0].
The assembly code introduced by that version irritated the reviewers.

I've found the way to bypass the obstacles[1] of the C implementation.
So I dare come again. Let me ask you to look at this code without
preconception.

Motivation
==========

STACKLEAK (initially developed by PaX Team):

 1. reduces the information that can be revealed through kernel stack leak bugs.
    The idea of erasing the thread stack at the end of syscalls is similar to
    CONFIG_PAGE_POISONING and memzero_explicit() in kernel crypto, which all
    comply with FDP_RIP.2 (Full Residual Information Protection) of the
    Common Criteria standard.

 2. blocks some uninitialized stack variable attacks (e.g. CVE-2017-17712,
    CVE-2010-2963). That kind of bugs should be killed by improving C compilers
    in future, which might take a long time.

 3. blocks stack depth overflow caused by alloca (aka Stack Clash attack).
    That is orthogonal to the mainline kernel VLA cleanup and protects
    un-upstreamed code.

Performance impact
==================

Hardware: Intel Core i7-4770, 16 GB RAM

Test #1: building the Linux kernel on a single core
	0.91% slowdown

Test #2: hackbench -s 4096 -l 2000 -g 15 -f 25 -P
	4.2% slowdown

So the STACKLEAK description in Kconfig includes:
"The tradeoff is the performance impact: on a single CPU system kernel
compilation sees a 1% slowdown, other systems and workloads may vary and you are
advised to test this feature on your expected workload before deploying it".

Links
=====

[0] http://www.openwall.com/lists/kernel-hardening/2018/03/03/7
[1] http://www.openwall.com/lists/kernel-hardening/2018/03/21/4


Alexander Popov (6):
  gcc-plugins: Clean up the cgraph_create_edge* macros
  x86/entry: Add STACKLEAK erasing the kernel stack at the end of
    syscalls
  gcc-plugins: Add STACKLEAK plugin for tracking the kernel stack
  lkdtm: Add a test for STACKLEAK
  fs/proc: Show STACKLEAK metrics in the /proc file system
  doc: self-protection: Add information about STACKLEAK feature

 Documentation/security/self-protection.rst |  23 +-
 Documentation/x86/x86_64/mm.txt            |   2 +
 arch/Kconfig                               |  53 ++++
 arch/x86/Kconfig                           |   1 +
 arch/x86/entry/Makefile                    |   3 +
 arch/x86/entry/calling.h                   |  14 +
 arch/x86/entry/entry_32.S                  |   7 +
 arch/x86/entry/entry_64.S                  |   3 +
 arch/x86/entry/entry_64_compat.S           |   5 +
 arch/x86/entry/erase.c                     |  58 ++++
 arch/x86/include/asm/processor.h           |   7 +
 arch/x86/kernel/dumpstack.c                |  19 ++
 arch/x86/kernel/process_32.c               |   8 +
 arch/x86/kernel/process_64.c               |   8 +
 drivers/misc/Makefile                      |   3 +
 drivers/misc/lkdtm.h                       |   4 +
 drivers/misc/lkdtm_core.c                  |   2 +
 drivers/misc/lkdtm_stackleak.c             | 141 +++++++++
 fs/proc/base.c                             |  18 ++
 include/linux/compiler.h                   |   4 +
 mm/util.c                                  |  33 ++
 scripts/Makefile.gcc-plugins               |   3 +
 scripts/gcc-plugins/gcc-common.h           |  26 +-
 scripts/gcc-plugins/stackleak_plugin.c     | 470 +++++++++++++++++++++++++++++
 24 files changed, 896 insertions(+), 19 deletions(-)
 create mode 100644 arch/x86/entry/erase.c
 create mode 100644 drivers/misc/lkdtm_stackleak.c
 create mode 100644 scripts/gcc-plugins/stackleak_plugin.c

-- 
2.7.4
