Return-Path: <SRS0=IZZZ=VX=lists.openwall.com=kernel-hardening-return-16591-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF97C7618B
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jul 2019 07:20:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 79AEC21852
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jul 2019 07:20:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79AEC21852
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16591-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21614 invoked by uid 550); 26 Jul 2019 07:20:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21580 invoked from network); 26 Jul 2019 07:20:49 -0000
Subject: Re: [RFC PATCH 00/10] implement KASLR for powerpc/fsl_booke/32
To: Kees Cook <keescook@chromium.org>
CC: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<kernel-hardening@lists.openwall.com>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <yebin10@huawei.com>,
	<thunder.leizhen@huawei.com>, <jingxiangfeng@huawei.com>,
	<fanchengyang@huawei.com>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <e6ad41bc-5d5a-cf3f-b308-e1863b4fef99@huawei.com>
 <201907251252.0C58037@keescook>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <877d818d-b3ec-1cea-d024-4ad6aea7af60@huawei.com>
Date: Fri, 26 Jul 2019 15:20:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <201907251252.0C58037@keescook>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/7/26 3:58, Kees Cook wrote:
> On Thu, Jul 25, 2019 at 03:16:28PM +0800, Jason Yan wrote:
>> Hi all, any comments?
> 
> I'm a fan of it, but I don't know ppc internals well enough to sanely
> review the code. :) Some comments below on design...
> 

Hi Kees, Thanks for your comments.

>>
>>
>> On 2019/7/17 16:06, Jason Yan wrote:
>>> This series implements KASLR for powerpc/fsl_booke/32, as a security
>>> feature that deters exploit attempts relying on knowledge of the location
>>> of kernel internals.
>>>
>>> Since CONFIG_RELOCATABLE has already supported, what we need to do is
>>> map or copy kernel to a proper place and relocate. Freescale Book-E
>>> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
>>> entries are not suitable to map the kernel directly in a randomized
>>> region, so we chose to copy the kernel to a proper place and restart to
>>> relocate.
>>>
>>> Entropy is derived from the banner and timer base, which will change every
>>> build and boot. This not so much safe so additionally the bootloader may
>>> pass entropy via the /chosen/kaslr-seed node in device tree.
> 
> Good: adding kaslr-seed is a good step here. Are there any x86-like
> RDRAND or RDTSC to use? (Or maybe timer base here is similar to x86
> RDTSC here?)
> 

Yes, time base is similar to RDTSC here.

>>>
>>> We will use the first 512M of the low memory to randomize the kernel
>>> image. The memory will be split in 64M zones. We will use the lower 8
>>> bit of the entropy to decide the index of the 64M zone. Then we chose a
>>> 16K aligned offset inside the 64M zone to put the kernel in.
> 
> Does this 16K granularity have any page table performance impact? My
> understanding was that x86 needed to have 2M granularity due to its page
> table layouts.
> 

The fsl booke TLB1 covers the whole low memeory. AFAIK, there is no page 
table performance impact. But if anyone knows there is any regressions, 
please let me know.

> Why the 64M zones instead of just 16K granularity across the entire low
> 512M?
> 

The boot code only maps one 64M zone at early start. If the kernel 
crosses two 64M zones, we need to map two 64M zones. Keep the kernel in 
one 64M saves a lot of complex codes.

>>>
>>>       KERNELBASE
>>>
>>>           |-->   64M   <--|
>>>           |               |
>>>           +---------------+    +----------------+---------------+
>>>           |               |....|    |kernel|    |               |
>>>           +---------------+    +----------------+---------------+
>>>           |                         |
>>>           |----->   offset    <-----|
>>>
>>>                                 kimage_vaddr
>>>
>>> We also check if we will overlap with some areas like the dtb area, the
>>> initrd area or the crashkernel area. If we cannot find a proper area,
>>> kaslr will be disabled and boot from the original kernel.
>>>
>>> Jason Yan (10):
>>>     powerpc: unify definition of M_IF_NEEDED
>>>     powerpc: move memstart_addr and kernstart_addr to init-common.c
>>>     powerpc: introduce kimage_vaddr to store the kernel base
>>>     powerpc/fsl_booke/32: introduce create_tlb_entry() helper
>>>     powerpc/fsl_booke/32: introduce reloc_kernel_entry() helper
>>>     powerpc/fsl_booke/32: implement KASLR infrastructure
>>>     powerpc/fsl_booke/32: randomize the kernel image offset
>>>     powerpc/fsl_booke/kaslr: clear the original kernel if randomized
>>>     powerpc/fsl_booke/kaslr: support nokaslr cmdline parameter
>>>     powerpc/fsl_booke/kaslr: dump out kernel offset information on panic
> 
> Is there anything planned for other fixed-location things, like x86's
> CONFIG_RANDOMIZE_MEMORY?
> 

Yes, if this feature can be accepted, I will start to work with 
powerpc64 KASLR and other things like CONFIG_RANDOMIZE_MEMORY.

