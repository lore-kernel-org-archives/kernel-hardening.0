Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <501FDB45.4050104@nod.at>
Date: Mon, 06 Aug 2012 16:57:09 +0200
From: Richard Weinberger <richard@nod.at>
MIME-Version: 1.0
References: <1344000593-18794-1-git-send-email-richard@nod.at> <1344264832.27828.65.camel@twins>
In-Reply-To: <1344264832.27828.65.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5E830B26402E23C357E6EBBF"
Subject: [kernel-hardening] Re: [PATCH] Revert "futex: Mark get_robust_list as deprecated"
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, dvhart@linux.intel.com, paul.gortmaker@windriver.com, jkosina@suse.cz, rob@landley.net, Randy Dunlap <rdunlap@xenotime.net>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net, keescook@chromium.org, tglx@linutronix.de, Cyrill Gorcunov <gorcunov@openvz.org>, xemul@parallels.com, stable@vger.kernel.org, #@programming.kicks-ass.net, 3.4.x@programming.kicks-ass.net
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5E830B26402E23C357E6EBBF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 06.08.2012 16:53, schrieb Peter Zijlstra:
> On Fri, 2012-08-03 at 15:29 +0200, Richard Weinberger wrote:
>> get_robust_list has at least two valid use cases.
>> 1. checkpoint/restore in userspace
>> 2. post mortem analysis=20
>=20
> Shouldn't this then also be added as a comment somewhere near the
> implementation to avoid a repeat of this deprecate / undeprecate cycle?=


Or someone submits a patch to glibc and the man-pages project to make thi=
s
system call official...

Thanks,
//richard


--------------enig5E830B26402E23C357E6EBBF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJQH9tFAAoJEN9758yqZn9epXMH/Rl+SnzG1YqiV/amABAwFVgj
k+296oeB89QqSBbPfTCA0LhykgssOTneq1EIRNilS7tZ/f2pM3Uz82E8+v7n4+Cu
VZEs5T7eqBtlqVRTSZXLlR08RnfCciwmHD7Xe5uAQGKgXliDsNW3FXL315a3vIpe
9HtxoF3d930TqbB1Qg1akX/J9qomtpZnjobS5eptWlp/FxNvm7DEXgxsxOAPPOMz
VoH+vJF1/LF3ijqMmpzn2xpO1Ou3tyIhd+BWzyFqLoXEtpESdrv39FroOoEvgnOY
QpQrCjrcBgVnNh0JGzc+T6E4sgpfZu+bPjPpl1m6E4eK3RTIPXvyxRpkBm7CX44=
=rbzp
-----END PGP SIGNATURE-----

--------------enig5E830B26402E23C357E6EBBF--
