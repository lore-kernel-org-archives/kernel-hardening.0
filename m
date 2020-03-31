Return-Path: <SRS0=/7qT=5Q=lists.openwall.com=kernel-hardening-return-18320-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5307C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0F2FA206EB
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="Cu17Rled";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RnDbHuxZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F2FA206EB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18320-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20006 invoked by uid 550); 31 Mar 2020 04:49:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19906 invoked from network); 31 Mar 2020 04:49:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=Tu8sBLS3zJK/o
	v+DbQsiIXToGWHNJtrgCaqNu1LJZa4=; b=Cu17RledTbvGP9qHrxQ7u5IqysUMS
	DT5G851Fd0mtrMvjpAgx5PUObj6ObKNLOZ/H+tili5g4SA1GNUDxKOqFOyzPZqMo
	npDf2S7F2m4mwfKmRAcF2g3fDM/LervEbH2iC+WHD95jeBOSondDXwMPVfJHHAsk
	lR15oupGxSh9DWj9stylG4HYM5JOUh4guaMet0Qy6C2GlspZeJrXJTxbXi7l+/vk
	a2s5Olb22Ttq002CxqXJd0JjIGVIewru6maev6c3gH5RWmgEbXE3rOSfgFOUtHti
	otjIOdVY8KZk8xkGODHpW0JvssZIIAh/xEsEut+8Gs8D6vAHMZBCjF64g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=Tu8sBLS3zJK/ov+DbQsiIXToGWHNJtrgCaqNu1LJZa4=; b=RnDbHuxZ
	hiw+mgmRXxFrBpmhtTCDnHPfBpBn5nYH8xb+hs3O9ZzK8NCCf9P3c0b2CQ6Ss5qW
	5FaILYk6JHwu5Wn/MhcNcVSIGuX3GITJ31ltZ5YBRgTsaPZkBzGCKPuPhgD8P1Qn
	bRi3qDfAf2i5NNyOp0B8OBKSHvAGeKmikKUESvrBMnL4XI3wuuZc6BAVc8RcrAet
	K26I6AdKCVrl6kieOD2dsVn8I/9keuVewW9pUx/xavWN2KDJ86/APPFmCK9zIYB9
	k0AkHKU6jpDIv2fsZjA2hNvUQvX/QdK5dcTlx4bT8cEwjNAZgTh+O7JRgF5Uv+MZ
	utnmnFaxuIJeWg==
X-ME-Sender: <xms:vMuCXseam8gGwDTWofS1wES7J71yB6UfqbQn2diVMs32qSYEuSnehw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeiiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdluddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecukfhppeduvddurdeghedrvdduvddrvdefleenucevlhhushhtvghr
    ufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvg
    hllhdrtggt
X-ME-Proxy: <xmx:vMuCXqidbjrbzUIw5swJMjqqVBTSbpcDlba-A1OZOn1ejY7DWqs7uw>
    <xmx:vMuCXgQanViWEqGLW66mqKqyIH80PpRy7VzueVknOZA3fABW6PI6hA>
    <xmx:vMuCXjxLhyzDFQFIvPvkmxltVGgDuPPQvdvxDLnncbiqQ7o7_TwUHA>
    <xmx:vMuCXhmVWXLRPfFaa6Vogu5SBEVUASeFDoN9XgiKD3w7Csr1DDk36g>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com,
	kbuild test robot <lkp@intel.com>,
	Russell Currey <ruscur@russell.cc>
Subject: [PATCH v7 6/7] powerpc/mm: implement set_memory_attr()
Date: Tue, 31 Mar 2020 15:48:24 +1100
Message-Id: <20200331044825.591653-7-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331044825.591653-1-ruscur@russell.cc>
References: <20200331044825.591653-1-ruscur@russell.cc>
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
v7: Use apply_to_existing_page_range() and check for negative numpages

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
index 2da3fbab6ff7..2fde1b195c85 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -79,3 +79,36 @@ int change_memory_attr(unsigned long addr, int numpages, long action)
 	return apply_to_existing_page_range(&init_mm, start, sz,
 					    change_page_attr, (void *)action);
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
+	if (numpages <= 0)
+		return 0;
+
+	return apply_to_existing_page_range(&init_mm, start, sz, set_page_attr,
+					    (void *)pgprot_val(prot));
+}
-- 
2.26.0

