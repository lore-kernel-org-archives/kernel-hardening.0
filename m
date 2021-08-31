Return-Path: <SRS0=i+hJ=NW=lists.openwall.com=kernel-hardening-return-21376-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E81C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:56:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8D77A61027
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:56:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8D77A61027
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 23834 invoked by uid 550); 31 Aug 2021 08:56:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23799 invoked from network); 31 Aug 2021 08:56:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1630400173;
	bh=DNUygxTSAI95z0kYhGZBnpsWktfjbuKT8jy5wGbbaVE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H1UsoCB6olqAwXiqi6JHq0icYTheLspJKQ9mo4xFG0W/ZEVDGIdL8iQZ+z45Iv6GL
	 lzSGekgjp++HeYdByKsCFII+ru1eFXNlPMPNCY35SMiVQIvxVq5YaSwpngidGiZbfd
	 lJf1wVIGGEYgBo5iL/QmstQ0PmnHGazxVMStZyS4gGcjsffFfnLwd/30yCuq93GTRH
	 Zga0Lh7fLX3yVrdNzuwBbDOScFpEryOXSpO52gYHSSuVmkSY0kGXAETznpR+7bpN24
	 v9ZgNhueXN6LJys1c9Ui4Unq6JyK+ZT5F7fr2Wn+DHUB35LAS9D8jvbwcqk3vjogwO
	 0NdNuHR1ekgJA==
Date: Tue, 31 Aug 2021 11:56:06 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	x86@kernel.org, akpm@linux-foundation.org, keescook@chromium.org,
	shakeelb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 16/19] x86/mm: Protect page tables with PKS
Message-ID: <YS3uphSSY/D3bt5f@kernel.org>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <20210830235927.6443-17-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830235927.6443-17-rick.p.edgecombe@intel.com>

On Mon, Aug 30, 2021 at 04:59:24PM -0700, Rick Edgecombe wrote:
> Write protect page tables with PKS. Toggle writeability inside the
> pgtable.h defined page table modifiction functions.
> 
> Do not protect the direct map page tables as it is more complicated and
> will come in a later patch.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/boot/compressed/ident_map_64.c |  5 ++
>  arch/x86/include/asm/pgtable.h          | 18 ++++++-
>  arch/x86/include/asm/pgtable_64.h       | 33 ++++++++++--
>  arch/x86/include/asm/pkeys_common.h     |  1 -
>  arch/x86/mm/pgtable.c                   | 71 ++++++++++++++++++++++---
>  arch/x86/mm/pkeys.c                     |  1 +
>  include/linux/pkeys.h                   |  1 +
>  mm/Kconfig                              |  6 +++
>  8 files changed, 123 insertions(+), 13 deletions(-)
 
...

> diff --git a/mm/Kconfig b/mm/Kconfig
> index 4184d0a7531d..0f8e8595a396 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -845,6 +845,12 @@ config ARCH_ENABLE_SUPERVISOR_PKEYS
>  	def_bool y
>  	depends on PKS_TEST || GENERAL_PKS_USER
>  
> +config PKS_PG_TABLES
> +	bool "PKS write protected page tables"
> +	select GENERAL_PKS_USER
> +	depends on !HIGHMEM && !X86_PAE && SPARSEMEM_VMEMMAP

Hmm, why is this x86-only feature is in mm/Kconfig?

> +	depends on ARCH_HAS_SUPERVISOR_PKEYS
> +
>  config PERCPU_STATS
>  	bool "Collect percpu memory statistics"
>  	help
> -- 
> 2.17.1
> 

-- 
Sincerely yours,
Mike.
