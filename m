Return-Path: <SRS0=pJ7B=NW=lists.openwall.com=kernel-hardening-return-21367-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA1AC432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:03:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3972B60F4B
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:03:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3972B60F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 7968 invoked by uid 550); 31 Aug 2021 00:00:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7403 invoked from network); 31 Aug 2021 00:00:32 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933731"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933731"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712977"
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
Subject: [RFC PATCH v2 14/19] x86/efi: Toggle table protections when copying
Date: Mon, 30 Aug 2021 16:59:22 -0700
Message-Id: <20210830235927.6443-15-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>

Toggle page table writability when copying page tables in
efi_sync_low_kernel_mappings(). These page tables will not be protected
until after init, but later on they will not be writable.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/platform/efi/efi_64.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 7515e78ef898..7a5c81450fa4 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -116,7 +116,9 @@ void efi_sync_low_kernel_mappings(void)
 	pgd_k = pgd_offset_k(PAGE_OFFSET);
 
 	num_entries = pgd_index(EFI_VA_END) - pgd_index(PAGE_OFFSET);
+	enable_pgtable_write();
 	memcpy(pgd_efi, pgd_k, sizeof(pgd_t) * num_entries);
+	disable_pgtable_write();
 
 	pgd_efi = efi_pgd + pgd_index(EFI_VA_END);
 	pgd_k = pgd_offset_k(EFI_VA_END);
@@ -124,7 +126,9 @@ void efi_sync_low_kernel_mappings(void)
 	p4d_k = p4d_offset(pgd_k, 0);
 
 	num_entries = p4d_index(EFI_VA_END);
+	enable_pgtable_write();
 	memcpy(p4d_efi, p4d_k, sizeof(p4d_t) * num_entries);
+	disable_pgtable_write();
 
 	/*
 	 * We share all the PUD entries apart from those that map the
@@ -139,13 +143,17 @@ void efi_sync_low_kernel_mappings(void)
 	pud_k = pud_offset(p4d_k, 0);
 
 	num_entries = pud_index(EFI_VA_END);
+	enable_pgtable_write();
 	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
+	disable_pgtable_write();
 
 	pud_efi = pud_offset(p4d_efi, EFI_VA_START);
 	pud_k = pud_offset(p4d_k, EFI_VA_START);
 
 	num_entries = PTRS_PER_PUD - pud_index(EFI_VA_START);
+	enable_pgtable_write();
 	memcpy(pud_efi, pud_k, sizeof(pud_t) * num_entries);
+	disable_pgtable_write();
 }
 
 /*
-- 
2.17.1

