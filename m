Return-Path: <SRS0=H9zp=4O=lists.openwall.com=kernel-hardening-return-17937-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357BAC4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:25:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 863D421556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:25:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="cCODXfxY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DJBdHd3h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 863D421556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17937-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27821 invoked by uid 550); 26 Feb 2020 06:24:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27700 invoked from network); 26 Feb 2020 06:24:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=N5bnzgbs5sk/h
	cpbVb2U9rRYKHzeu3F1EjOu4dcDwjg=; b=cCODXfxYu6LzegqSjTMUwx3zs6VB4
	NmQWoWdXNo9AU+REVaplRuP+D+9V/NJ7G8O3I8vHTvzQAd3vxZjMDLWcMmBdXqI6
	6+b5qoBuxANVRLIwaR3UzEwa5kkj1dyE4yAx3rb2IdxeD5LkCs5BQWQ+h9O5t47B
	5yQjdYBvoWjK7PvEYaRHD/SuU2w854aDSiDa/Ff5KQTKFqhiTMEncEej4kUAl5Cr
	tlbE1ViAFzHmlVzqiMxXM2D1ZMOKqCoo1wLGWeTUDO6Ru2qxKsjkyffLv0/olxoM
	4bmWk2EKObu6W6t3Zqhv1svjC9jL6wFJq1QZ1gsSAdT8CV9h716bFlx+g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=N5bnzgbs5sk/hcpbVb2U9rRYKHzeu3F1EjOu4dcDwjg=; b=DJBdHd3h
	dsW7MGGsNXYy/s1RIus85OsdYYDBABHhnbLxVXspA2cd5ntsVuruY4DB4fDkQ/Mi
	gjajTHPI/Vf4YeQDND2hek/q3sYdBj7W6VvM3Fiv+lFu0YeqQcnnfdst2sV4TcWa
	+UCgSYVxh90+n/ckfBP1X89M7UlHAnuicNmyPQRPg56llRfOhXjOJiPppddG3qaU
	VWLFNWgEPq5svOjEaomXxmGskHuf6w8ViELuFlG9BWRfE2wSKR1wtDjjGTRmhqVq
	tH3OAsdek8wlgHdlSIe8JLRZOzjH2iOnPJmY6y/ekdyAqDAAHTbY+83STNRYetTo
	uPJGSsbvi2f1dw==
X-ME-Sender: <xms:KA9WXvFDpw6A-ITZD_D_cAD-uTHIyxx3npqFZ4QabfuV3dY531qLSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    rhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:KA9WXtF3NqfPtafNw1s0ZrE0sWNV_MZB7-iqzqXcICOQcB2Xym34CQ>
    <xmx:KA9WXgzb8yaLCbIJBH08c4o1iWFBasL3_ghrsgk5RbW_x2LkYaH0sA>
    <xmx:KA9WXmSTHQOyF70C3COgyF-tewJEvlz5sGYzmY24BkbZU-iM6eUtlA>
    <xmx:KA9WXq7H-tCX6y7yK9UJjah-q_Mt6hfzThntOYDjnZ28E7gnaQcJKQ>
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
Subject: [PATCH v4 3/8] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
Date: Wed, 26 Feb 2020 17:23:58 +1100
Message-Id: <20200226062403.63790-4-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226062403.63790-1-ruscur@russell.cc>
References: <20200226062403.63790-1-ruscur@russell.cc>
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
index 0b063830eea8..e37960ef68c6 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -370,7 +370,7 @@ config PPC_PTDUMP
 	  If you are unsure, say N.
 
 config PPC_DEBUG_WX
-	bool "Warn on W+X mappings at boot"
+	bool "Warn on W+X mappings at boot & enable manual checks at runtime"
 	depends on PPC_PTDUMP && STRICT_KERNEL_RWX
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
index 206156255247..a15e19a3b14e 100644
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
@@ -413,6 +413,25 @@ void ptdump_check_wx(void)
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
2.25.1

