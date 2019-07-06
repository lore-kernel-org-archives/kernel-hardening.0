Return-Path: <SRS0=tPgF=VD=lists.openwall.com=kernel-hardening-return-16363-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34E2C0650E
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 12:42:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3C87B214AF
	for <kernel-hardening@archiver.kernel.org>; Sat,  6 Jul 2019 12:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C87B214AF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16363-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9613 invoked by uid 550); 6 Jul 2019 12:42:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9579 invoked from network); 6 Jul 2019 12:42:31 -0000
Date: Sat, 6 Jul 2019 14:42:04 +0200
From: Stephen Kitt <steve@sk2.org>
To: Kees Cook <keescook@chromium.org>
Cc: Nitin Gote <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <20190706144204.15652de7@heffalump.sk2.org>
In-Reply-To: <201907021024.D1C8E7B2D@keescook>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
	<20190629181537.7d524f7d@sk2.org>
	<201907021024.D1C8E7B2D@keescook>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/m.xxHd88eQTUb3QsxOnf/Bi"; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 10892800126257286414
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrfeeigdehiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd

--Sig_/m.xxHd88eQTUb3QsxOnf/Bi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Jul 2019 10:25:04 -0700, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Jun 29, 2019 at 06:15:37PM +0200, Stephen Kitt wrote:
> > On Fri, 28 Jun 2019 17:25:48 +0530, Nitin Gote <nitin.r.gote@intel.com>
> > wrote: =20
> > > 1. Deprecate strcpy() in favor of strscpy(). =20
> >=20
> > This isn=E2=80=99t a comment =E2=80=9Cagainst=E2=80=9D this patch, but =
something I=E2=80=99ve been
> > wondering recently and which raises a question about how to handle
> > strcpy=E2=80=99s deprecation in particular. There is still one scenario=
 where
> > strcpy is useful: when GCC replaces it with its builtin, inline version=
...
> >=20
> > Would it be worth introducing a macro for strcpy-from-constant-string,
> > which would check that GCC=E2=80=99s builtin is being used (when buildi=
ng with
> > GCC), and fall back to strscpy otherwise? =20
>=20
> How would you suggest it operate? A separate API, or something like the
> existing overloaded strcpy() macros in string.h?

The latter; in my mind the point is to simplify the thought process for
developers, so strscpy should be the =E2=80=9Cobvious=E2=80=9D choice in al=
l cases, even when
dealing with constant strings in hot paths. Something like

__FORTIFY_INLINE ssize_t strscpy(char *dest, const char *src, size_t count)
{
	size_t dest_size =3D __builtin_object_size(dest, 0);
	size_t src_size =3D __builtin_object_size(src, 0);
	if (__builtin_constant_p(count) &&
	    __builtin_constant_p(src_size) &&
	    __builtin_constant_p(dest_size) &&
	    src_size <=3D count &&
	    src_size <=3D dest_size &&
	    src[src_size - 1] =3D=3D '\0') {
		strcpy(dest, src);
		return src_size - 1;
	} else {
		return __strscpy(dest, src, count);
	}
}

with the current strscpy renamed to __strscpy. I imagine it=E2=80=99s not n=
ecessary
to tie this to FORTIFY =E2=80=94 __OPTIMIZE__ should be sufficient, shouldn=
=E2=80=99t it?
Although building on top of the fortified strcpy is reassuring, and I might
be missing something. I=E2=80=99m also not sure how to deal with the backin=
g strscpy:
weak symbol, or something else... At least there aren=E2=80=99t (yet) any
arch-specific implementations of strscpy to deal with, but obviously they=
=E2=80=99d
still need to be supportable.

In my tests, this all gets optimised away, and we end up with code such as

	strscpy(raead.type, "aead", sizeof(raead.type));

being compiled down to

	movl    $1684104545, 4(%rsp)

on x86-64, and non-constant code being compiled down to a direct __strscpy
call.

Regards,

Stephen

--Sig_/m.xxHd88eQTUb3QsxOnf/Bi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAl0glxwACgkQgNMC9Yht
g5xebA/9EAhjG5kG8Sj8OWFAgZ34loMcQry/RzeqzCMlSe5V+MDjRtB1htVzWQW0
Ts1l4TJOrJJe46PS/cxzrgnIrq/J9Ides6tOilpipuGGigkhTS4SGJ2FAAOLG/EN
WMZTSdrWy6tpU6LvRpyScd6SvG2kT7R+GTRB5pIvBnyO8WVDjmLejeBPGP14SMfU
tfAXQ2JaJJBowCvdUv4l3QTsa+NVRMjGWp9RoAuPsTJaFCISK/IG9HJwW0bjFjnI
X/KV1OorKEwjzf2a9cyXtuCgHqhm85d8SmXrqcIDpklqcsXiXVjTQM6HceW9SyhG
iWmlaHErQIHk0xXIW/Z+I9ZBSaGxEfSQRzEm18g5KjMcRSzK/tufdNwssC7U48yU
6snVL51BhJrAEv1uB34ynHrYQD7S3VtM8lfIgzw13+TPB/ALdyRLqmhZdDf9VDcO
CGy+obG1D65va8zVt8D05ZjlL9TjXy58v0cgRn7ZWswYZPL13mEdKwtLi5GcK00g
BHoBaFrANYn02Gj1Mj7AaiOz75x7pdckMxPkQr3Nb4AAysBqlokaWsq4EpJvJiXY
Lb0/RH36JaP2Zm7kBVZJmh4QBc0OSLUYYrQz3hEB54KU4gSTciHxB7yk5KnCz4NI
KoqS0ekb6WJ9DDHA3/DUxgEMY26ZsXa3uY+Dgs1ryHNp5SExYMw=
=cQvx
-----END PGP SIGNATURE-----

--Sig_/m.xxHd88eQTUb3QsxOnf/Bi--
