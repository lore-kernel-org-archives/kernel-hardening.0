Return-Path: <SRS0=nh42=25=lists.openwall.com=kernel-hardening-return-17552-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F390DC282DD
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jan 2020 16:49:21 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 517A520692
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jan 2020 16:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="egBuE1zI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 517A520692
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17552-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19530 invoked by uid 550); 8 Jan 2020 16:49:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19496 invoked from network); 8 Jan 2020 16:49:14 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=egBuE1zI; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1578502141; bh=fDLf2Lbvma1ro6euRU/zp5f/MAKJXOINHS68Q4Ro8U4=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=egBuE1zIY1PsLgbe954KQXy9/itY9Eqwe36YBGMFHa1PUpNnUC7uhP4kXsVFIJjgr
	 oYEA6UiZrikmE8WfXbsE9sImVVXBYeMyQhgDnjx4tFEfuAu+9SQogBqSDrwDPcHtVF
	 hiE6nieL29hN/VIjsHDYCrrp+8JGUSZWD7pXWPnc=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v6 2/5] powerpc/kprobes: Mark newly allocated probes as RO
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net,
 npiggin@gmail.com, kernel-hardening@lists.openwall.com
References: <20191224055545.178462-1-ruscur@russell.cc>
 <20191224055545.178462-3-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <51b9b43b-9f25-bb68-93f2-cd5ba7d67f38@c-s.fr>
Date: Wed, 8 Jan 2020 17:48:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191224055545.178462-3-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 24/12/2019 à 06:55, Russell Currey a écrit :
> With CONFIG_STRICT_KERNEL_RWX=y and CONFIG_KPROBES=y, there will be one
> W+X page at boot by default.  This can be tested with
> CONFIG_PPC_PTDUMP=y and CONFIG_PPC_DEBUG_WX=y set, and checking the
> kernel log during boot.
> 
> powerpc doesn't implement its own alloc() for kprobes like other
> architectures do, but we couldn't immediately mark RO anyway since we do
> a memcpy to the page we allocate later.  After that, nothing should be
> allowed to modify the page, and write permissions are removed well
> before the kprobe is armed.
> 
> The memcpy() would fail if >1 probes were allocated, so use
> patch_instruction() instead which is safe for RO.
> 
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
>   arch/powerpc/kernel/kprobes.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
> index 2d27ec4feee4..b72761f0c9e3 100644
> --- a/arch/powerpc/kernel/kprobes.c
> +++ b/arch/powerpc/kernel/kprobes.c
> @@ -24,6 +24,7 @@
>   #include <asm/sstep.h>
>   #include <asm/sections.h>
>   #include <linux/uaccess.h>
> +#include <linux/set_memory.h>
>   
>   DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>   DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> @@ -124,13 +125,14 @@ int arch_prepare_kprobe(struct kprobe *p)
>   	}
>   
>   	if (!ret) {
> -		memcpy(p->ainsn.insn, p->addr,
> -				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> +		patch_instruction(p->ainsn.insn, *p->addr);
>   		p->opcode = *p->addr;
>   		flush_icache_range((unsigned long)p->ainsn.insn,
>   			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));

patch_instruction() already does the flush, no need to flush again with 
flush_icache_range()

>   	}
>   
> +	set_memory_ro((unsigned long)p->ainsn.insn, 1);
> +

I don't really understand, why do you need to set this ro ? Or why do 
you need to change the memcpy() to patch_instruction() if the area is 
not already ro ?

If I understand correctly, p->ainsn.insn is within a special executable 
page allocated via module_alloc(). Wouldn't it be more correct to modify 
kprobe get_insn_slot() logic so that allocated page is ROX instead of RWX ?

>   	p->ainsn.boostable = 0;
>   	return ret;
>   }
> 

Christophe
