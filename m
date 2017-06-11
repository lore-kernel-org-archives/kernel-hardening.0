References: <201706100041.GFH78616.OFtOHFJSLQOMVF@I-love.SAKURA.ne.jp>
 <754b78d1-f7f9-58bd-bf74-fea9e105649a@nmatt.com>
 <20170609164315.GA1141@meriadoc.perfinion.com>
 <d84aaf19-307b-4b60-df74-4fb43a218c9c@nmatt.com>
 <CAGXu5jJt5MRU3ZdKABEbLt4qe-cCLxEm5tMH9SdUh=rtdLUV1w@mail.gmail.com>
 <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.net>
Date: Sun, 11 Jun 2017 13:44:22 +0200
MIME-Version: 1.0
In-Reply-To: <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="f2SIAQb6L1btw5MBEKvXtqi8gSjmHpxwn"
Subject: [kernel-hardening] Re: [PATCH v1] shebang: restrict python interactive
 prompt/interpreter
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org, matt@nmatt.com
Cc: jason@perfinion.com, zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>, kernel-hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f2SIAQb6L1btw5MBEKvXtqi8gSjmHpxwn
Content-Type: multipart/mixed; boundary="rPlAQtL1RliVNm1ilGuOIgI9PRqnbj38W";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org,
 matt@nmatt.com
Cc: jason@perfinion.com, zohar@linux.vnet.ibm.com,
 linux-security-module@vger.kernel.org, Daniel Micay <danielmicay@gmail.com>,
 kernel-hardening <kernel-hardening@lists.openwall.com>,
 LKML <linux-kernel@vger.kernel.org>
Message-ID: <d9aca46b-97c6-4faf-b559-484feb4aa640@digikod.net>
Subject: Re: [PATCH v1] shebang: restrict python interactive
 prompt/interpreter
References: <201706100041.GFH78616.OFtOHFJSLQOMVF@I-love.SAKURA.ne.jp>
 <754b78d1-f7f9-58bd-bf74-fea9e105649a@nmatt.com>
 <20170609164315.GA1141@meriadoc.perfinion.com>
 <d84aaf19-307b-4b60-df74-4fb43a218c9c@nmatt.com>
 <CAGXu5jJt5MRU3ZdKABEbLt4qe-cCLxEm5tMH9SdUh=rtdLUV1w@mail.gmail.com>
 <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>
In-Reply-To: <201706101427.EEG90168.OtFFHSFMOVOJQL@I-love.SAKURA.ne.jp>

--rPlAQtL1RliVNm1ilGuOIgI9PRqnbj38W
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable


On 10/06/2017 07:27, Tetsuo Handa wrote:
> Kees Cook wrote:
>> On Fri, Jun 9, 2017 at 10:23 AM, Matt Brown <matt@nmatt.com> wrote:
>>> what does everyone thing about a envp_blacklist option that is a list=
 of
>>> environmental variables that will be stripped from exec calls. This c=
an
>>> be done in the LSM hook bprm_check_security.
>>>
>>> Is there any reason on a hardened system why you would need the
>>> PYTHONINSPECT environmental variable?
>>
>> As part of shebang, it likely makes sense to whitelist (rather than
>> blacklist) the env of the restricted interpreters. Though this is
>> starting to get complex. :P
>=20
> Blacklisting environment variables is dangerous. I think that
> administrators can afford whitelisting environment variable names.
> I think that implementing whitelist of environment variable names
> as an independent LSM module would be fine.
>=20
> While it is true that things starts getting complex if we check environ=
ment
> variables, shebang will already become complex if it starts worrying ab=
out
> updating inode number list in order to close the race window between do=
ing
> creat()+write()+close()+chmod()+rename() by the package manager and tea=
ching
> the kernel the new inode number determined by creat(). We will need an
> interface for allowing the package manager to teach the kernel the new =
inode
> number and modification of the package manager, for the kernel side is =
doing
> inode number based blacklisting while user side can execute it before r=
ename().
> --
> To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Using filesystem xattr seems like a good idea for this kind of
exceptions and instead of a hardcoded interpreter path. Something like
"security.tpe.interpreter=3D1|2" (bitmask for interpreter-only and/or CLI=
)
and "security.tpe.environment=3DHOME,LOGNAME" would be quite flexible to
configure a security policy for some binaries. This could also be
protected by IMA/EVM, if needed.

This kind of xattr should be writable by the owner of the file. The TPE
LSM [1] could then take these xattr into account according to the TPE
policy.

The "security.tpe.environment" could also be set on a script file to be
part of the union with the interpreter's environment whitelist. This may
be needed to be able to use environment variables as configuration in a
script.

In the future, a "security.tpe.memory" could contain a set of flags as
PaX uses for mprotect-like exceptions (user.pax.flags).

Userland daemons such as paxctld or paxrat could be used (with some
tweaks) to keep a consistent TPE policy over time.

 Micka=EBl


[1] https://lkml.kernel.org/r/1497015878.21594.201.camel@linux.vnet.ibm.c=
om


--rPlAQtL1RliVNm1ilGuOIgI9PRqnbj38W--

--f2SIAQb6L1btw5MBEKvXtqi8gSjmHpxwn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlk9LRYACgkQIt7+33O9
apXL9Qf/RrvYEsVpo0fTlZJ0rnjtHWw0ls8Ub/jY5SVl5Ae51AjAJY1O3W45wLpy
xLcsUUisqdcsxfwUFdM1x3KUhSeunsPPhVh7tJ05DHRZtY0r4texi2tNMWM0PeyL
fAvIrTA2soRKfxoDv2FZV7QMDCl0eb2bc2GrhhRVsUXhGckEV3GZcwOSS3lnfl9o
OVd2cVN1ZbGMgttnhA9ap5I7/XKc/yuh94dXeao4cEBaf0Rz4twwmlQrtn2ZkYZ3
iT2rluJlKhq92c08ft2uaS7L1eO8Ojb0DlHrSAMwdlg4UFQcs2RUZgcGRihlVLTN
WGtNxo+tlB/NMvFqSFUPYDg0A9fK1g==
=G26Q
-----END PGP SIGNATURE-----

--f2SIAQb6L1btw5MBEKvXtqi8gSjmHpxwn--
