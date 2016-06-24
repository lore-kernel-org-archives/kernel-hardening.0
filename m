Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrXUZbsr+ZvcCsffCMGFwX7xs8zqM2WGtfwLd+ws7T5A6A@mail.gmail.com>
References: <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
 <20160623185340.GO30154@twins.programming.kicks-ass.net> <CA+55aFzhUo=2M-y39NOpWAVm1h0ADfjR3dxszJmefvoEYLa2og@mail.gmail.com>
 <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
 <CAMzpN2i7ve0Rq9BCxjp2FUw5naPLrGDd7Mf3evrrRjUZN75oJQ@mail.gmail.com>
 <CA+55aFwJ1=pyr9fP_UzDjnyX2qJ4mpxg_DTTiOJTv9PFW4dHgg@mail.gmail.com>
 <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
 <CA+55aFyKxNZQtCS3VY_8qMS4B=q-ar5ST8RdCTwAC07ZOkBjQA@mail.gmail.com>
 <CA+55aFx=wdH4v7cD2F5Kq+jwDfV5cz9qTANgOwpMTC3MY=99AQ@mail.gmail.com>
 <20160624202530.unmidps4kpebo2na@treble> <20160624205116.4hbnurrnan4afq2t@treble>
 <CA+55aFyWJSE3DdoZvtc=tkuqvn1eQC=-dK=kfQ70ZR_7xLTkvA@mail.gmail.com> <CALCETrXUZbsr+ZvcCsffCMGFwX7xs8zqM2WGtfwLd+ws7T5A6A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 24 Jun 2016 14:32:38 -0700
Message-ID: <CA+55aFw96289kXRz9q7N=d4GD3eJxQB8ddV=GXMYm+Cd6Pk=Bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 2:25 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> What's the prognosis for this patch?  Should I queue up all the pieces
> and send them out after the vmap-stack thing?

I'm going to split this thing up and apply the "semantically null"
cleanup parts.

For example, this patch makes it clear that our current
"alloc_thread_info_node()" this is entirely insane.

We literally do:

        ti = alloc_thread_info_node(tsk, node);
        ...
        tsk->stack = ti;

and

        arch_release_thread_info(tsk->stack);
        free_thread_info(tsk->stack);

and the pure *confusion* there is just crazy. We're talking
"tsk->stack", but then we talk about freeing and allocating
"thread_info"

So I'll apply the whole "rename 'free_thread_info()' into
'free_thread_stack()'" part independently of anything else. It will
not change any semantics at all, since we currently have "tsk->stack
== thread_info", but it's too ugly to live, and it will then make the
patches that *do* change semantics much clearer and easier to see.

So let me get the pure semantic patches done, and then for 4.8 when we
do the things that actually change real meaning we'll have a sane
base. Ok?

                   Linus
