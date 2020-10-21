Return-Path: <SRS0=8cRg=D4=lists.openwall.com=kernel-hardening-return-20241-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6027AC4363A
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:51:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5039422249
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cb1INmmj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5039422249
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20241-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20070 invoked by uid 550); 21 Oct 2020 09:51:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20041 invoked from network); 21 Oct 2020 09:51:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603273858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AXksiluvhYqlJrwQaYz1rE1CqU+tBOKw7Qr8hWu6eF8=;
	b=cb1INmmjqi9NdbcSTjotX2YS8rktG036JercS5YmeYiCWqw9hWEvml86Z0m7Zckg/5M/Zn
	U3UvGTkJQmoDvylmvAMa1H86nUZOQOlJP98uH/fIWQOIuXe5f+x5YYISetq4dS4yd+Q6rW
	xthIFAOaE5euW+G9vakxl/3yCgWzULU=
X-MC-Unique: qzseyaqoPSGju6oe_YyKmA-1
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
To: Michal Hocko <mhocko@suse.com>,
 "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 linux-security-module@vger.kernel.org, kernel@gpiccoli.net,
 cascardo@canonical.com, Alexander Potapenko <glider@google.com>,
 James Morris <jamorris@linux.microsoft.com>,
 Kees Cook <keescook@chromium.org>
References: <20201019182853.7467-1-gpiccoli@canonical.com>
 <20201020082022.GL27114@dhcp22.suse.cz>
 <9cecd9d9-e25c-4495-50e2-8f7cb7497429@canonical.com>
 <20201021061538.GA23790@dhcp22.suse.cz>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <0ad2f879-7c72-3eef-5cb6-dee44265eb82@redhat.com>
Date: Wed, 21 Oct 2020 11:50:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201021061538.GA23790@dhcp22.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 21.10.20 08:15, Michal Hocko wrote:
> On Tue 20-10-20 16:19:06, Guilherme G. Piccoli wrote:
>> On 20/10/2020 05:20, Michal Hocko wrote:
>>>
>>> Yes zeroying is quite costly and that is to be expected when the feature
>>> is enabled. Hugetlb like other allocator users perform their own
>>> initialization rather than go through __GFP_ZERO path. More on that
>>> below.
>>>
>>> Could you be more specific about why this is a problem. Hugetlb pool is
>>> usualy preallocatd once during early boot. 24s for 65GB of 2MB pages
>>> is non trivial amount of time but it doens't look like a major disaster
>>> either. If the pool is allocated later it can take much more time due to
>>> memory fragmentation.
>>>
>>> I definitely do not want to downplay this but I would like to hear about
>>> the real life examples of the problem.
>>
>> Indeed, 24s of delay (!) is not so harmful for boot time, but...64G was
>> just my simple test in a guest, the real case is much worse! It aligns
>> with Mike's comment, we have complains of minute-like delays, due to a
>> very big pool of hugepages being allocated.
> 
> The cost of page clearing is mostly a constant overhead so it is quite
> natural to see the time scaling with the number of pages. That overhead
> has to happen at some point of time. Sure it is more visible when
> allocating during boot time resp. when doing pre-allocation during
> runtime. The page fault path would be then faster. The overhead just
> moves to a different place. So I am not sure this is really a strong
> argument to hold.

We have people complaining that starting VMs backed by hugetlbfs takes
too long, they would much rather have that initialization be done when
booting the hypervisor ...

so looks like there is no right or wrong.


-- 
Thanks,

David / dhildenb

