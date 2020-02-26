Return-Path: <SRS0=k36p=4O=lists.openwall.com=kernel-hardening-return-17947-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FF9C4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:36:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D45F206E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="Io3bN9kK";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gng90mzG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D45F206E2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17947-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15697 invoked by uid 550); 26 Feb 2020 06:36:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15586 invoked from network); 26 Feb 2020 06:36:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=N5bnzgbs5sk/h
	cpbVb2U9rRYKHzeu3F1EjOu4dcDwjg=; b=Io3bN9kKEzvN1pUBaP9wuM0r35HNI
	vUu581Tvh+XFWThFq+UCML6MWlbmN+ekbDdpgIIzRpwqoFfMv+mkr1Zg897AF69I
	e2HPPAvF0JnHAnriyWm6l+tzZl3lbxB1JDXxHIwWSZtHaF+hjQYMm4Ugq37ANmQ1
	92haw7os4aDdqoMudjV+TOqY751FD3XefRvmOkyZJKBt5CAWId/oD42tYOa0wcNf
	P28sezk2OFkRkAr1rKxGUPZ0cKZM85lZ+IUBaAeTQM8GbmegdWE3sqtwZzKjenyy
	4TJWT6+4CnzyznEYrpqHD/8iiPUewFH9PLJ3sMT4cpEy3oi3TLlQCsjqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=N5bnzgbs5sk/hcpbVb2U9rRYKHzeu3F1EjOu4dcDwjg=; b=gng90mzG
	I3eXynh3NWTmVsc4O3wRkejMdGkJDlw4O6kHpV2MXiG8fpenxPZas8XXrR5C97jz
	jUPwS8SsSOyIH1YvjmPD1UeKGmsEgdGm/FGKoN1Reae6ICx7UXBTN70nieXnEw2y
	e629tgReOsmiqX0H2RaWfHGDhhBjKnaQp7OencwTthBtYwWS/MwcnrN9Q44RP1fD
	Z4XLB2KUdQTV6XXtktEHp/iYJt+OBLks/IiEviZkDBgh1TlfrWNLojIvFkVguqjJ
	ZGxv9Qrn3ZkV/0JFypJLWjikLuPhgvvhuse7dxKhWOgXsB2QFqvPxfUNGWqWndbi
	QmZmkjRBC1giXQ==
X-ME-Sender: <xms:5RFWXvJtTyg9M-1YbYXOTeMQqEgifSHFrslFEyf5D3TtwsbB_emyoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhep
    rhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:5RFWXq_3AdwO5-i8yf-C8ESpB9zH2Y3VIHJ2_WeXg6VLd6K33yn6-A>
    <xmx:5RFWXjFI9vLt_kXuKWWvPj268i9xl0cPHmoWHqJ6w_g0qipkmVo89g>
    <xmx:5RFWXiMbqe1AH0pOw7lbOAJl5d2ydTuA5CIT7xdzk8cmsMKMQqqtjw>
    <xmx:5RFWXsP8P30Fe2eT1utjFz_SUxhxmsFnRfxTRDaEboTZj8YgJ7SsBw>
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
Subject: [PATCH v5 3/8] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
Date: Wed, 26 Feb 2020 17:35:46 +1100
Message-Id: <20200226063551.65363-4-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226063551.65363-1-ruscur@russell.cc>
References: <20200226063551.65363-1-ruscur@russell.cc>
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

