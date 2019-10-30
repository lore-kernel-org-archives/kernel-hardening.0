Return-Path: <SRS0=v4MU=YX=lists.openwall.com=kernel-hardening-return-17162-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ECECA9EAF
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:32:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B8222054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="wQqtnQ5H";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TFH+9GaA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B8222054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17162-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32469 invoked by uid 550); 30 Oct 2019 07:31:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32358 invoked from network); 30 Oct 2019 07:31:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=WVehznCtMHUGH
	kkWKbgrT+yshqhj8IDof9KJa08Bq0M=; b=wQqtnQ5HYN2HhoT1Mr87LlzHxpDs7
	OMsTrzNUySexfr30//65eaX8cpiOXynT2XstIB7xpO9nDKCYhGmr4Dn20QbNrHwF
	bwOeY3brgkuk0LMOPVHmDWy+vw29Z/QqEqkIjhmEBHwKIj5kq+5emLcws1Sg+MQV
	m9b3AUY1SmWZRDPrkmHZJ6l/nXucf7c1riUjOFGSrxmjpiSNnjFpoIVgJ+hQvInW
	ks8h83RzQXMYM6bADNP5kWgntJHeVY7bjuT9Z5+ueZ7fLps/pxd6p2YXdN7DgDVn
	Ceh2utf81BEp/+TdoDIxWLBVq3lidTFgcW9ckA8zQYLrU4juPD+yJ8aQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=WVehznCtMHUGHkkWKbgrT+yshqhj8IDof9KJa08Bq0M=; b=TFH+9GaA
	0fjJovwpMWyMGSwcxoYcAkWolg1X1ViCME68QalsBhlA61Ln4C+ViZqrWDY/ojw/
	sM+Zt5IGQorEFngxAzVETzbMT976Uq4MKfJAqQ48M6WpEnv0VwHtnAVi55X1tmOA
	4mbmbUnHefBbu+akPM5BmrleJKw6sW8r3SgBpToCpBMnmxa/0CYz9JDPi1Rko5Q+
	RJCRgpcnpON1FsCp/Akomz+oA/Uf80LfdAFHRiiFaTEKbn8ENhQt+FC6Qdb3SbvU
	nQ6SmqtKNxS+vrV0pbs0LM/iXekAMHrABRayVvntgy1rlMF0CAcUIAGYvIPvNDTy
	nLlHbbkcj0CT9A==
X-ME-Sender: <xms:Yjy5XUSOURbOoxgqz9nzV3yHTBYxWD7R1_4uC-dQ_nLUOvA6kt8C6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtvddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhr
    rhgvhicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrd
    ekvddruddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghl
    lhdrtggtnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:Yjy5XcYDuDWKlDaq-lkoHIkasBC5ZlDCwiOIoYX75FinQY5X5xyVUA>
    <xmx:Yjy5XV5qqio72KccJdwCtev6sVlLqp3BYeMGy6m0VCQUDMiDiUtRRg>
    <xmx:Yjy5XdRCPs1UvZMNxNCYEYSUcq_7K_dFviKfCs_SyEXN-NgZLg571w>
    <xmx:Yjy5XfcnKqa4sGizMtQ1eUn6CbK-3xVhYQKCaAwAFdgx47LK5rCRQQ>
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
Subject: [PATCH v5 4/5] powerpc: Set ARCH_HAS_STRICT_MODULE_RWX
Date: Wed, 30 Oct 2019 18:31:10 +1100
Message-Id: <20191030073111.140493-5-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030073111.140493-1-ruscur@russell.cc>
References: <20191030073111.140493-1-ruscur@russell.cc>
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
This means that Daniel's test on book3e64 is pretty useless since we've
gone from being unable to turn it *off* to being unable to turn it *on*.

I think this is the right course of action for now.

 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8f7005f0d097..52028e27f2d3 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -135,6 +135,7 @@ config PPC
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
 	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
+	select ARCH_HAS_STRICT_MODULE_RWX	if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
 	select ARCH_HAS_UACCESS_MCSAFE		if PPC64
-- 
2.23.0

