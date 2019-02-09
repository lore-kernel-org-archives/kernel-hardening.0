From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Date: Sat, 9 Feb 2019 11:13:52 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net>
In-Reply-To: <20190208142642.GJ32511@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "keescook@chromium.org" <keescook@chromium.org>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

> On Fri, Feb 08, 2019 at 01:20:09PM +0000, Reshetova, Elena wrote:
> > > On Fri, Feb 08, 2019 at 02:15:49PM +0200, Elena Reshetova wrote:
>=20
> > >
> > > Why can't we change the stack offset periodically from an interrupt o=
r
> > > so, and then have every later entry use that.
> >
> > Hm... This sounds more complex conceptually - we cannot touch
> > stack when it is in use, so we have to periodically probe for a
> > good time (when process is in userspace I guess) to change it from an i=
nterrupt?
> > IMO trampoline stack provides such a good clean place for doing it and =
we
> > have stackleak there doing stack cleanup, so would make sense to keep
> > these features operating together.
>=20
> The idea was to just change a per-cpu (possible per-task if you ctxsw
> it) offset that is used on entry to offset the stack.
> So only entries after the change will have the updated offset, any
> in-progress syscalls will continue with their current offset and will be
> unaffected.

Let me try to write this into simple steps to make sure I understand your
approach:

- create a new per-stack value (and potentially its per-cpu "shadow") calle=
d stack_offset =3D 0
- periodically issue an interrupt, and inside it walk the process tree and
  update stack_offset randomly for each process
- when a process makes a new syscall, it subtracts stack_offset value from =
top_of_stack()
 and that becomes its new  top_of_stack() for that system call.=20

Smth like this?=20

I think it is close to what Andy has proposed
in his reply, but the main difference is that you propose to do this via an=
 interrupt.=20
And the main reasoning for doing this via interrupt would be not to affect
syscall performance, right?=20

The problem I see with interrupt approach is how often that should be done?
Because we don't want to end up with situation when we issue it too often, =
since
it is not going to be very light-weight operation (update all processes), a=
nd we=20
don't want it to be too rarely done that we end up with processes that exec=
ute many
syscalls with the same offset. So, we might have a situation when some proc=
esses
 will execute a number of syscalls with same offset and some will change th=
eir offset
more than once without even making a single syscall.=20

Also I fear that attacker might have more playroom here, since we don't hav=
e any
fixed guarantees on randomization anymore, but it depends on interrupt sche=
duling,
syscall rate for a given process, etc. I don't know how real are these conc=
erns in
practice, but feels much more things to worry about.=20

Best Regards,
Elena.


=20
