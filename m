Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrXFkzBvM1yBPwOTae3sUOvRfRJ9tbO35C8cfmuNov=y6w@mail.gmail.com>
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
 <CALCETrWC4u55TsW_B+DJOdfR8XkbZ5cXGtgKj5+JL5UU2ntUAg@mail.gmail.com>
 <CA+55aFxvZhBu9U1cqpVm4frv0p5mqu=0TxsSqE-=95ft8HvCVA@mail.gmail.com>
 <CALCETrX9LSNCrj6Z=QS122XUODpv89hEKi=U3rfxiaAZxs6E4Q@mail.gmail.com> <CALCETrXFkzBvM1yBPwOTae3sUOvRfRJ9tbO35C8cfmuNov=y6w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Jun 2016 18:23:19 -0700
Message-ID: <CA+55aFxyBaxsekkThob-fxww0-QynQLC3V_h=Z9ncb7b76orYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 25, 2016 at 4:30 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Maybe I'm misunderstanding the role of release_task.  It looks like
> there's this path in the scheduler I can borrow:
>
>     if (unlikely(prev_state == TASK_DEAD)) {
>
> With a kludge in place to free the stack in there and release_task and
> __put_task_struct, whichever is first, I get a nice speedup.
> Benchmarks coming later on.  Can I rely on that code path always being
> called?

Absolutely. That's the normal "task is done, put the thread struct".
IOW, that's the final "put_task_struct()" that the task "itself" calls
as it exits - there may be other things that hold a reference to the
task struct, but that's where you should free the stack because the
thread itself is done with it..

            Linus
