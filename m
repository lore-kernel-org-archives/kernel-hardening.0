Message-ID: <1493840201.2133.3.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 03 May 2017 15:36:41 -0400
In-Reply-To: <1493837804.20270.10.camel@redhat.com>
References: 
	<CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
	 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
	 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
	 <1493683745.2530.2.camel@redhat.com>
	 <CABniQZPEfptcLgBtbd5_GO5n8P6SxxkJMpqTCFazM8RCB4qKZQ@mail.gmail.com>
	 <CAGXu5jKqptmWwAgsDNtTRzN-r_JYBtVoNaPbpwN+_stfY4yrQA@mail.gmail.com>
	 <CABniQZMoX6h0dQk5Xa_kwnbV5NSVpE3EDAD4+TU9CM4Hx9TjuA@mail.gmail.com>
	 <1493837804.20270.10.camel@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-w3DhezWqoV/6Won89olc"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Rik van Riel <riel@redhat.com>, Shawn <citypw@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: Mathias Krause <minipli@googlemail.com>, Daniel =?UTF-8?Q?Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-w3DhezWqoV/6Won89olc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-05-03 at 14:56 -0400, Rik van Riel wrote:
> On Wed, 2017-05-03 at 12:50 +0800, Shawn wrote:
>=20
> > The fragmentation of Android eco-system may be inevitable. The whole
> > chains is too long from ASOP/BSP/Vendors and it affect the security
> > fix being delivered to the end user. According to my own statistic
> > from my customers, there will be more than 7 millions of Android
> > phone
> > will be using some features of PaX/Grsec this year.
>=20
> That is great news. I am glad to hear the hardening features
> are being used on that many phones.
>=20
> Of course, given the fragmentation of the eco-system, the
> only thing that can get the hardening on all of the (new)
> phones in the future will be getting the hardening features
> into the upstream kernel.

Just worth noting that the upstream in this case almost always includes
the Android common kernel. There's still some baseline out-of-tree
Android code, although there's much less than there used to be so the
vast majority of the code these days is SoC vendor code needed by a non-
Android Linux distribution on those devices too.

That's forked into the SoC vendor kernels and then the device kernels if
applicable (some are device-specific, but some vendors like Sony have
moved to having a shared kernel and the Pixel / Pixel XL share a kernel
since they're basically the same thing). Google can also verify that
hardening is present via the Compatibility Test Suite if it can be
detected from an unprivileged userspace app. Hopefully they'll turn
passing their new privileged vts test suite into a requirement too so
they can test for kernel self protection features.

For example, Android devices are required to have perf_event_paranoid=3D3
even though it was rejected upstream for the time being. If a clearly
useful change is rejected, that doesn't mean Google won't add it to
their common kernel which will then propagate at least to new devices
from other vendors and their own first-party released devices.
--=-w3DhezWqoV/6Won89olc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlkKMUkWHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKifUD/9QS0UFg9Y4Z7nDGfymGc0A+yEr
9eu2YzlAM4B7C14r4fr1F+mACwgneZv/xiUP46uN8BTSXSVer/xUJ+xncowpO6Y7
aLgO2HoOqzUSLqdUh9mBtMT7TOnQJRPBM+CgsoQOmZyvjIgctgweXEkUyc6gxk4n
NX0Cg96r1FsSn66ArU5bx4+mU+7eim7lgOOmt6Y607g/qP6mRVRnHsSKrZQV+mIX
ruv/K1yltKLsYA+KPHh0mKZfBsgWZ6Tqs+H+7N8CgOhNVi/josPKJR7lpj8lJsEW
iFTgaFnEBkEe6OWfzivftMtMHQR1MobgJniO9u4Axhrlnj6s5IH3sbMjN6tYU1y5
OW++yOV+4OsFJJjz15ELeFIbPx2O8yR1KGwVitl3IBDRTrsRWUqyeSyqwa2ufEzC
OeVuW8Q4CPxZit53FQYJDWvICyw/wJc0w/aJDyBnzPB+VupMpsKurANsJDTX+fnP
j90nhD2Q08URgZf+yEHC7k2aBOcS9fLmyXCSQp1rmyhSLbnM7mGDXJ0aU8UKq6ZU
NQEDnNSvnUU2jKKZAh1wrN6XaLthPsHJRj1jKq1BCrFcAjkCjaHKoe7ftJv+4+Ff
78j0cU0XNKBE1+LsxPA4yAQSphaG6RnhvcI6AQW2LxSQLqrVLs2eJD1R8DLGk3Xg
G6f9UYUNU1myKy288g==
=70mz
-----END PGP SIGNATURE-----

--=-w3DhezWqoV/6Won89olc--
