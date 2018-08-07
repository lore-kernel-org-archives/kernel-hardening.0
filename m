Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH 1/2] x86: WARN() when uaccess helpers fault on kernel addresses
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CAG48ez3nEszuPN9SZ9vV2=ubzv348bMpJjT9b5Q_wx6uxV2zXg@mail.gmail.com>
Date: Tue, 7 Aug 2018 15:28:17 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <126BF909-1BB3-45EF-944E-C0AAD239F752@amacapital.net>
References: <20180807012257.20157-1-jannh@google.com> <C6369CAA-CBB8-420F-97DB-7A242D9650A8@amacapital.net> <CAG48ez3nEszuPN9SZ9vV2=ubzv348bMpJjT9b5Q_wx6uxV2zXg@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>




> On Aug 7, 2018, at 2:17 PM, Jann Horn <jannh@google.com> wrote:
>=20
> On Tue, Aug 7, 2018 at 4:55 AM Andy Lutomirski <luto@amacapital.net> wrote=
:
>>> On Aug 6, 2018, at 6:22 PM, Jann Horn <jannh@google.com> wrote:
>>>=20
>>> There have been multiple kernel vulnerabilities that permitted userspace=
 to
>>> pass completely unchecked pointers through to userspace accessors:
>>>=20
>>> - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
>>> access_ok() checks")
>>> - the sg/bsg read/write APIs
>>> - the infiniband read/write APIs
>>>=20
>>> These don't happen all that often, but when they do happen, it is hard t=
o
>>> test for them properly; and it is probably also hard to discover them wi=
th
>>> fuzzing. Even when an unmapped kernel address is supplied to such buggy
>>> code, it just returns -EFAULT instead of doing a proper BUG() or at leas=
t
>>> WARN().
>>>=20
>>> This patch attempts to make such misbehaving code a bit more visible by
>>> WARN()ing in the pagefault handler code when a userspace accessor causes=

>>> #PF on a kernel address and the current context isn't whitelisted.
>>=20
>> I like this a lot, and, in fact, I once wrote a patch to do something sim=
ilar. It was before the fancy extable code, though, so it was a mess.  Here a=
re some thoughts:
>>=20
>> - It should be three patches. One patch to add the _UA annotations, one t=
o improve the info passes to the handlers, and one to change behavior.
>>=20
>> - You should pass the vector, the error code, and the address to the hand=
ler.
>>=20
>> - The uaccess handler should IMO WARN if the vector is anything other tha=
n #PF (which mainly means warning if it=E2=80=99s #GP). I think it should pr=
_emerg() and return false if the vector is #PF and the address is too high.
>=20
> What about #MC? do_machine_check() sometimes invokes fixup handlers.
> It looks like fixup_exception() is basically reached for anything that
> can't be restarted (either MCG_STATUS_RIPV isn't set or the worst
> severity is MCE_AR_SEVERITY), but doesn't reach MCE_PANIC_SEVERITY? In
> particular for "Action required: data load in error recoverable area
> of kernel", if I'm reading the code correctly. It seems like the code
> is intentionally preventing memory errors during user access from
> being treated as kernel memory errors? So perhaps #MC in user access
> should not WARN()?

Agreed.=20

>=20
>> - Arguably most non-uaccess fixups should at least warn for anything othe=
r than #GP and #UD.
