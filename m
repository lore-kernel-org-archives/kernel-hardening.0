Return-Path: <SRS0=myXS=4O=lists.openwall.com=kernel-hardening-return-17942-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7609EC4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:26:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B439E21556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:26:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="ig3tKLSd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="frUbAQk+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B439E21556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17942-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30592 invoked by uid 550); 26 Feb 2020 06:25:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30502 invoked from network); 26 Feb 2020 06:25:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=gC9R82Z78vRPQ
	T2nLufVwEVT7hVhqTaScp+rv4N5psk=; b=ig3tKLSd8Raq/f9CKyLsyOtp2xg0p
	M6k3229pNXNqKc/4FZtRMabYp0SHheExoD/IVpmPh0Df1NVlLFg2l5oUxL4GfMZ6
	wLUuNqJsVmB8/MSkx3h6T6fbwxEOIz6FAFyuKT0CN06iElfG4X4DF+n0+vhqjRwO
	PUCGuiMmbjQcwIXZJWzKBvzrL0uGwtcfc6V2AZERdGp4PgjNzQIxElofoAkLk3t7
	P8o3PBPfthiAQhUtI/ewAi6+Fcj7ycBjZwIXt77022+NckTpEPpA9jTsGw/kJFaM
	wL5OSq7jybpA22SGyW8IKd6fZOsoOTKbAu1BlYHwnO50L7HzpeJGY7hxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=gC9R82Z78vRPQT2nLufVwEVT7hVhqTaScp+rv4N5psk=; b=frUbAQk+
	+WhF2mjFG6mqR7RrBSsHeEnZIwA9UxXrczy/gHnoTS7GInTQ6elwiolhgKeEliX0
	wIh9kputHoQkGkADEBHBRCDnBFo4xULfJZwhMvoZ0rVmKawksIHlsfuKE53ohxaA
	DP7NJXlYhgM7Vr3cfCV/QOWpUPfdifq03agp/s8Rh0U+Rp91EnMkx9OL+FB0Qs90
	4KKgX1rmnlX9iFQuGsEFJ9kXYaf7X+FfyWQorR94L9kMoRIh4Id8Uc08QbY3gIkA
	rjZSMSyHPeeDSi1joc42f8N+Haa/0g/CRNufTS1bJSYIYMtpcxo+Xz827cXkid7N
	X3YP5avmMMzQkw==
X-ME-Sender: <xms:OQ9WXvf-H9ebOtO6IiQ9zIsX_iRAk42VcUzoCpyPIBW0gYwP2PxMBA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecuvehluhhsthgvrhfuihii
    vgepjeenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrd
    gttg
X-ME-Proxy: <xmx:OQ9WXi5geZ5bzbMV_FfB_bN0K3LxYdiNfkapWkgiyaz6S-ws-NKTlg>
    <xmx:OQ9WXqQx8mfzFhyaTQHDoQKfBZVMeV__sVxhI6AK1a3eaCjTAIVHGA>
    <xmx:OQ9WXtczVFGdIWyCpFHB0s-dWjAtpikZzyE3wqmyG1KpBsarqXOARw>
    <xmx:OQ9WXqS6SUimkUcIXJZWwKae3f6osCDHCrTa80zW-TKWBEadxqbeKw>
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
	Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v4 8/8] powerpc/mm: Disable set_memory() routines when strict RWX isn't enabled
Date: Wed, 26 Feb 2020 17:24:03 +1100
Message-Id: <20200226062403.63790-9-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226062403.63790-1-ruscur@russell.cc>
References: <20200226062403.63790-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are a couple of reasons that the set_memory() functions are
problematic when STRICT_KERNEL_RWX isn't enabled:

 - The linear mapping is a different size and apply_to_page_range()
	may modify a giant section, breaking everything
 - patch_instruction() doesn't know to work around a page being marked
 	RO, and will subsequently crash

The latter can be replicated by building a kernel with the set_memory()
patches but with STRICT_KERNEL_RWX off and running ftracetest.

Reported-by: Jordan Niethe <jniethe5@gmail.com>
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
v4: new

 arch/powerpc/mm/pageattr.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index ee6b5e3b7604..ff111930cf5e 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -96,12 +96,17 @@ static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
 
 int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)
 {
-	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
-	unsigned long sz = numpages * PAGE_SIZE;
+	unsigned long start, size;
+
+	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
+		return 0;
 
 	if (!numpages)
 		return 0;
 
-	return apply_to_page_range(&init_mm, start, sz, set_page_attr,
+	start = ALIGN_DOWN(addr, PAGE_SIZE);
+	size = numpages * PAGE_SIZE;
+
+	return apply_to_page_range(&init_mm, start, size, set_page_attr,
 				   (void *)pgprot_val(prot));
 }
-- 
2.25.1

