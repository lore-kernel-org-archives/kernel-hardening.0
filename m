Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com> <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com> <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
 <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
 <20160623185340.GO30154@twins.programming.kicks-ass.net> <CA+55aFzhUo=2M-y39NOpWAVm1h0ADfjR3dxszJmefvoEYLa2og@mail.gmail.com>
 <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Fri, 24 Jun 2016 08:25:20 -0400
Message-ID: <CAMzpN2i7ve0Rq9BCxjp2FUw5naPLrGDd7Mf3evrrRjUZN75oJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 2:17 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jun 23, 2016 at 12:17 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> With the goal being that I'm hoping that we can then actually get rid
>> of this (at least on x86-64, even if we leave it in some other
>> architectures) in 4.8.
>
> The context here was that we could almost get rid of thread-info
> entirely, at least for x86-64, by moving it into struct task_struct.
>
> It turns out that we're not *that* far off after the obvious cleanups
> I already committed, but I couldn't get things quite to work.
>
> I'm attaching a patch that I wrote today that doesn't boot, but "looks
> right". The reason I'm attaching it is because I'm hoping somebody
> wants to take a look and maybe see what else I missed, but mostly
> because I think the patch is interesting in a couple of cases where we
> just do incredibly ugly things.
>
> First off, some code that Andy wrote when he re-organized the entry path.
>
> Oh Gods, Andy. That pt_regs_to_thread_info() thing made me want to do
> unspeakable acts on a poor innocent wax figure that looked _exactly_
> like you.
>
> I just got rid of pt_regs_to_thread_info() entirely, and just replaced
> it with current_thread_info().  I'm not at all convinced that trying
> to be that clever was really a good idea.
>
> Secondly, the x86-64 ret_from_fork calling convention was documented
> wrongly. It says %rdi contains the previous task pointer. Yes it does,
> but it doesn't mention that %r8 is supposed to contain the new
> thread_info. That was fun to find.
>
> And thirdly, the stack size games that asm/kprobes.h plays are just
> disgusting. I stared at that code for much too long. I may in fact be
> going blind as a result.
>
> The rest was fairly straightforward, although since the end result
> doesn't actually work, that "straightforward" may be broken too. But
> the basic approach _looks_ sane.
>
> Comments? Anybody want to play with this and see where I went wrong?
>
> (Note - this patch was written on top of the two thread-info removal
> patches I committed in
>
>    da01e18a37a5 x86: avoid avoid passing around 'thread_info' in stack
> dumping code
>    6720a305df74 locking: avoid passing around 'thread_info' in mutex
> debugging code
>
> and depends on them, since "ti->task" no longer exists with
> CONFIG_THREAD_INFO_IN_TASK. "ti" and "task" will have the same value).
>
>                  Linus

  * A newly forked process directly context switches into this address.
  *
  * rdi: prev task we switched from
+ * rsi: task we're switching to
  */
 ENTRY(ret_from_fork)
-    LOCK ; btr $TIF_FORK, TI_flags(%r8)
+    LOCK ; btr $TIF_FORK, TI_flags(%rsi)    /* rsi: this newly forked task */

     call    schedule_tail            /* rdi: 'prev' task parameter */

I think you forgot GET_THREAD_INFO() here.  RSI is the task, not the
thread_info.  FYI, this goes away with my switch_to() rewrite, which
removes TIF_FORK.

--
Brian Gerst
