Return-Path: <SRS0=FwNv=5Q=lists.openwall.com=kernel-hardening-return-18317-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5C3C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DEB58206DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="RNYWsI3p";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nJUvIi5/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEB58206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18317-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18105 invoked by uid 550); 31 Mar 2020 04:49:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18006 invoked from network); 31 Mar 2020 04:49:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=7lxSiSzlC+CRa
	BOucvvMEahHc5ocTEmTHhLzUywxUHs=; b=RNYWsI3poX7iSqx2QX4AkSlMzpR/l
	2QsHyDn9fXKk8uIAak4ktw4HLoiN/QComTMxM/Nrb3Zzy9k5gy4D9cenM+LnWAKl
	wZf+CkdPqAfoql+MgSfMNB1dGSW2eRPJCTQNG+WwTmRbzIuIvs4ggHtrU63SgFz7
	rEdzxJhdggA7K/T1MJAfNjCWtiTdQ0b6HEDXYWm78+pCG8kzO3OoUTNcQA9Gd/vG
	+o2a2xydvtRMxz7KEQkVNDwZQPjwiUmQp5+I1RpWTSOfGJx3wK8N2fwkARgvqlU+
	Bvb9trV+TkrL+NfDioHQwX4z78Da15EOLyFmZkE3++GFZ3BeSmkpx2WfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=7lxSiSzlC+CRaBOucvvMEahHc5ocTEmTHhLzUywxUHs=; b=nJUvIi5/
	MUz3fp9JkeoyprNQLeiRzQmBiTjLnUEnmEY4/svivO6/WIXL/beGNRb0Y2IXDeTb
	IExUs6p+RMuwTFJ19Pmr+97XkTQd3BgBZZdk9XR8r7b8lYNueeILaHCosgLgFebu
	LxTMiDC4xL/kErnVyNDBAy/My1qZU2VgZ2CKJHZtf+fxJ1x++vOdPX0TcdZ83wRU
	xuK1RpjnBsLEt1KX+92eDUY9uKexliiYOEPBkbgVtMBU3yQY9ZFcrWrkAMVxdelF
	NcnszopBpgAx1XegiLgT3v7lxrGsj7r26MGCBr0ZLBCcp2OTX9wkH6wfc2y7kT+H
	sm4+x/WZnimwgw==
X-ME-Sender: <xms:tMuCXn0ldSEX5YIKBhyBAsYcp1nQShVOfEC7SPvroBeXeT31-WjaOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeiiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecukfhppeduvddurdeghedrvdduvddrvdefleenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvg
    hllhdrtggt
X-ME-Proxy: <xmx:tMuCXlRflkPbETX9bzxSZsczjuYhLjdcOEVfu3085MVlEQNNkmfOew>
    <xmx:tMuCXql5TVfd1riSo9GG1j-dwHe8ByK9n0Q2MSYxAFCd_7qL5BJlhw>
    <xmx:tMuCXmPcZ0WdFXpkqfKizNpCxNykJ6FjwfZZjBfg-BQTg5eqktP-Zg>
    <xmx:tMuCXqkYDjTWJQAyhepMPXEaApDIiWMuaoZa99e4GlJGoGc06HxtOQ>
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
Subject: [PATCH v7 3/7] powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
Date: Tue, 31 Mar 2020 15:48:21 +1100
Message-Id: <20200331044825.591653-4-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331044825.591653-1-ruscur@russell.cc>
References: <20200331044825.591653-1-ruscur@russell.cc>
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
2.26.0

