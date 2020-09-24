Return-Path: <SRS0=jBiG=DB=lists.openwall.com=kernel-hardening-return-20006-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4823C4363D
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Sep 2020 22:14:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1B82A23A1D
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Sep 2020 22:14:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B82A23A1D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ucw.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20006-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28166 invoked by uid 550); 24 Sep 2020 22:13:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28146 invoked from network); 24 Sep 2020 22:13:55 -0000
Date: Fri, 25 Sep 2020 00:13:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>,
	Florian Weimer <fw@deneb.enyo.de>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org, libffi-discuss@sourceware.org, luto@kernel.org,
	David.Laight@ACULAB.COM, mark.rutland@arm.com, mic@digikod.net
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200924221342.GB13185@amd>
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
 <20200923014616.GA1216401@rani.riverdale.lan>
 <20200923091125.GB1240819@rani.riverdale.lan>
 <a742b9cd-4ffb-60e0-63b8-894800009700@linux.microsoft.com>
 <20200923195147.GA1358246@rani.riverdale.lan>
 <2ed2becd-49b5-7e76-9836-6a43707f539f@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nVMJ2NtxeReIH9PS"
Content-Disposition: inline
In-Reply-To: <2ed2becd-49b5-7e76-9836-6a43707f539f@linux.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)


--nVMJ2NtxeReIH9PS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> PC-relative data referencing
> ----------------------------
>=20
> I agree that the current PC value can be loaded in a GPR using the trick
> of call, pop on i386.
>=20
> Perhaps, on other architectures, we can do similar things. For instance,
> in architectures that load the return address in a designated register
> instead of pushing it on the stack, the trampoline could call a leaf func=
tion
> that moves the value of that register into data_reg so that at the locati=
on
> after the call instruction, the current PC is already loaded in data_reg.
> SPARC is one example I can think of.
>=20
> My take is - if the ISA supports PC-relative data referencing explicitly =
(like
> X64 or ARM64), then we can use it. Or, if the ABI specification documents=
 an
> approved way to load the PC into a GPR, we can use it.
>=20
> Otherwise, using an ABI quirk or a calling convention side effect to load=
 the
> PC into a GPR is, IMO, non-standard or non-compliant or non-approved or
> whatever you want to call it. I would be conservative and not use

ISAs are very well defined, and basically not changing. If you want to
argue we should not use something, you should have very clear picture
_why_ it is bad. "Non-standard or non-approved or whatever" just does
not cut it.

And yes, certain tricks may be seriously slow on modern CPUs, and we
might want to avoid those. But other than that... you should have
better argument than "it is non-standard".

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--nVMJ2NtxeReIH9PS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl9tGhYACgkQMOfwapXb+vJZHwCfU5jKO40qUDcezUI+s8fyyfU7
zC8An2cC26db1I80i/2GbnoRTakpnf34
=8gy5
-----END PGP SIGNATURE-----

--nVMJ2NtxeReIH9PS--
