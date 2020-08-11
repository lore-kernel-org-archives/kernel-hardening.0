Return-Path: <SRS0=4SXx=BV=lists.openwall.com=kernel-hardening-return-19593-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2369C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 13:08:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 242412076C
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 13:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 242412076C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19593-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19774 invoked by uid 550); 11 Aug 2020 13:08:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19754 invoked from network); 11 Aug 2020 13:08:50 -0000
Date: Tue, 11 Aug 2020 15:08:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200811130837.hi6wllv6g67j5wds@duo.ucw.cz>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200731180955.GC67415@C02TD0UTHF1T.local>
 <6236adf7-4bed-534e-0956-fddab4fd96b6@linux.microsoft.com>
 <20200804143018.GB7440@C02TD0UTHF1T.local>
 <b3368692-afe6-89b5-d634-12f4f0a601f8@linux.microsoft.com>
 <20200808221748.GA1020@bug>
 <6cca8eac-f767-b891-dc92-eaa7504a0e8b@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yvr4rtdsyfwruwtq"
Content-Disposition: inline
In-Reply-To: <6cca8eac-f767-b891-dc92-eaa7504a0e8b@linux.microsoft.com>
User-Agent: NeoMutt/20180716


--yvr4rtdsyfwruwtq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> Thanks for the lively discussion. I have tried to answer some of the
> >> comments below.
> >=20
> >>> There are options today, e.g.
> >>>
> >>> a) If the restriction is only per-alias, you can have distinct aliases
> >>>    where one is writable and another is executable, and you can make =
it
> >>>    hard to find the relationship between the two.
> >>>
> >>> b) If the restriction is only temporal, you can write instructions in=
to
> >>>    an RW- buffer, transition the buffer to R--, verify the buffer
> >>>    contents, then transition it to --X.
> >>>
> >>> c) You can have two processes A and B where A generates instrucitons =
into
> >>>    a buffer that (only) B can execute (where B may be restricted from
> >>>    making syscalls like write, mprotect, etc).
> >>
> >> The general principle of the mitigation is W^X. I would argue that
> >> the above options are violations of the W^X principle. If they are
> >> allowed today, they must be fixed. And they will be. So, we cannot
> >> rely on them.
> >=20
> > Would you mind describing your threat model?
> >=20
> > Because I believe you are using model different from everyone else.
> >=20
> > In particular, I don't believe b) is a problem or should be fixed.
>=20
> It is a problem because a kernel that implements W^X properly
> will not allow it. It has no idea what has been done in userland.
> It has no idea that the user has checked and verified the buffer
> contents after transitioning the page to R--.

No, it is not a problem. W^X is designed to protect from attackers
doing buffer overflows, not attackers doing arbitrary syscalls.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--yvr4rtdsyfwruwtq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXzKYVQAKCRAw5/Bqldv6
8ukgAJ9NvrVhKohEnNz0+UYVlo/02QCYaACgiTn7V4hdsKUqG2xCfqc/g1HOnV4=
=VFJ2
-----END PGP SIGNATURE-----

--yvr4rtdsyfwruwtq--
