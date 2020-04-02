Return-Path: <SRS0=AyjQ=5S=lists.openwall.com=kernel-hardening-return-18370-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB39EC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:32:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 454C720757
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="s8oKKLCV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="p4RRk1Kf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 454C720757
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18370-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9669 invoked by uid 550); 2 Apr 2020 12:31:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9489 invoked from network); 2 Apr 2020 12:31:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=lHgLupnwwVnW8
	9H6t1yvE2k1Yy07V091CXapypcIwwE=; b=s8oKKLCVGzv7CIWboa5qpXbnjq5mC
	+c2hxm2CrgUq2nnL0cKLlz0EOh4x/VODGJT3rwPHY2AvS2arQsssz7aeGyl/EkQB
	f+oP8nPJuzTDJVrTvg907grD8aaAA7Cu+pvSntK3FCFcJM3fDneEZRzWN5W8Lrh0
	JUAtSuTTqV1qd8pTdAxsTE/TJlFI8iy6IVrzg9EUqbjqTsf2WE6abkL6u3OPOUzx
	fCPD87TDk8fW7EGy4DlxYjHp8TlW2GAxmqAp6pTNTXu6YVSvBP91cTaSVi6RS7xY
	kDKYiTo2MhmuU12dJgn4MvJwkjgAVSRoIeRsY1d17zhoGW0W70Y5+HQ+w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=lHgLupnwwVnW89H6t1yvE2k1Yy07V091CXapypcIwwE=; b=p4RRk1Kf
	VQkgMxYgvMSxW7TUIt8RnLu9eNP1MW1TV6bOujW3KeQI/dcfEHmtPJMo8RhTZQ6J
	y7uT1DEnsFvrNn6qJQWBJdXU3w77RvpiF+i1rUI6g6xRVm3D8IZNkJ9MpYPdzb7e
	6CjyPI5IELuy4Gw4h1Hkhmld5V+xl1JZ/TzWx8wSzFNZgnSLJPb2Po63/ke0q2x2
	bqGc5hfMsCzB79XlDkmx+n3brbNRr/kC2hpFt1N+KwIYmc/joe4yYW9lvVThQMwY
	Au8yGtELY+h3O6LwgxDST4My7q6Dn6ToNceI0rZtZT5cYiytZNU95SvRPUkzE2bI
	qzmXC69RQXNcEg==
X-ME-Sender: <xms:N6WFXq0DpMVAhoRa136LkVhnHv_yPObp7aWMUBethJSaNT8aXMDCaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeggddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvuddrgeehrddvuddvrddvfeelnecuvehluhhsthgvrhfu
    ihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlh
    hlrdgttg
X-ME-Proxy: <xmx:N6WFXhX0w4xW3mLKdZSl6pSRIRRROZvqgumRHDO7_OZSfJRlY56Pdg>
    <xmx:N6WFXt63wPdG4ggakB1c7cbennjt65LJrj99-pu0T7xsH3Mni4Yv6A>
    <xmx:N6WFXgLH5rXT2O2bJnp1kwbcTLNbV0NhnEa91w21ZfPKsOTpg6Wk_A>
    <xmx:N6WFXoPmLqat3FmLp5AMg5XsMo5JK4i-pPS1BnZXNmlrPYuV2p91ww>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Joel Stanley <joel@joel.id.au>
Subject: [PATCH v8 5/7] powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
Date: Thu,  2 Apr 2020 19:40:50 +1100
Message-Id: <20200402084053.188537-5-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200402084053.188537-1-ruscur@russell.cc>
References: <20200402084053.188537-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skiroot_defconfig is the only powerpc defconfig with STRICT_KERNEL_RWX
enabled, and if you want memory protection for kernel text you'd want it
for modules too, so enable STRICT_MODULE_RWX there.

Acked-by: Joel Stanley <joel@joel.id.au>
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/configs/skiroot_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 1b6bdad36b13..66d20dbe67b7 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -51,6 +51,7 @@ CONFIG_CMDLINE="console=tty0 console=hvc0 ipr.fast_reboot=1 quiet"
 # CONFIG_PPC_MEM_KEYS is not set
 CONFIG_JUMP_LABEL=y
 CONFIG_STRICT_KERNEL_RWX=y
+CONFIG_STRICT_MODULE_RWX=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_SIG_FORCE=y
-- 
2.26.0

