Message-ID: <1485097837.3733.1.camel@corsac.net>
From: Yves-Alexis Perez <corsac@corsac.net>
Date: Sun, 22 Jan 2017 16:10:37 +0100
In-Reply-To: <20170121234105.GA22967@openwall.com>
References: <20170121234105.GA22967@openwall.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-NBeHyQeQaADth+nU4XXY"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Disable and lock Silicon Debug feature on
 modern Intel CPUs
To: Solar Designer <solar@openwall.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-NBeHyQeQaADth+nU4XXY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2017-01-22 at 00:41 +0100, Solar Designer wrote:
> Silicon Debug should probably be disabled and locked by default, but
> there should be a kernel parameter to avoid this.

Hi, I intended to take a look but (un)fortunately it seems that my laptop
(ThinkPad X250) has it locked disabled (I guess by Lenovo BIOS).

I can still work on a patch but it'll be untested. Does one know of unlocke=
d
platforms?

For reference, here's how to determine your situation:

cpuid tools (version20161201) doesn't support the SDBG bit but you can disp=
lay
the raw value:

cpuid -r -1 -l 1=C2=A0=C2=A0| awk '/ecx=3D/ { print $5 }'
ecx=3D0x7ffafbbf

SDBG is bit 11, set here (Broadwell).

Looking at the IA32_DEBUG_INTERFACE (0xc80) MSR reveals its status:

rdmsr 0xc80
40000000

with:

IA32_DEBUG_INTERFACE_ENABLE	0x00000001
IA32_DEBUG_INTERFACE_LOCK	0x40000000
IA32_DEBUG_INTERFACE_MASK	0x80000000

So in my case it's not enabled, and it's locked.

Regards,
--=20
Yves-Alexis
--=-NBeHyQeQaADth+nU4XXY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEl0WwInMjgf6efq/1bdtT8qZ1wKUFAliEy20ACgkQbdtT8qZ1
wKUVIQf8Cw89rO2tEq9DT3K25lZNstAsfTtvjMNdPh/q8qSrFdMABAH9Cz5pYp3k
8eBxOnm3JwdiNETXttwiGr3iiVsBXGP/ZyNBQCjvVhbbs0D0HOxbY1/4sA4YYWQZ
59pKJCZvMQdsYmCIANsQSCkrd5uKMvzGykvG6F1/XEZ5oWq76bbuOh0B5dOzyomc
7KD8Q0wX1oEBMdNYqU9rgSGI4VEVvZJYTsOG2YQ1/tZculao3g1YkunzoxMJr040
eFlDeCFsnrOcHzU155GtpNDQ3VgdLejFLSIlHzkZPJkILTcL/PhxwNcyqyxMBiES
TU6mxq+XptOBggSEfVQyoIw1oPsEBA==
=MqVn
-----END PGP SIGNATURE-----

--=-NBeHyQeQaADth+nU4XXY--
