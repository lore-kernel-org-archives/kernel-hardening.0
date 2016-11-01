Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477984815.8761.24.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 01 Nov 2016 03:20:15 -0400
In-Reply-To: <20161101063359.GA27822@gmail.com>
References: <20161026204748.GA11177@amd>
	 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
	 <20161027091104.GB19469@amd>
	 <20161027093334.GK3102@twins.programming.kicks-ass.net>
	 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
	 <20161027212747.GA18147@amd> <20161028095141.GA5806@leverpostej>
	 <20161028112136.GA5635@amd> <20161028140522.GH5806@leverpostej>
	 <20161031082705.GA2863@amd> <20161101063359.GA27822@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-HbraBMUQbTZV9HtAjcSm"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: kernel-hardening@lists.openwall.com, Pavel Machek <pavel@ucw.cz>
Cc: Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-HbraBMUQbTZV9HtAjcSm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-11-01 at 07:33 +0100, Ingo Molnar wrote:
> * Pavel Machek <pavel@ucw.cz> wrote:
>=20
> > I'm not going to buy broken hardware just for a test.
>=20
> Can you suggest a method to find heavily rowhammer affected hardware?
> Only by=C2=A0
> testing it, or are there some chipset IDs ranges or dmidecode info
> that will=C2=A0
> pinpoint potentially affected machines?
>=20
> Thanks,
>=20
> 	Ingo

You can read the memory timing values, but you can't know if they're
reasonable for that hardware. Higher quality memory can have better
timings without being broken. The only relevant information would be the
memory model, combined with an expensive / time consuming effort to
build a blacklist based on testing. It doesn't seem realistic, unless
it's done in a coarse way based on brand and the date information.

I don't know how to get this data on Linux. The CPU-Z tool for Windows
knows how to obtain it but it's based on a proprietary library.

You definitely don't need to buy broken hardware to test a broken
hardware setup though. You just need a custom computer build where
motherboards expose the memory timing configuration. You can make it
more vulnerable by raising the refresh period (tREF). I wanted to play
around with that but haven't gotten around to it.
--=-HbraBMUQbTZV9HtAjcSm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYGEIvFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ipCIA//UGYUURz9Ya2tMfp2i4VVwdM97P9UwYgtuCcCn+OAV5FEWilDFkTWYM5S
sL4SNdDwxA9niMM3W1v3bJU3+Q/LvMpaydRJ7Y+NyqiPJn1VGPw+wZw4i5Auda4F
yT25I+ix0vi7NOZqBmU2wtbFajDPHxaS6CalnHpU/8m5O1qXtGSxacYTFdmPphfB
ShMdaAIHZEtQyHxdTtVS0Ge6MfkFZ5pYVEarYOcgNems3zzVHyCFVMME4o4A72ve
QJB7lbm9By2I+DDw3o5Ca7c2AR8BClDu5tVFtDyPNzEdamP+R/49vwBQWz4ypB1Z
g9JIZPDr/2PNhicZMsA8EM5Ujc6JxH0/JaDQ602AhOp84TQ39w7vunZVrl1Pg0SZ
aon+D0gcVeVl85zl368sfEqq8ucy7qLrcX6/5oGAakqQz/6fKxp61/pu00hq9blI
1MiyODyvtp+IR6NFTfEj87h73sfwiftWcn+fAP8f65X1VIqw6TJoQi2HExbIDqXo
27aW+N/fjp05l5XHKDTuSVhiJjwIAjcgdHVnCpEF6K99HrxLiSPUUYW9K/IaxtJd
jUD+sU0qUMiFXSpyJzvbYohWZql8L9NYzYvX9UMKgCNUVtsFNAeW6Mq2G5i4DytK
LjIRlHWeKHCv0RoFX3S7LNrP8Z6S0G2czCSVR4uisUKOR5Krejg=
=Ck3t
-----END PGP SIGNATURE-----

--=-HbraBMUQbTZV9HtAjcSm--
