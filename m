Return-Path: <SRS0=jfRx=2O=lists.openwall.com=kernel-hardening-return-17517-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D98C2D0CF
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2019 05:56:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B9612206B7
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2019 05:56:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="IbzIp6E6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="wZC2mhCu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9612206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17517-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21632 invoked by uid 550); 24 Dec 2019 05:56:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21528 invoked from network); 24 Dec 2019 05:56:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=HNaf5NLW14hQr
	LdxJDMbqeAu56lYddI2fvxI/Oi2Q/k=; b=IbzIp6E6KQyiIG9rgeFnW3fsle+lZ
	JyV0i6l09BrMpOSmyF4VjAfSg2rF0BeoapfxwQ7n9Te6C4uLyHURjVFQBgq4dp2m
	N08rF7QIym+65gl4tWtM29Gj0rCM88/JFtul1SWTr7NHLvEBwRPdq85OZoRZAXUW
	6MT1G5Ah4UNFDq64O1J5IYNEmvqaYhEyAlIjFw8U2toAed4Ho5PQ2zoH5uAGV1vG
	wkBqqvU9y0BgwjJbyiBZOARyDyalRuK39jWXmQ2UEEG3uxpndETk2r6EEYOOSgHv
	kqjiVq34f2LuycC8OXGW3pacbV3vr/MCSv+qTOc05YceqC8ClbzgSKQ/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=HNaf5NLW14hQrLdxJDMbqeAu56lYddI2fvxI/Oi2Q/k=; b=wZC2mhCu
	2+60kjZBIOrFAAgxXPXmngg4oD5xhdXASIxx17e7bchkcuPrmVkFbJSYshDyM4on
	VCfiP2zO3UeZ3+mzBxqv2czUqXcv/zX7L6+71H0PchwCwvwjUVmXSm+6o3bBJagJ
	PbXt7NGQ4mK3SpABlJsqvZ5G+V5OD0RpH/1x4Yf4eixAMszrM+rosaKNUcC5AL8e
	N9JjqUHKuhdvUVkYqT4izSsthG7xC0/Gq109dar1+Ae3AAVLUaThnt1npiLjcN9g
	Hq4XfJ7fAgDI6K47DUDnQnj0GDKTAVgSOzwwx0C+RznekoYeqeYD8QNnQVkXCv7o
	iaFApKS9kyiz8Q==
X-ME-Sender: <xms:c6gBXiNHcNCWIbdMxIBN09BHUhP2ulAqipcaINESYcHv5FQTLWs0gQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddvrdelledrke
    dvrddutdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhl
    rdgttgenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:c6gBXvsg3-G214m9zEYWPfdlLDVGscKUhTOwEWTxznb23bJuJqR0bQ>
    <xmx:c6gBXt2DhgvIojHFT7-oGd6rf60aEp_n8RV0OHSwVhOQk3yuVTVjUw>
    <xmx:c6gBXuynXM0eQ6JSF9oWj0PK0B0Nj9D1KYhUn3bo4wkIcupgosM60A>
    <xmx:c6gBXsDTzI-x_DmI0wLvxJ8F8rB_0APx1NhNRK-TNx55kHffqdfg_Q>
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
Subject: [PATCH v6 3/5] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
Date: Tue, 24 Dec 2019 16:55:43 +1100
Message-Id: <20191224055545.178462-4-ruscur@russell.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191224055545.178462-1-ruscur@russell.cc>
References: <20191224055545.178462-1-ruscur@russell.cc>
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
index 4e1d39847462..7c14c9728bc0 100644
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
2.24.1

