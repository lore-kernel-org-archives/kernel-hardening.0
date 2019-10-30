Return-Path: <SRS0=vmj6=YX=lists.openwall.com=kernel-hardening-return-17161-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7308BCA9EAF
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:32:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BBED82054F
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 07:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="lFArQLig";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RTfGwNn4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBED82054F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17161-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32110 invoked by uid 550); 30 Oct 2019 07:31:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32014 invoked from network); 30 Oct 2019 07:31:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=HYGtzzTlMcF3v
	eMN2AqVXMM15POrvmVyLU/o7hZnrc4=; b=lFArQLiguLC0Fok+qmwTKyvb8dtBh
	YEBgz8LH9y+dcyzK9DqkUO6BHsjByz7Z6eSJ7OgMM4I7SHTzm62TtE2GH+ChYtkU
	5SH+3bRkGyAd7gmxX89yCHt32YI1Eu7WfziVndA6ZW1L7bGJ4JYCRL+zffNHpSvG
	EHVUAaZdCkRHfKJKBgeRZ0cNqGYXTaF1QmYBGGQfgPN4/DspLpD4xGPURGZKEYBn
	Z4ErZGBnDJKWvH4sQ986SFbzdlzP6GR8Q+IgwTd/k+9vR3Su5tQFDwyP3e2V++p2
	lYsUan2GN7uSSpXTId//fAiS5iX7jGGX9dP+y9duKAQwj62yDFhTvvnmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=HYGtzzTlMcF3veMN2AqVXMM15POrvmVyLU/o7hZnrc4=; b=RTfGwNn4
	wj5qK3LdUONToXnvLOfnyujjyf8ksolxUKufUowgxmeEQXWHxqGMyEyGmAhISDy1
	LMtDZFiudOqrip+J8Evbx/DzuSK0pvz5EyBTCXq0U7/BBJNfQNKP1c6fCfyiSo5/
	1eqSvDjr7xBjlBeGHBppy6MX3p3IHyMCwBe+C49XMX9oeiMHyRWbakVjPY5axCkc
	yyIcWVbBP1QBSc8slJKfrjJpWT2m9uhOWuEw9Cd5RpZZbSNT7gJfRk+ypdyLoC4A
	Ub9ar+i07UGiGUF907ZU8uroeXnure1qP6Uk+GTIrsBbN5ij/C5jj0jeMxf4bWZl
	QaCBpNNZsibQ2g==
X-ME-Sender: <xms:Xjy5XWaPZjELCIbuLE5cf4VtYCfWGn2X7UVU7l6QCqJ9XD1rfvbzGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddtvddguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephf
    fvufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhr
    rhgvhicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrd
    ekvddruddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghl
    lhdrtggtnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:Xjy5XdqnrXSrzO4XkQrv36Koq4vrsknVDcnb27D0vo4fsP53wL8uqA>
    <xmx:Xjy5Xb9AYT1XAUgjtcnWGPmoRuY43yEhsM6ydQl5FAhterlt1W6acQ>
    <xmx:Xjy5Xc80p-PCNmGGN91w9oJh8fh2vr17W_zZ000mfXn9bGri-oFsMg>
    <xmx:Xzy5XcB6Ep65aGyUTXpDnYXsWPQD-A-r7DJf4or51S-kxLIOZOXWkg>
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
Subject: [PATCH v5 3/5] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
Date: Wed, 30 Oct 2019 18:31:09 +1100
Message-Id: <20191030073111.140493-4-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030073111.140493-1-ruscur@russell.cc>
References: <20191030073111.140493-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Very rudimentary, just

	echo 1 > [debugfs]/check_wx_pages

and check the kernel log.  Useful for testing strict module RWX.

Updated the Kconfig entry to reflect this.

Also fixed a typo.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/Kconfig.debug      |  6 ++++--
 arch/powerpc/mm/ptdump/ptdump.c | 21 ++++++++++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index c59920920ddc..dcfe83d4c211 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -370,7 +370,7 @@ config PPC_PTDUMP
 	  If you are unsure, say N.
 
 config PPC_DEBUG_WX
-	bool "Warn on W+X mappings at boot"
+	bool "Warn on W+X mappings at boot & enable manual checks at runtime"
 	depends on PPC_PTDUMP
 	help
 	  Generate a warning if any W+X mappings are found at boot.
@@ -384,7 +384,9 @@ config PPC_DEBUG_WX
 	  of other unfixed kernel bugs easier.
 
 	  There is no runtime or memory usage effect of this option
-	  once the kernel has booted up - it's a one time check.
+	  once the kernel has booted up, it only automatically checks once.
+
+	  Enables the "check_wx_pages" debugfs entry for checking at runtime.
 
 	  If in doubt, say "Y".
 
diff --git a/arch/powerpc/mm/ptdump/ptdump.c b/arch/powerpc/mm/ptdump/ptdump.c
index 2f9ddc29c535..b6cba29ae4a0 100644
--- a/arch/powerpc/mm/ptdump/ptdump.c
+++ b/arch/powerpc/mm/ptdump/ptdump.c
@@ -4,7 +4,7 @@
  *
  * This traverses the kernel pagetables and dumps the
  * information about the used sections of memory to
- * /sys/kernel/debug/kernel_pagetables.
+ * /sys/kernel/debug/kernel_page_tables.
  *
  * Derived from the arm64 implementation:
  * Copyright (c) 2014, The Linux Foundation, Laura Abbott.
@@ -409,6 +409,25 @@ void ptdump_check_wx(void)
 	else
 		pr_info("Checked W+X mappings: passed, no W+X pages found\n");
 }
+
+static int check_wx_debugfs_set(void *data, u64 val)
+{
+	if (val != 1ULL)
+		return -EINVAL;
+
+	ptdump_check_wx();
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(check_wx_fops, NULL, check_wx_debugfs_set, "%llu\n");
+
+static int ptdump_check_wx_init(void)
+{
+	return debugfs_create_file("check_wx_pages", 0200, NULL,
+				   NULL, &check_wx_fops) ? 0 : -ENOMEM;
+}
+device_initcall(ptdump_check_wx_init);
 #endif
 
 static int ptdump_init(void)
-- 
2.23.0

