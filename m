Return-Path: <SRS0=A7xt=NW=lists.openwall.com=kernel-hardening-return-21372-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AD7C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:32:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7288D60FE8
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 08:32:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7288D60FE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 3676 invoked by uid 550); 31 Aug 2021 08:32:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3638 invoked from network); 31 Aug 2021 08:32:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1630398729;
	bh=evRy179bA9/yF8IFACzwu79Pv8G7Hn/vmDMfFNnIDds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nUWc85PzOUfu58a67bCq3zLnpotGlucdv25Co68sYPw13DDY2QqjInNinhSIXkC6C
	 DbnhBVMTmrMYYWgG82O+cImQk6JA1unTdfTh6kTeHuU5arv15HGS6SmkTFLwExzj1y
	 DVGbaMMIcxpadue42kaoIADOxXS7yUz9GW9hNwMaAXjXuAsgasPHVzX/ndJOzkiV/k
	 pPOmlpHqD4x3KC2oBFgrQR2zdvpU1LrBPzs70DfPCCAb4InxK6SXtSKX3TEf0LQzVv
	 QJc8XGeKkwQUfXDxCoPsueI1oEBte9nX431PsWrtoi87Addeeg2xIK0g5sxOznHoPL
	 1IWJTV8WhSttw==
Date: Tue, 31 Aug 2021 11:32:01 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	x86@kernel.org, akpm@linux-foundation.org, keescook@chromium.org,
	shakeelb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 09/19] x86/mm: Support GFP_ATOMIC in
 alloc_table_node()
Message-ID: <YS3pAXxjRtAIeq8b@kernel.org>
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <20210830235927.6443-10-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830235927.6443-10-rick.p.edgecombe@intel.com>

On Mon, Aug 30, 2021 at 04:59:17PM -0700, Rick Edgecombe wrote:
> For GFP_ATOMIC in alloc_table/_node(), use get_grouped_page_atomic().

I think the patch that adds get_grouped_page_atomic() and this one can be
merged.
 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/mm/pgtable.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index ef0b4ce95522..e65d69ad6e0c 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -52,7 +52,10 @@ struct page *alloc_table(gfp_t gfp)
>  		return table;
>  	}
>  
> -	table = get_grouped_page(numa_node_id(), &gpc_pks);
> +	if (gfp & GFP_ATOMIC)
> +		table = get_grouped_page_atomic(numa_node_id(), &gpc_pks);
> +	else
> +		table = get_grouped_page(numa_node_id(), &gpc_pks);
>  	if (!table)
>  		return NULL;
>  	__SetPageTable(table);
> -- 
> 2.17.1
> 

-- 
Sincerely yours,
Mike.
