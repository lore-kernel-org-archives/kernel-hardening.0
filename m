Return-Path: <SRS0=3emP=W2=lists.openwall.com=kernel-hardening-return-16833-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7BEEC3A5A6
	for <kernel-hardening@archiver.kernel.org>; Fri, 30 Aug 2019 03:23:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0331F21897
	for <kernel-hardening@archiver.kernel.org>; Fri, 30 Aug 2019 03:23:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="CoDhq78H";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ghxsu9D6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0331F21897
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16833-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17955 invoked by uid 550); 30 Aug 2019 03:23:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17923 invoked from network); 30 Aug 2019 03:23:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:mime-version:content-transfer-encoding; s=fm2; bh=
	s8i/QhPR38U6LZIlXMpuiFvKQllTENh2MCPCjD2IL7Q=; b=CoDhq78HHjid0ZS1
	3uPTuipmGCyFY8U5G+Ao7cRImXPf01QPSTNLoFJbumyl4e/C/WUshfyiDU1dNIqQ
	ZzU1i2LETGghdj6MAZqVzo61sIi4ajJ0WkNp/bnGqd8Ddmi2CytVz1BJanFfpd+y
	FqykdezSVLWM7j/kU3g55IhBXaQZ7kesg1oSowBBEYRsXHtwyMAEclqR+QJhYFxi
	rRBa92NoiXeXmjTIFjdJs9xeCfjaZxwn47b3iKUWvTP0x+lAgbxt/XHLRjTnjJgf
	VkN40/KytJp1YNUNrEasZzdJcBS2Rhxlfwp0tsgV/O5WVZMbZ5hELyoelXE9tCEH
	Zoz8Uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; bh=s8i/QhPR38U6LZIlXMpuiFvKQllTENh2MCPCjD2IL
	7Q=; b=Ghxsu9D6mtowIYe5xNXII1SC80RmI4QreFIHGtRI1n+rEyJowh6gDfIfA
	na/OBa6unCESw92LiOuUa8A/8bh4AzlR62xuEnpJmSoHC4QX9Ekpzk10Dip2GKLR
	mJW+Ko5YchJ1/BZyWmFVPlIze6lHmPDsMWAY5jaxluJp2/TNcN+SMp7bZE8jchAD
	EEyvDnRgeu0ZOOUa6dMOxIMmS0SjJQLlVUbfQoNjx4gmmcMEcU6XyLjTIqnP01sz
	Az+kJ7inCSP3TS63jhhnaMIX9eQl+X2FkBjF3a6JgQP+FKkHh08t9vuUe59z0jtJ
	8LESceRq2Iw3BzsiEL5guaYQ5zTdw==
X-ME-Sender: <xms:jZZoXSbzqvWiz7OZEFgfQpshmamkaNG69TQUBOlCeLSeqiwgfX4h4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeifedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlfedtmdenucfjughrpefkuffhvfffjghftggfggfgsehtjeertddt
    reejnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhush
    hsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdrtggtnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:jZZoXRuY8Ax7Kid73dWZIjfs3yyTKiaYVDppJRd3SNTGyffd1FnSPA>
    <xmx:jZZoXfsO_Fz2JzmYe1TCulG5y00EJEqQHJHAtRU5_BA9VPYBHdJz7A>
    <xmx:jZZoXWeCv14vyAeAvSiABAMDAvJnI3IYtieRl1eZszBPPnXmMOQ1yQ>
    <xmx:jZZoXTaSC2Igo86GwP56n2tkTYkLWMt5hYfGpIjYpAKWFX_-VBdYHg>
Message-ID: <14925a214dbedf78eda85bb8ccf4ae9ad9fd150d.camel@russell.cc>
Subject: Re: [PATCH v2] powerpc/mm: Implement STRICT_MODULE_RWX
From: Russell Currey <ruscur@russell.cc>
To: Christophe Leroy <christophe.leroy@c-s.fr>, linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Date: Fri, 30 Aug 2019 13:22:48 +1000
In-Reply-To: <6bf5e5e3-1dfe-05fe-d736-7c846b8ac6f6@c-s.fr>
References: <20190614055013.21014-1-ruscur@russell.cc>
	 <6bf5e5e3-1dfe-05fe-d736-7c846b8ac6f6@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2019-08-28 at 15:54 +0200, Christophe Leroy wrote:
> Any plan to getting this applied soon ?

Hey Christophe,

I'm still working on it.  Had to rework it for a few reasons, and it
exposed a bug somewhere else.  Hope to have another version out soon.

- Russell

> 
> Christophe

