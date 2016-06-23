Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 23 Jun 2016 20:52:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20160623185221.GA17983@redhat.com>
References: <cover.1466466093.git.luto@kernel.org>
 <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com>
 <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com>
 <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 06/23, Linus Torvalds wrote:
>
> On Thu, Jun 23, 2016 at 10:03 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Let me quote my previous email ;)
> >
> >         And we can't free/nullify it when the parent/debuger reaps a zombie,
> >         say, mark_oom_victim() expects that get_task_struct() protects
> >         thread_info as well.
> >
> > probably we can fix all such users though...
>
> TIF_MEMDIE is indeed a potential problem, but I don't think
> mark_oom_victim() is actually problematic.
>
> mark_oom_victim() is called with either "current",

This is no longer true in -mm tree.

But I agree, this is fixable (and in fact I still hope TIF_MEMDIE will die,
at least in its current form).

But I am afraid we can have more users which assume that thread_info can't
go away if you have a reference to task_struct.

And yes, we have a users which rely on RCU, say show_state_filter() which
walks the task under rcu_read_lock() and calls sched_show_task() which prints
task_thread_info(p)->flags.

Yes this is fixable too, but

> so these days, thread_info has almost nothing really critical in it
> any more. There's the thread-local flags, yes, but they could stay or
> easily be moved to the task_struct or get similar per-cpu fixup as
> preempt_count did a couple of years ago. The only annoyance is the few
> remaining entry code assembly sequences, but I suspect they would
> actually become simpler with a per-cpu thing, and with Andy's cleanups
> they are pretty insignificant these days. There seems to be exactly
> two uses of ASM_THREAD_INFO(TI_flags,.. left.

So perhaps on x86_64 we should move thread_info from thread_union to
task_struct->thread as Andy suggests.


And just in case, even if we move thread_info, of course we will need
to change dump_trace/etc which reads ->stack. Again, show_state_filter()
relies on RCU, proc_pid_stack() on get_task_struct(). They need to pin
task->stack somehow,  but this is clear.

Oleg.
