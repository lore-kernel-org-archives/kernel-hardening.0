Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com> <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com> <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
 <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com>
 <20160623185340.GO30154@twins.programming.kicks-ass.net> <CA+55aFzhUo=2M-y39NOpWAVm1h0ADfjR3dxszJmefvoEYLa2og@mail.gmail.com>
 <CA+55aFxo8tU42+hMjRgs1dUrqn1=rzDnvikRHHWV9HwDVeYkuQ@mail.gmail.com>
 <CAMzpN2i7ve0Rq9BCxjp2FUw5naPLrGDd7Mf3evrrRjUZN75oJQ@mail.gmail.com>
 <CA+55aFwJ1=pyr9fP_UzDjnyX2qJ4mpxg_DTTiOJTv9PFW4dHgg@mail.gmail.com> <CA+55aFyu=G09-Qg=M-7CmAudS1Mj+OZMPNerd9VfUwvNk8VL+Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 24 Jun 2016 10:47:04 -0700
Message-ID: <CALCETrUh0s8zV0S=Si4V_RB1dEUx6n2RtALC-+VJhGMEBqPTzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brian Gerst <brgerst@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 24, 2016 at 10:40 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 24, 2016 at 10:21 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> But as mentioned, I must have missed something. There were a number of
>> places where the code used the task_stack_page() and
>> task_thread_info() interchangably, which used to work and is no longer
>> true. There might simply be cases I missed.
>
> .. and immediately as I wrote that, I went "Duh".
>
> One place I missed was free_thread_info(), which should now free the
> stack, not the ti pointer. But it does
>
>         struct page *page = virt_to_page(ti);
>
> and frees that, which is bogus. It turns out that we do do
>
>         free_thread_info(tsk->stack);
>
> which is bogus too, and undoes it, but I think I have a few new places
> to look at..

Try patching in this thing, which cleans up a bunch of that core crap:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vmap_stack&id=7ca9fb6bbf2838cc94b2af41e94854d02649c58c

It might not apply without the rest of my series, though.

FWIW, your patch is much more lenient than my approach: I was planning
prohibiting architectures from supplying their own struct thread_info
if they put it in task_struct.  To make that work, I have patches to
remove everything but cpu, flags, and task from x86's thread_info
first.  I'm planning on tidying them up and sending them out after the
vmap stack stuff lands in -tip -- I don't want to have big series that
depend on each other flying around by email at the same time, because
everyone will go nuts trying to figure out what applies where.

--Andy
