Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 19:00:22 +0200
From: Mathias Krause <minipli@ld-linux.so>
Message-ID: <20160628170022.GH22554@ld-linux.so>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v1 0/2] Introduce the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,

On Tue, Jun 28, 2016 at 01:34:07PM +0200, Emese Revfy wrote:
> I would like to introduce the initify gcc plugin. The kernel already has
> a mechanism to free up code and data memory that is only used during kernel
> or module initialization.
> This plugin will teach the compiler to find more such code and data that
> can be freed after initialization. It reduces memory usage.
> The initify gcc plugin can be useful for embedded systems.
> 
> It is a CII project supported by the Linux Foundation.
> 
> This plugin is the part of grsecurity/PaX.
> 
> The plugin supports all gcc versions from 4.5 to 6.0.
> 
> I made some changes on top of the PaX version (since March 6.). These are
> the important ones:
>  * move all local strings to init.rodata.str and exit.rodata.str
>    (not just __func__)
>  * report all initified strings and functions
>    (GCC_PLUGIN_INITIFY_VERBOSE config option)
>  * automatically discover init/exit functions and apply the __init or
>    __exit attributes on them
> 
> You can find more about the changes here:
> https://github.com/ephox-gcc-plugins/initify
> 
> This patch set is based on the "Add support for complex gcc plugins that
> don't fit in a single file" patch set (git/kees/linux.git#kspp HEAD:
> e5d4798b284cd192c8b).
> 
> Some statistics about the plugin:
> 
> On allyes config (amd64, gcc-6):
> * 7731 initified strings
> *  231 initified functions
> 
> On allmod config (i386, gcc-6):
> * 8846 initified strings
> *  252 initified functions
> 
> On allyes config (amd64, gcc-6):
> 
> section         vanilla                 vanilla + initify        change
> -----------------------------------------------------------------------
> .rodata         39059688 (0x25400e8)    38527210 (0x24be0ea)    -532478
> .data           45744128 (0x2ba0000)    45404160 (0x2b4d000)    -339968
> .init.data       1361144  (0x14c4f8)     1674200  (0x198bd8)    +313056
> .text           77615128 (0x4a05018)    77576664 (0x49fb9d8)     -38464
> .init.text       1108455  (0x10e9e7)     1137618  (0x115bd2)     +29163

You should probably provide numbers for .init.rodata.str, .exit.rodata.str
and .exit.text as well. Otherwise this delta calculation suggests a rather
gigantic image size reduction which is probably not the case ;)

Also a comparison of the final kernel image size would be nice to see if
the string duplication issue mentioned in [1] is actually an issue.

  [1] http://marc.info/?l=linux-kernel&m=140364632417795&w=2


Thanks,
Mathias

> 
> 
> Emese Revfy (2):
>  Add the initify gcc plugin
>  Mark functions with the __nocapture attribute
> 
> ---
>  arch/Kconfig                         |   23 +
>  arch/arm/include/asm/string.h        |   10 +-
>  arch/arm64/include/asm/string.h      |   23 +-
>  arch/powerpc/include/asm/string.h    |   19 +-
>  arch/x86/boot/string.h               |    4 +-
>  arch/x86/include/asm/string_32.h     |   21 +-
>  arch/x86/include/asm/string_64.h     |   18 +-
>  arch/x86/kernel/hpet.c               |    2 +-
>  include/asm-generic/bug.h            |    6 +-
>  include/asm-generic/vmlinux.lds.h    |    2 +
>  include/linux/compiler-gcc.h         |   10 +-
>  include/linux/compiler.h             |    4 +
>  include/linux/fs.h                   |    5 +-
>  include/linux/printk.h               |    2 +-
>  include/linux/string.h               |   73 +--
>  scripts/Makefile.gcc-plugins         |    4 +
>  scripts/gcc-plugins/initify_plugin.c | 1147 ++++++++++++++++++++++++++++++++++
>  17 files changed, 1283 insertions(+), 90 deletions(-)
