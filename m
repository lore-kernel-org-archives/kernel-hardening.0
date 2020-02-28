Return-Path: <SRS0=JQkI=4Q=lists.openwall.com=kernel-hardening-return-18005-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72A6C3F2CF
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 06:48:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 91936246A3
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 06:48:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91936246A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18005-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23554 invoked by uid 550); 28 Feb 2020 06:47:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22416 invoked from network); 28 Feb 2020 06:47:53 -0000
Subject: Re: [PATCH v3 0/6] implement KASLR for powerpc/fsl_booke/64
To: Scott Wood <oss@buserror.net>, Daniel Axtens <dja@axtens.net>,
	<mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <87tv3drf79.fsf@dja-thinkpad.axtens.net>
 <8171d326-5138-4f5c-cff6-ad3ee606f0c2@huawei.com>
 <e8cd8f287934954cfa07dcf76ac73492e2d49a5b.camel@buserror.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <dd8db870-b607-3f74-d3bc-a8d9f33f9852@huawei.com>
Date: Fri, 28 Feb 2020 14:47:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <e8cd8f287934954cfa07dcf76ac73492e2d49a5b.camel@buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/2/28 13:53, Scott Wood 写道:
> On Wed, 2020-02-26 at 16:18 +0800, Jason Yan wrote:
>> Hi Daniel,
>>
>> 在 2020/2/26 15:16, Daniel Axtens 写道:
>>> Hi Jason,
>>>
>>>> This is a try to implement KASLR for Freescale BookE64 which is based on
>>>> my earlier implementation for Freescale BookE32:
>>>> https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=131718
>>>>
>>>> The implementation for Freescale BookE64 is similar as BookE32. One
>>>> difference is that Freescale BookE64 set up a TLB mapping of 1G during
>>>> booting. Another difference is that ppc64 needs the kernel to be
>>>> 64K-aligned. So we can randomize the kernel in this 1G mapping and make
>>>> it 64K-aligned. This can save some code to creat another TLB map at
>>>> early boot. The disadvantage is that we only have about 1G/64K = 16384
>>>> slots to put the kernel in.
>>>>
>>>>       KERNELBASE
>>>>
>>>>             64K                     |--> kernel <--|
>>>>              |                      |              |
>>>>           +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
>>>>           |  |  |  |....|  |  |  |  |  |  |  |  |  |....|  |  |
>>>>           +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
>>>>           |                         |                        1G
>>>>           |----->   offset    <-----|
>>>>
>>>>                                 kernstart_virt_addr
>>>>
>>>> I'm not sure if the slot numbers is enough or the design has any
>>>> defects. If you have some better ideas, I would be happy to hear that.
>>>>
>>>> Thank you all.
>>>>
>>>
>>> Are you making any attempt to hide kernel address leaks in this series?
>>
>> Yes.
>>
>>> I've just been looking at the stackdump code just now, and it directly
>>> prints link registers and stack pointers, which is probably enough to
>>> determine the kernel base address:
>>>
>>>                     SPs:               LRs:             %pS pointer
>>> [    0.424506] [c0000000de403970] [c000000001fc0458] dump_stack+0xfc/0x154
>>> (unreliable)
>>> [    0.424593] [c0000000de4039c0] [c000000000267eec] panic+0x258/0x5ac
>>> [    0.424659] [c0000000de403a60] [c0000000024d7a00]
>>> mount_block_root+0x634/0x7c0
>>> [    0.424734] [c0000000de403be0] [c0000000024d8100]
>>> prepare_namespace+0x1ec/0x23c
>>> [    0.424811] [c0000000de403c60] [c0000000024d7010]
>>> kernel_init_freeable+0x804/0x880
>>>
>>> git grep \\\"REG\\\" arch/powerpc shows a few other uses like this, all
>>> in process.c or in xmon.
>>>
>>
>> Thanks for reminding this.
>>
>>> Maybe replacing the REG format string in KASLR mode would be sufficient?
>>>
>>
>> Most archs have removed the address printing when dumping stack. Do we
>> really have to print this?
>>
>> If we have to do this, maybe we can use "%pK" so that they will be
>> hidden from unprivileged users.
> 
> I've found the addresses to be useful, especially if I had a way to dump the
> stack data itself.  Wouldn't the register dump also be likely to give away the
> addresses?

If we have to print the address, then kptr_restrict and dmesg_restrict
must be set properly so that unprivileged users cannot see them.

> 
> I don't see any debug setting for %pK (or %p) to always print the actual
> address (closest is kptr_restrict=1 but that only works in certain
> contexts)... from looking at the code it seems it hashes even if kaslr is
> entirely disabled?  Or am I missing something?
> 

Yes, %pK (or %p) always hashes whether kaslr is disabled or not. So if
we want the real value of the address, we cannot use it. But if you only
want to distinguish if two pointers are the same, it's ok.

> -Scott
> 
> 
> 
> .
> 

