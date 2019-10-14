Return-Path: <SRS0=a9Ta=YH=lists.openwall.com=kernel-hardening-return-17015-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9640BC47404
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2019 05:14:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DDA372089C
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Oct 2019 05:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="CZcCXK1r";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="TGyP5rXI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDA372089C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17015-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9877 invoked by uid 550); 14 Oct 2019 05:14:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9784 invoked from network); 14 Oct 2019 05:14:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm3; bh=HYGtzzTlMcF3v
	eMN2AqVXMM15POrvmVyLU/o7hZnrc4=; b=CZcCXK1ruQMsWifP+BuWFTDNOwqjK
	cUq+xsM/2hPoT/Ct58QQDMUP/iCo8BqP9wRJkgfbW1q/2w1m2Q0KRPrEUKuBnaIH
	Fann+0zA05uyeaapNBG+Jm6ijffVGkgM7EzEhZXYQDFQgvoD31UOtN7tcz8+P4ov
	NTrXa13DgtietJBIsGZqs3O3HGZ0hH6ZQivPg5nfu3w2l6F58E9Q8aFFKOevmr4Q
	Jd14hwVW8xDQN/R4V1p+bNkifRcd6tUD4tn17p0+8bdxuYS9tVteBef4sgXGvwwd
	/73CT5W/MEBjrdNydVpBZb529Nng7TB++7oEQi7Ss7LAWSMFwy5Ty7MjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; bh=HYGtzzTlMcF3veMN2AqVXMM15POrvmVyLU/o7hZnrc4=; b=TGyP5rXI
	Po4QmiZG+PLIgKoTyopCASlfEGy4ZLWCDv54z0Ycr7GkL8PCW9X8Tdgs41+8ycr1
	YPSjKLe6z76EU07qVvQmf7p9IQqPiAlFAFbCcQ9SwoOY1oeYIlGhsghAcJ2dB/+d
	aRxTUkWW0ApUAyCnT74smhE09TQiPkD950dxRhru2FUosIK3CtoLpGYlRLniDbNL
	y0nmjwGyR/PWmaTHl68sZcsQqwI5lCHUy4MpyrP7psCLkZ7gEbv9hp1/4OwNsQ1A
	IDlleblqqQQcj8kMCGHHuxswL7xuM5Iibd2P/GnQixrEEVfCbJzXhG6es7OY+pwT
	xh7EMMfvBA/Oyw==
X-ME-Sender: <xms:FASkXVHJs88H8Xol6uokigFp9MYKvYgC1QCLvH4jNKflPZiHA68xDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrjedtgdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdeftddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdr
    tggtnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:FASkXSCUuL3XrcCWg_LVbzthcsbonkTFSWBEvXqjR_cmRvH7IJhZfA>
    <xmx:FASkXZXh2UzElft5w8B9TctxVgywhzs0rYBmZNPapCLVAWRADKcEYQ>
    <xmx:FASkXZxvdm0gIkwC2GlfXonHzMcNxGmNpFTIcuVnyfhUYyPSptNdGw>
    <xmx:FASkXXTx8vWwfyRgrPhQtvcBEcl2fctmV-i9Ya-Kb8pYr3ZuUfgK5Q>
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
Subject: [PATCH v4 3/4] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
Date: Mon, 14 Oct 2019 16:13:19 +1100
Message-Id: <20191014051320.158682-4-ruscur@russell.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191014051320.158682-1-ruscur@russell.cc>
References: <20191014051320.158682-1-ruscur@russell.cc>
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

