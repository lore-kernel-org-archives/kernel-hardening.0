Date: Fri, 22 Feb 2019 07:26:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 5/6] lib: Fix function documentation for
 strncpy_from_user
Message-ID: <20190222072652.2441e8a2@canb.auug.org.au>
In-Reply-To: <CAGXu5j+Mf2D5LgkEmps7VVBhmNGt=49y4caP1y1E0OBURJEeXQ@mail.gmail.com>
References: <20190218232308.11241-1-tobin@kernel.org>
	<20190218232308.11241-6-tobin@kernel.org>
	<CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com>
	<CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
	<20190221052435.GF11758@eros.localdomain>
	<CAGXu5j+Mf2D5LgkEmps7VVBhmNGt=49y4caP1y1E0OBURJEeXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/16HKosc1eB4/OdJ8zARR2vg"; protocol="application/pgp-signature"
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Jann Horn <jannh@google.com>, "Tobin
 C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-ID: <kernel-hardening.lists.openwall.com>

--Sig_/16HKosc1eB4/OdJ8zARR2vg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kees,

On Wed, 20 Feb 2019 22:02:32 -0800 Kees Cook <keescook@chromium.org> wrote:
>
> What I can't quite figure out yet is how to find a way for sfr to flag
> newly added users of strcpy, strncpy, and strlcpy. We might need to
> bring back __deprecated, but hide it behind a W=3Dlinux-next flag or
> something crazy. Stephen, in your builds you're already injecting
> -Wimplicit-fallthrough: do you do W=3D1 or anything like that? If not, I
> think we need some W=3D setting for your linux-next builds that generate
> the maintainer-nag warnings...

I just have a set of compiler flags that my build scripts explicitly
enable by setting KCFLAGS.

--=20
Cheers,
Stephen Rothwell

--Sig_/16HKosc1eB4/OdJ8zARR2vg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlxvCYwACgkQAVBC80lX
0Gy1iAgAipXsrzM+7B/eQNkmcSgakfzIso73aGvuVcrZUvqIJCwDQTO9URAJ5YL2
1kp/2Q4mkvXyRyun2CpFs6xry0kgo0FmVqOCjTxZE49JlZYPSiWnjaI5VLfdAy2h
L6G9jf2FKSapWuacbEJUqxne7UIMEe7OMJBsCoAKcXAo3snwbPRNhO8fGAhVzFMd
6hKFPWMymq6qEPrigr9J5yB1Q0lTGbz8tsh65AE0ENMswGHcJYFgN/nEb05eHx2h
G3rQhy2wX5WItnRhhXsueYwEE2oSRBFC8AfL+5N8zPW/RX+8fo91kg6rOZZpU0mX
/Lxm95vnAbmfahlPbpsaZACDSIVCUA==
=QQ0T
-----END PGP SIGNATURE-----

--Sig_/16HKosc1eB4/OdJ8zARR2vg--
