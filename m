Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477947388.8761.3.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 31 Oct 2016 16:56:28 -0400
In-Reply-To: <87mvhks0vs.fsf@mid.deneb.enyo.de>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	 <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	 <20161031162918.GA2994@pc.thejh.net> <87mvhks0vs.fsf@mid.deneb.enyo.de>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-g6Rt4mDDd2r9x4xm4fIz"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary
 random
To: Florian Weimer <fw@deneb.enyo.de>, Jann Horn <jann@thejh.net>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-g6Rt4mDDd2r9x4xm4fIz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-10-31 at 21:45 +0100, Florian Weimer wrote:
> * Jann Horn:
>=20
> > On Mon, Oct 31, 2016 at 09:04:02AM -0700, Kees Cook wrote:
> > > On Mon, Oct 31, 2016 at 7:04 AM, Jann Horn <jann@thejh.net> wrote:
> > > > On machines with sizeof(unsigned long)=3D=3D8, this ensures that th=
e
> > > > more
> > > > significant 32 bits of stack_canary are random, too.
> > > > stack_canary is defined as unsigned long, all the architectures
> > > > with stack
> > > > protector support already pick the stack_canary of init as a
> > > > random
> > > > unsigned long, and get_random_long() should be as fast as
> > > > get_random_int(),
> > > > so there seems to be no good reason against this.
> > > >=20
> > > > This should help if someone tries to guess a stack canary with
> > > > brute force.
> > > >=20
> > > > (This change has been made in PaX already, with a different
> > > > RNG.)
> > > >=20
> > > > Signed-off-by: Jann Horn <jann@thejh.net>
> > >=20
> > > Acked-by: Kees Cook <keescook@chromium.org>
> > >=20
> > > (A separate change might be to make sure that the leading byte is
> > > zeroed. Entropy of the value, I think, is less important than
> > > blocking
> > > canary exposures from unbounded str* functions. Brute forcing
> > > kernel
> > > stack canaries isn't like it bruting them in userspace...)
> >=20
> > Yeah, makes sense. Especially on 64bit, 56 bits of entropy ought to
> > be
> > enough anyway.
>=20
> So you two approve of the way glibc does this currently?=C2=A0=C2=A0(See =
the
> other thread.)
>=20
> I was under the impression that the kernel performs far less
> null-terminated string processing the average user space application,
> especially on the stack.=C2=A0=C2=A0(A lot of userspace code assumes larg=
e
> stacks and puts essentially arbitrarily long strings into VLAs.)

It makes a lot of sense on x86_64 where it means the canary is still 56
bits. Also, you want -fstack-check for protecting again stack overflows
rather than stack *buffer* overflow. SSP won't really help you in that
regard. Sadly, while -fstack-check now works well in GCC 6 with little
performance cost, it's not really a complete feature (and Clang impls it
as a no-op!).
--=-g6Rt4mDDd2r9x4xm4fIz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYF6/8FhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iqKbQ/+Mh2ULlr2AUMvBLJ/FPT5fl0EGPPcsTLsTreX4ynsFce9BTm2RBcvS6aq
bVqdRAI4HdwIrtuf7AvABpt+2yuc2RNHYZO6ag7l+aK0lWMwdcnKgA+EO8JWN1kL
Gq/Tud5ErZ8DBEvSOGlMwvTPckvPUOMui+NgTEOFc9Om/t97Zq2A2nk+q/a2bgwQ
62dX4ImPyt16OwhJXGuP/zvtGgg+y5Ojw+o98EPc0k8I0QYs/D02rTLcIulUkSRm
tMc4Tqdw6HwJjbgzxNrZ68RFFFk2neHVTXk4XwprvlhJ3jGlyNcG3OIz6ag5InbY
kPTYg6TQ3srxfo8df3iKSC58hui1YhO8aMqwYJ00zDY57U1hrGN4U3wbBOHFaN7j
1T1NUULPTu2KBiIZxk2W3apNx951QYukmlU4UjybRcL2bK99UNTT3VjjKceJKrRa
vIGHkYxlV5DZnRrqjHjE3JXXo5EqZOGw1j8+hGVzP1L7XfH4qCpyWZfzvWkfJQDX
in9uIJHE8E2pUCP0uAzVzrv18se07gqI0mVdXHQ0dKML6KnH/TTkDyARmOx92r6Z
7xs7XGJ2wQv24kCpv9THIgOSQ8JMIRXF6wXZpSsM19JWHvEunETsU10fKCHof5Xg
URoPsj6Bp/gwmz1emHqy9OOQNTvmqJKhqJIOdbR6ZnHLRG6wWXE=
=V5ec
-----END PGP SIGNATURE-----

--=-g6Rt4mDDd2r9x4xm4fIz--
