Return-Path: <SRS0=jGY6=YY=lists.openwall.com=kernel-hardening-return-17176-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BDECA9EC7
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 00:09:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 181F520873
	for <kernel-hardening@archiver.kernel.org>; Thu, 31 Oct 2019 00:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="AvR00X+O";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GPWL4c0s"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 181F520873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17176-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28038 invoked by uid 550); 31 Oct 2019 00:09:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28003 invoked from network); 31 Oct 2019 00:09:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:mime-version:content-transfer-encoding; s=fm3; bh=
	6Xnh4Ox3tofJQDh6J6oa86yo0sLnPm3QhRaqE4rorc0=; b=AvR00X+OMMJ6XlbU
	XKfE3k238wE/pmxoy/lGd0mVmMVftzAmAyLbiUk7ViUcqTY1r/DSclEziFOrEvNB
	Gitwk3x0EcLWezp0YHpYeRb2qgCps9xSCBG21Ixy+htasdIL2h2NM4B62p2S0chG
	8dl05/BmRbW7eVrkkxa4ZwAcIcSY2TpGxb/271ln/s2L1JaW7E0f5if4M8NL8ejY
	+xAYbmXQBJVV+Gf4nEJuCaOxRU0F3eWfFXK8+EnZt2trsZmROY3l6j/ESfWevSTj
	AGhzkv5oIEFNbyVpafnHWhz2bbXI8lvd62Bhh5ej4fv5M11dJIuZaHz03IBGTXMb
	AiHvtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; bh=6Xnh4Ox3tofJQDh6J6oa86yo0sLnPm3QhRaqE4ror
	c0=; b=GPWL4c0scAKFN9yel06oYMKw3EQUCEbnb7YRQ0bhKZljhGyjyYfXbU0C4
	wh+Uedm/ihnSJUpPJMDjld3JoRIrfD42YH1C2O8x24A3wKXPboUEg9fuXhCtJL+c
	4vMMtZMCgu/1dEffv/udNYmAs0qx3uv6WaCCvyHEJDiy/GGz0lABacXwv7uyBWjJ
	BFUI1JLNbjFMrDj1O9fylEi18VJeihVPA3U8lxOUcvWjbThV7MBA8e3N8fFF8DDD
	p6SUCUWsqawee38GjTN3fkj4bO3VggPzjlEZGjT00NGxGbKwYII0suFHk4GPUQKt
	7G1Cn796cHMyMILuilo1xKgZAjB8Q==
X-ME-Sender: <xms:Nya6XcvHg4SsU_7g3_hkh088S7Oh1yKFrXK9QoOga1tXd2pPa7Zybw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtgedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefkuffhvfffjghftggfggfgsehtkeertddt
    reejnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhush
    hsvghllhdrtggtqeenucffohhmrghinhepohiilhgrsghsrdhorhhgnecukfhppeduvddv
    rdelledrkedvrddutdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruh
    hsshgvlhhlrdgttgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:Nya6XQJF_IwkFePPnkUR1yHNikj2djemuYVAtPJckUplscaW_WsC1w>
    <xmx:Nya6XcOC7-jSwjwZdEMcIYBH4iMyyFR4WvO1TWgpfgFWz79sASlYZQ>
    <xmx:Nya6XdYtejbbSuC-0JgbbhAE3NVWwbSUP4gBfgYo8pMWYPpWfXS1xQ>
    <xmx:OSa6XbAui9qXytGS3G9Fuq0xxc7-a8LSG9c2p1eARSQu_us7x6k07g>
Message-ID: <a41b73640beafceb40ba748330958f833f4bf4e2.camel@russell.cc>
Subject: Re: [PATCH v5 0/5] Implement STRICT_MODULE_RWX for powerpc
From: Russell Currey <ruscur@russell.cc>
To: Christophe Leroy <christophe.leroy@c-s.fr>, linuxppc-dev@lists.ozlabs.org
Cc: joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net, 
	npiggin@gmail.com, kernel-hardening@lists.openwall.com
Date: Thu, 31 Oct 2019 11:09:21 +1100
In-Reply-To: <53461d29-ec0c-4401-542e-6d575545da38@c-s.fr>
References: <20191030073111.140493-1-ruscur@russell.cc>
	 <53461d29-ec0c-4401-542e-6d575545da38@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 2019-10-30 at 09:58 +0100, Christophe Leroy wrote:
> 
> Le 30/10/2019 à 08:31, Russell Currey a écrit :
> > v4 cover letter: 
> > https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198268.html
> > v3 cover letter: 
> > https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html
> > 
> > Changes since v4:
> > 	[1/5]: Addressed review comments from Michael Ellerman
> > (thanks!)
> > 	[4/5]: make ARCH_HAS_STRICT_MODULE_RWX depend on
> > 	       ARCH_HAS_STRICT_KERNEL_RWX to simplify things and avoid
> > 	       STRICT_MODULE_RWX being *on by default* in cases where
> > 	       STRICT_KERNEL_RWX is *unavailable*
> > 	[5/5]: split skiroot_defconfig changes out into its own patch
> > 
> > The whole Kconfig situation is really weird and confusing, I
> > believe the
> > correct resolution is to change arch/Kconfig but the consequences
> > are so
> > minor that I don't think it's worth it, especially given that I
> > expect
> > powerpc to have mandatory strict RWX Soon(tm).
> 
> I'm not such strict RWX can be made mandatory due to the impact it
> has 
> on some subarches:
> - On the 8xx, unless all areas are 8Mbytes aligned, there is a 
> significant overhead on TLB misses. And Aligning everthing to 8M is
> a 
> waste of RAM which is not acceptable on systems having very few RAM.
> - On hash book3s32, we are able to map the kernel BATs. With a few 
> alignment constraints, we are able to provide STRICT_KERNEL_RWX. But
> we 
> are unable to provide exec protection on page granularity. Only on 
> 256Mbytes segments. So for modules, we have to have the vmspace X. It
> is 
> also not possible to have a kernel area RO. Only user areas can be
> made RO.
> 

Yes, sorry, this was thoughtless from me, since in my mind I was just
thinking about the platforms I primarily work on (book3s64).

> Christophe
> 
> > Russell Currey (5):
> >    powerpc/mm: Implement set_memory() routines
> >    powerpc/kprobes: Mark newly allocated probes as RO
> >    powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
> >    powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
> >    powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
> > 
> >   arch/powerpc/Kconfig                   |  2 +
> >   arch/powerpc/Kconfig.debug             |  6 +-
> >   arch/powerpc/configs/skiroot_defconfig |  1 +
> >   arch/powerpc/include/asm/set_memory.h  | 32 +++++++++++
> >   arch/powerpc/kernel/kprobes.c          |  3 +
> >   arch/powerpc/mm/Makefile               |  1 +
> >   arch/powerpc/mm/pageattr.c             | 77
> > ++++++++++++++++++++++++++
> >   arch/powerpc/mm/ptdump/ptdump.c        | 21 ++++++-
> >   8 files changed, 140 insertions(+), 3 deletions(-)
> >   create mode 100644 arch/powerpc/include/asm/set_memory.h
> >   create mode 100644 arch/powerpc/mm/pageattr.c
> > 

