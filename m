Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon system call
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
Date: Mon, 11 Feb 2019 07:54:59 -0800
Content-Transfer-Encoding: quoted-printable
Message-Id: <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com> <1549628149-11881-2-git-send-email-elena.reshetova@intel.com> <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com> <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com> <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, "Perla, Enrico" <enrico.perla@intel.com>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "keescook@chromium.org" <keescook@chromium.org>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>



On Feb 10, 2019, at 10:39 PM, Reshetova, Elena <elena.reshetova@intel.com> w=
rote:

>> On Sat, Feb 9, 2019 at 3:13 AM Reshetova, Elena
>> <elena.reshetova@intel.com> wrote:
>>>=20
>>>> On Fri, Feb 08, 2019 at 01:20:09PM +0000, Reshetova, Elena wrote:
>>>>>> On Fri, Feb 08, 2019 at 02:15:49PM +0200, Elena Reshetova wrote:
>>>>=20
>>>>>>=20
>>>>>> Why can't we change the stack offset periodically from an interrupt o=
r
>>>>>> so, and then have every later entry use that.
>>>>>=20
>>>>> Hm... This sounds more complex conceptually - we cannot touch
>>>>> stack when it is in use, so we have to periodically probe for a
>>>>> good time (when process is in userspace I guess) to change it from an
>> interrupt?
>>>>> IMO trampoline stack provides such a good clean place for doing it and=
 we
>>>>> have stackleak there doing stack cleanup, so would make sense to keep
>>>>> these features operating together.
>>>>=20
>>>> The idea was to just change a per-cpu (possible per-task if you ctxsw
>>>> it) offset that is used on entry to offset the stack.
>>>> So only entries after the change will have the updated offset, any
>>>> in-progress syscalls will continue with their current offset and will b=
e
>>>> unaffected.
>>>=20
>>> Let me try to write this into simple steps to make sure I understand you=
r
>>> approach:
>>>=20
>>> - create a new per-stack value (and potentially its per-cpu "shadow") ca=
lled
>> stack_offset =3D 0
>>> - periodically issue an interrupt, and inside it walk the process tree a=
nd
>>>  update stack_offset randomly for each process
>>> - when a process makes a new syscall, it subtracts stack_offset value fr=
om
>> top_of_stack()
>>> and that becomes its new  top_of_stack() for that system call.
>>>=20
>>> Smth like this?
>>=20
>> I'm proposing somthing that is conceptually different.=20
>=20
> OK, looks like I fully misunderstand what you meant indeed.
> The reason I didn=E2=80=99t reply to your earlier answer is that I started=
 to look
> into unwinder code & logic to get at least a slight clue on how things
> can be done since I haven't looked in it almost at all before (I wasn't ch=
anging
> anything with regards to it, so I didn't have to). So, I meant to come bac=
k
> with a more rigid answer that just "let me study this first"...

Fair enough.

>=20
> You are,
>> conceptually, changing the location of the stack.  I'm suggesting that
>> you leave the stack alone and, instead, randomize how you use the
>> stack.=20
>=20
>=20
> So, yes, instead of having:
>=20
> allocated_stack_top
> random_offset
> actual_stack_top
> pt_regs
> ...
> and so on
>=20
> We will have smth like:
>=20
> allocated_stack_top =3D actual_stack_top
> pt_regs
> random_offset
> ...
>=20
> So, conceptually we have the same amount of randomization with=20
> both approaches, but it is applied very differently.=20

Exactly.

>=20
> Security-wise I will have to think more if second approach has any negativ=
e
> consequences, in addition to positive ones. As a paranoid security person,=

> you might want to merge both approaches and randomize both places (before a=
nd
> after pt_regs) with different offsets, but I guess this would be out of qu=
estion, right?=20

It=E2=80=99s not out of the question, but it needs some amount of cost vs be=
nefit analysis.  The costs are complexity, speed, and a reduction in availab=
le randomness for any given amount of memory consumed.

>=20
> I am not that experienced with exploits , but we have been
> talking now with Jann and Enrico on this, so I think it is the best they c=
omment
> directly here. I am just wondering if having pt_regs in a fixed place can
> be an advantage for an attacker under any scenario...=20

If an attacker has write-what-where (i.e. can write controlled values to con=
trolled absolute virtual addresses), then I expect that pt_regs is a pretty l=
ow ranking target.  But it may be a fairly juicy target if you have a stack b=
uffer overflow that lets an attacker write to a controlled *offset* from the=
 stack. We used to keep thread_info at the bottom of the stack, and that was=
 a great attack target.

But there=E2=80=99s an easier mitigation: just do regs->cs |=3D 3 or somethi=
ng like that in the exit code. Then any such attack can only corrupt *user* s=
tate.  The performance impact would be *very* low, since this could go in th=
e asm path that=E2=80=99s only used for IRET to user mode.
