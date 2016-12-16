Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1481847262.1054.3.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 15 Dec 2016 19:14:22 -0500
In-Reply-To: <1481846720.1054.1.camel@gmail.com>
References: <20161214185000.GA3930@kroah.com>
	 <20161214185052.GC4939@kroah.com>
	 <20161214202952.GV1555@brightrain.aerifal.cx>
	 <20161214205444.GA16183@kroah.com> <20161215175439.GA1172@kroah.com>
	 <1481835061.3477.5.camel@gmail.com> <20161215211807.GA13393@kroah.com>
	 <1481846720.1054.1.camel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-f2gX+d4T1gUhQ3q052Cj"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 3/4] Make static usermode helper
 binaries constant
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-f2gX+d4T1gUhQ3q052Cj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> So for statics, I think `static const char *` wins due to allowing
> merging (although it doesn't matter here). For non-statics, you end up
> with extra pointer constants. Those could get removed, but Linux
> doesn't
> have -fvisibility=3Dhidden and I'm not sure how clever linkers are.
> Maybe
> setting up -fvisibility=3Dhidden to work with monolithic non-module-
> enabled builds could actually be realistic. Expect it'd remove a fair
> bit of bloat but not sure how much would need to be marked as non-
> hidden=C2=A0
> other than the userspace ABI.

-fvisibility=3Dhidden + LTO would be really awesome though, since that
doesn't depend on the cleverness of linkers. So much that could be
ripped out of real world monolithic builds. Kinda getting off-topic now
though. LTO is pretty scary from a security perspective due to how much
worse undefined behavior that was previously harmless can get.
--=-f2gX+d4T1gUhQ3q052Cj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlhTMd4WHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKuvnD/4qNEo44aR4rQ3gyG7IqE9tjo60
SYc87lUp7Jo960HpQBrZuSlqTYcfjatmkUOw/AC9qG7vkS/bLoDqhpQB9SiQKbGm
kNukFRsSqSM6O27OW6QbcU2InkxGa8ZN/3g7WuPD+FHNfcbYMxJop7vKMBhvSmRl
hHkBUfsVFYMPjL/Uh02y44xJIyWoCe/glaI1xYxdl4T2q6zG/TuvGW3tcunIMikV
ApG/rlnGi1bs724rrT+hvFWfobfsubMiBvzMN5rA533EsweHF6aM8mQc4Il2k1iN
Hl3hRae+4PsW0cWs+2FuA24B5XrdEjgEgAXXZR9vm5qedvU/5Jnkf/Kj+f9dwZ0X
c3zNqXD3N4JZc+SBFtZknWT9GwJrD5aZrH/xUqrr33DBP/PwYzpF3Kyb/mr0LBZR
J24rjwqB6RUpV3BD9U663gCitj6szjbUZMWsK/wj5GbE77DpgVHouK25i0Pdjdp5
M4ixkjqL43W7SIAPt2nvR/5Grw0jttpF508v5cm7oQvuyu1pj2R6y2PEjOz9ctct
w4zcrekalhcILqg1qAJiu0Skl0c3oIMh7qrhX5QTFp+y+8YdehxTqLRvWk/sl1CD
pH0NlQEhXEBhg4QlR7I+oPEil6SRJFwQpKzQTS7FjUFB3IFj3LnEbEB/e6DyL9pD
FxGNm7PXty/uYiePFQ==
=XZuM
-----END PGP SIGNATURE-----

--=-f2gX+d4T1gUhQ3q052Cj--
