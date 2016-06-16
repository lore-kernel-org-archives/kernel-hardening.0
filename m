Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrUTwG+fNgJQP8wYsAbxzjzARUwJ05jaRs0XfFPDHTB+ZQ@mail.gmail.com>
References: <cover.1466036668.git.luto@kernel.org> <20160616060538.GA3923@osiris>
 <CALCETrUTwG+fNgJQP8wYsAbxzjzARUwJ05jaRs0XfFPDHTB+ZQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Jun 2016 11:14:33 -0700
Message-ID: <CALCETrVsOwy=dB16OgQ5OYkkn3ShyQyUxzjyJzsaeLO4m0ohEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Heiko Carstens <heiko.carstens@de.ibm.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Adding Paul, because RCU blew up.

On Thu, Jun 16, 2016 at 10:50 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jun 15, 2016 at 11:05 PM, Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
>> On Wed, Jun 15, 2016 at 05:28:22PM -0700, Andy Lutomirski wrote:
>>> Since the dawn of time, a kernel stack overflow has been a real PITA
>>> to debug, has caused nondeterministic crashes some time after the
>>> actual overflow, and has generally been easy to exploit for root.
>>>
>>> With this series, arches can enable HAVE_ARCH_VMAP_STACK.  Arches
>>> that enable it (just x86 for now) get virtually mapped stacks with
>>> guard pages.  This causes reliable faults when the stack overflows.
>>>
>>> If the arch implements it well, we get a nice OOPS on stack overflow
>>> (as opposed to panicing directly or otherwise exploding badly).  On
>>> x86, the OOPS is nice, has a usable call trace, and the overflowing
>>> task is killed cleanly.
>>
>> Do you have numbers which reflect the performance impact of this change?
>>
>
> Hmm.  My attempt to benchmark it caused some of the vmalloc core code
> to hang.  I'll dig around.

[  488.482010] Call Trace:
[  488.482389]  <IRQ>  [<ffffffff810da5f6>] sched_show_task+0xb6/0x110
[  488.483341]  [<ffffffff81108c7a>] rcu_check_callbacks+0x83a/0x840
[  488.484226]  [<ffffffff810dd48a>] ? account_system_time+0x7a/0x110
[  488.485157]  [<ffffffff8111c0f0>] ? tick_sched_do_timer+0x30/0x30
[  488.486133]  [<ffffffff8110d314>] update_process_times+0x34/0x60
[  488.487050]  [<ffffffff8111bb51>] tick_sched_handle.isra.13+0x31/0x40
[  488.488018]  [<ffffffff8111c128>] tick_sched_timer+0x38/0x70
[  488.488853]  [<ffffffff8110db2a>] __hrtimer_run_queues+0xda/0x250
[  488.489739]  [<ffffffff8110e263>] hrtimer_interrupt+0xa3/0x190
[  488.490630]  [<ffffffff810952f3>] local_apic_timer_interrupt+0x33/0x50
[  488.491660]  [<ffffffff81095d58>] smp_apic_timer_interrupt+0x38/0x50
[  488.492644]  [<ffffffff8194d022>] apic_timer_interrupt+0x82/0x90
[  488.493502]  [<ffffffff810ee1c0>] ? queued_spin_lock_slowpath+0x20/0x190
[  488.494550]  [<ffffffff8194c21b>] _raw_spin_lock+0x1b/0x20
[  488.495321]  [<ffffffff811b7a54>] find_vmap_area+0x14/0x60
[  488.496197]  [<ffffffff811b8f69>] find_vm_area+0x9/0x20
[  488.496922]  [<ffffffff810afb19>] account_kernel_stack+0x89/0x100
[  488.497885]  [<ffffffff810aff76>] free_task+0x16/0x50
[  488.498599]  [<ffffffff810b0042>] __put_task_struct+0x92/0x120
[  488.499525]  [<ffffffff810b4a66>] delayed_put_task_struct+0x76/0x80
[  488.500348]  [<ffffffff81107969>] rcu_process_callbacks+0x1f9/0x5e0
[  488.501208]  [<ffffffff810b7ca1>] __do_softirq+0xf1/0x280
[  488.501932]  [<ffffffff810b7f7e>] irq_exit+0x9e/0xa0
[  488.502955]  [<ffffffff81095d5d>] smp_apic_timer_interrupt+0x3d/0x50
[  488.503943]  [<ffffffff8194d022>] apic_timer_interrupt+0x82/0x90
[  488.504886]  <EOI>  [<ffffffff8194c20b>] ? _raw_spin_lock+0xb/0x20
[  488.505877]  [<ffffffff811b7c33>] ? __get_vm_area_node+0xc3/0x160
[  488.506812]  [<ffffffff810e013e>] ? task_move_group_fair+0x7e/0x90
[  488.507730]  [<ffffffff811b9360>] __vmalloc_node_range+0x70/0x280
[  488.508689]  [<ffffffff810b1ce5>] ? _do_fork+0xc5/0x370
[  488.509512]  [<ffffffff811ceb9b>] ? kmem_cache_alloc_node+0x7b/0x170
[  488.510502]  [<ffffffff81327418>] ? current_has_perm+0x38/0x40
[  488.511430]  [<ffffffff810b0501>] copy_process.part.46+0x141/0x1760
[  488.512449]  [<ffffffff810b1ce5>] ? _do_fork+0xc5/0x370
[  488.513285]  [<ffffffff8111faf3>] ? do_futex+0x293/0xad0
[  488.514093]  [<ffffffff810df14a>] ? check_preempt_wakeup+0x10a/0x240
[  488.515108]  [<ffffffff810d92c2>] ? wake_up_new_task+0xf2/0x180
[  488.516043]  [<ffffffff810b1ce5>] _do_fork+0xc5/0x370
[  488.516786]  [<ffffffff8112039d>] ? SyS_futex+0x6d/0x150
[  488.517615]  [<ffffffff810b2014>] SyS_clone+0x14/0x20
[  488.518385]  [<ffffffff81002b72>] do_syscall_64+0x52/0xb0
[  488.519239]  [<ffffffff8194c4e1>] entry_SYSCALL64_slow_path+0x25/0x25

The bug seems straightforward: vmap_area_lock is held, the RCU softirq
fires, and vmap_area_lock recurses and deadlocks.  Lockdep agrees with
my assessment and catches the bug immediately on boot.

What's the right fix?  Change all spin_lock calls on vmap_area_lock to
spin_lock_bh?  Somehow ask RCU not to call delayed_put_task_struct
from bh context?  I would naively have expected RCU to only call its
callbacks from thread context, but I was clearly wrong.

--Andy
