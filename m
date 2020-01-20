Return-Path: <SRS0=cfzS=3J=lists.openwall.com=kernel-hardening-return-17599-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05165C33CA1
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 08:35:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 57D6120684
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2020 08:35:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="pi9f6TM/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 57D6120684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=c-s.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17599-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13599 invoked by uid 550); 20 Jan 2020 08:35:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13561 invoked from network); 20 Jan 2020 08:35:17 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=pi9f6TM/; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1579509301; bh=byyZcxzdL9PR+hJEiI7kNW/TwgItiNGIa6x9MA2z3EQ=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=pi9f6TM/+rrGO39HuJdx14sJBDKQAJSMaiYHf7ubahWYdAGN7sJ3a3J/kqqQI3oIY
	 OAUMmk0upmj9M4yO+CfZatU0+Rdp6kWjg1YO0vysCy85NW/XoPTqi6EWJf1RkTKCXg
	 EFsZ6BnAjjku3PRAAwP9AopWKQ5Z653E3/j72H+Q=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v6 1/5] powerpc/mm: Implement set_memory() routines
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net,
 npiggin@gmail.com, kernel-hardening@lists.openwall.com
References: <20191224055545.178462-1-ruscur@russell.cc>
 <20191224055545.178462-2-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <b72d7a3b-5ef1-9628-5091-9c3e390c2c28@c-s.fr>
Date: Mon, 20 Jan 2020 09:35:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191224055545.178462-2-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 24/12/2019 à 06:55, Russell Currey a écrit :
> The set_memory_{ro/rw/nx/x}() functions are required for STRICT_MODULE_RWX,
> and are generally useful primitives to have.  This implementation is
> designed to be completely generic across powerpc's many MMUs.
> 
> It's possible that this could be optimised to be faster for specific
> MMUs, but the focus is on having a generic and safe implementation for
> now.
> 
> This implementation does not handle cases where the caller is attempting
> to change the mapping of the page it is executing from, or if another
> CPU is concurrently using the page being altered.  These cases likely
> shouldn't happen, but a more complex implementation with MMU-specific code
> could safely handle them, so that is left as a TODO for now.
> 
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
>   arch/powerpc/Kconfig                  |  1 +
>   arch/powerpc/include/asm/set_memory.h | 32 +++++++++++
>   arch/powerpc/mm/Makefile              |  1 +
>   arch/powerpc/mm/pageattr.c            | 83 +++++++++++++++++++++++++++
>   4 files changed, 117 insertions(+)
>   create mode 100644 arch/powerpc/include/asm/set_memory.h
>   create mode 100644 arch/powerpc/mm/pageattr.c
> 
> +static int __change_page_attr(pte_t *ptep, unsigned long addr, void *data)
> +{
> +	int action = *((int *)data);
> +	pte_t pte_val;

pte_val is really not a good naming, because pte_val() is already a 
function which returns the value of a pte_t var.

Here you should name it 'pte' as usual.

Christophe

> +
> +	// invalidate the PTE so it's safe to modify
> +	pte_val = ptep_get_and_clear(&init_mm, addr, ptep);
> +	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> +
> +	// modify the PTE bits as desired, then apply
> +	switch (action) {
> +	case SET_MEMORY_RO:
> +		pte_val = pte_wrprotect(pte_val);
> +		break;
> +	case SET_MEMORY_RW:
> +		pte_val = pte_mkwrite(pte_val);
> +		break;
> +	case SET_MEMORY_NX:
> +		pte_val = pte_exprotect(pte_val);
> +		break;
> +	case SET_MEMORY_X:
> +		pte_val = pte_mkexec(pte_val);
> +		break;
> +	default:
> +		WARN_ON(true);
> +		return -EINVAL;
> +	}
> +
> +	set_pte_at(&init_mm, addr, ptep, pte_val);
> +
> +	return 0;
> +}
> +
