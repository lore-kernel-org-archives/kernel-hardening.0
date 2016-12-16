Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 16 Dec 2016 14:06:20 -0800
Message-Id: <1481925984-98605-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v4 0/4] Introduce the initify gcc plugin
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Emese Revfy <re.emese@gmail.com>, Josh Triplett <josh@joshtriplett.org>, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a continuation of Emese Revfy's initify plugin upstreaming. This
is based on her v3, but updated with various fixes from her github tree.
Additionally, I split off the printf attribute fixes and sent those
separately.

This is the initify gcc plugin. The kernel already has a mechanism to
free up code and data memory that is only used during kernel or module
initialization.  This plugin will teach the compiler to find more such
code and data that can be freed after initialization. It reduces memory
usage.  The initify gcc plugin can be useful for embedded systems.

Originally it was a CII project supported by the Linux Foundation.

This plugin is the part of grsecurity/PaX.

The plugin supports all gcc versions from 4.5 to 7.0.

Changes on top of the PaX version (since March 6.). These are the important
ones:
 * move all local strings to init.rodata.str and exit.rodata.str
   (not just __func__)
 * report all initified strings and functions
   (GCC_PLUGIN_INITIFY_VERBOSE config option)
 * automatically discover init/exit functions and apply the __init or
   __exit attributes on them

You can find more about the changes here:
https://github.com/ephox-gcc-plugins/initify

This patch set is based on v4.9-rc2.

Some build statistics about the plugin:

On allyes config (amd64, gcc-6):
* 8412 initified strings
*  167 initified functions

On allmod config (i386, gcc-6):
* 8597 initified strings
*  159 initified functions

On allyes config (amd64, gcc-6):

section         vanilla                 vanilla + initify        change
-----------------------------------------------------------------------
.rodata         21746728 (0x14bd428)    21488680 (0x147e428)    -258048
.init.data       1338376  (0x146c08)     1683016  (0x19ae48)    +344640
.text           78270904 (0x4aa51b8)    78228280 (0x4a9ab38)     -42624
.init.text       1184725  (0x1213d5)     1223257  (0x12aa59)     +38532
.exit.data           104  (0x000068)       17760  (0x004560)     +17656
.exit.text        174473  (0x02a989)      175763  (0x02ae93)      +1290

        FileSiz (vanilla)       FileSiz (vanilla + initify)      change
------------------------------------------------------------------------
00      102936576 (0x622b000)   102678528 (0x61ec000)           -258048
03       28680192 (0x1b5a000)    29081600 (0x1bbc000)           +401408

00     .text .notes __ex_table .rodata __bug_table .pci_fixup .builtin_fw
       .tracedata __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata
       __param __modver
03     .init.text .altinstr_aux .init.data .x86_cpu_dev.init
       .parainstructions .altinstructions .altinstr_replacement
       .iommu_table .apicdrivers .exit.text .exit.data .smp_locks .bss .brk


On defconfig (amd64, gcc-6):
* 1957 initified strings
*   29 initified functions

On defconfig (amd64, gcc-6):

section         vanilla                 vanilla + initify        change
-----------------------------------------------------------------------
.rodata         2524240 (0x268450)      2462800 (0x259450)      -61440
.init.data       560256 (0x088c80)       644000 (0x09d3a0)      +83744
.text           9377367 (0x8f1657)      9373079 (0x8f0597)       -4288
.init.text       438586 (0x06b13a)       441828 (0x06bde4)       +3242
.exit.data            0                     832 (0x000340)        +832
.exit.text         8857 (0x002299)          8857 (0x002299)          0

        FileSiz (vanilla)       FileSiz (vanilla + initify)      change
------------------------------------------------------------------------
00      13398016 (0xcc7000)     13336576 (0xcb8000)             -61440
03       2203648 (0x21a000)      2293760 (0x230000)             +90112

00     .text .notes __ex_table .rodata __bug_table .pci_fixup .builtin_fw
       .tracedata __ksymtab __ksymtab_gpl __ksymtab_strings __init_rodata
       __param __modver
03     .init.text .altinstr_aux .init.data .x86_cpu_dev.init
       .parainstructions .altinstructions .altinstr_replacement
       .iommu_table .apicdrivers .exit.text .exit.data .smp_locks .bss .brk

One thing of note is that this plugin triggers false positive warnings
from the modpost section mismatch detector. Further work is needed to
deal with this.


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
