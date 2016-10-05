Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 5 Oct 2016 18:18:45 +0200
From: Jann Horn <jann@thejh.net>
Message-ID: <20161005161845.GR14666@pc.thejh.net>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
 <57F2B105.9050400@intel.com>
 <20161004124156.GE2040@pc.thejh.net>
 <57F51EB3.1030605@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YC8Ek3FeOE8ywfXk"
Content-Disposition: inline
In-Reply-To: <57F51EB3.1030605@intel.com>
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for
 HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--YC8Ek3FeOE8ywfXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 05, 2016 at 08:39:31AM -0700, Dave Hansen wrote:
> On 10/04/2016 05:41 AM, Jann Horn wrote:
> > $ time ./atomic_user_test 2 1 1000000000 # multi-threaded, no protection
> > real	0m9.550s
> > user	0m18.988s
> > sys	0m0.000s
> > $ time ./atomic_user_test 2 2 1000000000 # multi-threaded, racy protect=
ion
> > real	0m9.249s
> > user	0m18.430s
> > sys	0m0.004s
> > $ time ./atomic_user_test 2 3 1000000000 # multi-threaded, cmpxchg prot=
ection
> > real	1m47.331s
> > user	3m34.390s
> > sys	0m0.024s
>=20
> Yikes, that does get a ton worse.

Yeah, but as Kees said, that's an absolute worst case, and while there
might be some performance impact with some very syscall-heavy real-world
usage, I think it's very unlikely to be that bad in practice.

It probably doesn't matter much here, but out of curiosity: Do you know
what makes this so slow? I'm not familiar with details of how processors
work  - and you're at Intel, so maybe you know more about this or can ask
someone who knows? The causes I can imagine are:

1. Pipeline flushes because of branch prediction failures caused by
   more-or-less random cmpxchg retries? Pipeline flushes are pretty
   expensive, right?
2. Repeated back-and-forth bouncing of the cacheline because an increment
   via cmpxchg needs at least two accesses instead of one, and the
   cacheline could be "stolen" by the other thread between the READ_ONCE
   and the cmpxchg.
3. Simply the cost of retrying if the value has changed in the meantime.
4. Maybe if two CPUs try increments at the same time, with exactly the
   same timing, they get stuck in a tiny livelock where every cmpxchg
   fails because the value was just updated by the other core? And then
   something slightly disturbs the timing (interrupt / clock speed
   change / ...), allowing one task to win the race?

> But, I guess it's good to know we
> have a few choices between performant and absolutely "correct".

Hrm. My opinion is that the racy protection is unlikely to help much with
panic_on_oops=3D0. So IMO, on x86, it's more like a choice between:

 - performant, but pretty useless
 - performant, but technically unreliable and with panic on overflow
 - doing it properly, with a performance hit

> Do you have any explanation for "racy protection" going faster than no
> protection?

My guess is "I'm not measuring well enough and random stuff is going on".=
=20
Re-running these on the same box, I get the following numbers:

$ time ./atomic_user_test 2 1 1000000000 # multi-threaded, no protection
real	0m9.549s
user	0m19.023s
sys	0m0.000s
$ time ./atomic_user_test 2 2 1000000000 # multi-threaded, racy protection
real	0m9.586s
user	0m19.154s
sys	0m0.001s

(This might be because I'm using the ondemand governor, because my CPU has
the 4GHz boost thing, because stuff in the background is randomly
interfering... no idea.)

--YC8Ek3FeOE8ywfXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9SflAAoJED4KNFJOeCOoElIQAIiSYcsdBHOr0B2Xuo5xnc6b
VsvNM0sS/tBCQkN5hPtME/YxpAkUG34ef+x5NhYIy8YZ1H27jNkiY9SdFUTTktgV
7QO9s3xEsGw0up/NNkog0yDqKtSZ9g8GXrYGyiCPcDAQcEvORs8gEiUQ2i03atut
x9s1BxsVtagJiJfY5QbGflgJrGO2MItgbNrk+imFVTvuUBriQBdzrt4vLHqTL5G8
ejXLydlutO7Ac891cP7btMEf3io4lOVuRz75gsHzKLBIn6mivUywqFG6dFA6DlLF
fIoB+iAmQXVxzVqNNv/Nv838bu2Td/IO3APTW5W7XzD0XZ+WOWTXtIMotQX3NKMh
sNUSs30ltdLZou15EAhMHcSvulnAqZHVoHmEV9MKLtksbupNxs4y2Y/XqVgOJ3wv
c3wJW9boIf4nig7sSTSZffHjgB0IlugNfNy82Sq/1IgfxhmaRDVjAkiVc7rb02hV
P4zbOAm6Ql6Pws7FW1DmVTjQiEHHjnP5q83D1tRVXh6HlvQFuaJOrVPXP06+3Qwf
qNBJuf877bC+Yx+RIWQuCdQn/cbdxL8Neo9pjx6I8xINx2NiuGnPfyTwb3fxqUWg
wR9vyh6W80VAvjsvthFJwJq80W94kreEbY/NkcB6Tn9NhjKJSkLpXPHAL+OP8tsJ
YkfB3gKFe1EgylvTT0zR
=V/Rc
-----END PGP SIGNATURE-----

--YC8Ek3FeOE8ywfXk--
