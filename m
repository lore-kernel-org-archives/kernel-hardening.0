Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon system call
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CAG48ez3sh+qcw9X6u2M0apRdN2TJR5Z-MGQS_UcmDhje+44CSA@mail.gmail.com>
Date: Thu, 21 Feb 2019 07:49:23 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <B9C55CFA-74CE-4241-B9D0-F2087A4D35DB@amacapital.net>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com> <1549628149-11881-2-git-send-email-elena.reshetova@intel.com> <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com> <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com> <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com> <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net> <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com> <2236FBA76BA1254E88B949DDB74E612BA4BC57C1@IRSMSX102.ger.corp.intel.com> <CAGXu5jLbR0Tk6XEdCg+27bsc4+SKGwzNsV12imwjHnLmmpV0mA@mail.gmail.com> <CALCETrW84mH-jfKOCKmdODL06Bhzugck+vVt-vDe9byA27V=Jg@mail.gmail.com> <CAG48ez3sh+qcw9X6u2M0apRdN2TJR5Z-MGQS_UcmDhje+44CSA@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, "Perla, Enrico" <enrico.perla@intel.com>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>



> On Feb 21, 2019, at 5:20 AM, Jann Horn <jannh@google.com> wrote:
>=20
> On Thu, Feb 21, 2019 at 7:38 AM Andy Lutomirski <luto@kernel.org> wrote:
>>> On Feb 20, 2019, at 2:20 PM, Kees Cook <keescook@chromium.org> wrote:
>>>=20
>>> On Wed, Feb 13, 2019 at 11:52 PM Reshetova, Elena
>>> <elena.reshetova@intel.com> wrote:
>>>> Now back to our proposed countermeasures given that attacker has found a=
 way to do
>>>> a crafted overflow and overwrite:
>>>>=20
>>>> 1) pt_regs is not predictable, but can be discovered in ptrace-style sc=
enario or cache-probing.
>>>>    If discovered, then attack succeeds as of now.
>>>> 2) relative stack offset is not predictable and randomized, cannot be p=
robed very easily via
>>>>     cache or ptrace. So, this is an additional hurdle on the attacker's=
 way since stack is non-
>>>>     deterministic now.
>>>> 3) nothing changed for this type of attack, given that attacker's goal i=
s not to overwrite CS
>>>>     in adjusted pt_regs. If it is his goal, then it helps with that.
>>>>=20
>>>>=20
>>>> Now summary:
>>>>=20
>>>> It would seem to me that:
>>>>=20
>>>> - regs->cs |=3D 3 on exit is a thing worth doing anyway, just because i=
t is cheap, as Andy said, and it
>>>> might make a positive difference in two out of three attack scenarios. O=
bjections?
>>>=20
>>> I would agree, let's just do this.
>>=20
>> Thinking slightly more about this, it=E2=80=99s an incomplete protection.=
  It
>> keeps an attacker from returning to kernel mode, but it does not
>> protect the privileged flag bits.  I think that IOPL is the only thing
>> we really care about, and doing anything useful about IOPL would be
>> rather more complex, unfortunately.  I suppose we could just zero it
>> and guard that with a static branch that is switched off the first
>> time anyone uses iopl(3).
>>=20
>> I suppose we could also add a config option to straight-up disable
>> IOPL.  I sincerely hope that no one uses it any more. Even the small
>> number of semi-legit users really ought to be using ioperm() instead.
>=20
> /me raises hand. iopl(3) is useful for making CLI and STI work from
> userspace, I've used it for that (for testing stuff, not for anything
> that has been shipped to people). Of course, that's probably a reason
> to get rid of it, not to keep it. ^^

I was thinking that I don=E2=80=99t even try to make this use case work corr=
ectly ;)=
