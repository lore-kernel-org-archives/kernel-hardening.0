Return-Path: <SRS0=89v9=4O=lists.openwall.com=kernel-hardening-return-17948-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC1AC4BA0B
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:37:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BC1BC206E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:37:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="cLPnvYBQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TalURqec"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC1BC206E2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17948-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16063 invoked by uid 550); 26 Feb 2020 06:36:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15948 invoked from network); 26 Feb 2020 06:36:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=Z84AqZl7dQCow
	nF4r9rNWqCkiMXAjJ064l1LHKxjRLw=; b=cLPnvYBQqMLw3R/nIKxs4X0Dxb9u/
	wxDQORKzLLo49WE4d18S6N4rklknBW3cr2gnuvq/x6sELNRsczY5J70gvN4zINLw
	lLfLq7de96Lyd0NyjEnVF239zQ/2UapFsXH+vEz8lbkmzilxj93WJSbtEkt3L4yj
	8VKKrjY+qXDOTyKdDy47iX5Nry2JLM5YukiCNgRjv6vLb1p3dze5cvkQN68nKrW7
	xbrzbZBNugSH3lFHfSDmhgURtQw+Rpmuthy95UQLVfe/6Tb8YpOurrPIs3PqbB8Q
	YlZNQSjwCgfd81XdH9lMKhp0OJZawz4XscGkZO7Ro6sNUvtgqYLAmhJ7w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=Z84AqZl7dQCownF4r9rNWqCkiMXAjJ064l1LHKxjRLw=; b=TalURqec
	i6u8jSfsk43AUKcBm8OMNoaYnpSLd0bhc6hv4ax8F9Uu5sE1Vul6cP/5fRVLh/gK
	NIOcsxSJNokTJwEIIMItseOdw/H0mu7SggW1H59MJOxWZse0BV11CPUclJkkOS4x
	lwSyx12UR7m/RlsOhzBcnc/tV2xLjreYC9e25lPS3oyfFY2WizKo87/rtdtyQRCY
	wjdVdRYnOLWs7eOKY4XHtohnocoyG0YLSZF4dHbwU1+YfWtHuoFmdhrex8rIvkXT
	XfZvpAaM32pDUYU5faQhIt0+TDDNQh6FN4gEGDuyOFlJcTJTCxcg0xJ17RAcnsvJ
	v+8+pVJm7dX2HQ==
X-ME-Sender: <xms:6BFWXhYPGABShvuJYKkqaNE3TYVSiGQ30qBi-iv4ny6YOzt3MDQQeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhep
    rhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:6BFWXqSI2M6CXv89DQ2AhN4gj4Ccz_z6BbY_STTdEqrxkusSqKyHrg>
    <xmx:6BFWXpG3g72cogPureOo3xdPzSyqy6aWsNOBLWlcQoier96XQ3AGmg>
    <xmx:6BFWXv3XfklLijIkRa_w5Rz3cWQhKkGLTK30o_XQgtjP4Umx8uN8lQ>
    <xmx:6BFWXpan8UYfI3VAlyckSgukvu594-WjWubRJuu52G3LwW9vqpdLmw>
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
Subject: [PATCH v5 4/8] powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
Date: Wed, 26 Feb 2020 17:35:47 +1100
Message-Id: <20200226063551.65363-5-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226063551.65363-1-ruscur@russell.cc>
References: <20200226063551.65363-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To enable strict module RWX on powerpc, set:

    CONFIG_STRICT_MODULE_RWX=y

You should also have CONFIG_STRICT_KERNEL_RWX=y set to have any real
security benefit.

ARCH_HAS_STRICT_MODULE_RWX is set to require ARCH_HAS_STRICT_KERNEL_RWX.
This is due to a quirk in arch/Kconfig and arch/powerpc/Kconfig that
makes STRICT_MODULE_RWX *on by default* in configurations where
STRICT_KERNEL_RWX is *unavailable*.

Since this doesn't make much sense, and module RWX without kernel RWX
doesn't make much sense, having the same dependencies as kernel RWX
works around this problem.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index bd074246e34e..e1fc7fba10bf 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -131,6 +131,7 @@ config PPC
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
+	select ARCH_HAS_STRICT_MODULE_RWX	if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
-- 
2.25.1

