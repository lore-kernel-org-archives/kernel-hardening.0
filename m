MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net>
In-Reply-To: <20190208142642.GJ32511@hirez.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 13:51:44 -0800
Message-ID: <CAGXu5jJ65i5nu7kZhSnE71ohuiz-FCxWvGapdktVzkvcf1FJfg@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 8, 2019 at 6:26 AM Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Feb 08, 2019 at 01:20:09PM +0000, Reshetova, Elena wrote:
> > > On Fri, Feb 08, 2019 at 02:15:49PM +0200, Elena Reshetova wrote:
>
> > >
> > > Why can't we change the stack offset periodically from an interrupt or
> > > so, and then have every later entry use that.
> >
> > Hm... This sounds more complex conceptually - we cannot touch
> > stack when it is in use, so we have to periodically probe for a
> > good time (when process is in userspace I guess) to change it from an interrupt?
> > IMO trampoline stack provides such a good clean place for doing it and we
> > have stackleak there doing stack cleanup, so would make sense to keep
> > these features operating together.
>
> The idea was to just change a per-cpu (possible per-task if you ctxsw
> it) offset that is used on entry to offset the stack.
>
> So only entries after the change will have the updated offset, any
> in-progress syscalls will continue with their current offset and will be
> unaffected.

These defenses tend to need randomization between syscalls to actually
disrupt an attack. (Take for example, the attack I demonstrated with
uninitialized stack variables[1], which used back-to-back syscalls,
one to prime the memory contents followed by one to use those values
for an exploit.)

(Though I would say that with CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL=y
the uninitialized variables issue.)

-Kees

[1] https://www.defcon.org/images/defcon-19/dc-19-presentations/Cook/DEFCON-19-Cook-Kernel-Exploitation.pdf
slide 21

-- 
Kees Cook
