Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id F2667606A33C
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2026 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kjb.biglobe.ne.jp header.i=@kjb.biglobe.ne.jp header.a=rsa-sha256 header.s=default-1th84yt82rvi header.b=VELl0OFT
Received: (qmail 28467 invoked by uid 550); 6 Nov 2026 16:41:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23836 invoked from network); 6 Nov 2026 15:53:42 -0000
Message-ID: <5b6397fc76e820118f20edebe9dc454e1a8ac620.camel@kjb.biglobe.ne.jp>
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
From: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
To: Paul Moore <paul@paul-moore.com>
Cc: kernel-hardening@lists.openwall.com, keescook@kernel.org,
 mic@digikod.net,  linux-security-module@vger.kernel.org
Date: Sat, 07 Nov 2026 00:53:30 +0900
In-Reply-To: <CAHC9VhTB-obhgEM3g0VagzNaRUaF_tWTDu1FmX7SHeVU4pwfOA@mail.gmail.com>
References: 
	<ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
	 <CAHC9VhTB-obhgEM3g0VagzNaRUaF_tWTDu1FmX7SHeVU4pwfOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Biglobe-Sender: s-nakashima@kjb.biglobe.ne.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kjb.biglobe.ne.jp; s=default-1th84yt82rvi; t=1793980410;
 bh=2jHbuvgW8nH066FrG4kTNAIBlxTI2un3aWLAJ9ET1mE=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References;
 b=VELl0OFTsYtYF/egyF3+HXVNOlsjYeVmOIzOisCfJ5fpMw0CYkjTVr2a4xuulCxllgWvOf5/
 ZYCVyh7W5Aqk2T9oe/qzso3LMB6lz9QwH1gZK01ITb1HnxxL54eyBb06zlJXF1N9VLsV5h8Z4F
 BXMc3MBGpmoCMyilJ9NggxMYPwdELchbOt0OPHQkdNRKRpfkfgaF1ky2wgGzNfQXeDh6nIQJKh
 rMO6/V/XPtWMAOZYVNZ8W7u3uX45DUdQdEDuduSMhnXb5toyADkKR6Vg7NbhvA7ZLiHTc6ckuI
 7Draf3ETu+MiCULQdolTQZzbQ7R9S/0TjQIEevTwjhJyWfVA==
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


>=20
> It should be possible to do most, if not all, of these things with an
> LSM.=C2=A0 Wearing my SELinux hat, I can say that SELinux currently
> provides access controls for most of these things today.=C2=A0 I would
> expect similar capabilities with the BPF LSM, although I can't speak
> to the coverage of any specific BPF LSM tools.=C2=A0 I believe AppArmor
> and
> Smack cover some of these things, but I can't say for certain.
>=20

Thank you very much. I have a poor understanding of existing features
like SELinux and AppArmor, and I don't know how to handle them well.=C2=A0

I believe that if there is a mechanism to discard problematic APIs when
called, we can temporarily address them until the fix is complete. I
just thought it might help reduce the workload.
