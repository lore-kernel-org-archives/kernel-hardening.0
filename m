Return-Path: <SRS0=Lv8B=V3=lists.openwall.com=kernel-hardening-return-16632-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870C8C0650F
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 09:25:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D584320679
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 09:25:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="TZx1YxNl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D584320679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16632-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7533 invoked by uid 550); 30 Jul 2019 09:25:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7495 invoked from network); 30 Jul 2019 09:25:28 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=TZx1YxNl; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1564478716; bh=zrJuLYMZl8yMmLQ5arOArSoM6UnoE7nwuZhDCSwICX0=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=TZx1YxNl+aHzIHCeqfmgQSCd37IikeHQti8c8Fz4QiJ6R+8tmJ1SHzF52QfxLtJ7a
	 Jc9Jgy6ywynV3j+rHAxx2wHaH7ltod/8M33uPbFB23wrwhmxyKJSSr58SR2MpAC9jj
	 CNopfNTl5IWzOVK1RX/lo3kMNNv/gA904RkCznsI=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v2 02/10] powerpc: move memstart_addr and kernstart_addr
 to init-common.c
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
 fanchengyang@huawei.com, zhaohongjiang@huawei.com
References: <20190730074225.39544-1-yanaijie@huawei.com>
 <20190730074225.39544-3-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <98a0a18c-0a77-1ab1-d40a-f7de0b9c9009@c-s.fr>
Date: Tue, 30 Jul 2019 11:25:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730074225.39544-3-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 30/07/2019 à 09:42, Jason Yan a écrit :
> These two variables are both defined in init_32.c and init_64.c. Move
> them to init-common.c.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>

> ---
>   arch/powerpc/mm/init-common.c | 5 +++++
>   arch/powerpc/mm/init_32.c     | 5 -----
>   arch/powerpc/mm/init_64.c     | 5 -----
>   3 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
> index a84da92920f7..152ae0d21435 100644
> --- a/arch/powerpc/mm/init-common.c
> +++ b/arch/powerpc/mm/init-common.c
> @@ -21,6 +21,11 @@
>   #include <asm/pgtable.h>
>   #include <asm/kup.h>
>   
> +phys_addr_t memstart_addr = (phys_addr_t)~0ull;
> +EXPORT_SYMBOL_GPL(memstart_addr);
> +phys_addr_t kernstart_addr;
> +EXPORT_SYMBOL_GPL(kernstart_addr);
> +
>   static bool disable_kuep = !IS_ENABLED(CONFIG_PPC_KUEP);
>   static bool disable_kuap = !IS_ENABLED(CONFIG_PPC_KUAP);
>   
> diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
> index b04896a88d79..872df48ae41b 100644
> --- a/arch/powerpc/mm/init_32.c
> +++ b/arch/powerpc/mm/init_32.c
> @@ -56,11 +56,6 @@
>   phys_addr_t total_memory;
>   phys_addr_t total_lowmem;
>   
> -phys_addr_t memstart_addr = (phys_addr_t)~0ull;
> -EXPORT_SYMBOL(memstart_addr);
> -phys_addr_t kernstart_addr;
> -EXPORT_SYMBOL(kernstart_addr);
> -
>   #ifdef CONFIG_RELOCATABLE
>   /* Used in __va()/__pa() */
>   long long virt_phys_offset;
> diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
> index a44f6281ca3a..c836f1269ee7 100644
> --- a/arch/powerpc/mm/init_64.c
> +++ b/arch/powerpc/mm/init_64.c
> @@ -63,11 +63,6 @@
>   
>   #include <mm/mmu_decl.h>
>   
> -phys_addr_t memstart_addr = ~0;
> -EXPORT_SYMBOL_GPL(memstart_addr);
> -phys_addr_t kernstart_addr;
> -EXPORT_SYMBOL_GPL(kernstart_addr);
> -
>   #ifdef CONFIG_SPARSEMEM_VMEMMAP
>   /*
>    * Given an address within the vmemmap, determine the pfn of the page that
> 
