Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFxvZhBu9U1cqpVm4frv0p5mqu=0TxsSqE-=95ft8HvCVA@mail.gmail.com>
References: <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
 <20160623185340.GO30154@twins.programming.kicks-ass.net> <CA+55aFzhUo=2M-y39NOpWAVm1h0ADfjR3dxszJmefvoEYLa2og@mail.gmail.com>
 <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
 <CAMzpN2i7ve0Rq9BCxjp2FUw5naPLrGDd7Mf3evrrRjUZN75oJQ@mail.gmail.com>
 <CA+55aFwJ1=pyr9fP_UzDjnyX2qJ4mpxg_DTTiOJTv9PFW4dHgg@mail.gmail.com>
 <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
 <CA+55aFyKxNZQtCS3VY_8qMS4B=q-ar5ST8RdCTwAC07ZOkBjQA@mail.gmail.com>
 <CA+55aFx=wdH4v7cD2F5Kq+jwDfV5cz9qTANgOwpMTC3MY=99AQ@mail.gmail.com>
 <20160624202530.unmidps4kpebo2na@treble> <20160624205116.4hbnurrnan4afq2t@treble>
 <CA+55aFyWJSE3DdoZvtc=tkuqvn1eQC=-dK=kfQ70ZR_7xLTkvA@mail.gmail.com>
 <CALCETrXUZbsr+ZvcCsffCMGFwX7xs8zqM2WGtfwLd+ws7T5A6A@mail.gmail.com>
 <CA+55aFw96289kXRz9q7N=d4GD3eJxQB8ddV=GXMYm+Cd6Pk=Bg@mail.gmail.com>
 <CALCETrWC4u55TsW_B+DJOdfR8XkbZ5cXGtgKj5+JL5UU2ntUAg@mail.gmail.com> <CA+55aFxvZhBu9U1cqpVm4frv0p5mqu=0TxsSqE-=95ft8HvCVA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 25 Jun 2016 16:19:30 -0700
Message-ID: <CALCETrX9LSNCrj6Z=QS122XUODpv89hEKi=U3rfxiaAZxs6E4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 7:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 24, 2016 at 2:34 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>
>>> So let me get the pure semantic patches done, and then for 4.8 when we
>>> do the things that actually change real meaning we'll have a sane
>>> base. Ok?
>>
>> Works for me.  I'll see whether my vmap patches still apply and, if
>> needed, rebase and send a v5.
>
> Ok, I'e pushed out the cleanups (and all the pulls that always come in
> on Friday afternoon - gaah, I shouldn't have tried doing this on a
> Friday).
>
> I'm attaching the current left-over patch that actually changes
> things. It's obviously a composite, and includes your "remove
> stack_smp_processor_id()" thing etc, so it's not meant to be used
> as-is, but it does seem to work.
>
> Interestingly, it seems pretty clean too, removing more lines than it
> adds (despite the fact that it adds a new config option), and
> generally making things prettier rather than the reverse.
>
> That's always a good sign.

I rebased my series onto your tree and then rebased this thing onto my
series, tweaked it some, and split it up a bit.  My version works a
bit differently (thread_info has a single element if the new option is
set) but is otherwise more or less your code.  It seems to work.

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=01ac3242f314405c1bac0f820ec3575a850509d3
https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=87194cac139aebecec89a68eff719ab44f0469a2

On top of *that*, I taught the kernel to free stacks in release_task
and to cache stacks if vmalloced.  That still blows up: when
cryptomgr_test calls do_exit during boot, do_exit calls exit_notify,
which observes that the task state is TASK_DEAD and thus calls
release_task on itself and goes boom.

Linus, Oleg, help?  How am I supposed to quickly free the stack if the
task goes through this code path?  In fact, why does this work on
current kernels?  After all, can't schedule() indicates an RCU grace
period?  In principle, what prevents delayed_put_task_struct from
deleting the running stack before scheduling?

My kludged up patch that only early-releases the stack if release_task
is called from a different task is here:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=2327ca2ab3d634d120ea185e737fef2e4e9cf012

Ick.
