References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <49abb4c2-e638-9657-f007-0c18ef6d0f28@linux.com>
Date: Sat, 10 Jun 2017 02:00:18 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH RFC v2 1/1] gcc-plugins: Add stackleak feature erasing the
 kernel stack at the end of syscalls
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 09.06.2017 20:28, Kees Cook wrote:
> On Fri, Jun 9, 2017 at 7:30 AM, Alexander Popov <alex.popov@linux.com> wrote:
>> Hello,
>>
>> My employer Positive Technologies kindly allowed me to spend a part of my
>> working time on helping KSPP. So I join the initiative of porting STACKLEAK
>> to the mainline, which was started by Tycho Andersen.
> 
> Great, thanks for working on this!

Hello Kees, thanks for your prompt reply.

>> STACKLEAK is a security feature developed by Grsecurity/PaX (kudos to them!),
>> which can mitigate the damage from kernel stack leak bugs (see CVE-2010-2963,
>> CVE-2016-4569 and CVE-2016-4578).
> 
> It might help to distinguish that this covers at least two classes of
> issues: stack content exposure (the latter two CVEs above), and it can
> block some uninitialized variable attacks (like the mentioned
> CVE-2010-2963). In other words, this can be more than just an info
> exposure defense.

Thanks, I'll improve the description in the next version.

>> I carefully extracted STACKLEAK from the last public patch of Grsecurity/PaX
>> and do my best to understand it. So I added some comments describing that
>> understanding. You are welcome to discuss it.
> 
> Great, adding more comments to the gcc plugin will help others who are
> trying to get up to speed on it (like me). :)

Currently I annotated the arch-specific asm part of the STACKLEAK feature.
However, there are a few questions in my comments marked with TODO.
Playing with the gcc plugin is the next step.

>> Here are the results of a brief performance test on x86_64:
>>
>> Hardware: Intel Core i7-4770, 16 GB RAM
>>
>> Test #1: stress-ng --cpu 4 --io 2 --vm 2 --vm-bytes 2G --timeout 300s
>>  --metrics-brief
>> Result on 4.11-rc8:
>>   cpu bogo ops 269955
>>   iosync bogo ops 9809985
>>   vm bogo ops 17093608
>> Result on 4.11-rc8+stackleak:
>>   cpu bogo ops 270106 (+0.6%)
>>   iosync bogo ops 9474535 (-3.42%)
>>   vm bogo ops 17093608 (the same)
>>
>> Test #2: hackbench -s 4096 -l 2000 -g 15 -f 25 -P
>> Average result on 4.11-rc8: 8.71s
>> Average result on 4.11-rc8+stackleak: 9.08s (+4.29%)
>>
>> Test #3: building the Linux kernel with Ubuntu config (time make -j9)
>> Result on 4.11-rc8:
>>   real  32m14.893s
>>   user  237m30.886s
>>   sys   11m12.273s
>> Result on 4.11-rc8+stackleak:
>>   real  32m26.881s (+0.62%)
>>   user  238m38.926s (+0.48%)
>>   sys   11m36.426s (+3.59%)
> 
> Awesome, and thanks for the benchmarks! That should really help people
> understand the trade-offs for using this feature (and is likely worth
> mentioning in the Kconfig). Seems like less than 4% overhead, maybe
> much less? Real time on build times seems like a tiny difference, but
> hackbench shows 4%.

Yes, the performance penalty of STACKLEAK differs a lot depending on the
kind of load. Do you have any idea which test can give a bigger slowdown?
It should be some rapid syscall exhausting the kernel stack hard.

>> There is an important aspect of STACKLEAK on i386. PaX Team might know
>> about it, I can't say for sure. Dear Grsecurity, is it fine to talk with
>> you about such things in that mailing list? Should I do it differently?
>>
>> The STACKLEAK gcc plugin does not instrument the kernel code for i386. I've
>> checked that for the last public patch of Grsecurity/PaX and see the same
>> behaviour on my machines. The reason: the ix86_cmodel for the Linux kernel
>> on i386 is not CM_KERNEL. So the STACKLEAK plugin seems to skip the
>> instrumentation for that platform. As a result, on i386 erase_kstack()
>> always starts to search for the bottom of the stack from the top minus 128.
> 
> What version of gcc did you use for these builds, btw? Perhaps
> something changed there?

