MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
 <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
 <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net> <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com>
 <CAGXu5jJSWf=CAij3_dxA9+n6+fWtt1MOT3dWD07vdkhrfC8bpQ@mail.gmail.com>
 <5E269FBC3009974381A340959F3135C95C8FE7E1@hasmsx108.ger.corp.intel.com>
 <CAGXu5jJoODVOd8Bt+eMRPGvm=ZZNBHVmGE8LBsgMk6K=1Dv-cQ@mail.gmail.com> <5E269FBC3009974381A340959F3135C95C8FE928@hasmsx108.ger.corp.intel.com>
In-Reply-To: <5E269FBC3009974381A340959F3135C95C8FE928@hasmsx108.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 11:18:32 -0800
Message-ID: <CAGXu5j+=KSiRgi4HXd=vQLT1YkWcOS3NxwrczBedhcb+CFB+tg@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
To: "Perla, Enrico" <enrico.perla@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Reshetova, Elena" <elena.reshetova@intel.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 9:48 AM Perla, Enrico <enrico.perla@intel.com> wrote:
> In many kernel exploits one needs to emulate structures (or provide some controlled data) to keep things stable, do a second stage, etc.
> Old school approach was to dereference to userland. Now, with SMAP (or any other dereference protection), that cannot be done anymore.

Oh, I see now: using the pt_regs storage as a place in kernel memory
to have built the malicious structure. Got it.

> If I have a stack address leak, then I have a pretty nice primitive through pt_regs to load some arbitrary content at a known address.
> As discussed with Jan, if I have ptrace, randomization is basically moot. I can just PTRACE_SYSCALL and time my way to the correct location.
> Actually, randomization could even help getting some needed alignment.

Okay, I've chatted more with Jann off-list now; he's enlightened me
with more examples. Thank you both for walking me through my
denseness. :)

> So the open questions are:
> 1) are pt_regs considered enough of a vector to add the randomization nuisance?

In most cases, to be able to locate pt_regs at a fixed location, you
already need a stack address location leak. If you have such a leak,
and pt_regs location is randomized, a second thread's pt_regs could be
used, held with ptrace, and have prime+probe with PEEKs to figure out
where the offset to pt_regs is. And the other thread would just use
THAT pt_regs for its scratch space.

So, while it'd be nice to randomize it, it seems that only when there
are no other threads and no ptrace would it be useful (i.e. the
sandbox situation, as you've said).

> 2) is it worthwhile to randomize both pt_regs and the stack start location, so that ptrace doesn't leak at least the latter?

Given the pile of prerequisites needed for these attacks, I would say
"no" currently. In my assessment, I generally think a sandboxed
environment will already have reduced attack surface, so whatever
needed flaws may already be unavailable. These stack attacks tend to
need a lot of pieces working together, so better to optimize this
defense for the non-sandboxed case, in order to reduce the code's
complexity.

> I had mostly sandboxed scenarios in mind, I guess you had mostly the stackjacking case.
>
> Any variation on the above is ok, from not considering any of this worthwhile to doing just some - as long as the tradeoffs are clear (which is basically Elena's email), since randomization ends up being always a stopgap, not really a great defense.
>
> I don't have a strong opinion on any of this, especially since lots is happening to reduce/remove the leaking of kernel stack contents.

I'm sufficiently convinced that with all the trade-offs, leaving
pt_regs unrandomized is fine. If all we see is sandbox escapes using
fixed-location pt_regs, well, then we can change this later. :)

--
Kees Cook
