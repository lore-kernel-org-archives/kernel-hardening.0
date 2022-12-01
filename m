Return-Path: <kernel-hardening-return-21590-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B11D9C43217
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Dec 2022 20:09:41 +0000 (UTC)
Received: (qmail 32525 invoked by uid 550); 1 Dec 2022 20:09:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32487 invoked from network); 1 Dec 2022 20:09:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1669925352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=3nMuZflHCJgjbZeRaAyuyXiAQeVA5CjS44ClyCpw2/w=;
	b=s5/qofVi31/3/5WDjM8Qau/u5B63myolBZyabcCX+W5aMh89LUzeqt51upKRqfjnnJcIXZ
	QLGlSnRkR6Tvedxc5wPmdYWUYl+SFlZR7rh8Z84xqf2WpjqxVliHAbzZYacplUPiG7OCfu
	B4J1NeLzuE0CQRAAI49jYjg8HfFcpQcmPUyMd5z3T/UkrCEawR7n3l145EMqWDaajZ7U2p
	tbeBB4c0pn8TbGZM9Xe/z3rx7Rw6IuriTn0k4G6bDrfdWQQgIkQ69OKQ/LFKLXmlhPDwAc
	3M/nrIkIk4rGuSw4Ieuzfb9VGhgwxbIrcIszM/ED/SJOjcgVit34Gx/QwMLFHA==
Date: Thu, 1 Dec 2022 21:09:04 +0100
From: Stefan Bavendiek <stefan.bavendiek@mailbox.org>
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Subject: Reducing runtime complexity
Message-ID: <Y4kJ4Hw0DVfy7S37@mailbox.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="MPVpsBocrGziZFTp"
Content-Disposition: inline
X-MBO-RS-ID: 2d2959ca247fda16885
X-MBO-RS-META: j17x8cqmw8u9reffy354333mgtww1roa


--MPVpsBocrGziZFTp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Some time ago I wrote a thesis about complexity in the Linux kernel and how to reduce it in order to limit the attack surface[1].
While the results are unlikely to bring news to the audience here, it did indicate some possible ways to avoid exposing optional kernel features when they are not needed.
The basic idea would be to either build or configure parts of the kernel after or during the installation on a specific host.

Distributions are commonly shipping the kernel as one large binary that includes support for nearly every hardware driver and optional feature, but the end user will normally use very little of this.
In comparison, a custom kernel build for a particular device and use case, would be significantly smaller. While the reduced complexity won't be directly linked with reduction in attack surface, from my understanding the difference would make a relevant impact.

The question I keep wondering about is how feasible this is for general purpose distributions to have the kernel "rebuild" in this way when it is installed on a particular machine.

- Stefan


[1] https://doi.org/10.13140/RG.2.2.29943.70561

--MPVpsBocrGziZFTp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEjLwAv8xLYF1doyZLdIuckz2DLQMFAmOJCdQACgkQdIuckz2D
LQMndA//WbwikJvResHro4tj8M59EvcRMfcgMSSGWidjb1GtxJEfH6HA1yjcDFKL
5N8S+BdLy40wUClNQ8G1I3fRDOALJAUceaJj7bhvmHqDpD9gmOgYMRDukUq2eD9w
/mdFgtYug4WAlBbrCAEI0QzjAHL2zYjYkGV45MvK1z8QGC0u8U6VolnuIJftk2pT
QiTcU4Mg7l0E68hIrbEiRb+uVJgVYf+FQ18AsBrY9Cv9m+E+KP5z9Zi6yiKZDLWt
HSm2po2NfGq65hovAS1oHEMZI8Gdmo6Fr1EE6K3QSksox0zSwmhsyGDr61qKPOWx
83UEkmsDuFbkBpgDb/PWxx1Y78b71VBMg3Nd3DfLw4bsRtkNGm7JhZtEUv3yPASO
0Dmjr0jzYsGEOHsF2pvrOeod/HiQ0/b/mPiLQb9ufG9wsqiVDU8Rydjvbgi1kMB/
kudD8Dn72LCnqrSSQX9hu54clIPZUnePdahI+zvRFYbkfKpb1fPCc2xWxBq1dcsD
VB7XVLEklaCI+rG1feKmxcnYmXezl/CsKe+6wzFxQszH/G29NOOy5R9pjvhpXiJw
T5FddGp58q1/6en4bXbsK9XyjieOjhY+qWVn69QnfQt3s2ISGipQpbKLj4CJ4TyH
yaEHmQoy4C5D2BJFg9opSONOrsA2MfPdOwrhgYaWdAPnlpZGefg=
=XKYN
-----END PGP SIGNATURE-----

--MPVpsBocrGziZFTp--