I tried to compile the Linux kernel for i386 with two different versions of gcc:

#gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/6/lto-wrapper
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu/Linaro
6.3.0-18ubuntu2~16.04' --with-bugurl=file:///usr/share/doc/gcc-6/README.Bugs
--enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr
--program-suffix=-6 --program-prefix=x86_64-linux-gnu- --enable-shared
--enable-linker-build-id --libexecdir=/usr/lib --without-included-gettext
--enable-threads=posix --libdir=/usr/lib --enable-nls --with-sysroot=/
--enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes
--with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify
--enable-libmpx --enable-plugin --with-system-zlib --disable-browser-plugin
--enable-java-awt=gtk --enable-gtk-cairo
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-6-amd64/jre --enable-java-home
--with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-6-amd64
--with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-6-amd64 --with-arch-directory=amd64
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar --with-target-system-zlib
--enable-objc-gc=auto --enable-multiarch --disable-werror --with-arch-32=i686
--with-abi=m64 --with-multilib-list=m32,m64,mx32 --enable-multilib --with-tune=generic
--enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu
--target=x86_64-linux-gnu
Thread model: posix
gcc version 6.3.0 20170519 (Ubuntu/Linaro 6.3.0-18ubuntu2~16.04)

gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/i686-linux-gnu/5/lto-wrapper
Target: i686-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Ubuntu 5.4.0-6ubuntu1~16.04.4'
--with-bugurl=file:///usr/share/doc/gcc-5/README.Bugs
--enable-languages=c,ada,c++,java,go,d,fortran,objc,obj-c++ --prefix=/usr
--program-suffix=-5 --enable-shared --enable-linker-build-id --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix --libdir=/usr/lib --enable-nls
--with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes
--with-default-libstdcxx-abi=new --enable-gnu-unique-object --disable-vtable-verify
--enable-libmpx --enable-plugin --with-system-zlib --disable-browser-plugin
--enable-java-awt=gtk --enable-gtk-cairo
--with-java-home=/usr/lib/jvm/java-1.5.0-gcj-5-i386/jre --enable-java-home
--with-jvm-root-dir=/usr/lib/jvm/java-1.5.0-gcj-5-i386
--with-jvm-jar-dir=/usr/lib/jvm-exports/java-1.5.0-gcj-5-i386 --with-arch-directory=i386
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar --enable-objc-gc --enable-targets=all
--enable-multiarch --disable-werror --with-arch-32=i686 --with-multilib-list=m32,m64,mx32
--enable-multilib --with-tune=generic --enable-checking=release --build=i686-linux-gnu
--host=i686-linux-gnu --target=i686-linux-gnu
Thread model: posix
gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4)

Both of them compiled it with ix86_cmodel=0, so the STACKLEAK instrumentation
was skipped.

>> See the results of the same performance tests on i386:
>>
>> Test #1: stress-ng --cpu 4 --io 2 --vm 2 --vm-bytes 2G --timeout 300s
>>  --metrics-brief
>> Result on 4.11-rc8:
>>   cpu bogo ops 207754
>>   iosync bogo ops 9442815
>>   vm bogo ops 8546804
>> Result on 4.11-rc8+stackleak:
>>   cpu bogo ops 206061 (-0.81%)
>>   iosync bogo ops 9435139 (-0.08%)
>>   vm bogo ops 8546804 (the same)
>>
>> Test #2: hackbench -s 4096 -l 2000 -g 15 -f 25 -P
>> Average result on 4.11-rc8: 8.197s
>> Average result on 4.11-rc8+stackleak: 9.134s (+11.43%)
>>
>> Test #3: building the Linux kernel with Ubuntu config (time make -j9)
>> Result on 4.11-rc8:
>>   real  18m15.372s
>>   user  129m58.169s
>>   sys   8m27.884s
>> Result on 4.11-rc8+stackleak:
>>   real  18m34.244s (+1.72%)
>>   user  132m33.843s (+2.00%)
>>   sys   8m37.658s (+1.92%)
>>
>> More things to be done:
>>  - understand how the STACKLEAK gcc plugin works;
>>  - develop tests for STACKLEAK.
> 
> Since this is mostly an anti-exposure defense, LKDTM is probably not a
> good match (i.e. organizing a test for the uninit variable case can be
> very fragile). I think something similar to test_user_copy.c would be
> better.

