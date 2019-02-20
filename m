MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
 <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
 <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net> <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com>
In-Reply-To: <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Feb 2019 14:15:15 -0800
Message-ID: <CAGXu5jJSWf=CAij3_dxA9+n6+fWtt1MOT3dWD07vdkhrfC8bpQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "Perla, Enrico" <enrico.perla@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Reshetova, Elena" <elena.reshetova@intel.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 12, 2019 at 2:16 AM Perla, Enrico <enrico.perla@intel.com> wrot=
e:
>   I was somewhat fond of randomizing the pt_regs location, as that is som=
ething I could relate with in writing an exploit (handy way to load user co=
ntrolled data to kernel at a known location).
>
> But, as Jann pointed out, that only has value in a ptrace-blocked sandbox=
, because the randomization offset can be leaked otherwise through ptrace P=
EEK/POKE and observing cache behavior. Worse, if ptrace is present, then th=
e randomization is moot.
>
> Since containers seems to be going towards leaving ptrace open, I'm now w=
ondering whether that is a good motivation at all and the proposed simplifi=
ed version is not just better.

It does seem that using a flaw to attack one's own registers is rather
pointless. Maybe we'll eat our words, but for now, I'd agree.

> That's all fair. What I struggle with is finding a precise motivation for=
 the randomization (granted this might be extended to other KASLR cases, so=
 perhaps is not a strong hard stop).
>
> The proposed randomization does fit the overall KASLR story and it does i=
ts job of not letting an attacker predict future stack offset from one leak=
, but in practical terms I'm struggling to find a case or two where this wo=
uld have made a difference in an exploit.
>
> Can any of you think of some?

As you know, exploits tend to be written using the
easiest-possible-path to attack, so prior to VMAP_STACK, thread_info
moving, and VLA removal, attacks would use those properties. However,
looking at something like half-nelson[1], an attack may just probe to
find the distance between stacks and using a confused index to jump
over guard pages, etc. But if that calculation is disrupted at every
syscall, reliability goes way down. (Which, BTW, is likely why stack
randomization might be better to do an syscall entry time so the
offset isn't calculated and left hanging around in memory to be
exposed via some other flaw before starting the next syscall.)

--=20
Kees Cook
