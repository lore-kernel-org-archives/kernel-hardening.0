Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470143405.13627.22.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 02 Aug 2016 09:10:05 -0400
In-Reply-To: <20160802130457.GD26514@kernel.org>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20160802095243.GD6862@twins.programming.kicks-ass.net>
	 <20160802130457.GD26514@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-O4+mMNEKH1AgT3q2sUZE"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Vander Stoep <jeffv@google.com>, mingo@redhat.com, alexander.shishkin@linux.intel.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--=-O4+mMNEKH1AgT3q2sUZE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > So the problem I have with this is that it will completely inhibit
> > development of things like JITs that self-profile to re-compile
> > frequently used code.
>=20
> Or reimplement strace with sys_perf_event_open(), speeding it up
> greatly
> by not using ptrace (see 'perf trace', one such attempt), combining it
> with sys_bpf(), which can run unpriviledged as well, provides lots of
> possibilities for efficient tooling that would be greatly stiffled by
> such big hammer restrictions :-(

The usage on Android wouldn't impact strace. It's a debugging tool used
over the debugging shell so it could be taught to toggle on unprivileged
access to perf events as the other tools using the API were.
--=-O4+mMNEKH1AgT3q2sUZE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXoJutFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8iq/ZQ//afgWa0XQnZLOx+Eovkdj7fFtx69StlXq586u+ZAndgIbdImWcIielraZ
Aixv/tT8fzUqrxN6zOBgxRHkFj/a82UnTAp2ZvU4yxG3UP1eS5CFBzD3ict39STc
sUjcfGrznkseqEZevjGlTYwvt7GFE5xbjEMnwWc3/kf9p/EeTx8i1qYTxPalARqd
Ry2vZPLM5ecCpN2lei1tAqfA93lanCPD+S9demX4R/5kggrriSOwJyg1ntOOsw4r
EGlkA8vnTpiENqSvFr2kg7LF25T1fNzOYbEOeGDLqe1qVhSjnFo/iEKSHlWkmEOl
zKmhJXXNMbM8XSX8RZkEquI3K3GvPunb1xmF+mDIrhkJXtG9p8vX2PdeJogwdc7y
ORy5NpEfZtkxMWgGN+KHGydCk1oGfdPuyoWNioULtDcRvWLbR/f8HZmfbFdtxp6V
XwhAK9KSerEhrJsHJ2C/+doMEXcpaxZY2Cl+ZOdlGc36YR5Td3ZWW/LjvyfFzxLx
S+S6q2RupBZNkZgVpv2nqexYHYW2ywuJvpmkVrJ3bE2ZU6CDV/TaS1FxcI7S3W0z
9cNOOJr11BzYTNWWKM4PyapFlYv6ZPBMAsaona6caV+uV/aj4z/nrvDNhsEF+rVm
qsJ+5P6GQTk74OlUX865tMTf02CbPIGdlpFQaNqP1tgg1sClBi0=
=P+EX
-----END PGP SIGNATURE-----

--=-O4+mMNEKH1AgT3q2sUZE--
