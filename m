From: Kees Cook <keescook@chromium.org>
Date: Tue, 31 Jan 2017 12:24:18 -0800
Message-Id: <1485894263-91051-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v5 0/4] Introduce the initify gcc plugin
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, pageexec@freemail.hu, yamada.masahiro@socionext.com, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is a continuation of Emese Revfy's initify plugin upstreaming,
updated with various fixes from her github tree. Additionally, I split off
the printf attribute fixes and sent those separately.

This is the initify gcc plugin. The kernel already has a mechanism to
free up code and data memory that is only used during kernel or module
initialization.  This plugin will teach the compiler to find more such
code and data that can be freed after initialization. It reduces memory
usage at run-time, so the initify gcc plugin can be useful for embedded
systems.

Originally it was a CII project supported by the Linux Foundation.

This plugin is the part of grsecurity/PaX. You can find out more here:
https://github.com/ephox-gcc-plugins/initify

Section and header size changes for v4.10-rc2:

defconfig (x86_64, gcc 5.4.0)
* 2171 initified strings
*   17 initified functions

section     size (before)  size (with initify)  change
----------  -------------  -------------------  ------
.rodata      3362592        3333920             -28672
.init.data    577208         661432             +84224
.exit.data         0            672               +672
.text       10633407       10629247              -4160
.init.text    444371         446839              +2468
.exit.text      8427           8427                  0

header  FileSiz (before)  FileSiz (with initify)  change
------  ----------------  ----------------------  ------
00      16347136          16318464                -28672
03       1118208           1204224                +86016

00     .text .notes __ex_table .rodata __bug_table .pci_fixup .builtin_fw
       .tracedata __ksymtab __ksymtab_gpl __ksymtab_strings __param __modver

03     .init.text .altinstr_aux .init.data .x86_cpu_dev.init .altinstructions
       .altinstr_replacement .iommu_table .apicdrivers .exit.text .exit.data
       .smp_locks .data_nosave .bss .brk


Changed from v4:
 * Refresh from Emese's latest version.
 * Updated build statistics

Changed from v3:
 * Refresh from Emese's latest version.

Changed from v2:
 * Check all uses when walking a use-def chain.
 * Check all uses of initialized local variables and initify them if they
   have only nocapture uses. Previously only uses in call arguments
   determined whether the initializer value could be initified.
 * Handle the format gcc attribute from the plugin too.
 * Verify nocapture parameters of calls. Track uses of these parameters
   and verify that all uses are not captured. Verify only the nocapture
   attribute (The format attribute should be verified too.).
 * Fixed wrong indexing of function arguments.
 * Fixed decl comparison. When comparing two decls the tree codes must be
   the same.
 * Search capture uses of the return value. Use negative nocapture
   attribute parameter on a function argument to verify that the return
   value is not captured.
 * Stop the search for capture uses if there is a cast to integer type.
 * Removed unnecessary duplication hook.
 * Handle cloned functions with a changed argument list.
 * Check visited tree nodes to avoid an infinite loop.
 * Add a new initify plugin option: enable_init_to_exit_moves. Move a
   function to the exit section if it is called by __init and __exit
   functions too.
 * Added plugin option to disable the search of capture uses in nocapture
   functions. We must be able to disable verification of nocapture
   functions because there is a lot of asm code in the str* and mem*
   functions on i386.
 * Added some more nocapture attributes.
 * Added some more printf attributes.
 * Added some unverified_nocapture attributes.
 * Make is_kernel_rodata() nocapture.
 * Added comment for the nocapture attribute from Kees.

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
