Return-Path: <SRS0=MSZv=NW=lists.openwall.com=kernel-hardening-return-21371-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC532C432BE
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 03:50:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 092B661039
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Aug 2021 03:50:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 092B661039
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 32441 invoked by uid 550); 31 Aug 2021 03:50:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32409 invoked from network); 31 Aug 2021 03:50:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
	Subject:Sender:Reply-To:Content-ID:Content-Description;
	bh=lfVb8puVRcwGOE5PDLqOhyWo7XCfNi3oWP2MVkqEJUg=; b=4aaxxn1fX31IknqwFBEe/0Chss
	bpw5rJy6r5lR6Z2g44ldILvB3cUun0PMP+VQwvetUMvlAsqi00sjXNFmhim1/h4lxOXaiZGF5MfUr
	NeDDv7ktu6u5L/hym8/9PjKCXM+/wgYlaFGNbbw8DjNLR4eY6MduPR64HKuoyO/OhTCJ/jfl53lI4
	erPxqeUkWSkIE1NqolOIYGiTqvonADEjKsvciiVymftaTSv6AEGhjzv12Wfbh2EM80Nuu2LCY2WRb
	D4kmNPMSZC1gMnoI2LjSFlwSIN+HlSIU8I9rf+LXR0bSggIl4F0EogyNfYxYyTNJKxDpQ/2iLPnAF
	mjf10aaQ==;
Subject: Re: [RFC PATCH v2 18/19] x86/mm: Add PKS table soft mode
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
 luto@kernel.org, peterz@infradead.org, x86@kernel.org,
 akpm@linux-foundation.org, keescook@chromium.org, shakeelb@google.com,
 vbabka@suse.cz, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-hardening@vger.kernel.org,
 kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, linux-kernel@vger.kernel.org
References: <20210830235927.6443-1-rick.p.edgecombe@intel.com>
 <20210830235927.6443-19-rick.p.edgecombe@intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <052d20c6-347d-6340-1a62-d62bf53d3315@infradead.org>
Date: Mon, 30 Aug 2021 20:49:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210830235927.6443-19-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 8/30/21 4:59 PM, Rick Edgecombe wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 7902fce7f1da..8bb290fee77f 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -4254,6 +4254,10 @@
>   	nopti		[X86-64]
>   			Equivalent to pti=off
>   
> +	nopkstables	[X86-64] Disable PKS page table protection
> +
> +	pkstablessoft	[X86-64] Warn instead of oops on pks tables violations

preferably		                                 PKS

> +
>   	pty.legacy_count=
>   			[KNL] Number of legacy pty's. Overwrites compiled-in
>   			default number.


-- 
~Randy

