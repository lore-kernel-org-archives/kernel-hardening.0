Return-Path: <SRS0=Vy0q=WD=lists.openwall.com=kernel-hardening-return-16731-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF93C31E40
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Aug 2019 03:22:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 79767217D9
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Aug 2019 03:22:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79767217D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16731-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3420 invoked by uid 550); 7 Aug 2019 03:22:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3388 invoked from network); 7 Aug 2019 03:22:42 -0000
Subject: Re: [PATCH v4 09/10] powerpc/fsl_booke/kaslr: support nokaslr cmdline
 parameter
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>
References: <20190805064335.19156-1-yanaijie@huawei.com>
 <20190805064335.19156-10-yanaijie@huawei.com>
 <e7703798-c2e2-c75f-1001-46c01db88238@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <3a83c812-ac14-3e89-241e-eeade105d23e@huawei.com>
Date: Wed, 7 Aug 2019 11:22:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <e7703798-c2e2-c75f-1001-46c01db88238@c-s.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/6 15:59, Christophe Leroy wrote:
> 
> 
> Le 05/08/2019 à 08:43, Jason Yan a écrit :
>> One may want to disable kaslr when boot, so provide a cmdline parameter
>> 'nokaslr' to support this.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
>> Tested-by: Diana Craciun <diana.craciun@nxp.com>
> 
> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> Tiny comment below.
> 
>> ---
>>   arch/powerpc/kernel/kaslr_booke.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/arch/powerpc/kernel/kaslr_booke.c 
>> b/arch/powerpc/kernel/kaslr_booke.c
>> index 4b3f19a663fc..7c3cb41e7122 100644
>> --- a/arch/powerpc/kernel/kaslr_booke.c
>> +++ b/arch/powerpc/kernel/kaslr_booke.c
>> @@ -361,6 +361,18 @@ static unsigned long __init 
>> kaslr_choose_location(void *dt_ptr, phys_addr_t size
>>       return kaslr_offset;
>>   }
>> +static inline __init bool kaslr_disabled(void)
>> +{
>> +    char *str;
>> +
>> +    str = strstr(boot_command_line, "nokaslr");
>> +    if ((str == boot_command_line) ||
>> +        (str > boot_command_line && *(str - 1) == ' '))
>> +        return true;
> 
> I don't think additional () are needed for the left part 'str == 
> boot_command_line'
> 

Agree.

>> +
>> +    return false;
>> +}
>> +
>>   /*
>>    * To see if we need to relocate the kernel to a random offset
>>    * void *dt_ptr - address of the device tree
>> @@ -376,6 +388,8 @@ notrace void __init kaslr_early_init(void *dt_ptr, 
>> phys_addr_t size)
>>       kernel_sz = (unsigned long)_end - KERNELBASE;
>>       kaslr_get_cmdline(dt_ptr);
>> +    if (kaslr_disabled())
>> +        return;
>>       offset = kaslr_choose_location(dt_ptr, size, kernel_sz);
>>
> 
> .
> 

