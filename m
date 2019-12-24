Return-Path: <SRS0=l5LC=2O=lists.openwall.com=kernel-hardening-return-17520-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B49C2D0CF
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2019 06:42:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B3F40206B7
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2019 06:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="OtaCisGT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="bvyOJlC3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3F40206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17520-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5719 invoked by uid 550); 24 Dec 2019 06:41:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5682 invoked from network); 24 Dec 2019 06:41:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm3; bh=rtj/7hIjt1tw1EMAQkHvGXSlMO
	R7mLvY3RUuvJp9mpw=; b=OtaCisGTuxgVEtGx0Qs0NNbckvk9I35N6hPwQNiVSO
	QmAw9RLS0PTHoUI5f0qcdY7Io6mPbGY9tkBhpgZ/gYvIiB+8f59n1Wh/VZuEjy7K
	aOGYDuU4KInHcaPLhcAnh4ODTzHUTuKvJukxtyZgk6wqXzOV2eIuvDjsa97EiNJ+
	k3psk4cx5/xWgHEPlfv6rT6uRI3D0MzcVBUI9aU9IPWgkvd2g0b3fVHBXMmnLsqv
	O/AeFDsYSycRyLAoNkUnyUsd0xxe6XD6XmeOx1xhXgwVOE/x5Y0aXLrV4KGspR//
	Nvi8mM+MQ/R5EGPqd23crb6SRZmFuAzsOonAltaGCT3w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rtj/7hIjt1tw1EMAQ
	kHvGXSlMOR7mLvY3RUuvJp9mpw=; b=bvyOJlC3CKRi3MNsPeMJOLfczY3Dl7Ryn
	7yH7woMByuEJ1Tbb17w1JJpyGz0YdKdI4l3Q95+ZCsTepCF5wjeGnn00l8aRqM5/
	03VY2r7/Hj6nUe1iJBEN90JnnGmsWEoDu/nGu/ikWm/xSamg1oc5Voy7wGNCla0u
	m6hMOGWpkFdEnhRmO7ZE0JYk/NQWqozkRSY3ECZ4qp4+KauiJx8IqTlUjxUPyY2E
	YUcgfp4IvRpmQ1xM7jay4B5Ka9b/W6RZrinz0FLAg/2GeLzDf4etJc278+FiZjCU
	4+bJjVbQhcJZAPyMlfl5J1O3ljqxzy41JR3v1EpAX7bH+6myoi+Yw==
X-ME-Sender: <xms:J7MBXvGrZJMJLK334V8wUoBCRVKzJwA4SRnMdPSK_6eykL8-geVXSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvuddgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfedtmdenucfjughrpefhvf
    fufffkofgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgih
    uceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddvrdelledrkedvrd
    dutdenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrdgt
    tgenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:J7MBXor1A_zoX1EFfSQaB26r4TuP8IgyNSsJPPD9ZQ5PVV8W2FlpRQ>
    <xmx:J7MBXl3NXKaozps_al_ilxx1DXJ9M8IGX9QcftrM5aHPPAU6xBSabw>
    <xmx:J7MBXhn1H9YmbJwWtpgwnvrV4yU_gXC1SS9ewgj7V8mtbrjvaWeDtQ>
    <xmx:KbMBXnwUhjXSvFLCC1VR9NJ8dbQHTiVEJa3biWRBeJuegEglGtUdPA>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: ajd@linux.ibm.com,
	mpe@ellerman.id.au,
	christophe.leroy@c-s.fr,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH 1/2] powerpc/book3s64/hash: Disable 16M linear mapping size if not aligned
Date: Tue, 24 Dec 2019 17:41:25 +1100
Message-Id: <20191224064126.183670-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With STRICT_KERNEL_RWX on in a relocatable kernel under the hash MMU, if
the position the kernel is loaded at is not 16M aligned, the kernel
miscalculates its ALIGN*()s and things go horribly wrong.

We can easily avoid this when selecting the linear mapping size, so do
so and print a warning.  I tested this for various alignments and as
long as the position is 64K aligned it's fine (the base requirement for
powerpc).

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/mm/book3s64/hash_utils.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index b30435c7d804..523d4d39d11e 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -652,6 +652,7 @@ static void init_hpte_page_sizes(void)
 
 static void __init htab_init_page_sizes(void)
 {
+	bool aligned = true;
 	init_hpte_page_sizes();
 
 	if (!debug_pagealloc_enabled()) {
@@ -659,7 +660,15 @@ static void __init htab_init_page_sizes(void)
 		 * Pick a size for the linear mapping. Currently, we only
 		 * support 16M, 1M and 4K which is the default
 		 */
-		if (mmu_psize_defs[MMU_PAGE_16M].shift)
+		if (IS_ENABLED(STRICT_KERNEL_RWX) &&
+		    (unsigned long)_stext % 0x1000000) {
+			if (mmu_psize_defs[MMU_PAGE_16M].shift)
+				pr_warn("Kernel not 16M aligned, "
+					"disabling 16M linear map alignment");
+			aligned = false;
+		}
+
+		if (mmu_psize_defs[MMU_PAGE_16M].shift && aligned)
 			mmu_linear_psize = MMU_PAGE_16M;
 		else if (mmu_psize_defs[MMU_PAGE_1M].shift)
 			mmu_linear_psize = MMU_PAGE_1M;
-- 
2.24.1

