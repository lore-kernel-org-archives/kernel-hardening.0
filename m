Sender: Vincent Batts <vbatts@gmail.com>
Date: Fri, 3 Feb 2017 15:48:42 -0500
From: Vincent Batts <vbatts@hashbangbash.com>
Message-ID: <20170203204842.GF7330@bananaboat.hashbangbash.com>
References: <CAEk6tEzVh3=6QbvcjOUz6ESdA8JzFD4dagTFiKdguegtoquJXg@mail.gmail.com>
 <CAJcbSZHRo-sGVcMVBkXJRdRJHyv9_8g9RHYuy8wfo8m2gRhnDw@mail.gmail.com>
 <CAEk6tEz5XqKOytCSCYj3TfpXZDKSBS6aam-O1Aqp0Oz7-_RgNw@mail.gmail.com>
 <871svfytb0.fsf@xmission.com>
 <CAEk6tEw5-19rZFHL2+-uw+sibegb1KAQj24jk8YZz3m_KE7TKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1Ow488MNN9B9o/ov"
Content-Disposition: inline
In-Reply-To: <CAEk6tEw5-19rZFHL2+-uw+sibegb1KAQj24jk8YZz3m_KE7TKw@mail.gmail.com>
Subject: Re: [kernel-hardening] Container Hardening
To: Jessica Frazelle <me@jessfraz.com>
Cc: Thomas Garnier <thgarnie@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--1Ow488MNN9B9o/ov
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jess,

In the vein of your proposal (https://gist.github.com/jessfraz/3a84023ff854=
71696ee33a20031b9e7b),
there was recently a systemtap (http://sourceware.org/systemtap/) script
written to output some of this data that is not generally accessible
=66rom userspace.

Will Cohen was nice enough to upload this and a quick write-up on it's
usage.
https://github.com/wcohen/linux-instrumentation/blob/master/container_check=
=2Emd

Where this can show when a "badcap" is encountered, or just to see the
profile of capabilities and syscalls used.

vb



--1Ow488MNN9B9o/ov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAliU7KoACgkQEJN+V3M/E2IaHwCfRwoCNAwyL4+CEHYLjJP97L1C
d7IAoKrawLJFXrR4wQrXwVafM246++bv
=68MR
-----END PGP SIGNATURE-----

--1Ow488MNN9B9o/ov--
