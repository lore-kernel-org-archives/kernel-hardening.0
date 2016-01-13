Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jan 2016 19:08:19 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20160113180819.GA22567@pc.thejh.net>
References: <1452626745-31708-1-git-send-email-jann@thejh.net>
 <87mvsa5q40.fsf@gamma.ozlabs.ibm.com>
 <20160113002043.GA17146@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20160113002043.GA17146@openwall.com>
Subject: [kernel-hardening] Re: [RFC] kernel/panic: place an upper limit on number of oopses
To: Solar Designer <solar@openwall.com>
Cc: Daniel Axtens <dja@axtens.net>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Baoquan He <bhe@redhat.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-ID: <kernel-hardening.lists.openwall.com>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13, 2016 at 03:20:43AM +0300, Solar Designer wrote:
> Jann Horn <jann@thejh.net> wrote:
> > To prevent an attacker from turning a mostly harmless oops into an
> > exploitable issue using a refcounter wraparound caused by repeated
> > oopsing, limit the number of oopses.
>=20
> This may also reduce the likelihood of successful exploitation of some
> other vulnerabilities involving memory corruption, where an unsuccessful
> attempt may inadvertently trigger an Oops.  The attacker would then need
> to succeed in fewer than the maximum allowed number of Oops'es.  Jann's
> currently proposed default of 0x100000 is too high to make a difference
> in that respect, but people may set it differently.

I chose such a high value to increase the likelyhood that this gets
included in the kernel by default. Lower values would mitigate more
attacks, but I'm not sure whether they'd be acceptable for everyone.


> On Wed, Jan 13, 2016 at 10:34:39AM +1100, Daniel Axtens wrote:
> > I'm torn between making the limit configurable and not adding to the
> > massive proliferation of config options.
>=20
> What about reusing panic_on_oops for the configurable limit?  The
> currently supported values of 0 and 1 would retain their meaning,
> 2 would panic after 2nd Oops, and so on.
>=20
> There's overlap with grsecurity's banning of users on Oops, but I think
> it makes sense to have both the trivial change proposed by Jann (perhaps
> with the reuse of panic_on_oops for configuration) and grsecurity-style
> banning (maybe with a low configurable limit, rather than always on
> first Oops).

One edgecase here is that, afaik, grsecurity-style banning isn't very
effective in combination with the subuid mechanism (implemented in
userland, using the newuidmap setuid helper and /etc/subuid) because
it allows every user to control 2^16 kuids (not just inside namespaces,
but also indirectly in the init namespace).
This probably doesn't affect many people though: Debian and Ubuntu ship
newuidmap in a separate package "uidmap" that isn't installed by
default and is only installed by a few people (0.18% on Debian
according to popcon, those probably need it for unprivileged LXC or
so?). Arch ships with newuidmap installed, but without /etc/subuid.
I don't know what other distros do.

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWlpKTAAoJED4KNFJOeCOoYccP/1wu8hxYPci1fQ9qzkvqXS4S
7TmT6wOdG3+3KBiAY2cNxGFGM1gVeU1OjVAd/N2KnJdgeQXz4lM3C9QJw6CN9H2c
zvOwdsIF7yeM5h0CTihICXX280nwfMjxzPka0LcGFYP9UNyr/NWR9BhiZF6Omk52
KPs6Q1/N/fUhfFU3tJiNr5hOzmN+nG+JlqF1VdrU3CLaIOj0HrHfjnmmzaJ3K5f2
GsTPNgZ5azK3b8SJ9A3EfsoMFy0fueD/tFDEfkuW+Adbymb36H01w8goJ+ww9fuJ
ox3UD0k0V/twKuFKqVz8CKJ7uVrKEhE2TZYktPeV77cnv83IjRC8Jh+nkI5xoKCJ
brdg1G9jPipzjNgJX4jbUfS0P5g+FXXoeVWCaAoi/AL+fHJloj4SHFUKsvO1Rqjd
CVkHZbLZQKc6F+dBnYR8kbxoYfl8t58Uh543MfbFAX2df/YvE3wB68GcRWMIasIz
kjYRg6+s8olOQBDVlLCqbMyLndHeWxNL1h9C1b0+6cv5pQ4yow7f9/lQuAzS4ACe
InSfYMbtTkua1XvGNa9NVKi7yBSdcQ99dLUBsz4mWU5NCBGAK1/Fla2/TkTIQ3Oy
oC3O8yAu8NaqBZDaGkdez9zYOf6COY1MTbcRMUrkTnGh8kDvrzRZtX7lUN5ozASx
u8rgA6VGb0nkwWRH4mCL
=Wd1G
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
