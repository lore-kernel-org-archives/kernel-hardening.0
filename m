Return-Path: <SRS0=Q2Np=KA=lists.openwall.com=kernel-hardening-return-21237-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B8BC433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 08:16:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E43E661154
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 08:16:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E43E661154
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21237-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30539 invoked by uid 550); 5 May 2021 08:16:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30651 invoked from network); 5 May 2021 02:04:07 -0000
IronPort-SDR: LEZ5BU/PF/5OzbxYa7TVdZfhcD+VluKJ89ElNCBDqnYnnz5GZOkVprq0JbfAGGPmPR5SiHBhc/
 5mIhNlzfRXgA==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="218952839"
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="218952839"
IronPort-SDR: qmaz3lgwLJOIwgqsyrLKcWH5vSggMksDOP+oksXCm5BbW9SHf3O50ZGo68GJ2/kJ9Eakkp/MM5
 +XVO/SvgJHAw==
X-IronPort-AV: E=Sophos;i="5.82,273,1613462400"; 
   d="scan'208";a="621741505"
Date: Tue, 4 May 2021 19:03:53 -0700
From: Ira Weiny <ira.weiny@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rppt@kernel.org,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Message-ID: <20210505020353.GE1904484@iweiny-DESK2.sc.intel.com>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)

On Tue, May 04, 2021 at 05:30:23PM -0700, Rick Edgecombe wrote:
> 
> This is based on V6 [1] of the core PKS infrastructure patches. PKS 
> infrastructure follow-on’s are planned to enable keys to be set to the same 
> permissions globally. Since this usage needs a key to be set globally 
> read-only by default, a small temporary solution is hacked up in patch 8. Long 
> term, PKS protected page tables would use a better and more generic solution 
> to achieve this.

Before you send this out I've been thinking about this more and I think I would
prefer you not call this 'globally' setting the key.  Because you don't really
want to be able to update the key globally like I originally suggested for
kmap().  What is required is to set a different default for the key which gets
used by all threads by 'default'.

What is really missing is how to get the default changed after it may have been
used by some threads...  thus the 'global' nature...  Perhaps I am picking nits
here but I think it may go over better with Thomas and the maintainers.  Or
maybe not...  :-)

Would it be too much trouble to call this a 'default' change?  Because that is
really what you implement?

Ira
