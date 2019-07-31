Return-Path: <SRS0=6Mto=V4=lists.openwall.com=kernel-hardening-return-16657-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40535C32750
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 02:07:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 91AB1206E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 02:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91AB1206E0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16657-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28345 invoked by uid 550); 31 Jul 2019 02:07:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28309 invoked from network); 31 Jul 2019 02:07:19 -0000
Subject: Re: [PATCH v2 07/10] powerpc/fsl_booke/32: randomize the kernel image
 offset
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>
References: <20190730074225.39544-1-yanaijie@huawei.com>
 <20190730074225.39544-8-yanaijie@huawei.com>
 <b41c4650-ef30-6f02-d5b3-bc95c5ad3ce0@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <ab36084e-6cce-89d6-52a7-5c5fe06642b8@huawei.com>
Date: Wed, 31 Jul 2019 10:06:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <b41c4650-ef30-6f02-d5b3-bc95c5ad3ce0@c-s.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/7/30 17:44, Christophe Leroy wrote:
> 
> 
> Le 30/07/2019 à 09:42, Jason Yan a écrit :
>> After we have the basic support of relocate the kernel in some
>> appropriate place, we can start to randomize the offset now.
>>
>> Entropy is derived from the banner and timer, which will change every
>> build and boot. This not so much safe so additionally the bootloader may
>> pass entropy via the /chosen/kaslr-seed node in device tree.
>>
>> We will use the first 512M of the low memory to randomize the kernel
>> image. The memory will be split in 64M zones. We will use the lower 8
>> bit of the entropy to decide the index of the 64M zone. Then we chose a
>> 16K aligned offset inside the 64M zone to put the kernel in.
>>
>>      KERNELBASE
>>
>>          |-->   64M   <--|
>>          |               |
>>          +---------------+    +----------------+---------------+
>>          |               |....|    |kernel|    |               |
>>          +---------------+    +----------------+---------------+
>>          |                         |
>>          |----->   offset    <-----|
>>
>>                                kimage_vaddr
>>
>> We also check if we will overlap with some areas like the dtb area, the
>> initrd area or the crashkernel area. If we cannot find a proper area,
>> kaslr will be disabled and boot from the original kernel.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> ---
>>   arch/powerpc/kernel/kaslr_booke.c | 334 +++++++++++++++++++++++++++++-
>>   1 file changed, 332 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/kernel/kaslr_booke.c 
>> b/arch/powerpc/kernel/kaslr_booke.c
>> index 960bce4aa8b9..0bb02e45b928 100644
>> --- a/arch/powerpc/kernel/kaslr_booke.c
>> +++ b/arch/powerpc/kernel/kaslr_booke.c
>> @@ -23,6 +23,8 @@
>>   #include <linux/delay.h>
>>   #include <linux/highmem.h>
>>   #include <linux/memblock.h>
>> +#include <linux/libfdt.h>
>> +#include <linux/crash_core.h>
>>   #include <asm/pgalloc.h>
>>   #include <asm/prom.h>
>>   #include <asm/io.h>
>> @@ -34,15 +36,341 @@
>>   #include <asm/machdep.h>
>>   #include <asm/setup.h>
>>   #include <asm/paca.h>
>> +#include <asm/kdump.h>
>>   #include <mm/mmu_decl.h>
>> +#include <generated/compile.h>
>> +#include <generated/utsrelease.h>
>> +
>> +#ifdef DEBUG
>> +#define DBG(fmt...) printk(KERN_ERR fmt)
>> +#else
>> +#define DBG(fmt...)
>> +#endif
>> +
>> +struct regions {
>> +    unsigned long pa_start;
>> +    unsigned long pa_end;
>> +    unsigned long kernel_size;
>> +    unsigned long dtb_start;
>> +    unsigned long dtb_end;
>> +    unsigned long initrd_start;
>> +    unsigned long initrd_end;
>> +    unsigned long crash_start;
>> +    unsigned long crash_end;
>> +    int reserved_mem;
>> +    int reserved_mem_addr_cells;
>> +    int reserved_mem_size_cells;
>> +};
>>   extern int is_second_reloc;
>> +/* Simplified build-specific string for starting entropy. */
>> +static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
>> +        LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
>> +
>> +static __init void kaslr_get_cmdline(void *fdt)
>> +{
>> +    const char *cmdline = CONFIG_CMDLINE;
>> +    if (!IS_ENABLED(CONFIG_CMDLINE_FORCE)) {
>> +        int node;
>> +        const u8 *prop;
>> +        node = fdt_path_offset(fdt, "/chosen");
>> +        if (node < 0)
>> +            goto out;
>> +
>> +        prop = fdt_getprop(fdt, node, "bootargs", NULL);
>> +        if (!prop)
>> +            goto out;
>> +        cmdline = prop;
>> +    }
>> +out:
>> +    strscpy(boot_command_line, cmdline, COMMAND_LINE_SIZE);
> 
> boot_command_line is set by early_init_devtree() in 
> arch/powerpc/kernel/prom.c
> Is that too late for you ?
> 

Yes, it's too late.

> If so, what about calling early_init_dt_scan_chosen() instead of recoding ?
> 

Good suggestion. I will have a try.

> Christophe
> 
> .
> 

