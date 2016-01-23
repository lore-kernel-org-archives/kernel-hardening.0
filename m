Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 23 Jan 2016 23:25:40 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20160123222540.GA9740@pc.thejh.net>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <1453502345-30416-2-git-send-email-keescook@chromium.org>
 <87oacdyos0.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <87oacdyos0.fsf@x220.int.ebiederm.org>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] sysctl: expand use of
 proc_dointvec_minmax_sysadmin
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 22, 2016 at 09:10:07PM -0600, Eric W. Biederman wrote:
> Kees Cook <keescook@chromium.org> writes:
>=20
> > Several sysctls expect a state where the highest value (in extra2) is
> > locked once set for that boot. Yama does this, and kptr_restrict should
> > be doing it. This extracts Yama's logic and adds it to the existing
> > proc_dointvec_minmax_sysadmin, taking care to avoid the simple boolean
> > states (which do not get locked). Since Yama wants to be checking a
> > different capability, we build wrappers for both cases (CAP_SYS_ADMIN
> > and CAP_SYS_PTRACE).
>=20
> Sigh this sysctl appears susceptible to known attacks.
>=20
> In my quick skim I believe this sysctl implementation that checks
> capabilities is susceptible to attacks where the already open file
> descriptor is set as stdout on a setuid root application.
>=20
> Can we come up with an interface that isn't exploitable by an
> application that will act as a setuid cat?

Adding the struct file * to the parameters of all proc_handler
functions would work, right? (Or just filp->f_cred? That would be
less generic.)

A quick grep says that's just about 160 functions that'll need to
be changed. :/

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWo/3kAAoJED4KNFJOeCOoELUP/3CaoE6Ykam5ZOwYUBI3aQSH
x8UCRDxLljAvxhY5gEbby/QFN06oMVv9k34PfLN2MFWG34LC+2iNyArgfTQ7WxdF
8rskZtFuCb1o/4Br3v6W1Lbrnea3HRPW58VBoO3tUoa7rM/ERrSWXVP8mPPIP/tV
d6KNoERWyHjph0K/42nexG9+F7BMssz2BfTTogBtWDuOXF1Sf16fmjLxdKY+2Gn5
FqE7Mrph5QyR7YgbtglpwobeD5/p2ogIPdaelt2PO5IB7ADyrtiMP3Ht+lgEdasL
c29cA6v8MjXOeZFaPBtSrNT2y6aVlWBT77Nrmzw4mCFwLJc3dRNOoFbvG/KMs6Wq
/JRkbSBalGkUgr0i+NZBCQ7OcEic4JWZmDytOOCrH3WDQaM93B8KChffF+Unw73O
Y39tLDuAnpWpGs76LGAmuzwP6cAgra3P6Y2UpsO+G1jcKKZTyFoAwB+G8p80q5xc
xYGKmInZsvX3ZF7/JRl6oJGTFlpqdCVVWtyNX6b8EjlE8M9XsU7rqIKEOmIg+StI
NRwFjW/q+2wZ/RfxvAv+m+6Y5ZvaaWjJcVjRpKjvrz3Vdhk94hN1CoFIgrD+BRJ4
ySnWrbwK3R8ifTylO1xN9+0QABars2UfIl0TYxJPYQUORJVYmWzSaTvfdz6BGS0u
x1d0uMVmnZL8TBMQmBL0
=TgXw
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
