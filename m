Return-Path: <SRS0=xLN6=NW=lists.openwall.com=kernel-hardening-return-21360-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3BBC432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:02:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 38A9060F4B
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 00:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 38A9060F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 7469 invoked by uid 550); 31 Aug 2021 00:00:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7290 invoked from network); 31 Aug 2021 00:00:30 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="197933699"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="197933699"
X-IronPort-AV: E=Sophos;i="5.84,364,1620716400"; 
   d="scan'208";a="530712788"
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
Subject: [RFC PATCH v2 00/19] PKS write protected page tables
Date: Mon, 30 Aug 2021 16:59:08 -0700
Message-Id: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1

Hi,

This is a second RFC for the PKS write protected tables concept. I'm sharing to
show the progress to interested people. I'd also appreciate any comments,
especially on the direct map page table protection solution (patch 17).

Since v1[1], the improvements are:
 - Fully handle direct map page tables, and handle hotplug/unplug path.
 - Create a debug time checker that scans page tables and verifies 
   their protection.
 - Fix odds-and-ends kernel page tables that showed up with debug 
   checker. At this point all of the typical normal page tables should be
   protected.
 - Fix toggling of writablility for odds-and-ends page table modifications found
   that don't use the normal helpers.
 - Create atomic context grouped page allocator, after finding some page table
   allocations that are passing GFP_ATOMIC.
 - Create "soft" mode that warns and disables protection on violation instead
   of oopsing.
 - Boot parameters for disabling pks tables
 - Change PageTable set clear to ctor/dtor (peterz)
 - Remove VM_BUG_ON_PAGE in alloc_table() (Shakeel Butt) 
 - PeterZ/Vlastimil had suggested to also build a non-PKS mode for use in  
   debugging. I skipped it for now because the series was too big.
 - Rebased to latest PKS core v7 [2]

Also, Mike Rapoport has been experimenting[3] with this usage to work on how to
share caches of permissioned/broken pages between use cases. This RFCv2 still
uses the "grouped pages" concept, where each usage would maintain its own
cache, but should be able to integrate with a central solution if something is
developed.

Next I was planning to look into characterizing/tuning the performance, although
what page allocation scheme is ultimately used will probably impact that.

This applies on top of the PKS core v7 series[2] and this patch[4]. Testing is
still pretty light.

This RFC has been acked by Dave Hansen.

[1] https://lore.kernel.org/lkml/20210505003032.489164-1-rick.p.edgecombe@intel.com/
[2] https://lore.kernel.org/lkml/20210804043231.2655537-1-ira.weiny@intel.com/
[3] https://lore.kernel.org/lkml/20210823132513.15836-1-rppt@kernel.org/
[4] https://lore.kernel.org/lkml/20210818221026.10794-1-rick.p.edgecombe@intel.com/

Rick Edgecombe (19):
  list: Support getting most recent element in list_lru
  list: Support list head not in object for list_lru
  x86/mm/cpa: Add grouped page allocations
  mm: Explicitly zero page table lock ptr
  x86, mm: Use cache of page tables
  x86/mm/cpa: Add perm callbacks to grouped pages
  x86/cpufeatures: Add feature for pks tables
  x86/mm/cpa: Add get_grouped_page_atomic()
  x86/mm: Support GFP_ATOMIC in alloc_table_node()
  x86/mm: Use alloc_table() for fill_pte(), etc
  mm/sparsemem: Use alloc_table() for table allocations
  x86/mm: Use free_table in unmap path
  mm/debug_vm_page_table: Use setters instead of WRITE_ONCE
  x86/efi: Toggle table protections when copying
  x86/mm/cpa: Add set_memory_pks()
  x86/mm: Protect page tables with PKS
  x86/mm/cpa: PKS protect direct map page tables
  x86/mm: Add PKS table soft mode
  x86/mm: Add PKS table debug checking

 .../admin-guide/kernel-parameters.txt         |   4 +
 arch/x86/boot/compressed/ident_map_64.c       |   5 +
 arch/x86/include/asm/cpufeatures.h            |   2 +-
 arch/x86/include/asm/pgalloc.h                |   6 +-
 arch/x86/include/asm/pgtable.h                |  31 +-
 arch/x86/include/asm/pgtable_64.h             |  33 +-
 arch/x86/include/asm/pkeys_common.h           |   1 -
 arch/x86/include/asm/set_memory.h             |  24 +
 arch/x86/mm/init.c                            |  90 +++
 arch/x86/mm/init_64.c                         |  29 +-
 arch/x86/mm/pat/set_memory.c                  | 527 +++++++++++++++++-
 arch/x86/mm/pgtable.c                         | 183 +++++-
 arch/x86/mm/pkeys.c                           |   4 +
 arch/x86/platform/efi/efi_64.c                |   8 +
 include/asm-generic/pgalloc.h                 |  46 +-
 include/linux/list_lru.h                      |  26 +
 include/linux/mm.h                            |  16 +-
 include/linux/pkeys.h                         |   1 +
 mm/Kconfig                                    |  23 +
 mm/debug_vm_pgtable.c                         |  36 +-
 mm/list_lru.c                                 |  38 +-
 mm/memory.c                                   |   1 +
 mm/sparse-vmemmap.c                           |  22 +-
 mm/swap.c                                     |   6 +
 mm/swap_state.c                               |   5 +
 .../arch/x86/include/asm/disabled-features.h  |   8 +-
 26 files changed, 1123 insertions(+), 52 deletions(-)

-- 
2.17.1

