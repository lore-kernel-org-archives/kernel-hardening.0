Return-Path: <SRS0=tFIU=WZ=lists.openwall.com=kernel-hardening-return-16815-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 739CCC3A5A1
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 02:41:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BE4C522CF5
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 02:41:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE4C522CF5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16815-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18149 invoked by uid 550); 29 Aug 2019 02:41:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18115 invoked from network); 29 Aug 2019 02:41:42 -0000
Subject: Re: [PATCH v6 00/12] implement KASLR for powerpc/fsl_booke/32
To: Scott Wood <oss@buserror.net>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<christophe.leroy@c-s.fr>, <benh@kernel.crashing.org>, <paulus@samba.org>,
	<npiggin@gmail.com>, <keescook@chromium.org>,
	<kernel-hardening@lists.openwall.com>
CC: <wangkefeng.wang@huawei.com>, <linux-kernel@vger.kernel.org>,
	<jingxiangfeng@huawei.com>, <zhaohongjiang@huawei.com>,
	<thunder.leizhen@huawei.com>, <fanchengyang@huawei.com>, <yebin10@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com>
 <a39b81562bcdeda7ffe0c2c29a60ff08c77047a6.camel@buserror.net>
 <143e5a85bc630d2bb0324114e78bedec8fbeb299.camel@buserror.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <30a034e9-898c-5734-cf8b-c8704cdb42c5@huawei.com>
Date: Thu, 29 Aug 2019 10:41:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <143e5a85bc630d2bb0324114e78bedec8fbeb299.camel@buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/28 12:59, Scott Wood wrote:
> On Tue, 2019-08-27 at 23:05 -0500, Scott Wood wrote:
>> On Fri, 2019-08-09 at 18:07 +0800, Jason Yan wrote:
>>>   Freescale Book-E
>>> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
>>> entries are not suitable to map the kernel directly in a randomized
>>> region, so we chose to copy the kernel to a proper place and restart to
>>> relocate.
>>>
>>> Entropy is derived from the banner and timer base, which will change every
>>> build and boot. This not so much safe so additionally the bootloader may
>>> pass entropy via the /chosen/kaslr-seed node in device tree.
>>
>> How complicated would it be to directly access the HW RNG (if present) that
>> early in the boot?  It'd be nice if a U-Boot update weren't required (and
>> particularly concerning that KASLR would appear to work without a U-Boot
>> update, but without decent entropy).
> 
> OK, I see that kaslr-seed is used on some other platforms, though arm64 aborts
> KASLR if it doesn't get a seed.  I'm not sure if that's better than a loud
> warning message (or if it was a conscious choice rather than just not having
> an alternative implemented), but silently using poor entropy for something
> like this seems bad.
> 

It can still make the attacker's cost higher with not so good entropy.
The same strategy exists in X86 when X86 KASLR uses RDTSC if without
X86_FEATURE_RDRAND supported. I agree that having a warning message
looks better for reminding people in this situation.

> -Scott
> 
> 
> 
> .
> 

