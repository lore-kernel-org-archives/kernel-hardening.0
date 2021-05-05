Return-Path: <SRS0=f1f0=KA=lists.openwall.com=kernel-hardening-return-21240-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E47CC43460
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 11:08:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 24460613C7
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 11:08:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24460613C7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21240-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21703 invoked by uid 550); 5 May 2021 11:08:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21665 invoked from network); 5 May 2021 11:08:47 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
 luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org, x86@kernel.org,
 akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
 kernel-hardening@lists.openwall.com
Cc: ira.weiny@intel.com, rppt@kernel.org, dan.j.williams@intel.com,
 linux-kernel@vger.kernel.org
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Message-ID: <d01c7845-6f9c-6770-c861-e624c3e2bfc5@suse.cz>
Date: Wed, 5 May 2021 13:08:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 5/5/21 2:30 AM, Rick Edgecombe wrote:
> This is a POC for write protecting page tables with PKS (Protection Keys for 
> Supervisor) [1]. The basic idea is to make the page tables read only, except 
> temporarily on a per-cpu basis when they need to be modified. I’m looking for 
> opinions on whether people like the general direction of this in terms of 
> value and implementation.
> 
> Why would people want this?
> ===========================
> Page tables are the basis for many types of protections and as such, are a 
> juicy target for attackers. Mapping them read-only will make them harder to 
> use in attacks.
> 
> This protects against an attacker that has acquired the ability to write to 
> the page tables. It's not foolproof because an attacker who can execute 
> arbitrary code can either disable PKS directly, or simply call the same 
> functions that the kernel uses for legitimate page table writes.

Yeah, it's a good idea. I've once used a similar approach locally during
debugging a problem that appeared to be stray writes hitting page tables, and
without PKS I indeed made the whole pages read-only when not touched by the
designated code.

> Why use PKS for this?
> =====================
> PKS is an upcoming CPU feature that allows supervisor virtual memory 
> permissions to be changed without flushing the TLB, like PKU does for user 
> memory. Protecting page tables would normally be really expensive because you 
> would have to do it with paging itself. PKS helps by providing a way to toggle 
> the writability of the page tables with just a per-cpu MSR.

I can see in patch 8/9 that you are flipping the MSR around individual
operations on page table entries. In my patch I hooked making the page table
writable to obtaining the page table lock (IIRC I had only the PTE level fully
handled though). Wonder if that would be better tradeoff even for your MSR approach?

Vlastimil

> Performance impacts
> ===================
> Setting direct map permissions on whatever random page gets allocated for a 
> page table would result in a lot of kernel range shootdowns and direct map 
> large page shattering. So the way the PKS page table memory is created is 
> similar to this module page clustering series[2], where a cache of pages is 
> replenished from 2MB pages such that the direct map permissions and associated 
> breakage is localized on the direct map. In the PKS page tables case, a PKS 
> key is pre-applied to the direct map for pages in the cache.
> 
> There would be some costs of memory overhead in order to protect the direct 
> map page tables. There would also be some extra kernel range shootdowns to 
> replenish the cache on occasion, from setting the PKS key on the direct map of 
> the new pages. I don’t have any actual performance data yet.
> 
> This is based on V6 [1] of the core PKS infrastructure patches. PKS 
> infrastructure follow-on’s are planned to enable keys to be set to the same 
> permissions globally. Since this usage needs a key to be set globally 
> read-only by default, a small temporary solution is hacked up in patch 8. Long 
> term, PKS protected page tables would use a better and more generic solution 
> to achieve this.
> 
> [1]
> https://lore.kernel.org/lkml/20210401225833.566238-1-ira.weiny@intel.com/
> [2]
> https://lore.kernel.org/lkml/20210405203711.1095940-1-rick.p.edgecombe@intel.com
> /
> 
> Thanks,
> 
> Rick
> 
> 
> Rick Edgecombe (9):
>   list: Support getting most recent element in list_lru
>   list: Support list head not in object for list_lru
>   x86/mm/cpa: Add grouped page allocations
>   mm: Explicitly zero page table lock ptr
>   x86, mm: Use cache of page tables
>   x86/mm/cpa: Add set_memory_pks()
>   x86/mm/cpa: Add perm callbacks to grouped pages
>   x86, mm: Protect page tables with PKS
>   x86, cpa: PKS protect direct map page tables
> 
>  arch/x86/boot/compressed/ident_map_64.c |   5 +
>  arch/x86/include/asm/pgalloc.h          |   6 +
>  arch/x86/include/asm/pgtable.h          |  26 +-
>  arch/x86/include/asm/pgtable_64.h       |  33 ++-
>  arch/x86/include/asm/pkeys_common.h     |   8 +-
>  arch/x86/include/asm/set_memory.h       |  23 ++
>  arch/x86/mm/init.c                      |  40 +++
>  arch/x86/mm/pat/set_memory.c            | 312 +++++++++++++++++++++++-
>  arch/x86/mm/pgtable.c                   | 144 ++++++++++-
>  include/asm-generic/pgalloc.h           |  42 +++-
>  include/linux/list_lru.h                |  26 ++
>  include/linux/mm.h                      |   7 +
>  mm/Kconfig                              |   6 +-
>  mm/list_lru.c                           |  38 ++-
>  mm/memory.c                             |   1 +
>  mm/swap.c                               |   7 +
>  mm/swap_state.c                         |   6 +
>  17 files changed, 705 insertions(+), 25 deletions(-)
> 

