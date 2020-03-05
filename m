Return-Path: <SRS0=JcPc=4W=lists.openwall.com=kernel-hardening-return-18070-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF24C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 03:22:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D89E1208C3
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 03:22:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D89E1208C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18070-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3672 invoked by uid 550); 5 Mar 2020 03:22:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3637 invoked from network); 5 Mar 2020 03:22:38 -0000
Subject: Re: [PATCH v3 0/6] implement KASLR for powerpc/fsl_booke/64
To: Scott Wood <oss@buserror.net>, Daniel Axtens <dja@axtens.net>,
	<mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <87tv3drf79.fsf@dja-thinkpad.axtens.net>
 <d673649d6f371e82d4a94ba62bfd0d44efeca7b4.camel@buserror.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <473e276e-ed72-b75b-9797-7845ee27db88@huawei.com>
Date: Thu, 5 Mar 2020 11:22:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <d673649d6f371e82d4a94ba62bfd0d44efeca7b4.camel@buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/3/5 5:21, Scott Wood 写道:
> On Wed, 2020-02-26 at 18:16 +1100, Daniel Axtens wrote:
>> Hi Jason,
>>
>>> This is a try to implement KASLR for Freescale BookE64 which is based on
>>> my earlier implementation for Freescale BookE32:
>>> https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=131718
>>>
>>> The implementation for Freescale BookE64 is similar as BookE32. One
>>> difference is that Freescale BookE64 set up a TLB mapping of 1G during
>>> booting. Another difference is that ppc64 needs the kernel to be
>>> 64K-aligned. So we can randomize the kernel in this 1G mapping and make
>>> it 64K-aligned. This can save some code to creat another TLB map at
>>> early boot. The disadvantage is that we only have about 1G/64K = 16384
>>> slots to put the kernel in.
>>>
>>>      KERNELBASE
>>>
>>>            64K                     |--> kernel <--|
>>>             |                      |              |
>>>          +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
>>>          |  |  |  |....|  |  |  |  |  |  |  |  |  |....|  |  |
>>>          +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
>>>          |                         |                        1G
>>>          |----->   offset    <-----|
>>>
>>>                                kernstart_virt_addr
>>>
>>> I'm not sure if the slot numbers is enough or the design has any
>>> defects. If you have some better ideas, I would be happy to hear that.
>>>
>>> Thank you all.
>>>
>>
>> Are you making any attempt to hide kernel address leaks in this series?
>> I've just been looking at the stackdump code just now, and it directly
>> prints link registers and stack pointers, which is probably enough to
>> determine the kernel base address:
>>
>>                    SPs:               LRs:             %pS pointer
>> [    0.424506] [c0000000de403970] [c000000001fc0458] dump_stack+0xfc/0x154
>> (unreliable)
>> [    0.424593] [c0000000de4039c0] [c000000000267eec] panic+0x258/0x5ac
>> [    0.424659] [c0000000de403a60] [c0000000024d7a00]
>> mount_block_root+0x634/0x7c0
>> [    0.424734] [c0000000de403be0] [c0000000024d8100]
>> prepare_namespace+0x1ec/0x23c
>> [    0.424811] [c0000000de403c60] [c0000000024d7010]
>> kernel_init_freeable+0x804/0x880
>>
>> git grep \\\"REG\\\" arch/powerpc shows a few other uses like this, all
>> in process.c or in xmon.
>>
>> Maybe replacing the REG format string in KASLR mode would be sufficient?
> 
> Whatever we decide to do here, it's not book3e-specific so it should be
> considered separately from these patches.
> 

OK, I will continue to work with this series.

> -Scott
> 
> 
> 
> .
> 

