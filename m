Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 07386606A326
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2026 22:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kjb.biglobe.ne.jp header.i=@kjb.biglobe.ne.jp header.a=rsa-sha256 header.s=default-1th84yt82rvi header.b=RRu29A3B
Received: (qmail 1983 invoked by uid 550); 6 Nov 2026 22:33:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1920 invoked from network); 6 Nov 2026 22:33:49 -0000
Message-ID: <5839c90b7f964332482bcaf7eb5e9b77045c7d32.camel@kjb.biglobe.ne.jp>
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
From: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
To: Boris Lukashev <blukashev@sempervictus.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
 kernel-hardening@lists.openwall.com,  mic@digikod.net, paul@paul-moore.com
Date: Sat, 07 Nov 2026 07:33:38 +0900
In-Reply-To: <CAFUG7CciO_ZUMdjcOCfOtoi+YEni2+a-9QkcsCj1nox0NqHj0A@mail.gmail.com>
References: 
	<ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
	 <2026110611-tassel-bubble-dc09@gregkh>
	 <1cd0f5e304584ab9d0a595a5d35b5649dc232fb2.camel@kjb.biglobe.ne.jp>
	 <CAFUG7CciO_ZUMdjcOCfOtoi+YEni2+a-9QkcsCj1nox0NqHj0A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Biglobe-Sender: s-nakashima@kjb.biglobe.ne.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kjb.biglobe.ne.jp; s=default-1th84yt82rvi; t=1794004419;
 bh=UFaG6a16lWA5Bf4YPVTx3v3cnh0d1CMzcUI3mz/PL4M=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References;
 b=RRu29A3Bgpe6owZerowP6jKtCD04TkI6KL5MI3rUe90tFljhDK0bXmsJeONIsGow/VtYV3Qw
 hQbEbeo1vb8vo44G4faMqCfcJFSUuesE3P137H6ezwQKjDrwIWGA1gw/ITrmyecjzWvvvehXBf
 QgFX9s9/JmPX5S5CW0Ti2LidjRt7qPsYIJXGcPpITjE+MebCQjBEWEp6K9gy+7TKipC46Sa+g0
 yhmDJOAXzKz65O6SqjQzspyx5D/DuzTlFfPDtuj4GF6APIAOttHJ9dB8B2pUXrW+E3vX9rF9l2
 DdRoGeCUOGTmEcBMMgc7ZfGpiuBtFNS8HYZSZVYBNl33fntQ==
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


> @Nakashima Seiichi: To be fair it's actually "pick a better kernel"
> such as
> one with a security model starting at the execution and MMU layers
> since
> the fundamental problem with doing this at higher-levels comes down
> to
> mutable, type-confused, and improperly accessible memory (on-stack or
> via
> alloc) atop which the rest of what you describe has to be built.
> Castles
> built on sand with the added twist of ML tech adding grandfather
> worms
> straight from Dune.
>=20
> @Greg KH:=C2=A0 there is no practical choice for using anything but what'=
s
> prescribed by the vendor and contractually supported in the
> commercial
> world (further complicated by binary blobs/device trees/intellectual
> property concerns/etc). You cant ask the hotel to change the kiosk
> distribution to a safer one in order to check you in despite them
> having
> your PII and payment data running through it any more than the rest
> of us
> despite your undeniable awareness of the threat involved. It would be
> far
> more realistic and practical for the Linux Foundation to assign its
> seasoned talent to work on downstream distributions of economic
> relevance
> to its member entities than to swap out the OS' in the clustered
> engine of
> today's economy.
>=20
> -Boris
>=20

Thank you, Greg KH and Boris Lukashev, for your comments.

I am aware of options such as using the latest kernel or employing
tools like LivePatch. I also understand that programs execute in memory
and that those memory regions can be configured for various purposes.

In our actual production environment, we have a large number of virtual
machines running across many physical hosts, with numerous individual
applications operating on top of them. Simply applying kernel patches
in such an environment is a major undertaking.

My approach is straightforward: we handle network security using `ufw`
and web application security via a WAF. It occurred to me that if we
could use a "KAF" (Kernel API Firewall), we might be able to manage the
process of addressing and applying fixes in a more planned and
systematic way.

That said, I am not sure how difficult it would be to actually
implement such a KAF. I shared this idea simply because I thought it
could be a valuable solution if it were feasible.That is all.
