Return-Path: <SRS0=9S14=YX=lists.openwall.com=kernel-hardening-return-17163-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C14CA9EAF
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:32:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AFEE32054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:32:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="Tww42pkW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gG69+En0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFEE32054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17163-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32763 invoked by uid 550); 30 Oct 2019 07:32:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32680 invoked from network); 30 Oct 2019 07:32:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=dc5AVIQHNoFf/
	A7cIAbY87X8bxKg7zfElk6aDCs1HSg=; b=Tww42pkWm30LkhW5jHkFBwOEvZBDD
	b81996v6Bs0M+S2po+hTsjVJitX0ylEzGJ2ApHFfvdOQsiEx+WwL0LFschtGoiff
	3rGhnffxxUnYw0GkopYB6Yd35uOBV0UstdZ79BVlLvC1RpgFp+uPJQYuC2dstFb5
	n41XF4IAfOMDUpC/+iva6Pl2B5CEPVNzUcxlcpBPDpC9BGb6jtPHdk3ZgGBDMHJ9
	uqeu20jo5U+gg9rWDaJ0LvOOuRauc3TgHBQiNONOylC/kQ30Qu2qeJP5Oh5Nw3dD
	aCK0ZZARRuwAiXVIGn81e8Yj0X4+hUR31k1cObD9kMsElfFkUGJQuFrEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=dc5AVIQHNoFf/A7cIAbY87X8bxKg7zfElk6aDCs1HSg=; b=gG69+En0
	okZ1PKBi1VWrL7NU7JrkDF7mBCANG6r3qsetj5yGE7UpamgxGLs5WbPJgagnTU9f
	fjbwdLrlZulK1woLQYcbTtptIxwTn9WDYWhN+Q/62DWoLxiLWBWJVXmMMWFj1Pc0
	xPIFePoimmNMzB6nd+0PrQi986DmG9Vpbyh7kE1/qPEebN12+CJTU6zmgX0oyiNw
	XbL+sOfZ/NqLSb1z1RXZ9rMyx7DRSYpgSJc5rGnkyTtxQ7EdkBA4fLG2SCljuUAK
	T1oW5X7/dicWAAm1mJfwtiUjES/2Ik8rwqSUzjzTkJW0zVWTas/YAQpLi47BnHil
	k3iXpM8mXSuvOg==
X-ME-Sender: <xms:ZTy5XSYw1sMLV4Z6Vs-lRh5TEGcyIEsf2uT4grtZd38Xuk7zcoDVLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtvddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhr
    rhgvhicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrd
    ekvddruddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghl
    lhdrtggtnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:ZTy5Xb_kxM54wP237-CDUBgXzbAfpsZ2zGOwVJEUmB3_BxX0ek4YMA>
    <xmx:ZTy5XaIr9uK-UsCv32IG2e9QlZNVDWBCDCrsbjAu11QxUeEJOvYd5A>
    <xmx:ZTy5XWsBkZBXSoPTGfimDruj7Qrl6uut8fqk-Im6VVAeMvqTrzfYyw>
    <xmx:ZTy5XeVgVHnM2x95_YfDyC1JY2ZcpG3krvZczEVdDIzd29l-A0Tfdg>
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
Subject: [PATCH v5 5/5] powerpc/configs: Enable STRICT_MODULE_RWX in skiroot_defconfig
Date: Wed, 30 Oct 2019 18:31:11 +1100
Message-Id: <20191030073111.140493-6-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030073111.140493-1-ruscur@russell.cc>
References: <20191030073111.140493-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

skiroot_defconfig is the only powerpc defconfig with STRICT_KERNEL_RWX
enabled, and if you want memory protection for kernel text you'd want it
for modules too, so enable STRICT_MODULE_RWX there.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/configs/skiroot_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/skiroot_defconfig b/arch/powerpc/configs/skiroot_defconfig
index 1253482a67c0..719d899081b3 100644
--- a/arch/powerpc/configs/skiroot_defconfig
+++ b/arch/powerpc/configs/skiroot_defconfig
@@ -31,6 +31,7 @@ CONFIG_PERF_EVENTS=y
 CONFIG_SLAB_FREELIST_HARDENED=y
 CONFIG_JUMP_LABEL=y
 CONFIG_STRICT_KERNEL_RWX=y
+CONFIG_STRICT_MODULE_RWX=y
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_SIG=y
-- 
2.23.0

