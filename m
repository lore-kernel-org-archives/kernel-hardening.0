Return-Path: <SRS0=qvyR=4O=lists.openwall.com=kernel-hardening-return-17944-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5913BC4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:36:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AA14B21556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:36:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="QB3lHwMo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="O4/p3ZJv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA14B21556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17944-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13517 invoked by uid 550); 26 Feb 2020 06:36:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13482 invoked from network); 26 Feb 2020 06:36:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm1; bh=xzPxK0T3LkI6AKlfQxuJpPd2C1
	+xMqQduZDssjupEwU=; b=QB3lHwMoFrMTwCghDNWOiSxy2EErGseqg/TawWgLL/
	CmgWAj7Dq0dNddaHBCPXjD69LEOLV7nMa97QhYBdjBA8zGXO0ozC2izszq2jj42m
	mBBrHd0OROYbjFKjAIlIzc6xiawriOTP0HBFugkgSFrlQuxFsIuLAirOVrGyBwgZ
	vWO5L7+T2LRmJMIuE58XBv9bKBHSZ4wwFBRJU1TJaGpy6/4IG7c5GAjGO5DdxjJJ
	XMCS7iTCTY2zvROxQSV/PtIiCcOlad5r13j3EVJ2xPuaolJ/XShJjBJHoQ+T+dCj
	iUNw0kDVMC435P01rfRCuRyGGBGQPvwpUfMzZ+Gh9a7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xzPxK0T3LkI6AKlfQ
	xuJpPd2C1+xMqQduZDssjupEwU=; b=O4/p3ZJvPHU2wN2WkpCFFxVgXlb5y7zN1
	S4fob/M5jVJbSM63v82LuesIkd809mq/nhk1qddMxU5s1ue/PuMvZV+iT1uusdwb
	eDj16F0M9uM+GRHnqa6CAF7BV0EM7ZCMadBbKUx3nBe+WQxOzPuEU21+V+OfBjYu
	MMkXMxODChCsUXnxPlVqN5OZWQOcSm/UzMV1sTZA+3huyj3b6Uk0BygbS+dbemyv
	T3czXUb7XtOv6mHRtgtKxs/ymizI49FCP/A8S9n2djbcmUdf2jrp47hL78xtpTBf
	+uXAXJEQFJZ2EQ2+gQEL47ssz5b+tUB7werucUfi7bKO6j5o/E0Cw==
X-ME-Sender: <xms:2hFWXjwZ8PsF3RYZBr82cl83KP4hW5hPWuv7R-MmO22VKlwplbOVqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdduhedmnecujfgurhephffvuf
    ffkffoggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicu
    oehruhhstghurhesrhhushhsvghllhdrtggtqeenucffohhmrghinhepohiilhgrsghsrd
    horhhgnecukfhppeduvddvrdelledrkedvrddutdenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:2hFWXgzG1ZG8GHOfcB1lBAZSUHJbv4kHMPzvGwP2MH07QsOIyRwc4Q>
    <xmx:2hFWXlqyHoV86kVxbDL8IPAjkuZo58yyNQyWbS7_Im2WUFthohiKaA>
    <xmx:2hFWXrmL_VTKqcDgkIBHo6cCG47ZY5-jyr1BvtTpt8G_PAiMWjw8kw>
    <xmx:2xFWXg762S7bax3C8pnNjvrEFv6QMzTxraRC9dRSNsZKLrVSOmF6qg>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: jniethe5@gmail.com,
	Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v5 0/8] set_memory() routines and STRICT_MODULE_RWX
Date: Wed, 26 Feb 2020 17:35:43 +1100
Message-Id: <20200226063551.65363-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Repost from v4 because I somehow missed half of the final patch.

Picking up from Christophe's last series, including the following changes:

- [6/8] Cast "data" to unsigned long instead of int to fix build
- [8/8] New, to fix an issue reported by Jordan Niethe

Christophe's last series is here:
https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=156428

Christophe Leroy (4):
  powerpc/mm: Implement set_memory() routines
  powerpc/kprobes: Mark newly allocated probes as RO
  powerpc/mm: implement set_memory_attr()
  powerpc/32: use set_memory_attr()

Russell Currey (4):
  powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
  powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
  powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
  powerpc/mm: Disable set_memory() routines when strict RWX isn't
    enabled

 arch/powerpc/Kconfig                   |   2 +
 arch/powerpc/Kconfig.debug             |   6 +-
 arch/powerpc/configs/skiroot_defconfig |   1 +
 arch/powerpc/include/asm/set_memory.h  |  34 +++++++
 arch/powerpc/kernel/kprobes.c          |  17 +++-
 arch/powerpc/mm/Makefile               |   2 +-
 arch/powerpc/mm/pageattr.c             | 117 +++++++++++++++++++++++++
 arch/powerpc/mm/pgtable_32.c           |  95 +++-----------------
 arch/powerpc/mm/ptdump/ptdump.c        |  21 ++++-
 9 files changed, 202 insertions(+), 93 deletions(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

-- 
2.25.1

