Return-Path: <SRS0=FUug=YX=lists.openwall.com=kernel-hardening-return-17174-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E9D7CA9EC5
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 19:28:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4F08320717
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Oct 2019 19:28:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="TrJAltYS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4F08320717
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17174-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25705 invoked by uid 550); 30 Oct 2019 19:28:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25669 invoked from network); 30 Oct 2019 19:28:30 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=TrJAltYS; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1572463698; bh=ETokkupD46fOqlNm37kOMe+hG1J9xpIjHaEC+LfiVeY=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=TrJAltYSIt4J02S1w/Mp4rD1r8mebAnu7YyWhYjgDw3eJ74nOa6jTB1PVKY7/BSfr
	 kPMowTuZeTwMxpwoFdyQYhtzf5g9XwqAc2INQ2OSu8do83JzS/TjO4EUWDhndJdPUZ
	 r3Yt3G+byPB+HhmB0cZuEPwv1Tx3HiAK7Szz6n3E=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v5 0/5] Implement STRICT_MODULE_RWX for powerpc
To: Kees Cook <keescook@chromium.org>
Cc: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org,
 joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net,
 npiggin@gmail.com, kernel-hardening@lists.openwall.com
References: <20191030073111.140493-1-ruscur@russell.cc>
 <53461d29-ec0c-4401-542e-6d575545da38@c-s.fr>
 <201910301128.E7552CDD@keescook>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <776c0722-eb8c-622a-a70b-f19ae07c1dc3@c-s.fr>
Date: Wed, 30 Oct 2019 20:28:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <201910301128.E7552CDD@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 30/10/2019 à 19:30, Kees Cook a écrit :
> On Wed, Oct 30, 2019 at 09:58:19AM +0100, Christophe Leroy wrote:
>>
>>
>> Le 30/10/2019 à 08:31, Russell Currey a écrit :
>>> v4 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198268.html
>>> v3 cover letter: https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html
>>>
>>> Changes since v4:
>>> 	[1/5]: Addressed review comments from Michael Ellerman (thanks!)
>>> 	[4/5]: make ARCH_HAS_STRICT_MODULE_RWX depend on
>>> 	       ARCH_HAS_STRICT_KERNEL_RWX to simplify things and avoid
>>> 	       STRICT_MODULE_RWX being *on by default* in cases where
>>> 	       STRICT_KERNEL_RWX is *unavailable*
>>> 	[5/5]: split skiroot_defconfig changes out into its own patch
>>>
>>> The whole Kconfig situation is really weird and confusing, I believe the
>>> correct resolution is to change arch/Kconfig but the consequences are so
>>> minor that I don't think it's worth it, especially given that I expect
>>> powerpc to have mandatory strict RWX Soon(tm).
>>
>> I'm not such strict RWX can be made mandatory due to the impact it has on
>> some subarches:
>> - On the 8xx, unless all areas are 8Mbytes aligned, there is a significant
>> overhead on TLB misses. And Aligning everthing to 8M is a waste of RAM which
>> is not acceptable on systems having very few RAM.
>> - On hash book3s32, we are able to map the kernel BATs. With a few alignment
>> constraints, we are able to provide STRICT_KERNEL_RWX. But we are unable to
>> provide exec protection on page granularity. Only on 256Mbytes segments. So
>> for modules, we have to have the vmspace X. It is also not possible to have
>> a kernel area RO. Only user areas can be made RO.
> 
> As I understand it, the idea was for it to be mandatory (or at least
> default-on) only for the subarches where it wasn't totally insane to
> accomplish. :) (I'm not familiar with all the details on the subarchs,
> but it sounded like the more modern systems would be the targets for
> this?)
> 

Yes I guess so.

I was just afraid by "I expect powerpc to have mandatory strict RWX"

By the way, we have an open issue #223 namely 'Make strict kernel RWX 
the default on 64-bit', so no worry as 32-bit is aside for now.

Christophe
