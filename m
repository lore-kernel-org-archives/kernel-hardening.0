Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Jul 2016 01:39:28 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 0/3] Introduce the initify gcc plugin
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>

I would like to introduce the initify gcc plugin. The kernel already has
a mechanism to free up code and data memory that is only used during kernel
or module initialization.
This plugin will teach the compiler to find more such code and data that
can be freed after initialization. It reduces memory usage.
The initify gcc plugin can be useful for embedded systems.

It is a CII project supported by the Linux Foundation.

This plugin is the part of grsecurity/PaX.

The plugin supports all gcc versions from 4.5 to 6.0.

I made some changes on top of the PaX version (since March 6.). These are
the important ones:
 * move all local strings to init.rodata.str and exit.rodata.str
   (not just __func__)
 * report all initified strings and functions
   (GCC_PLUGIN_INITIFY_VERBOSE config option)
 * automatically discover init/exit functions and apply the __init or
   __exit attributes on them

You can find more about the changes here:
https://github.com/ephox-gcc-plugins/initify

This patch set is based on the "Add support for complex gcc plugins that
don't fit in a single file" patch set
(https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next.git#initify
HEAD: e08eda5d85f7f52641640).

Some statistics about the plugin:

On allyes config (amd64, gcc-6):
* 7765 initified strings
*  231 initified functions

On allmod config (i386, gcc-6):
* 9177 initified strings
*  288 initified functions

On allyes config (amd64, gcc-6):

section         vanilla                 vanilla + initify        change
-----------------------------------------------------------------------
.rodata		19054824 (0x122c0e8)	18841832 (0x11f80e8)	-212992
.init.data	 1273768  (0x136fa8)	 1583496  (0x182988)	+309728
.text		46126301 (0x2bfd4dd)	46099805 (0x2bf6d5d)	 -26496
.init.text	  836339  (0x0cc2f3)	  855952  (0x0d0f90)	 +19613
.exit.data	     104  (0x000068)	   16736  (0x004160)	 +16632
.exit.text	  125511  (0x01ea47)	  133267  (0x020893)	  +7756

	FileSiz (vanilla)	FileSiz (vanilla + initify)	 change
------------------------------------------------------------------------
00	67727360 (0x4097000)	65417216 (0x3e63000)		-2310144
03	 2453504  (0x257000)	 2809856  (0x2ae000)		 +356352

00     .text .notes __ex_table .rodata __bug_table .pci_fixup .builtin_fw
       .tracedata __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata
       __param __modver
03     .init.text .altinstr_aux .init.data .x86_cpu_dev.init
       .parainstructions .altinstructions .altinstr_replacement
       .iommu_table .apicdrivers .exit.text .exit.data .smp_locks .bss .brk


On defconfig (amd64, gcc-6):
* 2044 initified strings
*   43 initified functions

On defconfig (amd64, gcc-6):

section         vanilla                 vanilla + initify        change
-----------------------------------------------------------------------
.rodata		2466736 (0x25a3b0)	2405296 (0x24b3b0)	-61440
.init.data	 564656 (0x089db0)	 645616 (0x09d9f0)	+80960
.text		9364727 (0x8ee4f7)	9360823 (0x8ed5b7)	 -3904
.init.text	 436097 (0x06a781)	 439161 (0x06b379)	 +3064
.exit.data	      0			    864 (0x000360)	  +864
.exit.text	   8806 (0x002266)	   9824 (0x002660)	 +1018

	FileSiz (vanilla)	FileSiz (vanilla + initify)	 change
------------------------------------------------------------------------
00	13340672 (0xcb9000)	13279232 (0xcaa000)		-61440
03	 1097728 (0x10c000)	 1183744 (0x121000)		+86016

00     .text .notes __ex_table .rodata __bug_table .pci_fixup .builtin_fw
       .tracedata __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata
       __param __modver
03     .init.text .altinstr_aux .init.data .x86_cpu_dev.init
       .parainstructions .altinstructions .altinstr_replacement
       .iommu_table .apicdrivers .exit.text .exit.data .smp_locks .bss .brk


Emese Revfy (3):
 Add the initify gcc plugin
 Mark functions with the __nocapture attribute
 Constify some function parameters


Changes from v1:
 * Removed unnecessary nocapture attributes from boot code
   (Reported-by: PaX Team <pageexec@freemail.hu>)
 * Removed nocapture attributes from functions that return
   the marked parameter
   (Reported-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>)
 * Added nocapture attribute to strlen()
 * Updated gcc-common.h from PaX
 * Don't forcibly constify initified string types
   this caused the size reduction of the .data section
   (initify_plugin.c)
 * Added the section mismatch problem in the commit message

---
 arch/Kconfig                         |   23 +
 arch/arm/include/asm/string.h        |    4 +-
 arch/arm64/include/asm/string.h      |   19 +-
 arch/powerpc/include/asm/string.h    |   19 +-
 arch/x86/include/asm/string_32.h     |   21 +-
 arch/x86/include/asm/string_64.h     |   20 +-
 arch/x86/kernel/hpet.c               |    2 +-
 drivers/isdn/hisax/config.c          |    4 +-
 drivers/isdn/hisax/hisax.h           |    4 +-
 include/asm-generic/bug.h            |    6 +-
 include/asm-generic/vmlinux.lds.h    |    2 +
 include/linux/compiler-gcc.h         |   10 +-
 include/linux/compiler.h             |    4 +
 include/linux/fs.h                   |    5 +-
 include/linux/printk.h               |    2 +-
 include/linux/string.h               |   63 +-
 scripts/Makefile.gcc-plugins         |    4 +
 scripts/gcc-plugins/gcc-common.h     |   41 ++
 scripts/gcc-plugins/initify_plugin.c | 1183 ++++++++++++++++++++++++++++++++++
 19 files changed, 1353 insertions(+), 83 deletions(-)
