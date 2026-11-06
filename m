Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id C8828606A326
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2026 19:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kjb.biglobe.ne.jp header.i=@kjb.biglobe.ne.jp header.a=rsa-sha256 header.s=default-1th84yt82rvi header.b=It5B+Ej5
Received: (qmail 31807 invoked by uid 550); 6 Nov 2026 19:07:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30692 invoked from network); 6 Nov 2026 19:07:49 -0000
Message-ID: <1cd0f5e304584ab9d0a595a5d35b5649dc232fb2.camel@kjb.biglobe.ne.jp>
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
From: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, mic@digikod.net, paul@paul-moore.com
Date: Sat, 07 Nov 2026 04:07:38 +0900
In-Reply-To: <2026110611-tassel-bubble-dc09@gregkh>
References: 
	<ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
	 <2026110611-tassel-bubble-dc09@gregkh>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Biglobe-Sender: s-nakashima@kjb.biglobe.ne.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kjb.biglobe.ne.jp; s=default-1th84yt82rvi; t=1793992058;
 bh=1CYCoj1Kk4xsX9uNWw/TUFDUQHwWnbkkNu7XQq3SYIg=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References;
 b=It5B+Ej5DAvOI/WIunYy7yAy0JtJFXAmIFYkV+dU76aObsviizjicBXLAywnx1gwCq3sDUqu
 +bsg0zoFnuZr/TJ2K9NjEcJA8Bt1mG2kdSNwDPHuNParBRSidr7F7QZklqDnsYIBWPji8X85ho
 c01lVh2Y9SBXwtP1xljM6xNa9v0rcMbXf3bKclYQ37Z57uM2Av1kYmpc0W4l2MoqAwzkGN6+lt
 zB+LN131ls2+8oZMw/hHNRbMrAtcUHjuK3XeYGUbOTMVtuiG7kvQVuy4Id3f8dMfASMDyz6U0a
 YExyVwujRy1LnmJSVtGL8EUp0uLev+hrIp/0RI445If8ldvA==
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


>=20
> Pick a better distro.=C2=A0 Seriously, if the distro you are paying for
> isn't
> keeping it up to date and secure, what are you paying them for?=C2=A0
> Seems
> like an odd choice to stick with them given you have a contract
> saying
> they need to abide by it...
>=20
> good luck!
>=20
> greg k-h


Thank you for your comment. Given the high volume of vulnerability-
related issues lately, I simply shared some ideas in the hope that they
might help with improvements.
