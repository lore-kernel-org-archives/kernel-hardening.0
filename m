Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 22:22:51 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20161031212251.GB3286@pc.thejh.net>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
 <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
 <20161031162918.GA2994@pc.thejh.net>
 <87mvhks0vs.fsf@mid.deneb.enyo.de>
 <1477947388.8761.3.camel@gmail.com>
 <1477947674.8761.4.camel@gmail.com>
 <87ins8rzqm.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <87ins8rzqm.fsf@mid.deneb.enyo.de>
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary
 random
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 31, 2016 at 10:10:41PM +0100, Florian Weimer wrote:
> * Daniel Micay:
>=20
> >> It makes a lot of sense on x86_64 where it means the canary is
> >> still 56 bits. Also, you want -fstack-check for protecting again
> >> stack overflows rather than stack *buffer* overflow. SSP won't
> >> really help you in that regard. Sadly, while -fstack-check now
> >> works well in GCC 6 with little performance cost, it's not really a
>=20
> I think GCC still does not treat the return address push on
> architectures which have such a CALL instruction as an implicit stack
> probe.
>=20
> >> complete feature (and Clang impls it as a no-op!).
>=20
> How many guard pages at the end of the stack does the kernel
> guarantee?  I saw some -fstack-check-generated code which seemed to
> jump over a single guard page.

Until recently: Zero, no guard pages below stacks, stack overflow
goes straight into some other allocation.
Now: One guard page, thanks to a lot of work by Andy Lutomirski.
(I think that change is in the current 4.9-rc3 kernel, but not in
any stable kernel yet.)


> The other thing I've seen which could impact the effectiveness of
> -fstack-check: mmap *without* MAP_FIXED and a hint within stack
> allocation can create a mapping inside the stack.  That's rather
> surprising, and I'm not sure if the net result is that there actually
> is a guard page in all cases.
>=20
> > Note: talking about userspace after the entropy bit. The kernel doesn't
> > really -fstack-check, at least in even slightly sane code...
>=20
> There used to be lots of discussions about kernel stack sizes ...

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYF7YrAAoJED4KNFJOeCOog6EP/3WYZ5KfsugO64Lm0xioYx9u
lk1NuSjDs550I5OnaVXN4A9naj6W8+ZeTMX1BojF2sjm1arYsRYtKd7l6ivBX7KS
i5cK0NVQOwVYQe20aktqANBO4zcvwWLMtz62YTis04kxHZx8NwEiq/0F74G5S5kW
aUJgZr7LH2fiCAZfU/cqgLE4g0koozVwwxFAym+nmnAYS8mKeB9+ksyhFj9QOAIM
7I5h2oDmD5xSs2SPxJne+a7+RveC6dI9zRL58xYMUKN5SpSt0ZrCFjg7IetRxNtU
MLuLame3QenSLZVA+dAjoRP0M5LscVsEg2Fsx2YLbUj4iSRqlA1gk2PSFL666KTZ
L/GWsdBKpgQbgaHZdyPJ/imJKGznBSzCpTXe+glvmfjsVxfLG49uX1PxqPFRwhgZ
dHnQnqRD7YXjFaLezKmxcT/bRNNH7FgJ9bBfzA5qBIzASVkg8eJgoapfv/2K7TEf
YNdR9V+oTRdS8cdHYRhGuiz5J1RVOSa+6ni3//dntj3sJf4vWSVEuM1wd87vsKhC
ILaFRcm7Gu5rcY/iS4HNr707xtCu62i2V8QfTaQtPhUR6SuflRD6/w+lMUjzWx6T
qzIrOpCRtO41+PatuIjhN5+eybFUDz49af3KGKU7U7onjyllxsqCeh0Kidky+6uP
P6aCi43dyi8P6SsnrAMi
=o4OX
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
