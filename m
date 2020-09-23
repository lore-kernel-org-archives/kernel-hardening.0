Return-Path: <SRS0=Z0+R=DA=lists.openwall.com=kernel-hardening-return-19965-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1717C2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 08:42:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E61F9221F0
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 08:42:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E61F9221F0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19965-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32767 invoked by uid 550); 23 Sep 2020 08:42:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32747 invoked from network); 23 Sep 2020 08:42:44 -0000
Date: Wed, 23 Sep 2020 10:42:32 +0200
From: Pavel Machek <pavel@ucw.cz>
To: madvenka@linux.microsoft.com
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org, luto@kernel.org, David.Laight@ACULAB.COM,
	fweimer@redhat.com, mark.rutland@arm.com, mic@digikod.net
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923084232.GB30279@amd>
References: <210d7cd762d5307c2aa1676705b392bd445f1baa>
 <20200922215326.4603-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <20200922215326.4603-1-madvenka@linux.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Solution proposed in this RFC
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>=20
> >From this RFC's perspective, there are two scenarios for dynamic code:
>=20
> Scenario 1
> ----------
>=20
> We know what code we need only at runtime. For instance, JIT code generat=
ed
> for frequently executed Java methods. Only at runtime do we know what
> methods need to be JIT compiled. Such code cannot be statically defined. =
It
> has to be generated at runtime.
>=20
> Scenario 2
> ----------
>=20
> We know what code we need in advance. User trampolines are a good example=
 of
> this. It is possible to define such code statically with some help from t=
he
> kernel.
>=20
> This RFC addresses (2). (1) needs a general purpose trusted code generator
> and is out of scope for this RFC.

This is slightly less crazy talk than introduction talking about holes
in W^X. But it is very, very far from normal Unix system, where you
have selection of interpretters to run your malware on (sh, python,
awk, emacs, ...) and often you can even compile malware from sources.=20

And as you noted, we don't have "a general purpose trusted code
generator" for our systems.

I believe you should simply delete confusing "introduction" and
provide details of super-secure system where your patches would be
useful, instead.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9rCngACgkQMOfwapXb+vKeqgCgpVQMutlRE7F/wzcDjcBTlXwI
RbAAnjRDzunOtf0iSPKO6rIM9FPy6+JQ
=wVZX
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
