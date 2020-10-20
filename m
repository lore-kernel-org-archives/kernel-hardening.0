Return-Path: <SRS0=MRTU=D3=lists.openwall.com=kernel-hardening-return-20233-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	WEIRD_QUOTING autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F516C4363A
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Oct 2020 20:28:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 235F32225D
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Oct 2020 20:28:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q/nBTQvi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 235F32225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20233-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1084 invoked by uid 550); 20 Oct 2020 20:28:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1064 invoked from network); 20 Oct 2020 20:28:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603225703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPILpp6FHi1zJqT7K9xMImIrq/rzkU2lwDcVkjxIePA=;
	b=Q/nBTQviOZJb+QKwDNZvNfij+I2wXmwP3Hll+MLfA7QcQuYOPv0BLNtmuI+h3VLMWpK+jn
	uvrQ0Rir+RoPTcQIRau9D+bCwKzX4NmxH3BzFBVhIUW1cdiYy/J8IO8o+pM6JgAYla0KQX
	TJAT2YOIqRmxz815sFXtWRQxQLrzSJE=
X-MC-Unique: qZSV0rcZOjy8Ylkzihq2ww-1
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
From: David Hildenbrand <david@redhat.com>
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org, linux-security-module@vger.kernel.org,
 kernel@gpiccoli.net, cascardo@canonical.com,
 Alexander Potapenko <glider@google.com>,
 James Morris <jamorris@linux.microsoft.com>,
 Kees Cook <keescook@chromium.org>
References: <20201019182853.7467-1-gpiccoli@canonical.com>
 <20201020082022.GL27114@dhcp22.suse.cz>
 <9cecd9d9-e25c-4495-50e2-8f7cb7497429@canonical.com>
 <5650dc95-4ae2-05d3-c71a-3828d35bd49b@redhat.com>
Organization: Red Hat GmbH
Message-ID: <8b282de8-a324-6d9e-8d04-b370196ad0be@redhat.com>
Date: Tue, 20 Oct 2020 22:28:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <5650dc95-4ae2-05d3-c71a-3828d35bd49b@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 20.10.20 22:07, David Hildenbrand wrote:
> On 20.10.20 21:19, Guilherme G. Piccoli wrote:
>> Hi Michal, thanks a lot for your thorough response. I'll address the
>> comments inline, below. Thanks also David and Mike - in fact, I almost
>> don't need to respond here after Mike, he was right to the point I'm
>> going to discuss heh...
>>
>>
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
>>
>> Users have their own methodology for allocating pages, some would prefer
>> do that "later" for a variety of reasons, so early boot time allocations
>> are not always used, that shouldn't be the only focus of the discussion
>> here.
>> In the specific report I had, the user complains about more than 3
>> minutes to allocate ~542G of 2M hugetlb pages.
>>
>> Now, you'll ask why in the heck they are using init_on_alloc then -
>> right? So, the Kconfig option "CONFIG_INIT_ON_ALLOC_DEFAULT_ON" is set
>> by default in Ubuntu, for hardening reasons. So, the workaround for the
>> users complaining of delays in allocating hugetlb pages currently is to
>> set "init_on_alloc" to 0. It's a bit lame to ask users to disable such
>> hardening thing just because we have a double initialization in hugetlb...
>>
>>
>>>
>>>
>>> This has been discussed already (http://lkml.kernel.org/r/20190514143537.10435-4-glider@google.com.
>>> Previously it has been brought up in SLUB context AFAIR. Your numbers
>>> are quite clear here but do we really need a gfp flag with all the
>>> problems we tend to grow in with them?
>>>
>>> One potential way around this specifically for hugetlb would be to use
>>> __GFP_ZERO when allocating from the allocator and marking the fact in
>>> the struct page while it is sitting in the pool. Page fault handler
>>> could then skip the zeroying phase. Not an act of beauty TBH but it
>>> fits into the existing model of the full control over initialization.
>>> Btw. it would allow to implement init_on_free semantic as well. I
>>> haven't implemented the actual two main methods
>>> hugetlb_test_clear_pre_init_page and hugetlb_mark_pre_init_page because
>>> I am not entirely sure about the current state of hugetlb struct page in
>>> the pool. But there should be a lot of room in there (or in tail pages).
>>> Mike will certainly know much better. But the skeleton of the patch
>>> would look like something like this (not even compile tested).
>>> [code...]
>>
>> Thanks a lot for pointing the previous discussion for me! I should have
>> done my homework properly and read all versions of the patchset...my
>> bad! I'm glad to see this problem was discussed and considered early in
>> the patch submission, I guess it only missed more real-world numbers.
>>
>> Your approach seems interesting, but as per Mike's response (which seems
>> to have anticipated all my arguments heheh) your approach is a bit
>> reversed, solving a ""non-existent"" problem (of zeroing hugetlb pages
>> in fault time), whereas the big problem hereby tentatively fixed is the
>> massive delay on allocation time of the hugetlb pages.
>>
>> I understand that your suggestion has no burden of introducing more GFP
>> flags, and I agree that those are potentially dangerous if misused (and
>> I totally agree with David that __GFP_NOINIT_ON_ALLOC is heinous, I'd
>> rather go with the originally proposed __GFP_NO_AUTOINIT), but...
>> wouldn't it be letting the code just drive a design decision? Like "oh,
>> adding a flag is so bad..better just let this bug/perf issue to stay".
> 
> The main problem I have is that page alloc code does some internal page
> allocator things ("init_on_alloc" - "Fill newly allocated pages and heap
> objects with zeroes"), and we're allowing users of page alloc code *that
> really shouldn't have to care* to override that behavior, exposing
> unnecessary complexity. Mainly: other allocators.
> 
> "__GFP_NOINIT_ON_ALLOC" - what exactly does it do?
> "__GFP_NO_AUTOINIT" - what exactly does it do?
> 
> __GFP_ZERO set: page always zero.
> __GFP_ZERO not set: page zero with init_on_alloc, page not necessarily
>                     zero without init_on_alloc. Users can find out by 	
>                     looking at init_on_alloc.
> 
> IMHO, even something like __GFP_DONT_ZERO would be clearer. But I still
> somewhat don't like letting users of the buddy override configured
> behavior. Yes, it could be used by other alloactors (like hugetlb) to
> optimize.
> 
> But it could also be used by any driver wanting to optimize the
> "init_on_alloc" case, eventually introducing security issues because the
> code tries to be smart.
> 

BTW, there might be other users for something like __GFP_DONT_ZERO.

Especially, memory ballooning drivers (and virtio-mem), whereby the
hypervisor is (WHP) going to zap the page either way after allocation.
You just cannot assume that when freeing such a page again, that it's
actually zero.

But then, somebody told the system to suffer ("alloc_on_init"), so there
isn't too much motivation to optimize such corner cases.

-- 
Thanks,

David / dhildenb

