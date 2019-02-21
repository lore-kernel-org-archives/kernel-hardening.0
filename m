MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
 <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
 <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net> <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BC57C1@IRSMSX102.ger.corp.intel.com> <CAGXu5jLbR0Tk6XEdCg+27bsc4+SKGwzNsV12imwjHnLmmpV0mA@mail.gmail.com>
In-Reply-To: <CAGXu5jLbR0Tk6XEdCg+27bsc4+SKGwzNsV12imwjHnLmmpV0mA@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 20 Feb 2019 22:37:45 -0800
Message-ID: <CALCETrW84mH-jfKOCKmdODL06Bhzugck+vVt-vDe9byA27V=Jg@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "Perla, Enrico" <enrico.perla@intel.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

> On Feb 20, 2019, at 2:20 PM, Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Feb 13, 2019 at 11:52 PM Reshetova, Elena
> <elena.reshetova@intel.com> wrote:
>> Now back to our proposed countermeasures given that attacker has found a=
 way to do
>> a crafted overflow and overwrite:
>>
>>  1) pt_regs is not predictable, but can be discovered in ptrace-style sc=
enario or cache-probing.
>>     If discovered, then attack succeeds as of now.
>>  2) relative stack offset is not predictable and randomized, cannot be p=
robed very easily via
>>      cache or ptrace. So, this is an additional hurdle on the attacker's=
 way since stack is non-
>>      deterministic now.
>>  3) nothing changed for this type of attack, given that attacker's goal =
is not to overwrite CS
>>      in adjusted pt_regs. If it is his goal, then it helps with that.
>>
>>
>> Now summary:
>>
>> It would seem to me that:
>>
>> - regs->cs |=3D 3 on exit is a thing worth doing anyway, just because it=
 is cheap, as Andy said, and it
>> might make a positive difference in two out of three attack scenarios. O=
bjections?
>
> I would agree, let's just do this.

Thinking slightly more about this, it=E2=80=99s an incomplete protection.  =
It
keeps an attacker from returning to kernel mode, but it does not
protect the privileged flag bits.  I think that IOPL is the only thing
we really care about, and doing anything useful about IOPL would be
rather more complex, unfortunately.  I suppose we could just zero it
and guard that with a static branch that is switched off the first
time anyone uses iopl(3).

I suppose we could also add a config option to straight-up disable
IOPL.  I sincerely hope that no one uses it any more. Even the small
number of semi-legit users really ought to be using ioperm() instead.

>
>> - randomization of stack top is only worth doing in ptrace-blocked scena=
rio.
>> Do we have such scenarios left that people care about?
>> Because if we do, then we know that there is a real attack vector that w=
e close this way, otherwise not.
>> This is actually interesting, because we need to remember to take ptrace=
 into our overall
>> kernel hardening threat model (smth that at least I haven't quite realiz=
ed before) and evaluate every new
>> feature (especially randomization ones) being robust against ptrace prob=
ing.
>>
>> - randomization after pt_regs only would make a difference in attack sce=
nario "c", for which
>>  we don't yet have a proof of concept exploit or technique that would wo=
rk (does not guarantee that
>> attackers don't have the exploits ready through :( ).
>> So, if we implement this, the "justification part" for the feature would=
 be smth like "to make it
>> harder for future possible stack-based exploits that utilize overflows",=
 if/when someone find a new
>> 'ala VLA' way of doing the controlled overflow.
>> How do people feel about it? Is it worth having? I can work on the POC f=
or this in direction that Andy
>> outlined and can provide performance impact/etc., but it is good that we=
 understand that we cannot
>> provide a better justification for this feature at the moment unless som=
eone is ready to share some
>> new exploit technique with us.
>
> I think this make sense. I do think, however, the work should be done
> at syscall entry, though. Thoughts?
>
>

Seems reasonable to me.
