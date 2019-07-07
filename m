Return-Path: <SRS0=zep8=VE=lists.openwall.com=kernel-hardening-return-16376-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E471BC0650E
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Jul 2019 07:41:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 46992208E4
	for <kernel-hardening@archiver.kernel.org>; Sun,  7 Jul 2019 07:41:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46992208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16376-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17497 invoked by uid 550); 7 Jul 2019 07:41:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17457 invoked from network); 7 Jul 2019 07:41:05 -0000
Date: Sun, 7 Jul 2019 09:40:41 +0200
From: Stephen Kitt <steve@sk2.org>
To: Kees Cook <keescook@chromium.org>
Cc: Nitin Gote <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <20190707094041.6f7943a5@heffalump.sk2.org>
In-Reply-To: <20190706144204.15652de7@heffalump.sk2.org>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
	<20190629181537.7d524f7d@sk2.org>
	<201907021024.D1C8E7B2D@keescook>
	<20190706144204.15652de7@heffalump.sk2.org>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/BzPXpfC/EXZpRl.MgdFIL7d"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 11675019085324307726
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm

--Sig_/BzPXpfC/EXZpRl.MgdFIL7d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Jul 2019 14:42:04 +0200, Stephen Kitt <steve@sk2.org> wrote:
> On Tue, 2 Jul 2019 10:25:04 -0700, Kees Cook <keescook@chromium.org> wrot=
e:
> > On Sat, Jun 29, 2019 at 06:15:37PM +0200, Stephen Kitt wrote: =20
> > > On Fri, 28 Jun 2019 17:25:48 +0530, Nitin Gote <nitin.r.gote@intel.co=
m>
> > > wrote:   =20
> > > > 1. Deprecate strcpy() in favor of strscpy().   =20
> > >=20
> > > This isn=E2=80=99t a comment =E2=80=9Cagainst=E2=80=9D this patch, bu=
t something I=E2=80=99ve been
> > > wondering recently and which raises a question about how to handle
> > > strcpy=E2=80=99s deprecation in particular. There is still one scenar=
io where
> > > strcpy is useful: when GCC replaces it with its builtin, inline
> > > version...
> > >=20
> > > Would it be worth introducing a macro for strcpy-from-constant-string,
> > > which would check that GCC=E2=80=99s builtin is being used (when buil=
ding with
> > > GCC), and fall back to strscpy otherwise?   =20
> >=20
> > How would you suggest it operate? A separate API, or something like the
> > existing overloaded strcpy() macros in string.h? =20
>=20
> The latter; in my mind the point is to simplify the thought process for
> developers, so strscpy should be the =E2=80=9Cobvious=E2=80=9D choice in =
all cases, even
> when dealing with constant strings in hot paths. Something like
>=20
> __FORTIFY_INLINE ssize_t strscpy(char *dest, const char *src, size_t coun=
t)
> {
> 	size_t dest_size =3D __builtin_object_size(dest, 0);
> 	size_t src_size =3D __builtin_object_size(src, 0);
> 	if (__builtin_constant_p(count) &&
> 	    __builtin_constant_p(src_size) &&
> 	    __builtin_constant_p(dest_size) &&
> 	    src_size <=3D count &&
> 	    src_size <=3D dest_size &&
> 	    src[src_size - 1] =3D=3D '\0') {
> 		strcpy(dest, src);
> 		return src_size - 1;
> 	} else {
> 		return __strscpy(dest, src, count);
> 	}
> }
>=20
> with the current strscpy renamed to __strscpy. I imagine it=E2=80=99s not=
 necessary
> to tie this to FORTIFY =E2=80=94 __OPTIMIZE__ should be sufficient, shoul=
dn=E2=80=99t it?
> Although building on top of the fortified strcpy is reassuring, and I mig=
ht
> be missing something. I=E2=80=99m also not sure how to deal with the back=
ing
> strscpy: weak symbol, or something else... At least there aren=E2=80=99t =
(yet) any
> arch-specific implementations of strscpy to deal with, but obviously they=
=E2=80=99d
> still need to be supportable.

And there are at least two baked-in assumptions here: src really is a
constant string (so the if should only trigger then), to avoid TOCTTOU race=
s,
and there is only a single null byte at the end of src.

> In my tests, this all gets optimised away, and we end up with code such as
>=20
> 	strscpy(raead.type, "aead", sizeof(raead.type));
>=20
> being compiled down to
>=20
> 	movl    $1684104545, 4(%rsp)
>=20
> on x86-64, and non-constant code being compiled down to a direct __strscpy
> call.
>=20
> Regards,
>=20
> Stephen

--Sig_/BzPXpfC/EXZpRl.MgdFIL7d
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAl0hofkACgkQgNMC9Yht
g5z5Bg//az9zwI+TVVC+gSSBcadiZxra1V8z4OmJmisfCEjXq4R4C7gyDKJ2y8KH
bfAOoQa4oCZ7u7W7fmL+Ur8INMVgJK9vd9LczOgV35jxKfNq9Vr6EMATJ58Lrd4q
Cx/pX+0rUVU7fF4qKeVhhPJ0o6culj8NYjmJ+nLaYBwb8W7JBeZBMW5UEK/ZWgLC
CgT5JswqePfV1s/qsOKrtSdQil4PfwIjrYS0av9vkynwCgCoC6OVlttAYMnPd6Jd
OXxUVnZR//mhZEI2Dpo5NX82c7uz8MRHZYCfdCz4ONZkh12cRSLQ1hoJua+Lchlr
JgMatkL1hOitsGNGFwOQjohkZwKBm0dJ7BrwJvXD1KFloBpQU343FZTuvkr9m+DQ
gDITrF3f8Xeyk3o0XZzwL0gWZx6H4ky5ttLD/AUXVxkOULQGg1Nw1YuCTXqhWZzN
edGRQse8T9wuuUrt9CPuZCdH7SxTcUVuDAu7KdZYsBEAbXVCqJc2/ZRLaQOWIaIY
FBS7gIshuxlUVujM5VKpdp+MkdtiYNb6Ice6qs62eJmNySe5B4Pqv2khn0wXqpcT
21ZB2K+3Pd+oXhISHUj8Wjuiy70WMT4zCSS7ItmdORKJlyNNYr79AAuLsE2DmjkF
YMsRJfW1rz6oBVC2f+aQO6nds5KSCnpTKLlzO+rqHtRmZeNrvXM=
=fnRe
-----END PGP SIGNATURE-----

--Sig_/BzPXpfC/EXZpRl.MgdFIL7d--
