Date: Mon, 26 Feb 2018 09:13:39 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Subject: Re: Pull Request for linux-next
Message-ID: <20180225221339.GA2808@eros>
References: <20180225075907.GB9456@eros>
 <20180226075422.6d55953d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20180226075422.6d55953d@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tycho@tycho.ws, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2018 at 07:54:22AM +1100, Stephen Rothwell wrote:
> Hi Tobin,
>=20
> On Sun, 25 Feb 2018 18:59:07 +1100 "Tobin C. Harding" <me@tobin.cc> wrote:
> >
> > Would it be possible to get the development tree for
> > scripts/leaking_addresses.pl included in Linux-next please.
> >=20
> > The tree is hosted on kernel.org
> >=20
> > https://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git/
> >=20
> > I have created a branch called linux-next.  This branch is not tagged or
> > signed.  I'm super new to kernel maintainer branch management, ATM the
> > tree mirrors GregKH's staging tree setup i.e 3 branches
> >=20
> > 	master
> > 	leaks-testing
> > 	leaks-next
> >=20
> > Development done on leaks-testing.  Once patches have been rinsed
> > through LKML move them to leaks-next.  Any holes in that?
>=20
> That looks fine to me.  I have added your leaks-next branch from
> today.  It would be nice to see some Reviewed-by or Acked-by tags on
> your commits.

Yeah I know that would be awesome, there doesn't seem to be a lot of
interest in this script ATM.  None of my recent patches have gotten any
comments what so ever.  We have a second maintainer now though so
hopefully there will be at least two sets of eyes going over it.

> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgement of your code.

lol, that line made my heart jump into mouth ready for the comment to
come :)

> The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.=20
>=20
> You will need to ensure that the patches/commits in your tree/series have
> been:
>      * submitted under GPL v2 (or later) and include the Contributor's
>         Signed-off-by,
>      * posted to the relevant mailing list,
>      * reviewed by you (or another maintainer of your subsystem tree),
>      * successfully unit tested, and=20
>      * destined for the current or next Linux merge window.
>=20
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.

Cheers,
Tobin.
--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJakzUOAAoJEEC/nkwmnWYHF4QQAKJ52BUMrMeTv1Yh6S4AmerH
LsE1M/FrBkjoJpiP27uXhRQNYDmm+E0rlTRscmB6Cyfm2q3W5ZRnBGPvHHmmO9r0
Nz/hte3nCFSG/BLnsmtRdJ9yuqcNBc/ekcMTP1JbKLM9RVvw5t6i4UaHBzGoPjJt
nQk7hWtS38QwXr7419VsJBEKPl/x5E2b86WcgT1Sg0GD9BHCArOR//W06ProNBaA
CCMny3Es+wMMdCbzcJj1sEaAcuRCx6OM1e+0Q2CXQChUlMNBxpAiOk5vN9TpM2gj
SodMiICCY3J+mXoCAbBue66bXeUi/uwmbLDS1f52EM+j9SJL3BZZ9B4yfE7qflNu
J52qwGhpGqfOiSKo9w/WfZafvrtkaqjFzzSPz1vC3t69V/WI93/CNy9f1+WIL+ZH
9InW5g8kJPKQYLq3pDaxPBbuLCK/qPXoJxttOlQfAsgTiEywkXM3GhvbA4dd2ZvI
fWWiwiRG9IZ2RyXsF7JKbydMkVbyXCuuPpnoUzh2/iu/L6lC11Cb0ec55gcb6Xfd
NtPXDSpXjTueh+dP+oxGI+ij0l7qQx9XMZCAP7qNHw5kS3ckzkNvbIDSxgQsoZBS
L956JD8TGIljKRx9y93lwzqPccavm/PxBXiVWCnLQqehgD1ZU33XkU8GnZAckXjo
ze15gUSqdyF9ev9LK33u
=t+BO
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
