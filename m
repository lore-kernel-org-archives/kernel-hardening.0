Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyYruc_7Ax-hjh96zXPWmJJpCqm0yqq-fYpT094owSO_Q@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com> <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
 <20160623170352.GA17372@redhat.com> <CA+55aFwHUw+6xEc-M+mZvwOxCsBD6zZDwyAQ-a_xupaH8py7cA@mail.gmail.com>
 <CA+55aFy54iDN56FDJAz3A8epRvKECVO+nL5LaMxdmKrFEOm05w@mail.gmail.com> <CA+55aFyYruc_7Ax-hjh96zXPWmJJpCqm0yqq-fYpT094owSO_Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 23 Jun 2016 12:08:59 -0700
Message-ID: <CALCETrUkMKLZfCfk7GF_EX4xrxwPfGMoWKR2FGMmjYYqH_yk_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 11:46 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jun 23, 2016 at 10:52 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Ugh. Looking around at this, it turns out that a great example of this
>> kind of legacy issue is the debug_mutex stuff.
>
> Interestingly, the *only* other user of ti->task for a full
> allmodconfig build of x86-64 seems to be
>
>   arch/x86/kernel/dumpstack.c
>
> with the print_context_stack() -> print_ftrace_graph_addr() -> task =
> tinfo->task chain.
>
> And that doesn't really seem to want thread_info either. The callers
> all have 'task', and have to generate thread_info from that anyway.
>
> So this attached patch (which includes the previous one) seems to
> build. I didn't actually boot it, but there should be no users left
> unless there is some asm code that has hardcoded offsets..

I think you'll break some architectures when you remove the
initialization of ti->task.  That either needs to be pushed down into
arch code in unicore32, openrisc, microblaze, powerpx, xtensa, sparc,
parisc, arm, mips, s390, and whatever I missed, or you should leave
the field initialized and existing and wait for my patch to
conditionally remove/embed thread_info to get rid of the
initialization part.

On the C side, there's:

arm's contextidr_notifier (easily fixable)

sh's irqctx->tinfo.task = curctx->task; (probably useless) and
print_ftrace_graph_addr

cris's ugdb_trap_user (probably easily fixable)

sparc's arch_trigger_all_cpu_backtrace (possibly quite hard to fix)

sparc's flush_thread (trivial)

sparc's __save_stack_trace (not sure)

unicore's __die (probably easy)

metag's do_softirq_own_stack (not sure if it's useful)


I found these with this coccinelle script:

@@
struct thread_info *ti;
@@

* ti->task

$ spatch --sp-file titask.cocci --dir .
