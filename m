Message-ID: <1494343857.20270.23.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Tue, 09 May 2017 11:30:57 -0400
In-Reply-To: <22a14b06-9489-3494-bbb7-428d4e5fa186@nod.at>
References: <9df77051-ac01-bfe9-3cf7-4c2ecbcb9292@iaik.tugraz.at>
	 <20170504154717.GA24353@infradead.org>
	 <f9a4e8ed-1b22-0d73-924c-f5bb1e18ba93@iaik.tugraz.at>
	 <CAFLxGvwuMN52-Xf46j7XuG+cnJ9xnZjXWhihpgxr9_EUX0Z+Bg@mail.gmail.com>
	 <cc75a38a-4ea6-e300-0370-882dfbfd7a23@iaik.tugraz.at>
	 <6013bf3f-c3bd-3836-e5e2-ea89cc2e556a@nod.at>
	 <8aecf7d4-9767-5367-1bc0-75fbd4b17e46@iaik.tugraz.at>
	 <07322e2c-e95f-ea35-bc1f-7b05c082e287@gdata-adan.de>
	 <22a14b06-9489-3494-bbb7-428d4e5fa186@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-VxG2MrT06kx2SI7xdMPD"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [RFC, PATCH] x86_64: KAISER - do not
 mapkernel in user mode
To: Richard Weinberger <richard@nod.at>, "Fogh, Anders" <anders.fogh@gdata-adan.de>, Daniel Gruss <daniel.gruss@iaik.tugraz.at>
Cc: Christoph Hellwig <hch@infradead.org>, kernel list <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "clementine.maurice@iaik.tugraz.at" <clementine.maurice@iaik.tugraz.at>, "moritz.lipp@iaik.tugraz.at" <moritz.lipp@iaik.tugraz.at>, Michael Schwarz <michael.schwarz@iaik.tugraz.at>, Richard Fellner <richard.fellner@student.tugraz.at>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-VxG2MrT06kx2SI7xdMPD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-05-09 at 16:57 +0200, Richard Weinberger wrote:
> Am 09.05.2017 um 16:44 schrieb Fogh, Anders:
> > > > i.e. how does it perform on recent AMD systems?
> >=20
> > Sorry for the latency. Recent AMD is reported by Enrique Nissem to
> > not
> > be vulnerable to the prefetch attack. TSX attack doesn't apply to
> > AMD.
> > Hund, Willems & Holz wrote in 2013 that AMD was vulnerable to that
> > attack. The BTB is almost surely working in a different manner of
> > fashion if at all. So AMD may or may not be vulnerable to the DPF
> > attack, but none of the modern attacks should work - at least out
> > of the
> > box.
>=20
> But the promoted patch will also run on AMD systems, that's why I
> asked
> for the overhead.

Well, if it is a compile time switch, and the
overhead is unacceptable on everything but the
very latest Intel chips, chances are the code
will not be enabled in any distribution kernel.

--=20
All rights reversed
--=-VxG2MrT06kx2SI7xdMPD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZEeCxAAoJEM553pKExN6DcM0IAKbkNhyOAjvOkQRjlrb38tw+
N5J6ks5SYc7OFkS7BYMM7atcunYQE2aE8e2o+Eux/hhm2/npbyXQaFBbpxtLOUxU
97vsPV1OT4WGyuBuDuDgigOgatB/B4kSHa5A4SnZdAoIVBsV9Ub3tbiyUGt2hD7F
HaAL8+LTadlF1OnrdTd2wf0y13pqWvhNDLdY46k+JZh15XVHXY7yu+mtYK8D9Mzh
PR3qa3qehQZTEFEIcDuM6eUMZUARgk7511UydStdeGFJsrq6IOXJWUWdEVYPlSJT
3gUR/KPV89WaOFxg8oOsHDQ1JTnhGJJtUfu3liOcneITQh2gb78r5O69rXc+FUo=
=hMMh
-----END PGP SIGNATURE-----

--=-VxG2MrT06kx2SI7xdMPD--