Ok, thanks for the clue.

>> From d22af45233b2f6d657a29dcb1815b35a5a45c539 Mon Sep 17 00:00:00 2001
>> From: Alexander Popov <alex.popov@linux.com>
>> Date: Fri, 9 Jun 2017 15:21:16 +0300
>> Subject: [PATCH RFC v2 1/1] gcc-plugins: Add stackleak feature erasing the
>>  kernel stack at the end of syscalls
>>
>> The stackleak feature erases the kernel stack before returning from syscalls.
>> That reduces the information which a kernel stack leak bug can reveal.
>>
>> This feature consists of:
>>   - the architecture-specific code filling the used part of the kernel stack
>>   with a poison value before returning to the userspace (currently only
>>   for i386 and x86_64);
>>   - the gcc plugin for tracking the lowest border of the kernel stack. It
>>   instruments the kernel code inserting the track_stack() function call if
>>   a stack frame size is over a specified limit.
>>
>> The stackleak feature is ported from grsecurity/PaX. For more information see:
>>   https://grsecurity.net/
>>   https://pax.grsecurity.net/
>>
>> This code is verbatim from Brad Spengler/PaX Team's code in the last public
> 
> Maybe "nearly verbatim" since Kconfigs and such were (correctly)
> renamed/expanded, and comments were added.

Agree, I'll fix it.

>> patch of grsecurity/PaX based on our understanding of the code. Changes or
>> omissions from the original code are ours and don't reflect the original
>> grsecurity/PaX code.
>>
>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>> Signed-off-by: Tycho Andersen <tycho@docker.com>
> 
> This S-o-b is not right, I think it should just be yours. Perhaps say
> something like "Continued upstreaming work started by Tycho Anderson."
> in the commit log.

Ok, excuse me.
Tycho looked at this patch and tested it. I had to use "Tested-by".

>> ---
>>  arch/Kconfig                           |  20 ++
>>  arch/x86/Kconfig                       |   1 +
>>  arch/x86/entry/common.c                |  17 +-
>>  arch/x86/entry/entry_32.S              |  71 +++++++
>>  arch/x86/entry/entry_64.S              |  99 ++++++++++
>>  arch/x86/entry/entry_64_compat.S       |   8 +
>>  arch/x86/include/asm/processor.h       |   4 +
>>  arch/x86/kernel/asm-offsets.c          |   9 +
>>  arch/x86/kernel/dumpstack_32.c         |  12 ++
>>  arch/x86/kernel/dumpstack_64.c         |  33 ++++
>>  arch/x86/kernel/process_32.c           |   5 +
>>  arch/x86/kernel/process_64.c           |   5 +
>>  fs/exec.c                              |  17 ++
>>  scripts/Makefile.gcc-plugins           |   3 +
>>  scripts/gcc-plugins/stackleak_plugin.c | 342 +++++++++++++++++++++++++++++++++
>>  15 files changed, 643 insertions(+), 3 deletions(-)
>>  create mode 100644 scripts/gcc-plugins/stackleak_plugin.c
>>
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index cd211a1..a209bd5 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -436,6 +436,26 @@ config GCC_PLUGIN_STRUCTLEAK_VERBOSE
>>           initialized. Since not all existing initializers are detected
>>           by the plugin, this can produce false positive warnings.
>>
>> +config ARCH_HAS_STACKLEAK
>> +       def_bool n
> 
> This can just be "bool" (it will default off).

