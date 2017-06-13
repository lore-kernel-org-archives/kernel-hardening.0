References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608034349.31876-2-matt@nmatt.com>
 <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
 <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com>
 <20170613212704.GA16726@openwall.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <25278a42-736e-0d3b-8c0a-7b2b05ed7d28@digikod.net>
Date: Wed, 14 Jun 2017 01:53:56 +0200
MIME-Version: 1.0
In-Reply-To: <20170613212704.GA16726@openwall.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="OIp2lIbEGP9uLC14Lf0umXXTur4KWjLoa"
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution
 as a stackable LSM
To: Solar Designer <solar@openwall.com>, Matt Brown <matt@nmatt.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OIp2lIbEGP9uLC14Lf0umXXTur4KWjLoa
Content-Type: multipart/mixed; boundary="m2LL5vbkljwgQeEAbdTxaalmFicQ8DqEE";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Solar Designer <solar@openwall.com>, Matt Brown <matt@nmatt.com>
Cc: kernel-hardening@lists.openwall.com
Message-ID: <25278a42-736e-0d3b-8c0a-7b2b05ed7d28@digikod.net>
Subject: Re: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution
 as a stackable LSM
References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608034349.31876-2-matt@nmatt.com>
 <CAGXu5jLsrTZV_xDR_MPZdkT44P1MpbDiF3Kk2HNWBXKsdY+fzg@mail.gmail.com>
 <94ba5ebb-952b-2037-799e-07306629a6f9@nmatt.com>
 <20170613212704.GA16726@openwall.com>
In-Reply-To: <20170613212704.GA16726@openwall.com>

--m2LL5vbkljwgQeEAbdTxaalmFicQ8DqEE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable


On 13/06/2017 23:27, Solar Designer wrote:
> Matt,
>=20
> I removed most CC's like before, as I don't want my voice on this to be=

> too loud.
>=20
> On Thu, Jun 08, 2017 at 11:50:32PM -0400, Matt Brown wrote:
>> On 06/08/2017 10:38 PM, Kees Cook wrote:
>>> On Wed, Jun 7, 2017 at 8:43 PM, Matt Brown <matt@nmatt.com> wrote:
>>>> *  Issues:
>>>>   *  Can be bypassed by interpreted languages such as python. You ca=
n run
>>>>      malicious code by doing: python -c 'evil code'
>>>
>>> What's the recommendation for people interested in using TPE but
>>> having interpreters installed?
>>
>> If you don't need a given interpreter installed, uninstall it. While
>> this is common sense system hardening it especially would make a
>> difference under the TPE threat model.
>>
>> I don't have a knock down answer for this. Interpreters are a hard
>> problem for TPE.
>=20
> Interpreters are only a tip of the iceberg.
>=20
> With TPE, every program invocation becomes similar to a SUID/SGID one a=
s
> it relates to TPE's newly introduced security barrier.  However, the
> dynamic linker and libc have no idea of this, and will happily grant
> arbitrary code execution in context of those programs via LD_PRELOAD an=
d
> such.  Even if this is somehow dealt with (how would you do that in the=

> kernel alone? filter typical env var names? it quickly becomes way too
> hackish and blacklistish, thus imperfect), then there's still:

What about using the AT_SECURE auxv (cf. security_bprm_secureexec)?

>=20
> I think many, and maybe most, binaries on a system will contain buffer
> overflows and such that also allow for arbitrary code execution.  Those=


Enforcing W^X (cf. tpe.memory xattr) mitigate this threat.

> programs were not written as carefully as SUID/SGID ones are supposed t=
o
> be.  They don't treat their input and environment as untrusted.

Sure, but perfect is the enemy of good. Having a kernel enforcing TPE is
a good argument to convince userland to be hardened against untrusted
input. ;) For example, thanks to PaX, the Gentoo Hardened community
patched a lot of userland programs to make them compatible with PIE and
other security features.

>=20
> Closer to the topic of interpreters, there's also this old trick:
>=20
> $ strace -e execve /lib/ld-linux.so.2 /bin/uname -ms
> execve("/lib/ld-linux.so.2", ["/lib/ld-linux.so.2", "/bin/uname", "-ms"=
], [/* 28 vars */]) =3D 0
> Linux i686
> +++ exited with 0 +++
>=20
> As you can see, the only execve(2) is of the dynamic linker.  Will /lib=

> or/and /lib64 be among trusted paths in a typical setup?  Well, maybe
> not, although not including them will break ldd(1) on the more security=

> conscious distros, where it uses a similar trick of invoking the dynami=
c
> linker explicitly (rather than the historical unsafe way of invoking th=
e
> binary being ldd'ed with some env vars set to tell its dynamic linker t=
o
> do the magic rather than proceed to execute the program).
>=20
> But this last one is relatively minor.  The real big issue is that TPE
> is either inherently fairly easily bypassable (and should be documented=

> as such) via many of the installed programs (by far not just explicit
> interpreters, but also any programs containing "weird machines", which
> is probably most non-trivial programs out there, and some trivial ones)=
,
> or it relies on all programs in the trusted paths being written as if
> they were SUID/SGID (unrealistic for non-trivial systems).

Right, this is the most complex part, but we should start somewhere. :)
This kind of machine can not be constrain by the kernel, only by the
programs themselves. We need them to honor the AT_SECURE.

>=20
> Just so that you know what you're getting into, and so that you don't
> mislead your users.
>=20
> Alexander
>=20


--m2LL5vbkljwgQeEAbdTxaalmFicQ8DqEE--

--OIp2lIbEGP9uLC14Lf0umXXTur4KWjLoa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAllAexQACgkQIt7+33O9
apVljgf+KUAzcUBHVZU0VwqhLZ3GYTEBvfK8vPVUoezg05qLd/TCbWeWKV0GJW8X
DP618tcD++kLYJqzV33a9OZ6+tS66u8JNLhd8mZYHSe24oKwCsivAIqfNjnUnzT2
EKocNX/g2LqAL4YoXBT6qqnyzQY30hRVjFdb3kjTqLwziLUljm7Sd9vzQHsCgXAE
/RI/wsn8aDEJp4laDrvijCM0+8X5YkAhZSBAJeXiXuMEI1uN2wi8A9QzyQoP0T66
Htner2Q5kHLfXpeS/lCt2SEZ9aPlpdXzkTJ8rRHCFGPbO9JM6j8zeRHpBeFG8so1
eVCmVtfEaUOCX8F3XN2zuVzCtCY0ww==
=QoEA
-----END PGP SIGNATURE-----

--OIp2lIbEGP9uLC14Lf0umXXTur4KWjLoa--
