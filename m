Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Jun 2016 15:51:16 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20160624205116.4hbnurrnan4afq2t@treble>
References: <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
 <20160623185340.GO30154@twins.programming.kicks-ass.net>
 <CA+55aFzhUo=2M-y39NOpWAVm1h0ADfjR3dxszJmefvoEYLa2og@mail.gmail.com>
 <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
 <CAMzpN2i7ve0Rq9BCxjp2FUw5naPLrGDd7Mf3evrrRjUZN75oJQ@mail.gmail.com>
 <CA+55aFwJ1=pyr9fP_UzDjnyX2qJ4mpxg_DTTiOJTv9PFW4dHgg@mail.gmail.com>
 <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
 <CA+55aFyKxNZQtCS3VY_8qMS4B=q-ar5ST8RdCTwAC07ZOkBjQA@mail.gmail.com>
 <CA+55aFx=wdH4v7cD2F5Kq+jwDfV5cz9qTANgOwpMTC3MY=99AQ@mail.gmail.com>
 <20160624202530.unmidps4kpebo2na@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20160624202530.unmidps4kpebo2na@treble>
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brian Gerst <brgerst@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 03:25:30PM -0500, Josh Poimboeuf wrote:
> On Fri, Jun 24, 2016 at 11:11:47AM -0700, Linus Torvalds wrote:
> > On Fri, Jun 24, 2016 at 10:51 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > And in particular, the init_task stack initialization initialized it
> > > to the init_thread pointer. Which was definitely deadly.
> > >
> > > Let's see if that was it..
> > 
> > No, it's still broken. But it's *less* broken, so here's a new version
> > of the patch that at least gets some of the stack setup right, in my
> > hope that somebody will bother to look at this, and being less broken
> > might mean that somebody sees what else I missed..
> 
> I found at least one bug.  The changing of task->stack from a "void *" to an
> "unsigned long *":
> 
> > -	void *stack;
> > +	unsigned long *stack;
> 
> That subtly changes the pointer arithmetic in do_boot_cpu():
> 
> 
> 	idle->thread.sp = (unsigned long) (((struct pt_regs *)
> 			  (THREAD_SIZE +  task_stack_page(idle))) - 1);
> 
> 
> That ends up adding 128k to the stack page bottom instead of 16k.
> 
> But fixing that doesn't seem to fix this:
> 
> [18446743832.576241] ------------[ cut here ]------------
> [18446743832.576241] WARNING: CPU: 1 PID: 0 at /home/jpoimboe/git/linux/arch/x86/kernel/cpu/common.c:1434 cpu_init+0x34b/0x440
> [18446743832.576241] Modules linked in:
> [18446743832.576241] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.7.0-rc4+ #47
> [18446743832.576241] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.1-20150318_183358- 04/01/2014
> [18446743832.576241]  0000000000000086 574e5e6c6855ace9 ffff88007c553e88 ffffffff8143cb83
> [18446743832.576241]  0000000000000000 0000000000000000 ffff88007c553ec8 ffffffff810b0e7b
> [18446743832.576241]  0000059a00000000 0000000000000000 0000000000000000 0000000000000000
> [18446743832.576241] Call Trace:
> [18446743832.576241]  [<ffffffff8143cb83>] dump_stack+0x85/0xc2
> [18446743832.576241]  [<ffffffff810b0e7b>] __warn+0xcb/0xf0
> [18446743832.576241]  [<ffffffff810b0fad>] warn_slowpath_null+0x1d/0x20
> [18446743832.576241]  [<ffffffff810491bb>] cpu_init+0x34b/0x440
> [18446743832.576241]  [<ffffffff8105ab7c>] start_secondary+0x1c/0x1a0
> [18446743832.576241] ---[ end trace 924d57afbaca0720 ]---
> 
> So there's at least another bug lurking..

Found another bug:

#define stack_smp_processor_id()					\
({								\
	struct thread_info *ti;						\
	__asm__("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
	ti->cpu;							\
})

That macro is obviously no longer valid.

That seems to cause the above warning.  When trying to boot CPU 1,
cpu_init() calls the above macro which incorrectly returns 0.

-- 
Josh
