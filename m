From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
References: <201706100041.GFH78616.OFtOHFJSLQOMVF@I-love.SAKURA.ne.jp>
 <754b78d1-f7f9-58bd-bf74-fea9e105649a@nmatt.com>
 <20170609164315.GA1141@meriadoc.perfinion.com>
 <d84aaf19-307b-4b60-df74-4fb43a218c9c@nmatt.com>
 <CAGXu5jJt5MRU3ZdKABEbLt4qe-cCLxEm5tMH9SdUh=rtdLUV1w@mail.gmail.com>
 <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
 <d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.net>
 <1497234757.21594.280.camel@linux.vnet.ibm.com>
 <1497277644.21594.319.camel@linux.vnet.ibm.com>
Message-ID: <9e17ed9e-7322-559f-052f-ce809025e64f@digikod.net>
Date: Tue, 13 Jun 2017 22:59:59 +0200
MIME-Version: 1.0
In-Reply-To: <1497277644.21594.319.camel@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="UCnGu2jiColSsbarRrPd8uan8Ue1FbgL5"
Subject: [kernel-hardening] Re: [PATCH v1] shebang: restrict python interactive
 prompt/interpreter
To: Mimi Zohar <zohar@linux.vnet.ibm.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org, matt@nmatt.com
Cc: jason@perfinion.com, linux-security-module@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>, kernel-hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UCnGu2jiColSsbarRrPd8uan8Ue1FbgL5
Content-Type: multipart/mixed; boundary="enRIifCn2VmD0bvf6o9ROeEacqQvXS3DW";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org,
 matt@nmatt.com
Cc: jason@perfinion.com, linux-security-module@vger.kernel.org,
 Daniel Micay <danielmicay@gmail.com>,
 kernel-hardening <kernel-hardening@lists.openwall.com>,
 LKML <linux-kernel@vger.kernel.org>
Message-ID: <9e17ed9e-7322-559f-052f-ce809025e64f@digikod.net>
Subject: Re: [PATCH v1] shebang: restrict python interactive
 prompt/interpreter
References: <201706100041.GFH78616.OFtOHFJSLQOMVF@I-love.SAKURA.ne.jp>
 <754b78d1-f7f9-58bd-bf74-fea9e105649a@nmatt.com>
 <20170609164315.GA1141@meriadoc.perfinion.com>
 <d84aaf19-307b-4b60-df74-4fb43a218c9c@nmatt.com>
 <CAGXu5jJt5MRU3ZdKABEbLt4qe-cCLxEm5tMH9SdUh=rtdLUV1w@mail.gmail.com>
 <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
 <d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.net>
 <1497234757.21594.280.camel@linux.vnet.ibm.com>
 <1497277644.21594.319.camel@linux.vnet.ibm.com>
In-Reply-To: <1497277644.21594.319.camel@linux.vnet.ibm.com>

--enRIifCn2VmD0bvf6o9ROeEacqQvXS3DW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 12/06/2017 16:27, Mimi Zohar wrote:
> On Sun, 2017-06-11 at 22:32 -0400, Mimi Zohar wrote:
>> On Sun, 2017-06-11 at 13:44 +0200, Micka=C3=ABl Sala=C3=BCn wrote:
> =20
>>> Using filesystem xattr seems like a good idea for this kind of
>>> exceptions and instead of a hardcoded interpreter path. Something lik=
e
>>> "security.tpe.interpreter=3D1|2" (bitmask for interpreter-only and/or=
 CLI)
>>> and "security.tpe.environment=3DHOME,LOGNAME" would be quite flexible=
 to
>>> configure a security policy for some binaries. This could also be
>>> protected by IMA/EVM, if needed.
>>
>> Checking for the existence of an xattr without caching is relatively
>> slow.  I'm not sure that we would want to go this route.
> =20
> For identifying interpreters, xattrs would be too slow (without
> caching results), but once identified, using xattrs as you suggested,
> for specifying how interpreters can be invoked and limiting
> environment variables, is a good idea.  Perhaps the two xattrs could
> be combined?

Yes, caching results is definitely interesting. I think using one
variable per usage is cleaner, though.


--enRIifCn2VmD0bvf6o9ROeEacqQvXS3DW--

--UCnGu2jiColSsbarRrPd8uan8Ue1FbgL5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAllAUk8ACgkQIt7+33O9
apX+Twf6A7n+BteDbBUMLamSznAUIkkfJ6boucLsdOjva/rbbRoI8MbZwSKJoPwl
JAYC3EKMpHEq8jBThDCB4UEZpFkPlmBBGbd0a6RR8ZLdgXHNaNrSt+7RqXSqqWRV
RPoE/089awoiI9VSuYrxdNXEEYQcESfrQdVNOj74AeVG1yOKvuDHP2fJP8LAPfiy
IFUC6KwDtbn7Mjqmjw5suAV5Lqs8YRMjkorpk+q2pk8txqAJSL4g+YTdWDmrFoBN
lZaSW37OU8kQa6EV+TZgGL+/SeaEC12xq9IgGz+AtbxGHnKEVvU721mxh1zglP77
Jo5HKWO3Yw2p6F6TeYmlMW3icug1Fw==
=8gVN
-----END PGP SIGNATURE-----

--UCnGu2jiColSsbarRrPd8uan8Ue1FbgL5--
