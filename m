Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1453309539.3734.52.camel@decadent.org.uk>
From: Ben Hutchings <ben@decadent.org.uk>
Date: Wed, 20 Jan 2016 17:05:39 +0000
In-Reply-To: <20160119175409.GB7485@kroah.com>
References: <20160119112812.GA10818@mwanda>
	 <1453221128.3734.26.camel@decadent.org.uk>
	 <20160119175409.GB7485@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-F8Mr8RZEee491zorzpvY"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-F8Mr8RZEee491zorzpvY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-01-19 at 09:54 -0800, Greg KH wrote:
> On Tue, Jan 19, 2016 at 04:32:08PM +0000, Ben Hutchings wrote:
> > As for USB descriptors, I'm somewhat more hopeful about hardening. =C2=
=A0At
> > the same time, it seems like it should be practical to put more low-
> > performance USB drivers into userspace.
>=20
> What drivers do we currently have in the kernel that should/could be
> done in userspace instead?=C2=A0=C2=A0I'll gladly drop them from the tree=
.

An obvious example would be HID drivers. =C2=A0(I'll grant you that putting
those in user-space would complicate the boot process when a disk
encryption passphrase is needed.)

Ben.

> And yes, we need to do better about handling crazy USB descriptors, I
> think the majority of this work is already done, but it takes
> hand-auditing to verify it :(

--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.
--=-F8Mr8RZEee491zorzpvY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVp++Y+e/yOyVhhEJAQpdOxAApXtilTQHAIM5XbLBBJT61SDEuYqhTXV1
edbDdBFGe0eTPVz4IkCRODxjPOkUuaUjLkNe/4neDTencxr95mauuEfbk0+I70xQ
Fzjz+hyefDaO6haxGaJmSBuCGbJhx89PxJn3FhOuGavMf1ePOZiEXeDM29q5vJYi
0aCNyCTDBYd0NyB/BvjIhz3Ay0TU0lk7/2KMsZVBbL5b54IKxE5fDkqDD8+uRuoR
VUBXu65RZWPr77Bi42m/RE29AFqvMts5/eoL8GFYBIBIy4nVLOy2RXcq4aK9hQva
GmLIaW8W3sN/VeTDwHSKL1Bbe2cSJHlIwi4jjbAcBNhGz8RV8yLsBFaNuhwhVxVJ
Yx4uxhaWICCfg1BbzMik+dn0xlCO5scqMMvQzOTNYG66Y4AVf2/UBkcKGU0wsvcE
4oXPL+JHTL7mKup7GYBYYPprs/AggIJTqvogYfMdEiUDUHjl0aOv9RYci4x18Nbl
dwuoHRZuqjg0E+INQQiCg4iaMl9r3GKd1Yse5H140XRmc6EdnPTV5xbDnXOU5wbN
XGx42DpwtJys8nvBW6Dll846XobF/iyVUY+zIQi7LjdQDKcGJarNCtiXDM71cwir
DQaHSVEFqwikVgK3Id0y5Qo4kEucs/1D2grX61r62YPppFRYuVucyzo+napL8hkw
qRMTUbqDIzg=
=H+M4
-----END PGP SIGNATURE-----

--=-F8Mr8RZEee491zorzpvY--
