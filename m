Return-Path: <SRS0=/79m=43=lists.openwall.com=kernel-hardening-return-18116-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F03C10F25
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Mar 2020 01:04:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 51B0F20637
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Mar 2020 01:04:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="nuHFjJ3b";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="igN1LVoO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51B0F20637
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18116-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26035 invoked by uid 550); 10 Mar 2020 01:04:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25946 invoked from network); 10 Mar 2020 01:04:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=8lzF+bki5ljY1
	+3LRVnTxy2EovRyYNho4bqwRNKSXkI=; b=nuHFjJ3bYut+r7z12RZ+iPn9kAOFm
	BqZ7jkWFLpiJwEJg8b32a/owfy59xHaNRZ925cgDdAsId4j2Lr9PG22Ve0TFzPjF
	iyMn3mO9jX4uYRM8Y/ZZhM2y5E0k+uAczRX77d0nnOgo776kL8TUkwwyNrObmTKJ
	lFUssyFdRSYwq1lRx3dEGHaa4VL4forHy+8/zPKi0SdCv9rpKbIVmnGiTQCdMdJH
	BijBbpWdNhRvKMc6/2RUzSuSbTnwdlD6TdwfbadahinKRm861ygaZp9isWD77zdH
	D/qQOK6L8xmvC2xcAmV5q4MzLnXaDescHpHWc1b0nfOxqm0Gdg2yAvGgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=8lzF+bki5ljY1+3LRVnTxy2EovRyYNho4bqwRNKSXkI=; b=igN1LVoO
	NEY7Rpz1yZkAlgZMCRCjlBSQ59rxJCm6adTX17R6kZWnUBXWHd1NpL6La6HoVIQ7
	7oI58mSWfexvcK393VtWdjLzuRRizj1p8/AYeAaEOIUjON7bP+wT4cZJk+xwzLeB
	8caEN98n+X62itKsVt+/Uupmt+fzSHDyVRJCkkwAcm/Bo3wyjlvyxJMlKNF/EK/Q
	Q8SZHlGMtdvlMuH24MXWrwEKnh8sgUdlyUN7I8JyyEnopBhyCqSBsexHZuT0Shf8
	GHVuzmgsrYYqeq/dy9R1adtydAXMhiVixxqP3jaidCsI9MKNSv+ixjvs3+r20ot5
	y9KjwTOX2ENSKA==
X-ME-Sender: <xms:jOdmXk5XCHFewHV0XU11nwhNNyG2f-mXTgWAO1nts2cp09G_u9SEFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudduledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecukfhppeduvddvrdelledrkedvrddutdenucevlhhushhtvghrufhi
    iigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghllh
    drtggt
X-ME-Proxy: <xmx:jOdmXvOv0qIhdU9SMDcs91-D0Vgs1_qwiM89Aqh-0I19G0LJ5TX0ZA>
    <xmx:jOdmXqsLQ_IRTG0CbveAS2CC5KxjJiDquzfRLXYxLoxN264jzHXUBA>
    <xmx:jOdmXqa42_3-ZfC1hXMsendy_wHbIj4HpcUoVbv3BcF7pu1Qr43-CQ>
    <xmx:jOdmXv-VdiexqtA8bepYfl8GASXw13Nxm5S-qZP6SNJHmnhUVXQyGA>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>
Subject: [PATCH v6 3/7] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
Date: Tue, 10 Mar 2020 12:03:34 +1100
Message-Id: <20200310010338.21205-4-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310010338.21205-1-ruscur@russell.cc>
References: <20200310010338.21205-1-ruscur@russell.cc>
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

