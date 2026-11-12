Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id E1812606A31C
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Nov 2026 19:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kjb.biglobe.ne.jp header.i=@kjb.biglobe.ne.jp header.a=rsa-sha256 header.s=default-1th84yt82rvi header.b=Lp7MPjuI
Received: (qmail 5780 invoked by uid 550); 12 Nov 2026 19:20:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5703 invoked from network); 12 Nov 2026 19:20:18 -0000
Message-ID: <1e18c29fe7f9605b399c542ddd9c2de3142c1dd2.camel@kjb.biglobe.ne.jp>
Subject: Re: [RFC][IDEA] External Monitoring of Kernel Network Stack via BPF
 kprobe (KAF v2/v3 withdrawn)
From: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
To: Marian Marinov <hackman@yuhu.biz>, kernel-hardening@lists.openwall.com, 
	linux-security-module@lists.linux.dev
Cc: keescook@chromium.org, paul@paul-moore.com, mic@digikod.net
Date: Fri, 13 Nov 2026 04:20:07 +0900
In-Reply-To: <8bcf9e92773fc1b5b4350bdb49e2bc60@yuhu.biz>
References: 
	<354cfbd5cfa9f1728a19acf33bd6d7409eb60059.camel@kjb.biglobe.ne.jp>
	 <8bcf9e92773fc1b5b4350bdb49e2bc60@yuhu.biz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Biglobe-Sender: s-nakashima@kjb.biglobe.ne.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kjb.biglobe.ne.jp; s=default-1th84yt82rvi; t=1794511207;
 bh=53T7bMZU++GThMVlggog6bVf8VGogNKzmM2SDePoPj4=;
 h=Subject:From:To:Cc:Date:In-Reply-To:References;
 b=Lp7MPjuIwhPBUavjrrvavsOsIyHRu9UOltkD8o9S3bOcg4oIVO7luMxG8hnsZDD5smIVDZ23
 9b9AewKxsJf6BdKYGDyqnTBJsrQDN41sgBb3w+WaDloFIDfx041WpPaJdsixzmBW652Gncx8J2
 Zj3+YUZAApDQnz1PqshxwjyHfVmhL7YjAABmv8k3DbvRebM9Nyfe+uQKx/2itjM+sGoudHU/kE
 tUiJUEqK93TSf908irhLSe0dihSah0uFSe5LPbbqsSRYWb0HL3Bac9o4GbGL9tczTt2U5vVV9J
 AH61ox4jO8Ung9SbNnMGJ/5cxxvZp3fe0VJGsqoRlGpT2ycg==
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Dear Marian

Thank you for your comment.

I apologize for taking up your valuable time. I will end it here.

I had hoped that if we could stop the threat somewhere,=20
various burdens would be reduced,=20
but I have realized that this is difficult to achieve.

I learned a lot, thank you.

Nakashima Seiichi

> Do you realize how slow this would be in a hot path in the kernel?
>=20
> Please think this through. A network path on a 10G interface might
> process millions of packets per second.
> Implementing what you want will kill the performance. Performance
> that is tightly optimized around CPU cache lines.
> What you are proposing will introduce slowness and change of cache
> coherency that will have a heavy hit on performance.=20
>=20
> I think that we should allow the sysadmins to decide if they want to
> reduce their system performance for this kind of security measure. We
> already suffer some performance hit because of CPU mitigations and
> there is nothing the kernel can do about it.=20
>=20
> Additionally, most of the serious attack vectors would require
> multiple things in the kernel to be monitored.=20
> We also know that slowing down some parts of the kernel might open
> other parts of it to race condition attacks.=20
>=20
> Maybe we should focus more on educating people on how to handle these
> types of attacks with the tools we have at our disposal at the
> moment.
>=20
> I really hope that this path you took, thought you more about how the
> kernel and its security works, so you can enhance your idea(s) in the
> future.
>=20
> I would also suggest that you look at building this out-of-tree and
> getting some of your friends on board. Obviously you are doing a lot
> of work with an LLM. Force it to build the PoC for you. Show this as
> a viable option.=20
>=20
> At the moment, personally, I think this proposal is just loosing the
> valuable time of the people in these mailing lists.=20
>=20
> Marian
>=20

