MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Sat, 9 Feb 2019 10:25:48 -0800
Message-ID: <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "keescook@chromium.org" <keescook@chromium.org>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 9, 2019 at 3:13 AM Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>
> > On Fri, Feb 08, 2019 at 01:20:09PM +0000, Reshetova, Elena wrote:
> > > > On Fri, Feb 08, 2019 at 02:15:49PM +0200, Elena Reshetova wrote:
> >
> > > >
> > > > Why can't we change the stack offset periodically from an interrupt or
> > > > so, and then have every later entry use that.
> > >
> > > Hm... This sounds more complex conceptually - we cannot touch
> > > stack when it is in use, so we have to periodically probe for a
> > > good time (when process is in userspace I guess) to change it from an interrupt?
> > > IMO trampoline stack provides such a good clean place for doing it and we
> > > have stackleak there doing stack cleanup, so would make sense to keep
> > > these features operating together.
> >
> > The idea was to just change a per-cpu (possible per-task if you ctxsw
> > it) offset that is used on entry to offset the stack.
> > So only entries after the change will have the updated offset, any
> > in-progress syscalls will continue with their current offset and will be
> > unaffected.
>
> Let me try to write this into simple steps to make sure I understand your
> approach:
>
> - create a new per-stack value (and potentially its per-cpu "shadow") called stack_offset = 0
> - periodically issue an interrupt, and inside it walk the process tree and
>   update stack_offset randomly for each process
> - when a process makes a new syscall, it subtracts stack_offset value from top_of_stack()
>  and that becomes its new  top_of_stack() for that system call.
>
> Smth like this?

I'm proposing somthing that is conceptually different.  You are,
conceptually, changing the location of the stack.  I'm suggesting that
you leave the stack alone and, instead, randomize how you use the
stack.  In plain C, this would consist of adding roughly this snippet
in do_syscall_64() and possibly other entry functions:

if (randomize_stack()) {
  void *dummy = alloca(rdrand() & 0x7f8);

  /* Make sure the compiler doesn't optimize out the alloca. */
  asm volatile ("" :: "=rm" (dummy));
}

... do the actual syscall work here.

This has a few problems, namely that the generated code might be awful
and that alloca is more or less banned in the kernel.  I suppose
alloca could be unbanned in the entry C code, but this could also be
done fairly easily in the asm code.  You'd just need to use a register
to store whatever is needed to put RSP back in the exit code.  The
obvious way would be to use RBP, but it's plausible that using a
different callee-saved register would make the unwinder interactions
easier to get right.

With this approach, you don't modify any of the top_of_stack()
functions or macros at all -- the top of stack isn't changed.

>
> I think it is close to what Andy has proposed
> in his reply, but the main difference is that you propose to do this via an interrupt.
> And the main reasoning for doing this via interrupt would be not to affect
> syscall performance, right?
>
> The problem I see with interrupt approach is how often that should be done?
> Because we don't want to end up with situation when we issue it too often, since
> it is not going to be very light-weight operation (update all processes), and we
> don't want it to be too rarely done that we end up with processes that execute many
> syscalls with the same offset. So, we might have a situation when some processes
>  will execute a number of syscalls with same offset and some will change their offset
> more than once without even making a single syscall.

I bet that any attacker worth their salt could learn the offset by
doing a couple of careful syscalls and looking for cache and/or TLB
effects.  This might make the whole exercise mostly useless.  Isn't
RDRAND supposed to be extremely fast, though?

I usually benchmark like this:

$ ./timing_test_64 10M sys_enosys
10000000 loops in 2.53484s = 253.48 nsec / loop

using https://git.kernel.org/pub/scm/linux/kernel/git/luto/misc-tests.git/
