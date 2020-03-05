Return-Path: <SRS0=0y16=4W=lists.openwall.com=kernel-hardening-return-18069-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB282C3F2CE
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 03:21:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4047B2051A
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 03:21:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4047B2051A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18069-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1721 invoked by uid 550); 5 Mar 2020 03:20:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1689 invoked from network); 5 Mar 2020 03:20:57 -0000
Subject: Re: [PATCH v3 5/6] powerpc/fsl_booke/64: clear the original kernel if
 randomized
To: Scott Wood <oss@buserror.net>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<christophe.leroy@c-s.fr>, <benh@kernel.crashing.org>, <paulus@samba.org>,
	<npiggin@gmail.com>, <keescook@chromium.org>,
	<kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-6-yanaijie@huawei.com>
 <5737c82b1ab4c80e53904e4846694884ca429569.camel@buserror.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <71e25bac-bdf6-a754-c0f8-c9d99a393085@huawei.com>
Date: Thu, 5 Mar 2020 11:20:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <5737c82b1ab4c80e53904e4846694884ca429569.camel@buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/3/5 5:53, Scott Wood 写道:
> On Thu, 2020-02-06 at 10:58 +0800, Jason Yan wrote:
>> The original kernel still exists in the memory, clear it now.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Scott Wood <oss@buserror.net>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> ---
>>   arch/powerpc/mm/nohash/kaslr_booke.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c
>> b/arch/powerpc/mm/nohash/kaslr_booke.c
>> index c6f5c1db1394..ed1277059368 100644
>> --- a/arch/powerpc/mm/nohash/kaslr_booke.c
>> +++ b/arch/powerpc/mm/nohash/kaslr_booke.c
>> @@ -378,8 +378,10 @@ notrace void __init kaslr_early_init(void *dt_ptr,
>> phys_addr_t size)
>>   	unsigned int *__kaslr_offset = (unsigned int *)(KERNELBASE + 0x58);
>>   	unsigned int *__run_at_load = (unsigned int *)(KERNELBASE + 0x5c);
>>   
>> -	if (*__run_at_load == 1)
>> +	if (*__run_at_load == 1) {
>> +		kaslr_late_init();
>>   		return;
>> +	}
> 
> What if you're here because kexec set __run_at_load (or
> CONFIG_RELOCATABLE_TEST is enabled), not because kaslr happened?
> 

Nothing will happen because kaslr_late_init() only clears memory when
kernstart_virt_addr is not KERNELBASE. When __run_at_load is set then
KASLR will not take effect.

> -Scott
> 
> 
> 
> .
> 

