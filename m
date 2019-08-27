Return-Path: <SRS0=HzZO=WZ=lists.openwall.com=kernel-hardening-return-16822-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DATE_IN_PAST_12_24,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C692C3A5A3
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 12:05:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 794822339E
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 12:05:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 794822339E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=buserror.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16822-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30175 invoked by uid 550); 29 Aug 2019 12:05:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10177 invoked from network); 28 Aug 2019 22:01:07 -0000
Date: Tue, 27 Aug 2019 17:07:52 -0500
From: Scott Wood <oss@buserror.net>
To: Jason Yan <yanaijie@huawei.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
	diana.craciun@nxp.com, christophe.leroy@c-s.fr,
	benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
	keescook@chromium.org, kernel-hardening@lists.openwall.com,
	wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
	jingxiangfeng@huawei.com, zhaohongjiang@huawei.com,
	thunder.leizhen@huawei.com, fanchengyang@huawei.com,
	yebin10@huawei.com
Message-ID: <20190827220752.GA17757@home.buserror.net>
References: <20190809100800.5426-1-yanaijie@huawei.com>
 <20190809100800.5426-5-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809100800.5426-5-yanaijie@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-SA-Exim-Connect-IP: 2601:449:8400:7293:12bf:48ff:fe84:c9a0
X-SA-Exim-Rcpt-To: yanaijie@huawei.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, jingxiangfeng@huawei.com, zhaohongjiang@huawei.com, thunder.leizhen@huawei.com, fanchengyang@huawei.com, yebin10@huawei.com
X-SA-Exim-Mail-From: oss@buserror.net
Subject: Re: [PATCH v6 04/12] powerpc/fsl_booke/32: introduce
 create_tlb_entry() helper
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on baldur.buserror.net)

On Fri, Aug 09, 2019 at 06:07:52PM +0800, Jason Yan wrote:
> Add a new helper create_tlb_entry() to create a tlb entry by the virtual
> and physical address. This is a preparation to support boot kernel at a
> randomized address.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
> Tested-by: Diana Craciun <diana.craciun@nxp.com>
> ---
>  arch/powerpc/kernel/head_fsl_booke.S | 29 ++++++++++++++++++++++++++++
>  arch/powerpc/mm/mmu_decl.h           |  1 +
>  2 files changed, 30 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
> index adf0505dbe02..04d124fee17d 100644
> --- a/arch/powerpc/kernel/head_fsl_booke.S
> +++ b/arch/powerpc/kernel/head_fsl_booke.S
> @@ -1114,6 +1114,35 @@ __secondary_hold_acknowledge:
>  	.long	-1
>  #endif
>  
> +/*
> + * Create a 64M tlb by address and entry
> + * r3/r4 - physical address
> + * r5 - virtual address
> + * r6 - entry
> + */
> +_GLOBAL(create_tlb_entry)

This function is broadly named but contains various assumptions about the
entry being created.  I'd just call it create_kaslr_tlb_entry.

> +	lis     r7,0x1000               /* Set MAS0(TLBSEL) = 1 */
> +	rlwimi  r7,r6,16,4,15           /* Setup MAS0 = TLBSEL | ESEL(r6) */
> +	mtspr   SPRN_MAS0,r7            /* Write MAS0 */
> +
> +	lis     r6,(MAS1_VALID|MAS1_IPROT)@h
> +	ori     r6,r6,(MAS1_TSIZE(BOOK3E_PAGESZ_64M))@l
> +	mtspr   SPRN_MAS1,r6            /* Write MAS1 */
> +
> +	lis     r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@h
> +	ori     r6,r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@l
> +	and     r6,r6,r5
> +	ori	r6,r6,MAS2_M@l
> +	mtspr   SPRN_MAS2,r6            /* Write MAS2(EPN) */
> +
> +	ori     r8,r4,(MAS3_SW|MAS3_SR|MAS3_SX)
> +	mtspr   SPRN_MAS3,r8            /* Write MAS3(RPN) */
> +
> +	tlbwe                           /* Write TLB */
> +	isync
> +	sync
> +	blr

Should set MAS7 under MMU_FTR_BIG_PHYS (or CONFIG_PHYS_64BIT if it's
too early for features) -- even if relocatable kernels over 4GiB aren't
supported (I don't remember if they work or not), MAS7 might be non-zero
on entry.  And the function claims to take a 64-bit phys addr as input...

MAS2_M should be MAS2_M_IF_NEEDED to match other kmem tlb entries.

-Scott
