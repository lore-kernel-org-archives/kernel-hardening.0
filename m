Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1466177070.849.24.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 17 Jun 2016 11:24:30 -0400
In-Reply-To: <871t3wuzmp.fsf@ashishki-desk.ger.corp.intel.com>
References: <20160111151958.GQ28542@decadent.org.uk>
	 <20160111152355.GS28542@decadent.org.uk>
	 <871t3wuzmp.fsf@ashishki-desk.ger.corp.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-/Orb6oQdqJ+h9YjlZ8/l"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 2/2] security,perf: Allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com, Ben Hutchings <ben@decadent.org.uk>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-/Orb6oQdqJ+h9YjlZ8/l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> As a debian user, is this a good place to complain? Because it does
> get
> it the way.

It would be relevant to whether or not it should be set to 3 by default
in the kernel without explicit configuration, but there's no proposal to
do that. Debian has to pick a trade-off beyond security and a tiny
roadblock for developers. It's not always the case though.

In Android, there's userspace integration allowing it to be toggled by
the Android Debugging Bridge shell user so profiling tools are being
taught to automatically toggle it. Enabling ADB and then using it for
profiling is an implicit opt-in.
--=-/Orb6oQdqJ+h9YjlZ8/l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXZBYuAAoJEPnnEuWa9fIqYyoQAJbeRecnZ9P/atJCDQIjvoSG
/ZIRggK6MNygodYHlvAmsL4v+viXspB0dKYLZSkJDSEndPyLn+Z3gvl3pw0QHhMF
ZlyO37RiuKeNVm8FbtmuUTV4Tf3TAAi1E5grocYotgs6FaRpvfrEumVfINBHVode
wp7Hn8ODIEtKehlb81qE0sIeYL04zk+mt0U0wEQrJT7xaPmsSI7HB+8nvSlMeFK5
OHyAVigd+Nlzd57xWjXa0ggWlKkMvJ5YfdsGr3m+pJOIoSga+4bRbSSgu5MZsiMd
eK26/yhv8EVJdgjsMmfZDVJto2IeECU2AABP83G1aEfHZYBzuqn4VLNiS7IzwVLS
feqCA7LdnVTSmOw7nCt7MDqn0sIWJhl2lU0U7GujElad1sxTArtdFIBeRJIyzoU0
bmfFsClAmV4sx4Hto8JbHFj0JrTKfE0Pp7rCQpHzAVLruiIWLmpA5y6OFy7BT9/4
GutiWhYMm8Kp6AgDYdQTEAPMm2gZStDpFUZIk3ETbHniScpmMInJzK25YiYbPVzv
zWDVDAxOnkxAVdSHNa0VR3nN2GrrnxMQKp+uz4tPN7q9GB7N8Ng6tPEZ/hRqUJMq
/VLo+d5ovH3PQQscgm14rquMQvYmHlegvrN7WuXW/uCNWyxkYXaO1P9EteA0uvKc
YMVsa5lP4k9J43kG4pQg
=Xn1G
-----END PGP SIGNATURE-----

--=-/Orb6oQdqJ+h9YjlZ8/l--
