Return-Path: <SRS0=BGDg=EK=lists.openwall.com=kernel-hardening-return-20362-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248D4C2D0A3
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 18:54:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D711B20780
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 18:54:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lTD+MMdV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D711B20780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20362-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30013 invoked by uid 550); 4 Nov 2020 18:54:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29993 invoked from network); 4 Nov 2020 18:54:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604516033;
	bh=zuZ9nX+TBMLiNsLth8Qt6qG5oSOCogTVAFskRJa3Fq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lTD+MMdV25P8blNmKc6P3Cd5Bs1R5CqdU2Vm79mlWiElma0Hn5+xzVhkDN/QDZUQJ
	 31uJomNLQrXbBlAIwcQ2NzRSVJYwn3USfQUI4FRxHuMNGrcXf9XWInJx0zgrwHac0Y
	 VcpFOO0utlogr33cg0o9ogQTL8X3OvJqAoTQqqbQ=
Date: Wed, 4 Nov 2020 18:53:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Jeremy Linton <jeremy.linton@arm.com>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
	Florian Weimer <fweimer@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Topi Miettinen <toiwoton@gmail.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
Message-ID: <20201104185342.GC4812@sirena.org.uk>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <8c99cc8e-41af-d066-b786-53ac13c2af8a@arm.com>
 <20201104105058.GA4812@sirena.org.uk>
 <8c2d08a7-5595-6221-8da8-a7cbf6e1d493@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="raC6veAxrt5nqIoY"
Content-Disposition: inline
In-Reply-To: <8c2d08a7-5595-6221-8da8-a7cbf6e1d493@arm.com>
X-Cookie: Take your Senator to lunch this week.
User-Agent: Mutt/1.10.1 (2018-07-13)


--raC6veAxrt5nqIoY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 04, 2020 at 12:47:09PM -0600, Jeremy Linton wrote:
> On 11/4/20 4:50 AM, Mark Brown wrote:

> > The effect on pre-BTI hardware is an issue, another option would be for
> > systemd to disable this seccomp usage but only after checking for BTI
> > support in the system rather than just doing so purely based on the
> > architecture.

> That works, but your also losing seccomp in the case where the machine is
> BTI capable, but the service isn't. So it should really be checking the elf
> notes, but at that point you might just as well patch glibc.

True, I guess I was assuming that a BTI rebuild is done at the distro
level but of course even if that's the case a system could have third
party binaries so you can't just assume that the world is BTI.

--raC6veAxrt5nqIoY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+i+LUACgkQJNaLcl1U
h9A1Iwf/cR6PzznOo3yZ6VYIwt3XAnwwNPCTfUHvvCc5m541wZZ1dRd5t2wsM3u+
NTbi0wBtAEjaAZLiiaTBrtUA9sCoF9HVYCQfYGmOm9sLVeFhF+wOZzO14n2FN2k7
TqxAARgrtfqs52IcLA4XNvujSzWKCavgE1zmr4kOwoE0RogpLifIeP3N3cC4hIQb
os0ORrgCuApTIq4Lj/5pG3fBvrFqkmFNP+TrRJJGGHlJr21GiIPOcpUrUPinNmbI
nx/DzPu7BHQOtaSdQc0Y9m0g9GFHJPKjQsFmGoRTPDCsyfq3T6N12EuD/pZrDjxt
0HmmLxaatYwoT9tClHb/rLm6fgLx9Q==
=hict
-----END PGP SIGNATURE-----

--raC6veAxrt5nqIoY--
