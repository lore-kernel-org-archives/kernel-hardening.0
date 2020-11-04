Return-Path: <SRS0=qVV4=EK=lists.openwall.com=kernel-hardening-return-20352-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6CBDC55178
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 10:51:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6463D21734
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 10:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gnw8ix7j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6463D21734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20352-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24199 invoked by uid 550); 4 Nov 2020 10:51:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24178 invoked from network); 4 Nov 2020 10:51:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604487069;
	bh=EL3MPPblpZETCN5CGBbpdx2wNFw2ehB7q+0vul79rOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gnw8ix7jtk+FpSQ2JPIWzav2vH+eYG7WJxtrf3gv/xekAf36Ws7aUG0veeDYpGsdL
	 ZjtWjWdRkESnWPvGc+DUh/VM2bj8OT7CsSAU3S2NIC1qWVtX/2BmeZkbk7CC9Iar2b
	 vUlKB7Q91MQqaa5expOpYUMEFOz2ppmzbdDJ95Es=
Date: Wed, 4 Nov 2020 10:50:58 +0000
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
Message-ID: <20201104105058.GA4812@sirena.org.uk>
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <8c99cc8e-41af-d066-b786-53ac13c2af8a@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <8c99cc8e-41af-d066-b786-53ac13c2af8a@arm.com>
X-Cookie: Take your Senator to lunch this week.
User-Agent: Mutt/1.10.1 (2018-07-13)


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 03, 2020 at 11:41:42PM -0600, Jeremy Linton wrote:
> On 11/3/20 11:34 AM, Mark Brown wrote:

> > Given that there were still some ongoing discussions on a more robust
> > kernel interface here and there seem to be a few concerns with this
> > series should we perhaps just take a step back and disable this seccomp
> > filter in systemd on arm64, at least for the time being?  That seems
> > safer than rolling out things that set ABI quickly, a big part of the

> So, that's a bigger hammer than I think is needed and punishes !BTI
> machines. I'm going to suggest that if we need to carry a temp patch its
> more like the glibc patch I mentioned in the Fedora defect. That patch
> simply logs a message, on the mprotect failures rather than aborting. Its
> fairly non-intrusive.

> That leaves seccomp functional, and BTI generally functional except when
> seccomp is restricting it. I've also been asked that if a patch like that is
> needed, its (temporary?) merged to the glibc trunk, rather than just being
> carried by the distro's.

The effect on pre-BTI hardware is an issue, another option would be for
systemd to disable this seccomp usage but only after checking for BTI
support in the system rather than just doing so purely based on the
architecture.

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+ih5EACgkQJNaLcl1U
h9Dcpwf/XdKNaAx2fhe7pT7ULDO3eS7hkZsOWJAp/10DTzy4okkGEczgGoT+sN0F
5SY0u/yy8VpiUyQbxawQcWMFX4F8mwiNq6SH4GOFGL+zE4BbLUWULZsszOc2d4oQ
MmtZZPIE/+e8dNjvfe/rV+BEcKV4vTgVYHm/khWphDNYFymbinSrEkkCaTltcjdT
zr85iYltlC5uVO+WxbNhSc4rXx63oWZV3XCpUpwHf6go8ke0LrWqVH7XbZzXqrDC
h/c/vVfMESWXbxtPO46wo1g+KP+cL1ySrz2jK5LswI2aBDCyL3dWJSDaMeM7puX6
K37KSG088x6Vh/z2Qv2bjUci04ePeA==
=ta+U
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
