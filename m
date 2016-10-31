Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 31 Oct 2016 17:29:18 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20161031162918.GA2994@pc.thejh.net>
References: <1477922641-2221-1-git-send-email-jann@thejh.net>
 <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Hz=AmmTAh3+QOv1wTG3HA60LPK0Dq6F8uybNQ5e+sHw@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] fork: make whole stack_canary
 random
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 31, 2016 at 09:04:02AM -0700, Kees Cook wrote:
> On Mon, Oct 31, 2016 at 7:04 AM, Jann Horn <jann@thejh.net> wrote:
> > On machines with sizeof(unsigned long)=3D=3D8, this ensures that the mo=
re
> > significant 32 bits of stack_canary are random, too.
> > stack_canary is defined as unsigned long, all the architectures with st=
ack
> > protector support already pick the stack_canary of init as a random
> > unsigned long, and get_random_long() should be as fast as get_random_in=
t(),
> > so there seems to be no good reason against this.
> >
> > This should help if someone tries to guess a stack canary with brute fo=
rce.
> >
> > (This change has been made in PaX already, with a different RNG.)
> >
> > Signed-off-by: Jann Horn <jann@thejh.net>
>=20
> Acked-by: Kees Cook <keescook@chromium.org>
>=20
> (A separate change might be to make sure that the leading byte is
> zeroed. Entropy of the value, I think, is less important than blocking
> canary exposures from unbounded str* functions. Brute forcing kernel
> stack canaries isn't like it bruting them in userspace...)

Yeah, makes sense. Especially on 64bit, 56 bits of entropy ought to be
enough anyway.

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYF3FeAAoJED4KNFJOeCOocY8QALoHW3aWMXZN40tvze8/0Nv3
Bcvq0ruys5cDqTEUhWF/bdpCXpOtwJvTLRDMCH47k710ZhgtZYyOQ/rvVOOzBuF2
LURf+saU0Pj85lcTmnw1yfOQ4Vu9zZm0Fr/ReOG1Vqz7S6vJ/xeLjFlqIlSFvo7u
n5rOwR0cRL40kshS6XmBHphPajwMzuQqgcgpH5ZwTM/5zhs5ckLoQY083kunpwL2
71OCjH30INtocA8b329CL5uZcbQ6rykFERcgx73R7pAmL+pYD/5pSmNfub+YW3Ff
+k8UC2iiLQwTd9SKUstbzua7a/3h0t04g270iGxs0g2GhQmQxVUBGd0JasLJl6x3
AsWICvDAc64aFaXpBzb7RNMYlHPjSXvs7sT9qZ4Ztz5m7qgmt+1QWIjGeWh6pB+9
32+RjgaqQ1pKLvUNL13STqrkuezQYVWCnTNtp+cu54P7zG3Km+2lDTKPbx/7PSo8
jDmhrJObPuAK0vzcurAdL6euYZV6drcKCcBl5uH9oyJMEgOZfdj5/r2e7ctLZaGt
Fjq6eITybmfy/D2SbCTQ5MEPimiZ2+xgeIq9seBt/SnmyKSCm5Fa01njjrTUrZeF
aqHTEvPAkxDjSif6ugiNwEMZLG2EWgEm8f8o+rA6amgXN0EEEYQl7haf7cJcqlKh
Wt4Xqvf/0uNzVq+6JWCf
=2vU7
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
