Subject: Re: [PATCH v15 0/7] Introduce the STACKLEAK feature and a test for it
References: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <2c6b7b5a-0db8-a4d0-ddfc-839aa67907f0@redhat.com>
Date: Tue, 21 Aug 2018 09:20:11 -0700
MIME-Version: 1.0
In-Reply-To: <1534457824-7211-1-git-send-email-alex.popov@linux.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 08/16/2018 03:16 PM, Alexander Popov wrote:
> This is the 15th version of the patch series introducing STACKLEAK to
> the mainline kernel for x86. This version comes with changes according
> to the feedback from Linus Torvalds:
>   1. BUG_ON() in stackleak_erase() is safely eliminated;
>   2. Stack Clash detection (alloca() check) is completely dropped, since global
>      '-Wvla' should arrive soon (https://patchwork.kernel.org/patch/10489873).
>      stackleak_check_alloca() for arm64 is dropped as well in a separate commit.
> 
> This version is rebased onto Linus' tree.
> 
> Previous version discussion:
>    https://lore.kernel.org/lkml/20180813214328.GA15137@beast/T/#u
> 
> Motivation
> ==========
> 
> STACKLEAK (initially developed by PaX Team):
> 
>   1. reduces the information that can be revealed through kernel stack leak bugs.
>      The idea of erasing the thread stack at the end of syscalls is similar to
>      CONFIG_PAGE_POISONING and memzero_explicit() in kernel crypto, which all
>      comply with FDP_RIP.2 (Full Residual Information Protection) of the
>      Common Criteria standard.
> 
>   2. blocks some uninitialized stack variable attacks (e.g. CVE-2017-17712,
>      CVE-2010-2963). That kind of bugs should be killed by improving C compilers
>      in future, which might take a long time.
> 
> Performance impact
> ==================
> 
> Hardware: Intel Core i7-4770, 16 GB RAM
> 
> Test #1: building the Linux kernel on a single core
> 	0.91% slowdown
> 
> Test #2: hackbench -s 4096 -l 2000 -g 15 -f 25 -P
> 	4.2% slowdown
> 
> So the STACKLEAK description in Kconfig includes:
> "The tradeoff is the performance impact: on a single CPU system kernel
> compilation sees a 1% slowdown, other systems and workloads may vary and you are
> advised to test this feature on your expected workload before deploying it".
> 
> 
> Alexander Popov (7):
>    x86/entry: Add STACKLEAK erasing the kernel stack at the end of
>      syscalls
>    gcc-plugins: Add STACKLEAK plugin for tracking the kernel stack
>    lkdtm: Add a test for STACKLEAK
>    fs/proc: Show STACKLEAK metrics in the /proc file system
>    doc: self-protection: Add information about STACKLEAK feature
>    stackleak: Allow runtime disabling of kernel stack erasing
>    arm64: Drop unneeded stackleak_check_alloca()
> 
>   Documentation/security/self-protection.rst |  10 +-
>   Documentation/sysctl/kernel.txt            |  18 ++
>   Documentation/x86/x86_64/mm.txt            |   2 +
>   arch/Kconfig                               |   7 +
>   arch/arm64/kernel/process.c                |  22 --
>   arch/x86/Kconfig                           |   1 +
>   arch/x86/entry/calling.h                   |  14 +
>   arch/x86/entry/entry_32.S                  |   7 +
>   arch/x86/entry/entry_64.S                  |   3 +
>   arch/x86/entry/entry_64_compat.S           |   5 +
>   drivers/misc/lkdtm/Makefile                |   2 +
>   drivers/misc/lkdtm/core.c                  |   1 +
>   drivers/misc/lkdtm/lkdtm.h                 |   3 +
>   drivers/misc/lkdtm/stackleak.c             |  73 +++++
>   fs/proc/base.c                             |  18 ++
>   include/linux/sched.h                      |   5 +
>   include/linux/stackleak.h                  |  35 +++
>   kernel/Makefile                            |   4 +
>   kernel/fork.c                              |   3 +
>   kernel/stackleak.c                         | 132 +++++++++
>   kernel/sysctl.c                            |  15 +-
>   scripts/Makefile.gcc-plugins               |  10 +
>   scripts/gcc-plugins/Kconfig                |  51 ++++
>   scripts/gcc-plugins/stackleak_plugin.c     | 427 +++++++++++++++++++++++++++++
>   24 files changed, 840 insertions(+), 28 deletions(-)
>   create mode 100644 drivers/misc/lkdtm/stackleak.c
>   create mode 100644 include/linux/stackleak.h
>   create mode 100644 kernel/stackleak.c
>   create mode 100644 scripts/gcc-plugins/stackleak_plugin.c
> 

For arm64:

Tested-by: Laura Abbott <labbott@redhat.com>
