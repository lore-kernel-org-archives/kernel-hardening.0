Return-Path: <SRS0=cco7=DA=lists.openwall.com=kernel-hardening-return-19964-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C8FC2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 08:14:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 98AF2238A1
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 08:14:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98AF2238A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19964-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25915 invoked by uid 550); 23 Sep 2020 08:14:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25873 invoked from network); 23 Sep 2020 08:14:40 -0000
Date: Wed, 23 Sep 2020 10:14:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: madvenka@linux.microsoft.com
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org, luto@kernel.org, David.Laight@ACULAB.COM,
	fweimer@redhat.com, mark.rutland@arm.com, mic@digikod.net
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923081426.GA30279@amd>
References: <210d7cd762d5307c2aa1676705b392bd445f1baa>
 <20200922215326.4603-1-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <20200922215326.4603-1-madvenka@linux.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Introduction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> Dynamic code is used in many different user applications. Dynamic code is
> often generated at runtime. Dynamic code can also just be a pre-defined
> sequence of machine instructions in a data buffer. Examples of dynamic
> code are trampolines, JIT code, DBT code, etc.
>=20
> Dynamic code is placed either in a data page or in a stack page. In order
> to execute dynamic code, the page it resides in needs to be mapped with
> execute permissions. Writable pages with execute permissions provide an
> attack surface for hackers. Attackers can use this to inject malicious
> code, modify existing code or do other harm.
>=20
> To mitigate this, LSMs such as SELinux implement W^X. That is, they may n=
ot
> allow pages to have both write and execute permissions. This prevents
> dynamic code from executing and blocks applications that use it. To allow
> genuine applications to run, exceptions have to be made for them (by sett=
ing
> execmem, etc) which opens the door to security issues.
>=20
> The W^X implementation today is not complete. There exist many user level
> tricks that can be used to load and execute dynamic code. E.g.,
>=20
> - Load the code into a file and map the file with R-X.
>=20
> - Load the code in an RW- page. Change the permissions to R--. Then,
>   change the permissions to R-X.
>=20
> - Load the code in an RW- page. Remap the page with R-X to get a separate
>   mapping to the same underlying physical page.
>=20
> IMO, these are all security holes as an attacker can exploit them to inje=
ct
> his own code.

IMO, you are smoking crack^H^H very seriously misunderstanding what
W^X is supposed to protect from.

W^X is not supposed to protect you from attackers that can already do
system calls. So loading code into a file then mapping the file as R-X
is in no way security hole in W^X.

If you want to provide protection from attackers that _can_ do system
calls, fine, but please don't talk about W^X and please specify what
types of attacks you want to prevent and why that's good thing.

Hint: attacker that can "Load the code into a file and map the file
with R-X." can probably also load the code into /foo and
os.system("/usr/bin/python /foo").

This is not first crazy patch from your company. Perhaps you should
have a person with strong Unix/Linux experience performing "straight
face test" on outgoing patches?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9rA+IACgkQMOfwapXb+vLeswCgxLsVovoEu7Zr4CWuzSbUatKX
B5wAnRA2x52GHgeeAkFmdWf8Tz3etxRA
=lIi4
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
