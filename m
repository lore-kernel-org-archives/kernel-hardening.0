Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 24 Sep 2016 09:45:25 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20160924074525.GA28371@amd>
References: <1472121165-29071-1-git-send-email-mic@digikod.net>
 <20160915091902.GA13132@amd>
 <57E16D07.4050301@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <57E16D07.4050301@digikod.net>
Subject: [kernel-hardening] Re: [RFC v2 00/10] Landlock LSM: Unprivileged sandboxing
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, Elena Reshetova <elena.reshetova@intel.com>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Paul Moore <pmoore@redhat.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, netdev@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2016-09-20 19:08:23, Micka=EBl Sala=FCn wrote:
>=20
> On 15/09/2016 11:19, Pavel Machek wrote:
> > Hi!
> >=20
> >> This series is a proof of concept to fill some missing part of seccomp=
 as the
> >> ability to check syscall argument pointers or creating more dynamic se=
curity
> >> policies. The goal of this new stackable Linux Security Module (LSM) c=
alled
> >> Landlock is to allow any process, including unprivileged ones, to crea=
te
> >> powerful security sandboxes comparable to the Seatbelt/XNU Sandbox or =
the
> >> OpenBSD Pledge. This kind of sandbox help to mitigate the security imp=
act of
> >> bugs or unexpected/malicious behaviors in userland applications.
> >>
> >> The first RFC [1] was focused on extending seccomp while staying at th=
e syscall
> >> level. This brought a working PoC but with some (mitigated) ToCToU race
> >> conditions due to the seccomp ptrace hole (now fixed) and the non-atom=
ic
> >> syscall argument evaluation (hence the LSM hooks).
> >=20
> > Long and nice description follows. Should it go to Documentation/
> > somewhere?
> >=20
> > Because some documentation would be useful...
>=20
> Right, but I was looking for feedback before investing in documentation. =
:)

Heh. And I was hoping to learn what I'm reviewing. Too bad :-).

								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlfmLxUACgkQMOfwapXb+vIhUwCeJRBd+yxgp5b6dajyXx7AqeXp
NpoAnj5y4eKIbwut7GxzUIFQBVxKg8q/
=1Isn
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
