Return-Path: <SRS0=Yxz9=4O=lists.openwall.com=kernel-hardening-return-17950-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E750C4BA0B
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:37:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5F0FB206E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 06:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="fzJATGDo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="qRtBUCWh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F0FB206E2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17950-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17888 invoked by uid 550); 26 Feb 2020 06:36:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17792 invoked from network); 26 Feb 2020 06:36:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=kp8u9qL5i5T1m
	QUU2K/sNa+O6ICOZSqNmkNONM8HCIA=; b=fzJATGDokN1+R+MlmNqqa13I3oLTq
	OkzLJ7lhs5ghIs1tFaMk0ljnYHBPpfoygjxDUDw97FJBJJSPGdkoQN8W2VqM3MF+
	OINrLWpgpgBYy6LmdnpU0fz49+qlnDJAgq3BVz1PjdFt0mFr6gl31d4t1O70PZXC
	Tfcv5P5ApNbE3EIoNF+udZYV9TNFgdgir2EdR0/Lj6dDWBNpP1j7h71LArZRnoRY
	G33RK5MNlC9z4HFpa+S/CoUSbd1I4PxoxawB8SZM8eBDi3N7kSOHRLTkSdli3Qb2
	N5biH5UpTcG3FRdM/laciMGA4S6wgpZ8fLoNPYW/WnlWd6+LkAjFiU6Qw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=kp8u9qL5i5T1mQUU2K/sNa+O6ICOZSqNmkNONM8HCIA=; b=qRtBUCWh
	6sRn7gRUKt9JnHKqRL1rmrGS6E2TgS5qT0MvRFBnqqPnneowNTCpNcHbDyaVfpxx
	uRB+jwq8dM+q/20vhRIHcOBN6IQfk35vxx6WBqw8LJyV9GX2sC0ohsgEjbcqs2E0
	mjdw3YEnBaLh1RpKYLeKXX7Y3E34Xx9WyMmrH84Sw8fGftD+BxNm5wjcHD+5IOVc
	oICmk7iNicWKTfSOubPkNyItxPx4j5RPkwgNB/wHCVUkXcWvF/iDu/fugQFHUOh8
	5R/oXt6+S6RjwZ/ZK+C4LOFGXZm8Bv8L5n7A83gjCyY75katBdLbGCqeKtNrm8Fz
	QJa5Qi4B2JI1tw==
X-ME-Sender: <xms:8BFWXh-14232arNZb80RwQozkVJEQgPpZX3bPHtrLfDAOTGEeb7vcw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleefgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculddutddmnecujfgurhephffvufffkffojghfggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecuvehluhhsthgvrhfuihii
    vgepheenucfrrghrrghmpehmrghilhhfrhhomheprhhushgtuhhrsehruhhsshgvlhhlrd
    gttg
X-ME-Proxy: <xmx:8BFWXmN_qLxEeTlILR3cGdlJaZbu378a6u9S6OLG00QNmw0wLKBlNw>
    <xmx:8BFWXgsZ3RjlblJzAEmdfA8hfAEcDF5hrAUajFRipE9nxdksNqsbXA>
    <xmx:8BFWXg3BaG2cXgkoPtj8XvK9gG7p2V_Lv_fKBmTO9d_7hIxwLpX4Ig>
    <xmx:8BFWXrdwf5Y7SRUCpXhobxrqsFZ7EoUO8LtYQl9N7e0FPtzvsypxb-rYWF8>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: jniethe5@gmail.com,
	Christophe Leroy <christophe.leroy@c-s.fr>,
	joel@jms.id.au,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	kbuild test robot <lkp@intel.com>,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH v5 6/8] powerpc/mm: implement set_memory_attr()
Date: Wed, 26 Feb 2020 17:35:49 +1100
Message-Id: <20200226063551.65363-7-ruscur@russell.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200226063551.65363-1-ruscur@russell.cc>
References: <20200226063551.65363-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@c-s.fr>

In addition to the set_memory_xx() functions which allows to change
the memory attributes of not (yet) used memory regions, implement a
set_memory_attr() function to:
- set the final memory protection after init on currently used
kernel regions.
- enable/disable kernel memory regions in the scope of DEBUG_PAGEALLOC.

Unlike the set_memory_xx() which can act in three step as the regions
are unused, this function must modify 'on the fly' as the kernel is
executing from them. At the moment only PPC32 will use it and changing
page attributes on the fly is not an issue.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Reported-by: kbuild test robot <lkp@intel.com>
[ruscur: cast "data" to unsigned long instead of int]
Signed-off-by: Russell Currey <ruscur@russell.cc>
---
v4: cast "data" to unsigned long instead of int

 arch/powerpc/include/asm/set_memory.h |  2 ++
 arch/powerpc/mm/pageattr.c            | 33 +++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
index 64011ea444b4..b040094f7920 100644
--- a/arch/powerpc/include/asm/set_memory.h
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -29,4 +29,6 @@ static inline int set_memory_x(unsigned long addr, int numpages)
 	return change_memory_attr(addr, numpages, SET_MEMORY_X);
 }
 
+int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot);
+
 #endif
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index 2b573768a7f7..ee6b5e3b7604 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -72,3 +72,36 @@ int change_memory_attr(unsigned long addr, int numpages, long action)
 
 	return apply_to_page_range(&init_mm, start, sz, change_page_attr, (void *)action);
 }
+
+/*
+ * Set the attributes of a page:
+ *
+ * This function is used by PPC32 at the end of init to set final kernel memory
+ * protection. It includes changing the maping of the page it is executing from
+ * and data pages it is using.
+ */
+static int set_page_attr(pte_t *ptep, unsigned long addr, void *data)
+{
+	pgprot_t prot = __pgprot((unsigned long)data);
+
+	spin_lock(&init_mm.page_table_lock);
+
+	set_pte_at(&init_mm, addr, ptep, pte_modify(*ptep, prot));
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+int set_memory_attr(unsigned long addr, int numpages, pgprot_t prot)
+{
+	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long sz = numpages * PAGE_SIZE;
+
+	if (!numpages)
+		return 0;
+
+	return apply_to_page_range(&init_mm, start, sz, set_page_attr,
+				   (void *)pgprot_val(prot));
+}
-- 
2.25.1

