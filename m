MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
 <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
 <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net> <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BC57C1@IRSMSX102.ger.corp.intel.com>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612BA4BC57C1@IRSMSX102.ger.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 Feb 2019 15:47:41 +0100
Message-ID: <CAG48ez2xpgLhEQp7y9AJw0gS2yk1kBC7SDbOG_7Piqti-1eiNA@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Perla, Enrico" <enrico.perla@intel.com>, Andy Lutomirski <luto@amacapital.net>, "keescook@chromium.org" <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 14, 2019 at 8:52 AM Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> After some thinking and discussions, let me try to summarize the options =
and the
> security benefits of each approach based on everyone else feedback before
> going any further with work. We all want only useful things in kernel, so=
 merging
> smth that provides a subtle/almost non-existing benefit is clearly not a =
priority.
>
> So, first about the protection methods. We can do randomization in two wa=
ys:
>
> 1. stack top itself (and location of pt_regs)
> 2. relative stack positioning (offset from pt_regs).
>
> In addition to randomization we can do some fixup on exit, like Andy prop=
osed:
>
> 3. Make sure CS always points to user on exit (for example by regs->cs |=
=3D 3),
> potentially smth else can be fixed up similarly, if needed
>
> Here are *known* (at least to me, please shout if you know more!) possibl=
e
> attacks vectors and implications on them by doing 1), 2) or 3)
>
> a) attacker's goal is to store some user-controlled data in pt_regs to re=
ference it later
>   1) pt_regs is not predictable, but can be discovered in ptrace-style sc=
enario or cache-probing.
>      If discovered, then attack succeeds as of now.
>   2) nothing changed for this type of attack, attack succeeds as of now
>   3) nothing changed for this type of attack, attack succeeds as of now
>
> b) attacker's goal is to return to userland from a syscall with CS pointi=
ng to kernel
>  1) pt_regs is not predictable, but can be discovered in ptrace-style sce=
nario or cache-probing.
>      If discovered, then attack succeeds as of now.
>  2) nothing changed for this type of attack, attack succeeds as of now
>  3) CS changed explicitly on exit, so impossible to have this attack, *gi=
ven* that the
>     change is done late enough and no races, sleeps, etc. are possible
>
> c) attacker's goal is to perform some kind of stack overflow into parts o=
f adjusted stack
>   memory via some method. Here the main unknown is the "method".
> This vector of attack is the challenge for the current exploit writers: I=
 guess if you can do
> it now with all the current protections for stack enabled, you get a nice=
 defcon talk at least :)
> VLA used to be an easy way of doing it, hopefully they are gone from the =
main source now
> (out of tree drivers is a different story).
> Uninitialized locals might be other way, but there is work ongoing to clo=
se this (see Kees's
> patches on stackinit).
> Smth else we don=E2=80=99t yet know?
> Now back to our proposed countermeasures given that attacker has found a =
way to do
> a crafted overflow and overwrite:
>
>   1) pt_regs is not predictable, but can be discovered in ptrace-style sc=
enario or cache-probing.
>      If discovered, then attack succeeds as of now.
>   2) relative stack offset is not predictable and randomized, cannot be p=
robed very easily via
>       cache or ptrace. So, this is an additional hurdle on the attacker's=
 way since stack is non-
>       deterministic now.
>   3) nothing changed for this type of attack, given that attacker's goal =
is not to overwrite CS
>       in adjusted pt_regs. If it is his goal, then it helps with that.
>
>
> Now summary:
>
> It would seem to me that:
>
> - regs->cs |=3D 3 on exit is a thing worth doing anyway, just because it =
is cheap, as Andy said, and it
> might make a positive difference in two out of three attack scenarios. Ob=
jections?
>
> - randomization of stack top is only worth doing in ptrace-blocked scenar=
io.
> Do we have such scenarios left that people care about?

There are some, I think; for example, Chrome renderers on desktop
Linux can't use ptrace.
