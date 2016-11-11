Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1478838308.11393.15.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Thu, 10 Nov 2016 23:25:08 -0500
In-Reply-To: <CAGXu5jJpOxewaYTOFRKBS-YmzAGDY++guVFYdQh8vsJLU4zJzA@mail.gmail.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
	 <20161110203749.GV3117@twins.programming.kicks-ass.net>
	 <20161110204838.GE17134@arm.com>
	 <20161110211310.GX3117@twins.programming.kicks-ass.net>
	 <CAGXu5jJpOxewaYTOFRKBS-YmzAGDY++guVFYdQh8vsJLU4zJzA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Ys84C7+qDTjq07eZg+LO"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-Ys84C7+qDTjq07eZg+LO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-11-10 at 13:23 -0800, Kees Cook wrote:

> If we don't use opt-out for atomics, we're going to be in the same
> situation where we have to constantly review every commit with an
> atomic for exploitable refcount flaws. Kicking this down from
> "privilege escalation" to "DoS" is a significant change in the
> kernel's weaknesses.

The only way I see around that would be to totally get
rid of the name atomic_t, forcing people with out of
tree code to use kref_t, or whatever name we pick for
the variable type that can wrap.

Something like checkpatch or a patch checking bot
could warn whenever new code is submitted that uses
the counter type that can wrap.

Not sure whether I like my idea :)

--=20
All Rights Reversed.
--=-Ys84C7+qDTjq07eZg+LO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYJUgkAAoJEM553pKExN6D0dcH/Ao78/CtATZDzp7OW0XS16FC
zlg05vKoZIGPP3Fv54OeRULeAC9Bqee1v1U283l4aLnqsQNeY8y1yRQ5ceLvbmz3
ry7TYqrW4GbPJueZhxlgZUnqppPkmDmZd5mm0DZtACRiRl0FAKWigfa47LuIU/L1
2e144GRWdhJp94vSStssjIGPwSPWthYo7wYQ2Khj3oRH4rtTwyazn/CaMRauqlPP
0hcwSCsE0HldkxuQhizSgbWTHo2ATp+p7D7lamLyWXcGwg/wv+/0gJkkOhfCqAuF
62x5u+WE0i2sO1/4T4vAaQNbK0fga30DlRiI4083gkFbKHaHAmrqkPBEi4A1SJY=
=b1wr
-----END PGP SIGNATURE-----

--=-Ys84C7+qDTjq07eZg+LO--
