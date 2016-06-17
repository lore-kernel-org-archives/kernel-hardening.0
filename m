Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1466165881.27155.84.camel@decadent.org.uk>
From: Ben Hutchings <ben@decadent.org.uk>
Date: Fri, 17 Jun 2016 13:18:01 +0100
In-Reply-To: <871t3wuzmp.fsf@ashishki-desk.ger.corp.intel.com>
References: <20160111151958.GQ28542@decadent.org.uk>
	 <20160111152355.GS28542@decadent.org.uk>
	 <871t3wuzmp.fsf@ashishki-desk.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iHmIn0jDojz5bgJtZJC9"
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH 2/2] security,perf: Allow further restriction of
 perf_event_open
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-iHmIn0jDojz5bgJtZJC9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-06-17 at 08:56 +0300, Alexander Shishkin wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > When kernel.perf_event_open is set to 3 (or greater), disallow all
> > access to performance events by users without CAP_SYS_ADMIN.
> > Add a Kconfig symbol CONFIG_SECURITY_PERF_EVENTS_RESTRICT that
> > makes this value the default.
>=20
> So this patch does two things, can it then be made into two patches?

It could.

> >=20
> > This is based on a similar feature in grsecurity
> > (CONFIG_GRKERNSEC_PERF_HARDEN).=C2=A0=C2=A0This version doesn't include=
 making
> > the variable read-only.=C2=A0=C2=A0It also allows enabling further rest=
riction
> > at run-time regardless of whether the default is changed.
>=20
> This paragraph doesn't seem to belong in the commit message.

I'm giving credit where credit is due.

> What this commit message is missing entirely is the rationale behind
> this change other than "grsecurity does the same". Can you please
> elaborate?

It allows disabling a facility which in many systems is not needed and
is only a security risk.

> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > ---
> > I made a similar change to Debian's kernel packages in August,
> > including the more restrictive default, and no-one has complained yet.
>=20
> As a debian user, is this a good place to complain? Because it does get
> it the way.

OK, then you're the first one. =C2=A0And you know how to change this, don't
you?

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- A=
lbert
Camus

--=-iHmIn0jDojz5bgJtZJC9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXY+p5AAoJEOe/yOyVhhEJ+pQQALYGOs/lXVUrdHojUlh/NI/E
9Vb2HEESIrm3l6KO+kg4MVlThMRpz/gCzlPoL1mRWhbDkdTJodN1F7coAncBNILD
rTx4w2FxGEgt6xOg0JF/dEM1IKmv8JxmpIXEze9epoBKw/JF1/mLSDHsgNjkb5Go
ch8yCZU6ybUhaaxjrl0Del59jsrgoVjov9S3eaoOiB0eabXsH//nQVSvunhqsbeB
B7goKqzwbgS7o8Nh3W+SOYyW5fI4KI7EjzBQtZ9kdAvbfakfl3PY767v/aXf0Xc+
kYRnATjlRSGW82rd8oG/aY8/7Ag59dAW5zp/6e/1N0s3NkpW9f6xon7t4q/jRy3L
E3cYe6ZG/dBNFHYmXHcWfNc4Wv7TK0wfdlmma688/mQPJzboo2cQGeteT83+uQkB
ASpkKrOMpbTsIxUc0CHVoFtZ9dSaliWn7sXHy+2kz3dTf9FI5itPzUHDrSfKE7Rn
p5B4kOkJreTaI/plCLC4YIstF9U0cDCmKI0pxgUTjSf5Q+Msj1Cl3gyqKhz/rHac
090rzjvgg2xvIoTxn+DDc2Ir6ZgO2HUchLh4iYIrtKoOBVjLpbW86WTp4aR1zDR+
chzMqncxb7apXnbG3cgCqeAzB5lOnLu/h8yOqYBX6MswWrSt7wdCO0DFPh5o0wWN
kfv3ycJQblwYDs64ZPMe
=XJhh
-----END PGP SIGNATURE-----

--=-iHmIn0jDojz5bgJtZJC9--