Ok.

>> +       help
>> +         An architecture should select this if it has the code which
>> +         fills the used part of the kernel stack with a poison value
>> +         before returning from system calls.
> 
> Maybe specifically mention the -0xBEEF value?

Ok. Should I create some macro for it?

>> +
>> +config STACKLEAK
> 
> I would follow the naming of the others, and call this GCC_PLUGIN_STACKLEAK

It seems to me that GCC_PLUGIN_STACKLEAK is not a right name since the whole
feature consists of two parts: the arch-specific asm code actually cleaning
the kernel stack and the gcc plugin which helps to do it faster and more
reliable. What do you think?

>> +       bool "Erase the kernel stack before returning from syscalls"
>> +       depends on GCC_PLUGINS
>> +       depends on ARCH_HAS_STACKLEAK
>> +       help
>> +         This option makes the kernel erase the kernel stack before it
>> +         returns from a system call. That reduces the information which
>> +         a kernel stack leak bug can reveal.
>> +
>> +         This plugin was ported from grsecurity/PaX. More information at:
>> +          * https://grsecurity.net/
>> +          * https://pax.grsecurity.net/
> 
> Is Kconfig smart enough to include this in the gcc plugins sub-page
> when the ARCH_HAS_STACKLEAK config is between this and the others?

You are right, it's outside gcc plugins subpage. If we finally choose the
name GCC_PLUGIN_STACKLEAK, I'll put it inside.

>> +
>>  config HAVE_CC_STACKPROTECTOR
>>         bool
>>         help
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index cc98d5a..5988a5f 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -56,6 +56,7 @@ config X86
>>         select ARCH_HAS_PMEM_API                if X86_64
>>         select ARCH_HAS_SET_MEMORY
>>         select ARCH_HAS_SG_CHAIN
>> +       select ARCH_HAS_STACKLEAK
>>         select ARCH_HAS_STRICT_KERNEL_RWX
>>         select ARCH_HAS_STRICT_MODULE_RWX
>>         select ARCH_HAS_UBSAN_SANITIZE_ALL
>> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
>> index 370c42c..8ff0a84 100644
>> --- a/arch/x86/entry/common.c
>> +++ b/arch/x86/entry/common.c
>> @@ -43,6 +43,12 @@ __visible inline void enter_from_user_mode(void)
>>  static inline void enter_from_user_mode(void) {}
>>  #endif
>>
>> +#ifdef CONFIG_STACKLEAK
>> +asmlinkage void erase_kstack(void);
>> +#else
>> +static void erase_kstack(void) {}
>> +#endif
>> +
>>  static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
>>  {
>>  #ifdef CONFIG_X86_64
>> @@ -79,8 +85,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
>>                 emulated = true;
>>
>>         if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
>> -           tracehook_report_syscall_entry(regs))
>> +           tracehook_report_syscall_entry(regs)) {
>> +               erase_kstack();
>>                 return -1L;
>> +       }
>>
>>         if (emulated)
>>                 return -1L;
>> @@ -114,9 +122,11 @@ static long syscall_trace_enter(struct pt_regs *regs)
>>                         sd.args[5] = regs->bp;
>>                 }
>>
>> -               ret = __secure_computing(&sd);
>> -               if (ret == -1)
>> +               ret = secure_computing(&sd);
>> +               if (ret == -1) {
>> +                       erase_kstack();
>>                         return ret;
>> +               }
>>         }
>>  #endif
> 
> Since this is x86-specific, maybe Cc x86@kernel.org and/or Andy
> Lutomirski on follow-up versions. I'm sure they'll have opinions about
> changes to the entry code. :)

Thanks! Of course, I'll do it for the next version.

> It seems like it shouldn't be too hard to add on-user-return erasure
> code to other architectures too.

Yes, maybe. At the same time the gcc plugin might somehow depend on x86.
I'll investigate that.

Best regards,
Alexander
