Return-Path: <SRS0=I5gi=4O=lists.openwall.com=kernel-hardening-return-17931-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54181C4BA0B
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 05:08:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A3D1B21556
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Feb 2020 05:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="KzpNUgHw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3D1B21556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17931-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16001 invoked by uid 550); 26 Feb 2020 05:08:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15969 invoked from network); 26 Feb 2020 05:08:32 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=KzpNUgHw; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1582693700; bh=P9F+TW11il3dDG/JQwLQZ9bfwJOcps3i7xL5sjC2o4k=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=KzpNUgHw2EtMqKovHHARDbs08RAkwUm4n5Wu+3xK7obpFJoYeDpkkR2JrZaMBRac3
	 oDrO1U0t9a5ip9BQfSego2phz4FrMb9Aej7Oi8Bstz+rh+2re6Xrg1AHfwm0fomAkx
	 p/P+J9gHqmSzukHZeTIOx2LnEQ/8Sd+bkMU6V4VU=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v3 3/6] powerpc/fsl_booke/64: implement KASLR for
 fsl_booke64
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com, oss@buserror.net
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-4-yanaijie@huawei.com>
 <41b9f1ca-c6fd-291a-2c96-2a0e8a754ec4@c-s.fr>
 <dbe0b316-40a2-7da4-c26b-e59efa555400@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <046ebac6-9cab-cc3e-e535-9a50051dc25f@c-s.fr>
Date: Wed, 26 Feb 2020 06:08:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <dbe0b316-40a2-7da4-c26b-e59efa555400@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 26/02/2020 à 03:40, Jason Yan a écrit :
> 
> 
> 在 2020/2/20 21:48, Christophe Leroy 写道:
>>
>>
>> Le 06/02/2020 à 03:58, Jason Yan a écrit :
>>>       /*
>>>        * Decide which 64M we want to start
>>>        * Only use the low 8 bits of the random seed
>>>        */
>>> -    index = random & 0xFF;
>>> +    unsigned long index = random & 0xFF;
>>
>> That's not good in terms of readability, index declaration should 
>> remain at the top of the function, should be possible if using 
>> IS_ENABLED() instead
> 
> I'm wondering how to declare a variable inside a code block such as if 
> (IS_ENABLED(CONFIG_PPC32)) at the top of the function and use the 
> variable in another if (IS_ENABLED(CONFIG_PPC32)). Is there any good idea?

You declare it outside the block as usual:

	unsigned long some_var;

	if (condition) {
		some_var = something;
	}
	do_many_things();
	do_other_things();

	if (condition)
		return some_var;
	else
		return 0;


Christophe
