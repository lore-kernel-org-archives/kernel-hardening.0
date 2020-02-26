Return-Path: <SRS0=giz4=4O=lists.openwall.com=kernel-hardening-return-17934-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E9CAC4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:24:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E988221556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="vVBBZCHx";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Ub7NgYU3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E988221556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17934-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25795 invoked by uid 550); 26 Feb 2020 06:24:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25758 invoked from network); 26 Feb 2020 06:24:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm1; bh=x+/2idmAuI9HRwFz8DjPzZI/Dq
	qAF8SMUv2srieGbSk=; b=vVBBZCHxYM4sCRcDSXCykaS2dYYtu4Q5Cpm7kVmuSb
	i0SF5mLZo1JskE/5n+tWykldulh8Nzy9FR0lyuYRvVvqZiysxjf2eX+0DKC+pRIe
	aahOjKF87D0uC0ZDB7rRQPWBQ+bluY/XiM9MphjN+Bb990jMzc5+3sCVqD2nRAqW
	GIv/CJou715kDuE4JbT7wSx15qIx0fQQLeNBbyN0+0ffSZKoqMOu1iahA7h0zS4q
	/vzC9WEysCT35CV5sl71X8jaYUWTz2T7RPUWEQ9DwGFI4RU6CzApjvIoGQxbD9ey
	R874x6dE5SnCjxt2wSzRht76Rs8FKS2sariBgNdlYiUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=x+/2idmAuI9HRwFz8
	DjPzZI/DqqAF8SMUv2srieGbSk=; b=Ub7NgYU3nTNpP96Wvtby+X1cv2LrC2V9E
	Kosu3BdakRynuyc5VI6vFEXeERMOYUcmkJ8jNx6gC8kAZoeQKN7VZiS0OiZ9wyxJ
	iHL5saq+3ASiKn44pHA/NQ18xaJH2J8TOj9TSNQfOFrAOIF57ymxOda+pZE1E6SF
	CvPMPoXQB9rErqJ1Its6VLZyKSrpFemsMBNBhMnu1jtOd6GY+WmJuvcky38mjNnb
	R2ZzrKlUVVmc/zIVs1hrAe6v4GB2tGLcP7UXIZsZKOmpSeG+NPtKya5qPjDUkkBx
	bg1B0PPAW+FJIvLHN5d5NFZ0/dDjCQ7lspt5il8IoKYPD7vR8TQkQ==
X-ME-Sender: <xms:Hg9WXqvkIC95Ybosj9dGeMwnFGQqK3r-GqiJEUAa36bUKc0auLk9gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdduhedmnecujfgurhephffvuf
    ffkffoggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicu
    oehruhhstghurhesrhhushhsvghllhdrtggtqeenucffohhmrghinhepohiilhgrsghsrd
    horhhgnecukfhppeduvddvrdelledrkedvrddutdenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:Hg9WXsGGvW6swRa-HcWG1CfVJactoE-WPdx70-NUweH07N6v4DcnoA>
    <xmx:Hg9WXpYg9VGDYrDqgUASzEMGVwWs8XHALRZaElVDdU7bUtWQ9cJkiA>
    <xmx:Hg9WXrU67W47NQm6MuNEBlV-VRIsdWF1R5stLZ4X9U6lGDmXgbNefg>
    <xmx:Hw9WXo73aaJAZ5x-1USBWInGNFNzdyOO4lfID_X8alR_1PBnfwc2Bg>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v4 0/8] set_memory() routines and STRICT_MODULE_RWX
Date: Wed, 26 Feb 2020 17:23:55 +1100
Message-Id: <20200226062403.63790-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 arch/powerpc/include/asm/set_memory.h  |  34 ++++++++
 arch/powerpc/kernel/kprobes.c          |  17 +++-
 arch/powerpc/mm/Makefile               |   2 +-
 arch/powerpc/mm/pageattr.c             | 112 +++++++++++++++++++++++++
 arch/powerpc/mm/pgtable_32.c           |  95 +++------------------
 arch/powerpc/mm/ptdump/ptdump.c        |  21 ++++-
 9 files changed, 197 insertions(+), 93 deletions(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

-- 
2.25.1

