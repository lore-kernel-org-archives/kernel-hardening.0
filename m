Return-Path: <SRS0=Bpa0=4O=lists.openwall.com=kernel-hardening-return-17952-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FAFC4BA0A
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:37:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 31D34206E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="L6CsOItH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="mPi9H+PU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31D34206E2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17952-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19544 invoked by uid 550); 26 Feb 2020 06:36:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19456 invoked from network); 26 Feb 2020 06:36:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=W5XsVjL9tIlpR
	T/rT1hidYf17YF0ZVTADr8UzRX/C3A=; b=L6CsOItH9rQDK40ZHxDDveX5ypsBb
	ClDy6mOULobhKgxQ/qGVMtg2cTCduu15RGWQ0RiNC/kBaW1AMi57bWUw6+9dJfYB
	7xRzUmj7wR4T2s5LkZ+YDGHgLSrONf1efS8f9RhSlN8j1LoxZ1G1x2d0j7+5ZMSK
	5CwCgI4qulW8qY6kGY+lw5Ug247ZQiWCCyag6sQponpXELmWKKqG96qEj0i8+ARt
	wkdiqFmpNEEFGo8wFcvZUT42/VcmX4v+WIWn2N/MC0o0XC8tvGLsEYqIqMsyOXan
	CbnwAbuusu38Ia8TYTjej/hgOJVAvnvEQgF8wmBO4+LQwaOUL/hOCTv3A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=W5XsVjL9tIlpRT/rT1hidYf17YF0ZVTADr8UzRX/C3A=; b=mPi9H+PU
	Lo6fKgNX1fUhBf5pFZ4LuC5/rQ+GQd+XxQ2z907YbMN3MczhyNJDu2V8PHsb5Z5b
	aN0KiGH65+3CrmJ/oOjU4XpCBTDsSaFBs6DZK6AxEkJr/L6ou8dQuXi2c8iAh5os
	K6sVWnETfMNetfgDmJ2AjggJLUcv9GhN5wwOlzF3VIupjwHcZVwffvfsBoVnRsbK
	HtLrZAB+3Xp0/CZh+/3EG3o0KZhBu7v3ZamOVpLsDxlm/pbTBcjPV9rs/AoCPDsq
	EG+htObDHZIFaogUcYLNWc2Kq/T72sjJBwhm4cFukWrGgnWWypp5BFAqLD0oMG0D
	HcMyqF32PK3SrA==
X-ME-Sender: <xms:9xFWXmLen64EiRKs67CERxHZDNLtCtjR8pnmMP-az16IDUtQaFJ12A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdduhedmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgv
    hicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvd
    druddtnecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhep
    rhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:9xFWXrg7ylTU1z3kmYOiT2xAUcjWNBF8UnDN8w6AiR0xaH8SBWztyQ>
    <xmx:9xFWXr53YHUhApAyMVE1rzVpUeYu4pwB5zZV0tYr8qI1Ty86OTpS7g>
    <xmx:9xFWXozKpB9fuvw4zogOXXgT8sFpF1AUHMxgMUj8GxMAIr7Ad-c3dQ>
    <xmx:9xFWXvU3Xzvcn16NikFrKtmGDko3NSRmSEOJ6SBfS-slCUt4fVxysg>
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
Subject: [PATCH v5 8/8] powerpc/mm: Disable set_memory() routines when strict RWX isn't enabled
Date: Wed, 26 Feb 2020 17:35:51 +1100
Message-Id: <20200226063551.65363-9-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226063551.65363-1-ruscur@russell.cc>
References: <20200226063551.65363-1-ruscur@russell.cc>
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
v5: Apply to both set_memory_attr() and change_memory_attr()
v4: New

 arch/powerpc/mm/pageattr.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index ee6b5e3b7604..49b8e2e0581d 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -64,13 +64,18 @@ static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
 
 int change_memory_attr(unsigned long addr, int numpages, long action)
 {
-	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
-	unsigned long sz = numpages * PAGE_SIZE;
+	unsigned long start, size;
+
+	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
+		return 0;
 
 	if (!numpages)
 		return 0;
 
-	return apply_to_page_range(&init_mm, start, sz, change_page_attr, (void *)action);
+	start = ALIGN_DOWN(addr, PAGE_SIZE);
+	size = numpages * PAGE_SIZE;
+
+	return apply_to_page_range(&init_mm, start, size, change_page_attr, (void *)action);
 }
 
 /*
@@ -96,12 +101,17 @@ static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
 
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

