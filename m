Return-Path: <SRS0=bkzO=VT=lists.openwall.com=kernel-hardening-return-16534-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB458C7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 21:02:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1B50721901
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 21:02:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B50721901
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16534-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13322 invoked by uid 550); 22 Jul 2019 21:01:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12220 invoked from network); 22 Jul 2019 21:01:25 -0000
Date: Mon, 22 Jul 2019 23:01:02 +0200
From: Stephen Kitt <steve@sk2.org>
To: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
 jannh@google.com, kernel-hardening@lists.openwall.com, corbet@lwn.net,
 linux-kernel@vger.kernel.org, Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <20190722230102.442137dc@heffalump.sk2.org>
In-Reply-To: <15f2be3cde69321f4f3a48d60645b303d66a600b.camel@perches.com>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
	<20190629181537.7d524f7d@sk2.org>
	<201907021024.D1C8E7B2D@keescook>
	<20190706144204.15652de7@heffalump.sk2.org>
	<201907221047.4895D35B30@keescook>
	<15f2be3cde69321f4f3a48d60645b303d66a600b.camel@perches.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/_Z99aAs_wWSXS_RmNzhv7m="; protocol="application/pgp-signature"
X-Ovh-Tracer-Id: 2601110263553084917
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggdduiedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm

--Sig_/_Z99aAs_wWSXS_RmNzhv7m=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Jul 2019 10:59:00 -0700, Joe Perches <joe@perches.com> wrote:
> On Mon, 2019-07-22 at 10:50 -0700, Kees Cook wrote:
> > On Sat, Jul 06, 2019 at 02:42:04PM +0200, Stephen Kitt wrote: =20
> > > On Tue, 2 Jul 2019 10:25:04 -0700, Kees Cook <keescook@chromium.org>
> > > wrote: =20
> > > > On Sat, Jun 29, 2019 at 06:15:37PM +0200, Stephen Kitt wrote: =20
> > > > > On Fri, 28 Jun 2019 17:25:48 +0530, Nitin Gote
> > > > > <nitin.r.gote@intel.com> wrote:   =20
> > > > > > 1. Deprecate strcpy() in favor of strscpy().   =20
> > > > >=20
> > > > > This isn=E2=80=99t a comment =E2=80=9Cagainst=E2=80=9D this patch=
, but something I=E2=80=99ve been
> > > > > wondering recently and which raises a question about how to handle
> > > > > strcpy=E2=80=99s deprecation in particular. There is still one sc=
enario
> > > > > where strcpy is useful: when GCC replaces it with its builtin,
> > > > > inline version...
> > > > >=20
> > > > > Would it be worth introducing a macro for
> > > > > strcpy-from-constant-string, which would check that GCC=E2=80=99s=
 builtin
> > > > > is being used (when building with GCC), and fall back to strscpy
> > > > > otherwise?   =20
> > > >=20
> > > > How would you suggest it operate? A separate API, or something like
> > > > the existing overloaded strcpy() macros in string.h? =20
> > >=20
> > > The latter; in my mind the point is to simplify the thought process f=
or
> > > developers, so strscpy should be the =E2=80=9Cobvious=E2=80=9D choice=
 in all cases,
> > > even when dealing with constant strings in hot paths. Something like
> > >=20
> > > __FORTIFY_INLINE ssize_t strscpy(char *dest, const char *src, size_t
> > > count) {
> > > 	size_t dest_size =3D __builtin_object_size(dest, 0);
> > > 	size_t src_size =3D __builtin_object_size(src, 0);
> > > 	if (__builtin_constant_p(count) &&
> > > 	    __builtin_constant_p(src_size) &&
> > > 	    __builtin_constant_p(dest_size) &&
> > > 	    src_size <=3D count &&
> > > 	    src_size <=3D dest_size &&
> > > 	    src[src_size - 1] =3D=3D '\0') {
> > > 		strcpy(dest, src);
> > > 		return src_size - 1;
> > > 	} else {
> > > 		return __strscpy(dest, src, count);
> > > 	}
> > > }
> > >=20
> > > with the current strscpy renamed to __strscpy. I imagine it=E2=80=99s=
 not
> > > necessary to tie this to FORTIFY =E2=80=94 __OPTIMIZE__ should be suf=
ficient,
> > > shouldn=E2=80=99t it? Although building on top of the fortified strcp=
y is
> > > reassuring, and I might be missing something. I=E2=80=99m also not su=
re how to
> > > deal with the backing strscpy: weak symbol, or something else... At
> > > least there aren=E2=80=99t (yet) any arch-specific implementations of=
 strscpy
> > > to deal with, but obviously they=E2=80=99d still need to be supportab=
le.
> > >=20
> > > In my tests, this all gets optimised away, and we end up with code su=
ch
> > > as
> > >=20
> > > 	strscpy(raead.type, "aead", sizeof(raead.type));
> > >=20
> > > being compiled down to
> > >=20
> > > 	movl    $1684104545, 4(%rsp)
> > >=20
> > > on x86-64, and non-constant code being compiled down to a direct
> > > __strscpy call. =20
> >=20
> > Thanks for the details! Yeah, that seems nice. I wonder if there is a
> > sensible way to combine these also with the stracpy*() proposal[1], so =
the
> > call in your example above could just be:
> >=20
> > 	stracpy(raead.type, "aead");
> >=20
> > (It seems both proposals together would have the correct result...)
> >=20
> > [1] https://lkml.kernel.org/r/201907221031.8B87A9DE@keescook =20
>=20
> Easy enough to do.

How about you submit your current patch set, and I follow up with the above
adapted to stracpy?

Regards,

Stephen

--Sig_/_Z99aAs_wWSXS_RmNzhv7m=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAl02JA4ACgkQgNMC9Yht
g5ycxg//VDIjlBNpWaXHad+UEWucVHIXXVMmCChalfG8jqBFBwzmxOYy0Gkyh3mQ
RwEkCBJSrsj/VltKzQRW6B5E6RDqujOEnuq03U54o9FAVTp35OSaaIuLSudEI5/b
jh19jnx8NDX25EMQoUjP2vOt76pdnVg1ClJ92JKxFfXfVJGNpTqXpJrXlxK+RYkV
79SLtnJHpjdIjsSY6emwayV4ueOXgnF2RsxYQPqR3+QwWw6u94xIhl9Kb21r8/5d
+QyAxX+fXLSy43MBr/uAHIx7sqG6FSf0F917PjoP0A+Ki7IHUyKmonQXOPxx2aHJ
S0a8ZMdcAsHmF4nrcgPxAtrTS4jJA6HRAZ+ExgsYcGjaw6mD6jIYbO0pnpsWzZtr
jDQJB+0qlnMhxSGM/kd31yu8qgG/B+HNBA09u17+A+/p+PRMUXIsJ0G6A4Tp3YqW
VPQ01Zf0FUGczzZtB5uPvbLFIYhFaBec4Awj3MCQu9YYxCroLzkDqSrthgvPvw26
Ry/Que1fEFOCPEtK4l3KXu2sZlYUR+1VuOKW5Dshy/fPONtl2KgRHFZl2sykEcp0
gksTutJ/icOkzoGj0rM7OZiFogS5nv7YnfJJ56pvIi99tLVf6IlZ8sylxvn0arXr
RVHS3wjbHNK9gHUSrQvmGsRWiIZjQ4t7giNhdC/hKgQazQ0QOts=
=da33
-----END PGP SIGNATURE-----

--Sig_/_Z99aAs_wWSXS_RmNzhv7m=--
