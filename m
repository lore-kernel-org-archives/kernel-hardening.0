Return-Path: <SRS0=zdu0=NW=lists.openwall.com=kernel-hardening-return-21365-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D1BC432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:03:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C1A3C60F4B
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C1A3C60F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 7750 invoked by uid 550); 31 Aug 2021 00:00:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7404 invoked from network); 31 Aug 2021 00:00:32 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933735"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933735"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712992"
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: dave.hansen@intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	x86@kernel.org,
	akpm@linux-foundation.org,
	keescook@chromium.org,
	shakeelb@google.com,
	vbabka@suse.cz,
	rppt@kernel.org
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 15/19] x86/mm/cpa: Add set_memory_pks()
Date: Mon, 30 Aug 2021 16:59:23 -0700
Message-Id: <20210830235927.6443-16-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

Add function for setting PKS key on kernel memory.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/set_memory.h | 1 +
 arch/x86/mm/pat/set_memory.c      | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index e0516651698a..1ba2fb45ed05 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -52,6 +52,7 @@ int set_memory_decrypted(unsigned long addr, int numpages);
 int set_memory_np_noalias(unsigned long addr, int numpages);
 int set_memory_nonglobal(unsigned long addr, int numpages);
 int set_memory_global(unsigned long addr, int numpages);
+int set_memory_pks(unsigned long addr, int numpages, int key);
 
 int set_pages_array_uc(struct page **pages, int addrinarray);
 int set_pages_array_wc(struct page **pages, int addrinarray);
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index c51792a797cb..dc704e8da032 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1922,6 +1922,13 @@ int set_memory_wb(unsigned long addr, int numpages)
 }
 EXPORT_SYMBOL(set_memory_wb);
 
+int set_memory_pks(unsigned long addr, int numpages, int key)
+{
+	return change_page_attr_set_clr(&addr, numpages, __pgprot(_PAGE_PKEY(key)),
+					__pgprot(_PAGE_PKEY(0xF & ~(unsigned int)key)),
+					0, 0, NULL);
+}
+
 int set_memory_x(unsigned long addr, int numpages)
 {
 	if (!(__supported_pte_mask & _PAGE_NX))
-- 
2.17.1

