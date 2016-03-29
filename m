Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1459292110.913.48.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 29 Mar 2016 18:55:10 -0400
In-Reply-To: <CALCETrWeLp1FX3Fz2z-kJezhPXKjvZHEhBH3guijeCgXdUunng@mail.gmail.com>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
	 <CALCETrUxfPBawXNvKZgOnxhkaesw-b4PqCFUZbkRdaaqpjqnPQ@mail.gmail.com>
	 <56FAF571.3040802@eng.utah.edu>
	 <CALCETrWeLp1FX3Fz2z-kJezhPXKjvZHEhBH3guijeCgXdUunng@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Q8Om2CoBofz+O+SE1AWK"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation:
 Sigreturn Cookies
To: kernel-hardening@lists.openwall.com, Scotty Bauer <sbauer@eng.utah.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-Q8Om2CoBofz+O+SE1AWK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Then there's an unanswered question: is this patch acceptable given
> that it's an ABI break?=C2=A0=C2=A0Security fixes are sometimes an except=
ion to
> the "no ABI breaks" rule, but it's by no means an automatic exception.
>=20
> --Andy

It seems this could be worked around in general. Processes can have a
bit tracking whether this is enabled, and CRIU can save/restore it. It
would just leave it off for resuming old saved processes.

Should CRIU really be covered by the kernel's ABI guarantee though? It
seems like this was meant to be extensible, so it's adding an extra ABI
guarantee that wasn't there before. It makes sense to freeze this ABI
for CRIU, but a version field should be added first in one final ABI
break if it's not too late.
--=-Q8Om2CoBofz+O+SE1AWK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJW+wfOAAoJEPnnEuWa9fIqPgEP/24ek/ARd7mjMYBsYMh/QidG
aOc75ecryh63nLrExdi4IYMf8oV/7zWWniinmJP70cMq4VgsebMM9ATyT4GiSZ0Z
oHqD0ZXiSWFliaOEQhRIfCa4Jlxx0p5e2R45e3irZeNZWNDeytGMckfy4edJIJNp
0EZDs+v7yIUnJxAaYae8SADHbct1NlFNs7+c0uAiqP+xgFnTa3t+xbFEAmS6tD9b
ft6Jf+pJ9V2PtnrMCWRfLvPvtasivn472tYnWv9fzuEc9chrnJv8bVs++LdeyKXx
nbbEhsNnLK6s/rDSYax/4KOuopscRRtF0pvm+aVYMctvscPd3MvL+cM0LCUX3iQy
HGMC7lPudiJ5rO/3oy8lgyhdIhpBrZQgIrLL1e/rueKe2IY3p60zk5icui2WFjTY
eA5JK8BcfwB9Qn9FzoEY1Boapjmwur1cz3C5xYsks+mmx1S5/agMl1EC6shK1mAP
cfGrsFqIftWeUZiYkyo/tCed0u2g1sK0Yg5nxumYoA2KouxWT8qCkawmpUlhj1L9
sSmiZu7PHsEy+iN7A9frFOxGAHuWPk2iJRAe8WrqCZTMrbOmtUj7wUsMVIA1IdSp
IxTcFZd+808+horXLppQo3p+q2oKKxLxrmF3VpMTuu7WOU76Qsv8pq65mD91/sDz
XYwQMyubv1OGf3c9d9az
=vRDp
-----END PGP SIGNATURE-----

--=-Q8Om2CoBofz+O+SE1AWK--
