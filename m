Return-Path: <SRS0=n9oB=4O=lists.openwall.com=kernel-hardening-return-17927-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61EDC4BA06
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 02:46:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1AE6E2082F
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 02:46:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AE6E2082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17927-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20382 invoked by uid 550); 26 Feb 2020 02:46:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20350 invoked from network); 26 Feb 2020 02:46:25 -0000
Subject: Re: [PATCH v3 6/6] powerpc/fsl_booke/kaslr: rename kaslr-booke32.rst
 to kaslr-booke.rst and add 64bit part
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-7-yanaijie@huawei.com>
 <77c4a404-3ce5-5090-bbff-aaca71507146@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <1b1c7659-2eb0-81ab-78e1-061c1e300986@huawei.com>
Date: Wed, 26 Feb 2020 10:46:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <77c4a404-3ce5-5090-bbff-aaca71507146@c-s.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/2/20 21:50, Christophe Leroy 写道:
> 
> 
> Le 06/02/2020 à 03:58, Jason Yan a écrit :
>> Now we support both 32 and 64 bit KASLR for fsl booke. Add document for
>> 64 bit part and rename kaslr-booke32.rst to kaslr-booke.rst.
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
>>   .../{kaslr-booke32.rst => kaslr-booke.rst}    | 35 ++++++++++++++++---
>>   1 file changed, 31 insertions(+), 4 deletions(-)
>>   rename Documentation/powerpc/{kaslr-booke32.rst => kaslr-booke.rst} 
>> (59%)
> 
> Also update Documentation/powerpc/index.rst ?
> 

Oh yes, thanks for reminding me of this.

Thanks,
Jason

> Christophe
> 
> .

