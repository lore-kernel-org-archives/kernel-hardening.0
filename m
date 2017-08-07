Date: Mon, 7 Aug 2017 18:55:33 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170807175533.GA20805@n2100.armlinux.org.uk>
References: <20170726170051.28328-1-thgarnie@google.com>
 <20170726170051.28328-2-thgarnie@google.com>
 <CAGXu5jLbJuokv+B_Nn8uRDVadi05ywJM7FSgpOr+maO2pQrd0w@mail.gmail.com>
 <CAJcbSZHfoHNPv3tk11iCj49UkLGU-QdeyMj2BS60wng5z5L4pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZHfoHNPv3tk11iCj49UkLGU-QdeyMj2BS60wng5z5L4pg@mail.gmail.com>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [PATCH v2 2/3] arm/syscalls: Optimize address limit check
To: Thomas Garnier <thgarnie@google.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>, Leonard Crestez <leonard.crestez@nxp.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 07, 2017 at 10:42:14AM -0700, Thomas Garnier wrote:
> On Mon, Aug 7, 2017 at 10:35 AM, Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Jul 26, 2017 at 10:00 AM, Thomas Garnier <thgarnie@google.com> wrote:
> >> Disable the generic address limit check in favor of an architecture
> >> specific optimized implementation. The generic implementation using
> >> pending work flags did not work well with ARM and alignment faults.
> >>
> >> The address limit is checked on each syscall return path to user-mode
> >> path as well as the irq user-mode return function. If the address limit
> >> was changed, a function is called to stop the kernel with an explicit
> >> message.
> >>
> >> The address limit check has to be done before any pending work because
> >> they can reset the address limit. For example the lkdtm address limit
> >> check does not work because the signal to kill the process will reset
> >> the user-mode address limit.
> >>
> >> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> >> ---
> >>  arch/arm/kernel/entry-common.S | 11 +++++++++++
> >>  arch/arm/kernel/signal.c       |  5 +++++
> >>  2 files changed, 16 insertions(+)
> >>
> >> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> >> index 0b60adf4a5d9..99c908226065 100644
> >> --- a/arch/arm/kernel/entry-common.S
> >> +++ b/arch/arm/kernel/entry-common.S
> >> @@ -12,6 +12,7 @@
> >>  #include <asm/unistd.h>
> >>  #include <asm/ftrace.h>
> >>  #include <asm/unwind.h>
> >> +#include <asm/memory.h>
> >>  #ifdef CONFIG_AEABI
> >>  #include <asm/unistd-oabi.h>
> >>  #endif
> >> @@ -48,10 +49,14 @@ ret_fast_syscall:
> >>   UNWIND(.fnstart       )
> >>   UNWIND(.cantunwind    )
> >>         disable_irq_notrace                     @ disable interrupts
> >> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
> >> +       cmp     r2, #TASK_SIZE
> >> +       blne    addr_limit_check_failed
> >>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
> >>         tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> >>         bne     fast_work_pending
> >>
> >> +
> >>         /* perform architecture specific actions before user return */
> >>         arch_ret_to_user r1, lr
> >>
> >> @@ -74,6 +79,9 @@ ret_fast_syscall:
> >>   UNWIND(.cantunwind    )
> >>         str     r0, [sp, #S_R0 + S_OFF]!        @ save returned r0
> >>         disable_irq_notrace                     @ disable interrupts
> >> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
> >> +       cmp     r2, #TASK_SIZE
> >> +       blne    addr_limit_check_failed
> >>         ldr     r1, [tsk, #TI_FLAGS]            @ re-check for syscall tracing
> >>         tst     r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
> >>         beq     no_work_pending
> >> @@ -106,6 +114,9 @@ ENTRY(ret_to_user)
> >>  ret_slow_syscall:
> >>         disable_irq_notrace                     @ disable interrupts
> >>  ENTRY(ret_to_user_from_irq)
> >> +       ldr     r2, [tsk, #TI_ADDR_LIMIT]
> >> +       cmp     r2, #TASK_SIZE
> >> +       blne    addr_limit_check_failed
> >>         ldr     r1, [tsk, #TI_FLAGS]
> >>         tst     r1, #_TIF_WORK_MASK
> >>         bne     slow_work_pending
> >
> > Instead of taking the entire system down, how about a WARN/kill combo
> > instead? If it's too late for "force_sig(SIGKILL, current)", then
> > likely we should perform a "do_group_exit(SIGKILL)".
> 
> Sure, why not. I can also change the others architectures to move to a
> do_group_exit(SIGKILL).
> 
> Before the next iteration, I want to know if Russel has any feedback
> on this implementation, given the previous thread.

It's better in so far as it avoids the problems previously highlighted.

However, it depends how efficient we want these paths to be - the
difference between your assembly and the assembly I've previously
supplied is that mine fills in any delay slots with some useful work
and avoids adding extra delay slots in this path.

Arguably, the system call exit path is as important as the system
call entry path for OS performance, so I think we should strive to
make it as efficient as possible - much as I already did when I
posted code on this topic previously.

I think that code can simply be adapted to call your C function
instead of the assembly "addr_limit_fail" label.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
