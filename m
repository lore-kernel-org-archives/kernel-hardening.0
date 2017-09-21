Message-ID: <1506025307.5486.24.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Thu, 21 Sep 2017 16:21:47 -0400
In-Reply-To: <20170921185239.88398-3-ebiggers3@gmail.com>
References: <20170921185239.88398-1-ebiggers3@gmail.com>
	 <20170921185239.88398-3-ebiggers3@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-7xkChiA9PXNB1wO4FFuT"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH v3 2/3] x86/fpu: tighten validation
 of user-supplied xstate_header
To: Eric Biggers <ebiggers3@gmail.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-7xkChiA9PXNB1wO4FFuT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-09-21 at 11:52 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Move validation of user-supplied xstate_headers into a helper
> function
> and call it from both the ptrace and sigreturn syscall paths.=C2=A0=C2=A0=
The
> new
> function also considers it to be an error if *any* reserved bits are
> set, whereas before we were just clearing most of them.
>=20
> This should reduce the chance of bugs that fail to correctly validate
> user-supplied XSAVE areas.=C2=A0=C2=A0It also will expose any broken user=
space
> programs that set the other reserved bits; this is desirable because
> such programs will lose compatibility with future CPUs and kernels if
> those bits are ever used for anything.=C2=A0=C2=A0(There shouldn't be any=
 such
> programs, and in fact in the case where the compacted format is in
> use
> we were already validating xfeatures.=C2=A0=C2=A0But you never know...)
>=20
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hao <haokexin@gmail.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Wanpeng Li <wanpeng.li@hotmail.com>
> Cc: Yu-cheng Yu <yu-cheng.yu@intel.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
>=20
Reviewed-by: Rik van Riel <riel@redhat.com>

--=20
All rights reversed
--=-7xkChiA9PXNB1wO4FFuT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJZxB9cAAoJEM553pKExN6D8ygIAIl128KarCAq3fc+6HjyWCA6
YuJAU0kDYE23OQ+1UpZ4VNCSsWk8kmG6N/goj20yF2pQKwVqV4FaA2uGtSjkuENX
amSZetbgzP7M9E8RYJRAcJZGwVRP/dWsmli9fcgan6biNDMZx2TonmJuuoPiBrWi
K/AaoQOsyTuBRtIeHTyZujoNnCEFeYkrOBetUb5rkIJG4eBWeT1mMNPt+Zbqp5oh
cBm7ro3OF2N1L2R5yrnhpDw4DrH1Nj+WBwgH0YqFXj7t+Dsi9+7Xd4YYsX7C2l6W
UZyXcxILc9Mm9ooLxAVPKag0TFmJJrbmjzC+5UjPtyfWan00HpLiAUIicQeDnVk=
=8ypp
-----END PGP SIGNATURE-----

--=-7xkChiA9PXNB1wO4FFuT--
