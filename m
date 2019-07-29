Return-Path: <SRS0=Pzfh=V2=lists.openwall.com=kernel-hardening-return-16608-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F56AC433FF
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 11:39:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A1A1321655
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 11:39:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="CN1IqAJT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1A1321655
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16608-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31835 invoked by uid 550); 29 Jul 2019 11:39:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31802 invoked from network); 29 Jul 2019 11:39:10 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=CN1IqAJT; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1564400333; bh=nziOx+hsAmSgHaUew2nk7oKkm5bBxFcVZVeuZ8olOds=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=CN1IqAJT5TRTGPGfzxV/ACgvbI3nuqf2174u4PWQd9Ase9/M+vHqjqmWnrCYoIbw6
	 yE3FBsZeQZsCnTcqZazPFn2WiXxexkLpBBbomM3ozi46ukMJ3IxVZgdpmFES3H2pwh
	 4ivVSPPMX9Pw+vXzT5OWKhHUUUl7ClwZhgNV8iHg=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [RFC PATCH 09/10] powerpc/fsl_booke/kaslr: support nokaslr
 cmdline parameter
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
 fanchengyang@huawei.com
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-10-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <e31851fd-5032-2787-ea36-c48a7a6ebbe9@c-s.fr>
Date: Mon, 29 Jul 2019 13:38:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190717080621.40424-10-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 17/07/2019 à 10:06, Jason Yan a écrit :
> One may want to disable kaslr when boot, so provide a cmdline parameter
> 'nokaslr' to support this.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> ---
>   arch/powerpc/kernel/kaslr_booke.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/kaslr_booke.c b/arch/powerpc/kernel/kaslr_booke.c
> index 00339c05879f..e65a5d9d2ff1 100644
> --- a/arch/powerpc/kernel/kaslr_booke.c
> +++ b/arch/powerpc/kernel/kaslr_booke.c
> @@ -373,6 +373,18 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
>   	return kaslr_offset;
>   }
>   
> +static inline __init bool kaslr_disabled(void)
> +{
> +	char *str;
> +
> +	str = strstr(early_command_line, "nokaslr");

Why using early_command_line instead of boot_command_line ?


> +	if ((str == early_command_line) ||
> +	    (str > early_command_line && *(str - 1) == ' '))

Is that stuff really needed ?

Why not just:

return strstr(early_command_line, "nokaslr") != NULL;

> +		return true;
> +
> +	return false;
> +}


> +
>   /*
>    * To see if we need to relocate the kernel to a random offset
>    * void *dt_ptr - address of the device tree
> @@ -388,6 +400,8 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
>   	kernel_sz = (unsigned long)_end - KERNELBASE;
>   
>   	kaslr_get_cmdline(dt_ptr);
> +	if (kaslr_disabled())
> +		return;
>   
>   	offset = kaslr_choose_location(dt_ptr, size, kernel_sz);
>   
> 

Christophe
