Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453402008.3734.94.camel@decadent.org.uk>
From: Ben Hutchings <ben@decadent.org.uk>
Date: Thu, 21 Jan 2016 18:46:48 +0000
In-Reply-To: <20160120180447.GA31532@kroah.com>
References: <20160119112812.GA10818@mwanda>
	 <1453221128.3734.26.camel@decadent.org.uk>
	 <20160119175409.GB7485@kroah.com>
	 <1453309539.3734.52.camel@decadent.org.uk>
	 <20160120180447.GA31532@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UrjKYzpSI3toax+hDOD5"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-UrjKYzpSI3toax+hDOD5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2016-01-20 at 10:04 -0800, Greg KH wrote:
> On Wed, Jan 20, 2016 at 05:05:39PM +0000, Ben Hutchings wrote:
> > On Tue, 2016-01-19 at 09:54 -0800, Greg KH wrote:
> > > On Tue, Jan 19, 2016 at 04:32:08PM +0000, Ben Hutchings wrote:
> > > > As for USB descriptors, I'm somewhat more hopeful about hardening. =
=C2=A0At
> > > > the same time, it seems like it should be practical to put more low=
-
> > > > performance USB drivers into userspace.
> > >=20
> > > What drivers do we currently have in the kernel that should/could be
> > > done in userspace instead?=C2=A0=C2=A0I'll gladly drop them from the =
tree.
> >=20
> > An obvious example would be HID drivers. =C2=A0(I'll grant you that put=
ting
> > those in user-space would complicate the boot process when a disk
> > encryption passphrase is needed.)
>=20
> That and for userspace that expects to get an input device stream,
> combining serial, ps2, bluetooth, and USB devices all at the same time.
> So while it might be possible, keeping input devices and HID support in
> the kernel makes sense.
[...]

I was thinking that the HID drivers would feed events back into the
kernel through an enhanced version of evdev_write(). =C2=A0The userland
consumers of input events wouldn't need to change at all.

Ben.

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.
--=-UrjKYzpSI3toax+hDOD5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVqEnmOe/yOyVhhEJAQoyOg/7BWs9n7my7LWCqTKj1eWUBwP9LxhQnhny
eAM6g62maxh1VX2FzdMGrsqlr1NIg2/Xdgqy6F6nLqjkWDcTDjfuJD93FMXYRz3c
nqnYuqebBYJa+OjStR+UuVVokl/lcuTJtzyUGJY9XZLeOv2XvxteKwAMjP33FIch
s8ctx2zXrbA58xktw6vBs4mK2znPGPvrKhvD0N6kWKtiA2Ai+jkIr5yfHvdkNUI+
ysTyipyM2ktKBLUlx3fX/qCqAIStdQSLmkKIAuKOI4zIwdpiZL6o25fFxZhbCy3y
mSVkqQcvIasAtLdvxlabEQrfmUah7q0lxYqxlcSAXH1vnaUfMDyJStfBzCYWc2G7
F8pCH98QBqIly7oUWxM/wDhMepFWmNHsotgl5iS+o+Eto+Me1wE/YdXGq+cM9wAf
wrUigzkI/Utd71DoIU4y5BJ4B6bVdr0hBc0SJuoVoUQ/OiauXNyQ8Z3Ogxpmun82
dLn9SLqJ8jZ4op2Pwwc6R+U/+U0/VXNM+TRFLtfWMbucJzrtmrIGSgrOfpLYkkXi
oNwp2+z/69Sy7VJoE9M7gHbpk/eneGdVaZrvYjieYQtKJtneT9m9dM+atoXVstzg
6h1TiuE3WW2uJfNz4gAlxdpCQays+fR43Yq7vUYH8QdUCebEF/IfIBzSsOGbW5bV
YKkRPUSgwyo=
=9Md6
-----END PGP SIGNATURE-----

--=-UrjKYzpSI3toax+hDOD5--
