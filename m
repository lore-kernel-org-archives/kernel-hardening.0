Return-Path: <SRS0=UPTa=DB=lists.openwall.com=kernel-hardening-return-20005-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F552C4363D
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Sep 2020 22:06:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A7D98208E4
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Sep 2020 22:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7D98208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20005-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9866 invoked by uid 550); 24 Sep 2020 22:05:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9842 invoked from network); 24 Sep 2020 22:05:55 -0000
Date: Fri, 25 Sep 2020 00:05:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org, luto@kernel.org, David.Laight@ACULAB.COM,
	fweimer@redhat.com, mark.rutland@arm.com
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200924220540.GA13185@amd>
References: <210d7cd762d5307c2aa1676705b392bd445f1baa>
 <20200922215326.4603-1-madvenka@linux.microsoft.com>
 <20200923084232.GB30279@amd>
 <34257bc9-173d-8ef9-0c97-fb6bd0f69ecb@linux.microsoft.com>
 <20200923205156.GA12034@duo.ucw.cz>
 <c5ddf0c2-962a-f93a-e666-1c6f64482d97@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <c5ddf0c2-962a-f93a-e666-1c6f64482d97@digikod.net>
User-Agent: Mutt/1.5.23 (2014-03-12)


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>> I believe you should simply delete confusing "introduction" and
> >>> provide details of super-secure system where your patches would be
> >>> useful, instead.
> >>
> >> This RFC talks about converting dynamic code (which cannot be authenti=
cated)
> >> to static code that can be authenticated using signature verification.=
 That
> >> is the scope of this RFC.
> >>
> >> If I have not been clear before, by dynamic code, I mean machine code =
that is
> >> dynamic in nature. Scripts are beyond the scope of this RFC.
> >>
> >> Also, malware compiled from sources is not dynamic code. That is ortho=
gonal
> >> to this RFC. If such malware has a valid signature that the kernel per=
mits its
> >> execution, we have a systemic problem.
> >>
> >> I am not saying that script authentication or compiled malware are not=
 problems.
> >> I am just saying that this RFC is not trying to solve all of the secur=
ity problems.
> >> It is trying to define one way to convert dynamic code to static code =
to address
> >> one class of problems.
> >=20
> > Well, you don't have to solve all problems at once.
> >=20
> > But solutions have to exist, and AFAIK in this case they don't. You
> > are armoring doors, but ignoring open windows.
>=20
> FYI, script execution is being addressed (for the kernel part) by this
> patch series:
> https://lore.kernel.org/lkml/20200924153228.387737-1-mic@digikod.net/

Ok.

> > Or very probably you are thinking about something different than
> > normal desktop distros (Debian 10). Because on my systems, I have
> > python, gdb and gcc...
>=20
> It doesn't make sense for a tailored security system to leave all these
> tools available to an attacker.

And it also does not make sense to use "trampoline file descriptor" on
generic system... while W^X should make sense there.

> > It would be nice to specify what other pieces need to be present for
> > this to make sense -- because it makes no sense on Debian 10.
>=20
> Not all kernel features make sense for a generic/undefined usage,
> especially specific security mechanisms (e.g. SELinux, Smack, Tomoyo,
> SafeSetID, LoadPin, IMA, IPE, secure/trusted boot, lockdown, etc.), but
> they can still be definitely useful.

Yep... so... I'd expect something like... "so you have single-purpose
system with all script interpreters removed, IMA hashing all the files
to make sure they are not modified, and W^X enabled. Attacker can
still execute code after buffer overflow by .... and trapoline file
descriptor addrsses that"... so that people running generic systems
can stop reading after first sentence.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9tGDQACgkQMOfwapXb+vJJrACguUwBUXADnMj7K1we9pMBCXao
yuMAoLYUAsqVN8r3PK8Ax9IBA9TWFYbf
=yH8g
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
