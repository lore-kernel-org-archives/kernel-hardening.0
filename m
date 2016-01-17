Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 17 Jan 2016 04:58:31 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20160117035831.GA28443@pc.thejh.net>
References: <1452626745-31708-1-git-send-email-jann@thejh.net>
 <87mvsa5q40.fsf@gamma.ozlabs.ibm.com>
 <20160113002043.GA17146@openwall.com>
 <20160113180819.GA22567@pc.thejh.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20160113180819.GA22567@pc.thejh.net>
Subject: Re: [kernel-hardening] Re: [RFC] kernel/panic: place an upper limit
 on number of oopses
To: Solar Designer <solar@openwall.com>, Brad Spengler <spender@grsecurity.net>
Cc: Daniel Axtens <dja@axtens.net>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Baoquan He <bhe@redhat.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
List-ID: <kernel-hardening.lists.openwall.com>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13, 2016 at 07:08:19PM +0100, Jann Horn wrote:
> On Wed, Jan 13, 2016 at 03:20:43AM +0300, Solar Designer wrote:
> > Jann Horn <jann@thejh.net> wrote:
> > > To prevent an attacker from turning a mostly harmless oops into an
> > > exploitable issue using a refcounter wraparound caused by repeated
> > > oopsing, limit the number of oopses.
> >=20
> > This may also reduce the likelihood of successful exploitation of some
> > other vulnerabilities involving memory corruption, where an unsuccessful
> > attempt may inadvertently trigger an Oops.  The attacker would then need
> > to succeed in fewer than the maximum allowed number of Oops'es.  Jann's
> > currently proposed default of 0x100000 is too high to make a difference
> > in that respect, but people may set it differently.
>=20
> I chose such a high value to increase the likelyhood that this gets
> included in the kernel by default. Lower values would mitigate more
> attacks, but I'm not sure whether they'd be acceptable for everyone.
>=20
>=20
> > On Wed, Jan 13, 2016 at 10:34:39AM +1100, Daniel Axtens wrote:
> > > I'm torn between making the limit configurable and not adding to the
> > > massive proliferation of config options.
> >=20
> > What about reusing panic_on_oops for the configurable limit?  The
> > currently supported values of 0 and 1 would retain their meaning,
> > 2 would panic after 2nd Oops, and so on.
> >=20
> > There's overlap with grsecurity's banning of users on Oops, but I think
> > it makes sense to have both the trivial change proposed by Jann (perhaps
> > with the reuse of panic_on_oops for configuration) and grsecurity-style
> > banning (maybe with a low configurable limit, rather than always on
> > first Oops).
>=20
> One edgecase here is that, afaik, grsecurity-style banning isn't very
> effective in combination with the subuid mechanism (implemented in
> userland, using the newuidmap setuid helper and /etc/subuid) because
> it allows every user to control 2^16 kuids (not just inside namespaces,
> but also indirectly in the init namespace).
> This probably doesn't affect many people though: Debian and Ubuntu ship
> newuidmap in a separate package "uidmap" that isn't installed by
> default and is only installed by a few people (0.18% on Debian
> according to popcon, those probably need it for unprivileged LXC or
> so?). Arch ships with newuidmap installed, but without /etc/subuid.
> I don't know what other distros do.

Aaand now grsecurity mitigates that (by panicking if too many uids
cause kernel crashes).

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWmxFnAAoJED4KNFJOeCOouKcP/jB9IAmsgJi5zOc09bq7k4a3
MoT6He36YCca6QzBk7fqoroFTwnYdGJX6IwMrO0LM7m8n0EZ8CIAVZZ7E3inVmhJ
UGg4HNOkx2UJGJYC36PtPNnRbXFcyCEIf6BgPamYM1F5YAqb8PhO4CMD54szoUin
nYKbHEaITCVy9cJORhKivjQQPg7nlVzlUCUq2++QWNmSmN8C1itktBK8B07T39Uj
qEsaf7ubdZG6fX9bn7jBZCRsoIeX8jYQ2sTE7F2EhzOfoHUyIC8BAbvuvLmS+dqN
zczu5PhNHka8cWobdmZQtugGTkeVr4Gx5/oxapwEsw+btc5asRsBciese+LXH8rD
E1KK155EjTtMYUiasvec88QLqJoWywsUI1rlkHzaDXpTpfasTZkDGpuAd19Xx5Pb
qY4EmnFaYJS/rEGO74BbCPjIDKGA4ehgzcIyYHALUwTv4NksMm6xEfTr0IdKPXqr
RCxq1i23oKiqoE5AppMP/gukHL27Ldy+vHQ+wudskgc7h1hoeWylCVUhLkLYu5au
msZg6MLhbQTUUvmA6h6UZ4fb/cnFmn3dYpDY9TgJmSX3D8Koeip2f9+5HHrY8Ref
1Wb7fvrhUsh3vepDsixpzUZEcktcJYSt9rgwQyMyi41yQVQ8yXKhPCSDXi42jSOH
yn7BEOxNdZWiRQ92+v7r
=tiNk
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
