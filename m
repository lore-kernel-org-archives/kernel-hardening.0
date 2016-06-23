Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20160623170352.GA17372@redhat.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com> <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Jun 2016 10:44:08 -0700
Message-ID: <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 10:03 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Let me quote my previous email ;)
>
>         And we can't free/nullify it when the parent/debuger reaps a zomb=
ie,
>         say, mark_oom_victim() expects that get_task_struct() protects
>         thread_info as well.
>
> probably we can fix all such users though...

TIF_MEMDIE is indeed a potential problem, but I don't think
mark_oom_victim() is actually problematic.

mark_oom_victim() is called with either "current", or with a victim
that still has its mm and signal pointer (and the task is locked). So
the lifetime is already guaranteed - or that code is already very very
buggy, since it follows tsk->signal and tsk->mm

So as far as I can tell, that's all fine.

That said, by now it would actually in many ways be great if we could
get rid of thread_info entirely. The historical reasons for
thread_info have almost all been subsumed by the percpu area.

The reason for thread_info originally was

 - we used to find the task_struct by just masking the stack pointer
(long long ago). When the task struct grew too big, we kept just the
critical pieces and some arch-specific stuff and , called it
"thread_info", and moved the rest to an external allocation and added
the pointer to it.

 - the really crticial stuff we didn't want to follow a pointer for,
so things like preempt_count etc were in thread_info

 - but they were *so* critical that PeterZ (at my prodding) moved
those things to percpu caches that get updated at schedule time
instead

so these days, thread_info has almost nothing really critical in it
any more. There's the thread-local flags, yes, but they could stay or
easily be moved to the task_struct or get similar per-cpu fixup as
preempt_count did a couple of years ago. The only annoyance is the few
remaining entry code assembly sequences, but I suspect they would
actually become simpler with a per-cpu thing, and with Andy's cleanups
they are pretty insignificant these days. There seems to be exactly
two uses of ASM_THREAD_INFO(TI_flags,.. left.

So I suspect that it would

 (a) already be possible to just free the stack and thread info at
release time, because any rcu users will already be doing task_lock()
and check mm etc.

 (b) it probably would be a nice cleanup to try to make it even more
obviously safe by just shrinking thread_info more (or even getting rid
of it entirely, but that may be too painful because there are other
architectures that may depend on it more).

I dunno. Looking at what remains of thread_info, it really doesn't
seem very critical.

The thread_info->tsk pointer, that was one of the most critical issues
and the main raison d'=C3=AAtre of the thread_info, has been replaced on
x86 by just using the per-cpu "current_task". Yes,.there are probably
more than a few "ti->task" users left for legacy reasons, harking back
to when the thread-info was cheaper to access, but it shouldn't be a
big deal.

                  Linus
