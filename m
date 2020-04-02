Return-Path: <SRS0=mSF8=5S=lists.openwall.com=kernel-hardening-return-18373-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37438C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:32:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86DB620757
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 12:32:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="f0JvxmfL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="gJzjpJKm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86DB620757
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18373-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9737 invoked by uid 550); 2 Apr 2020 12:31:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9485 invoked from network); 2 Apr 2020 12:31:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=8Fq17lP4Lp1M3
	6AFgwRFg9dSME8eRCywiX5gdakCTfw=; b=f0JvxmfLSNTbawAkXghe48bmb/lQf
	5Lqp9a3hQIB4bcRxDJyT5X5CAWBYwfjqdCQUcUhFI/iRMMYsHzZ5W/LRXmqf98Tm
	QJtVP4oWozIrkWKjTUYUed7+tJPldT6164PvHU0zUVyYLdkV2n2o+XRd4K4szA8h
	3sBtFVz3syCiRmMwV4Qb4L4wxtdjXDqDp9c+hey0Byrmh1usthmxm+MZsF2LXytz
	CffBqkM/3Pt4ZdKkek8nG972FG41iJJJLWHTwoTT8aE+at8HPLtAi+4q3PP3MEjI
	EpvfqpXBzlhJGje1LQ4pfSaTPy01UmwtrInAW6CQ6Scg2ESpiE6+z8HqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=8Fq17lP4Lp1M36AFgwRFg9dSME8eRCywiX5gdakCTfw=; b=gJzjpJKm
	kvt+qlKQLF9UtzjOJb1uWh3ILFWuvESAR+d/ghC6wdwL9q25DB0c/nPzrAGFSPke
	gv4kI17Da37woxnD76zwXZ6TqRR86kwTLx8Ri2JrAjFsXS/l4jYnMoT4pvtJGWQ6
	/nOIGwfKxwkprTCqNNSPPWLt/cwjgIvMlTqMERLOP25/V4od7lpl/c0CQxlYMk9D
	+6ExzSR2NCf5qyNUU9ejCki3+cNZnD8jLP6fchkJy+rWVO7X8OTFRgw0PR099IBs
	C5afHnJkFv+/4OV61N1SI1ZJ7vd58zbrrc6RDX3A2isQEUkyzSJYqBQ9QY5VFAtJ
	ReGAQNCDcZqA4A==
X-ME-Sender: <xms:MKWFXhSxXVb06-MWfPHdP6QXq4AR0kZii461yLPRtDg5PKHkt3ZgyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeggddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvuddrgeehrddvuddvrddvfeelnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlh
    hlrdgttg
X-ME-Proxy: <xmx:MKWFXlc2EqwZCmEP2h1KnV0Asf0jhMZNC2DfSNUIuq7IRY538BheYQ>
    <xmx:MKWFXtf_hjevik3fF1ALtnuc-2cZP3aL4POfedxYczSIKMo4QguIbQ>
    <xmx:MKWFXj-0stcaHr27Du3hiJMyTX1CuiEf_X56z6SVUrRObID8I-f49g>
    <xmx:MKWFXtQGAYzRGi-NE3nhLGA6C0DjTkXa0_1xdjJzztveUNG505Tu4Q>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH v8 3/7] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
Date: Thu,  2 Apr 2020 19:40:48 +1100
Message-Id: <20200402084053.188537-3-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200402084053.188537-1-ruscur@russell.cc>
References: <20200402084053.188537-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Very rudimentary, just

	echo 1 > [debugfs]/check_wx_pages

and check the kernel log.  Useful for testing strict module RWX.

Updated the Kconfig entry to reflect this.

Also fixed a typo.

Reviewed-by: Kees Cook <keescook@chromium.org>
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
index d92bb8ea229c..525ca5aeaa01 100644
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
2.26.0

