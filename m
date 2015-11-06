Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1446816504.8412.35.camel@debian.org>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<1446816504.8412.35.camel@debian.org>
Date: Fri, 6 Nov 2015 10:11:21 -0800
Message-ID: <CAGXu5jKkF61CG_Aiv19p24XvJ7yQ-V+J_RBXbvMbw-cWmzDbmQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 6, 2015 at 5:28 AM, Yves-Alexis Perez <corsac@debian.org> wrote=
:
> On jeu., 2015-11-05 at 12:59 -0800, Kees Cook wrote:
>> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
>> gcc plugin, which will also get us the gcc plugin infrastructure.
>> Other people, please speak up on what you'd like to tackle.
>
> Hi Kees, and first many thanks for the initiative. That's definitely some=
thing
> of interest for me (both personally and professionally).
>
> Something which might also be interesting in kernel self protection is th=
e
> =E2=80=9Cactive response=E2=80=9D found in grsecurity (GRKERNSEC_SEC_KERN=
_LOCKOUT) and the
> =E2=80=9Cdeter exploite bruteforcing=E2=80=9D (GRKERNSEC_BRUTE), which ca=
n help prevent
> exploitation with repeated attempts.

I don't want to discourage work on any of this, but for now, I'm
trying to focus on kernel protections (rather than the userspace
hardening features). If other people (you?) want to coordinate the
userspace hardening work, then let's add it to the list, and create a
separate kernsec.org wiki landing place for it. I think it should be
organized in the same way, though: discuss a problem, give examples,
list potential mitigations.

FWIW, GRKERNSEC_BRUTE was attempted earlier[1], and the technical
discussion devolved into people thinking that glibc should handle it.
I totally disagree[2], since not all systems use glibc (Android).
Bruteforcing protection should be in the kernel: it is the manager of
processes, full stop.

> Some features (especially SEC_KERN_LOCKOUT) are really more useful when U=
DEREF
> and KERNEXEC are available (since those are the most severe violations on=
e can
> find), but it could still apply to other violations.

I think GRKERNSEC_KERN_LOCKOUT is kind of on both sides of the
kernel/userspace defense fence. For now, I think the granularity of
response for KSPP-ported features will likely just be a full system
Oops. But I suspect once more of them land, we'll want the finer
granularity that GRKERNSEC_KERN_LOCKOUT provides.

-Kees

[1] https://lkml.org/lkml/2014/12/24/306
[2] https://lkml.org/lkml/2015/1/5/732

--=20
Kees Cook
Chrome OS Security
