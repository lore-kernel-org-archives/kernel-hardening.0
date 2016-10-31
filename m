Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477948871.8761.9.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 31 Oct 2016 17:21:11 -0400
In-Reply-To: <87ins8rzqm.fsf@mid.deneb.enyo.de>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	 <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	 <20161031162918.GA2994@pc.thejh.net> <87mvhks0vs.fsf@mid.deneb.enyo.de>
	 <1477947388.8761.3.camel@gmail.com> <1477947674.8761.4.camel@gmail.com>
	 <87ins8rzqm.fsf@mid.deneb.enyo.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-AyK6V0Lx2ymOWFCjM29W"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary
 random
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Jann Horn <jann@thejh.net>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-AyK6V0Lx2ymOWFCjM29W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-10-31 at 22:10 +0100, Florian Weimer wrote:
> * Daniel Micay:
>=C2=A0
> > > It makes a lot of sense on x86_64 where it means the canary is
> > > still 56 bits. Also, you want -fstack-check for protecting again
> > > stack overflows rather than stack *buffer* overflow. SSP won't
> > > really help you in that regard. Sadly, while -fstack-check now
> > > works well in GCC 6 with little performance cost, it's not really
> > > a
>=C2=A0
> I think GCC still does not treat the return address push on
> architectures which have such a CALL instruction as an implicit stack
> probe.
>=C2=A0
> > > complete feature (and Clang impls it as a no-op!).
>=C2=A0
> How many guard pages at the end of the stack does the kernel
> guarantee?=C2=A0=C2=A0I saw some -fstack-check-generated code which seeme=
d to
> jump over a single guard page.
>
> The other thing I've seen which could impact the effectiveness of
> -fstack-check: mmap *without* MAP_FIXED and a hint within stack
> allocation can create a mapping inside the stack.=C2=A0=C2=A0That's rathe=
r
> surprising, and I'm not sure if the net result is that there actually
> is a guard page in all cases.

It's not ideal but userspace can work around it. OpenJDK and ART both do
something like walking to the end of the main thread stack during init
to install their own guard region. ART then uses all but the last guard
page it installed as a red zone to handle out-of-stack (not sure about
OpenJDK).

-fstack-stack is supposed to handle a single guard by default, and
that's all there is for thread stacks by default.

> > Note: talking about userspace after the entropy bit. The kernel
> > doesn't
> > really -fstack-check, at least in even slightly sane code...
>=C2=A0
> There used to be lots of discussions about kernel stack sizes ...

It should just be banning VLAs, alloca and large stack frames though, if
it's not already. There wasn't even support for guard pages with kernel
stacks until recently outside grsecurity, and -fstack-check relies on
them so it doesn't seem like a great solution for the kernel.
--=-AyK6V0Lx2ymOWFCjM29W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYF7XHFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iplbg/8Cxs037rjkbWibrUfsfUMMGJYZT3khr/hv6jyQmRjhE16yOW/mCoGy1R3
QL/7VFwN+T0JkwfSeR6Vn6sfCcCyVL68wWt78IIudIV2t20ZdTwHTDXe5XgAMJfp
+YE4T5UgIVIli0E1jpAY7+NQjyz+ATQVMoyXnZ+yk6ZssfB5KSDJ0DHOZ5MEuQzK
tkwUdRCLqmu/7n5eX1pTtnL/SlhECWb4dPpblPe5ZQCca2LsaJjwxQuK8G35HBIQ
9keEp6b9BQBPJA/RHCMJO491FenxINB0lAURkIYWwEH1onJUyQXpTSQ0WbZlQ2MP
Gb9bngknls/4r0gsb8smiSMpY5oLNsdQxc30Dzc0gECL/fRkhaI/Pqpd5nG8lTeM
nFcp8iwFs7cKwPszd1qAUH3R2lwkjZ6jmQh7hUR20THVfuCKt+/lloVG5dczUTIP
9kNIwWrxri2oH3drP2vZ69RT6hOZC5OkAQ8tXQA6V5FMTDWkuYRuQqgImm1rfSxV
GTa6hr/e55/x0ACAEMyhrewFud4odHog0YBGu6MXNWWvF73boocqTvK1cjpk7FUl
E0QWu8pVdqDrm4ZAU2wYtcVah9SVraNGV6e7ZrvsrFW/IE1Pqrf0PSrgJYzz6Y/x
eeXMrh60ZUi6k4Pm+zX43deo3mfy2siZkOYcLrXI5C2zkbuTyZE=
=pouk
-----END PGP SIGNATURE-----

--=-AyK6V0Lx2ymOWFCjM29W--
