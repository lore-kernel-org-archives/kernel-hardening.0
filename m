Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477949185.8761.13.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 31 Oct 2016 17:26:25 -0400
In-Reply-To: <20161031212251.GB3286@pc.thejh.net>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
	 <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
	 <20161031162918.GA2994@pc.thejh.net> <87mvhks0vs.fsf@mid.deneb.enyo.de>
	 <1477947388.8761.3.camel@gmail.com> <1477947674.8761.4.camel@gmail.com>
	 <87ins8rzqm.fsf@mid.deneb.enyo.de> <20161031212251.GB3286@pc.thejh.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-R6vl2bnfngJG/0ZwYDkc"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary
 random
To: Jann Horn <jann@thejh.net>, Florian Weimer <fw@deneb.enyo.de>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-R6vl2bnfngJG/0ZwYDkc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2016-10-31 at 22:22 +0100, Jann Horn wrote:
> On Mon, Oct 31, 2016 at 10:10:41PM +0100, Florian Weimer wrote:
> > * Daniel Micay:
> >=20
> > > > It makes a lot of sense on x86_64 where it means the canary is
> > > > still 56 bits. Also, you want -fstack-check for protecting again
> > > > stack overflows rather than stack *buffer* overflow. SSP won't
> > > > really help you in that regard. Sadly, while -fstack-check now
> > > > works well in GCC 6 with little performance cost, it's not
> > > > really a
> >=20
> > I think GCC still does not treat the return address push on
> > architectures which have such a CALL instruction as an implicit
> > stack
> > probe.
> >=20
> > > > complete feature (and Clang impls it as a no-op!).
> >=20
> > How many guard pages at the end of the stack does the kernel
> > guarantee?=C2=A0=C2=A0I saw some -fstack-check-generated code which see=
med to
> > jump over a single guard page.
>=20
> Until recently: Zero, no guard pages below stacks, stack overflow
> goes straight into some other allocation.
> Now: One guard page, thanks to a lot of work by Andy Lutomirski.
> (I think that change is in the current 4.9-rc3 kernel, but not in
> any stable kernel yet.)

I think Florian is talking about the main thread stack in userspace.

Thus the next part about how it doesn't actually *guarantee* a guard
page at all right now for that. Userspace has to work around that if
it's worried about it (it can't really happen in practice though, but
it's not great that mmap with a hint + no MAP_FIXED can break it).
--=-R6vl2bnfngJG/0ZwYDkc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYF7cBFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iph8BAAgFAsZs12DwPHpBQQVAW444EEG0vsSXOvRaGbQhqAfw47Aj8ht9gFcIwb
IriMbDEiqmAa9bzhXsvglvi/2ewDt8PT2haEM7S+zvqeY/j8ooK31Zzmu68Tkym9
hu+x/0bBiP3DGYq2sBxc9MCNrVTEJYWde0TPBINWH81yJrPIueEARqrX34gZyMr6
UtPPVssEw9xIbxK2xbsnBv7IcM54iyYp0EiPfoUq7teUKGNNFV+jyX75eJsK9Jz7
Ye3zxMahnXVxUAN4vH7l0Orw5XR0ev6MTNPb56q3jBxyJR5Jsl3ai4p8e4chTKhR
bED5d9uSl+3eYynWFtOSS8DzU9k66RiPxr2/70oZLHAsnOSlxuUSUbQQXVvLsEDw
+NaoK92Q4N3dRVqwwP7tnpKYPgFMdiY7vVq28CUgcCF0qYpPs5cDrTuiOG1XwUZU
XXsGyiOW9PmFvePaJVZURBsAWDN/MtJRckvkp0S/omMXKw+rE9xyNsUlOnim9Ec4
vLj7xglETgC3BpZ0JLd/W6gtiUwcKTL2tjiYtgabLPIjvsESxzPoCnep7nC1R3vB
DQTWyntqlegs0yXHjo5vqmiJDoWuaLjdwFYFv/JoKdez+ohCoVfm8PDWhKZVdK1n
Ks0m7266gjdH8GAn6NulWazPh+AZzxs/9kgewTjn9RDz7ooRG0Q=
=b0Nx
-----END PGP SIGNATURE-----

--=-R6vl2bnfngJG/0ZwYDkc--
