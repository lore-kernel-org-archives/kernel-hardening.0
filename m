Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon syscall
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612BA4C40185@IRSMSX102.ger.corp.intel.com>
Date: Fri, 5 Apr 2019 07:14:11 -0600
Content-Transfer-Encoding: quoted-printable
Message-Id: <C39303A6-7E9F-47FE-9757-0E73F08C07A9@amacapital.net>
References: <20190329081358.30497-1-elena.reshetova@intel.com> <CAGXu5jKH3js8pOv726jQ84rycd04OcwosN9-OkJg7UnsMMiuxA@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612BA4C3BA7F@IRSMSX102.ger.corp.intel.com> <CAGXu5j+05tZUOuka2YQy+5WPvVwHBrM-YEeto1iLzz2shCnANQ@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612BA4C40185@IRSMSX102.ger.corp.intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>, "Perla, Enrico" <enrico.perla@intel.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>



On Apr 5, 2019, at 4:14 AM, Reshetova, Elena <elena.reshetova@intel.com> wro=
te:

>> On Thu, Apr 4, 2019 at 4:41 AM Reshetova, Elena
>> <elena.reshetova@intel.com> wrote:
>>> What I still don't fully understand here (due to my little knowledge of
>>> compilers) and afraid of is that the asm code that alloca generates (see=
 my version)
>>> and the alignment might differ on the different targets, etc.
>>=20
>> I guess it's possible, but for x86_64, since appears to be consistent.
>=20
> So, yes, I double checked this now with just printing all possible offsets=
 I get for rsp
> from do_syscall_64, it is indeed 33 different offsets, so it is indeed mor=
e like 5 bits of entropy.=20
> We can increase it, if we want and people are ok with losing a bit more st=
ack space.=20
>=20
>>=20
>>> If you tried it on yours, can you send me the asm code that it produced f=
or you?
>>> Is it different from mine?
>>=20
>> You can compare compiler outputs here. Here's gcc vs clang for this code:=

>> https://godbolt.org/z/WJSbN8
>> You can adjust compiler versions, etc.
>=20
> Oh, this is handy! Thank you for the link!=20
>=20
>=20
> So, should I resend to lkml (with some cosmetic fixes) or how to proceed w=
ith this?
> I will also update the randomness bit info.=20
>=20
>=20

Go ahead and send a new version, please.=
