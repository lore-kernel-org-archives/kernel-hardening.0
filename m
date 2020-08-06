Return-Path: <SRS0=1ZX5=BQ=lists.openwall.com=kernel-hardening-return-19564-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACCFC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 03:24:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9756420792
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Aug 2020 03:24:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="L4XB6nyS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9756420792
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19564-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9298 invoked by uid 550); 6 Aug 2020 03:24:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9245 invoked from network); 6 Aug 2020 03:24:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=49z1+LbfP1EHSHgEOp6zvM41RF4pfO5OwrTaUPLGq48=;
        b=L4XB6nySvLkVi+tDRz+aVFN9lE8H84VaWRQI9BAqRXXdak9thdwmJjjjTgNzlDvW4J
         gMpjXWFmtTYc3PQ4pGwSnkXYbIxaLIfk1P5EvL88W+s2VQfm5bPTlD6QGSkV2KBpHbFV
         ixZWucTBUr7LvmVibQM4DI6H+LTBXuSNATnCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=49z1+LbfP1EHSHgEOp6zvM41RF4pfO5OwrTaUPLGq48=;
        b=iFxYHN+fvENq+QptF5wwQv1k9eWf/dGQ0+NNMn1creOtXs9He8/HItPl/Kj9PFFJTR
         NvSt1UUrHz3bhoVRpVnORCVFU40xDXweIwazCduyxmlwcKhXBwa7/VOk6yYqvfY72ibt
         QBwpyGn12KO/giV9YhVlS7zyhTw0e/cxCVxq31BEoAUcSIpgLv+GN4UxL2f9b6FDFYF9
         k5V9wAHVFxoylz0l7okVx/tAFuJMSdiEjpLajN0B1XElsVoB0P0MbPeku6xIUn/h8N0j
         7nZ70NS+zFC111UFULqDR4/jtRNlPkBPsQO3cW3ldWxp8zTAYo9FzjlC8AUVaFVfWVmq
         vuIQ==
X-Gm-Message-State: AOAM532q/CjDr6g75rcnHa0F2JXXuh+dCeHJl0x7Qjp/dNu/87R00qQT
	28h2NTjTrAcoWwkuzWdk5e4FOQ==
X-Google-Smtp-Source: ABdhPJxSs9CpbLd302YKlzGAw+TbSuhCbGjVK9m95qyXcoDgClcDijTfJJJP6G/XTsFMO3IjQGldVg==
X-Received: by 2002:a63:b90a:: with SMTP id z10mr5385445pge.277.1596684275018;
        Wed, 05 Aug 2020 20:24:35 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: "Christopher M. Riedl" <cmr@informatik.wtf>, linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2 2/5] powerpc/lib: Initialize a temporary mm for code patching
In-Reply-To: <20200709040316.12789-3-cmr@informatik.wtf>
References: <20200709040316.12789-1-cmr@informatik.wtf> <20200709040316.12789-3-cmr@informatik.wtf>
Date: Thu, 06 Aug 2020 13:24:31 +1000
Message-ID: <87lfiso3rk.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

"Christopher M. Riedl" <cmr@informatik.wtf> writes:

> When code patching a STRICT_KERNEL_RWX kernel the page containing the
> address to be patched is temporarily mapped with permissive memory
> protections. Currently, a per-cpu vmalloc patch area is used for this
> purpose. While the patch area is per-cpu, the temporary page mapping is
> inserted into the kernel page tables for the duration of the patching.
> The mapping is exposed to CPUs other than the patching CPU - this is
> undesirable from a hardening perspective.
>
> Use the `poking_init` init hook to prepare a temporary mm and patching
> address. Initialize the temporary mm by copying the init mm. Choose a
> randomized patching address inside the temporary mm userspace address
> portion. The next patch uses the temporary mm and patching address for
> code patching.
>
> Based on x86 implementation:
>
> commit 4fc19708b165
> ("x86/alternatives: Initialize temporary mm for patching")
>
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
> ---
>  arch/powerpc/lib/code-patching.c | 33 ++++++++++++++++++++++++++++++++
>  1 file changed, 33 insertions(+)
>
> diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
> index 0a051dfeb177..8ae1a9e5fe6e 100644
> --- a/arch/powerpc/lib/code-patching.c
> +++ b/arch/powerpc/lib/code-patching.c
> @@ -11,6 +11,8 @@
>  #include <linux/cpuhotplug.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <linux/sched/task.h>
> +#include <linux/random.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/page.h>
> @@ -44,6 +46,37 @@ int raw_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
>  }
>  
>  #ifdef CONFIG_STRICT_KERNEL_RWX
> +
> +static struct mm_struct *patching_mm __ro_after_init;
> +static unsigned long patching_addr __ro_after_init;
> +
> +void __init poking_init(void)
> +{
> +	spinlock_t *ptl; /* for protecting pte table */
> +	pte_t *ptep;
> +
> +	/*
> +	 * Some parts of the kernel (static keys for example) depend on
> +	 * successful code patching. Code patching under STRICT_KERNEL_RWX
> +	 * requires this setup - otherwise we cannot patch at all. We use
> +	 * BUG_ON() here and later since an early failure is preferred to
> +	 * buggy behavior and/or strange crashes later.
> +	 */
> +	patching_mm = copy_init_mm();
> +	BUG_ON(!patching_mm);
> +
> +	/*
> +	 * In hash we cannot go above DEFAULT_MAP_WINDOW easily.
> +	 * XXX: Do we want additional bits of entropy for radix?
> +	 */
> +	patching_addr = (get_random_long() & PAGE_MASK) %
> +		(DEFAULT_MAP_WINDOW - PAGE_SIZE);

It took me a while to understand this calculation. I see that it's
calculating a base address for a page in which to do patching. It does
the following:

 - get a random long

 - mask with PAGE_MASK so as to get a page aligned value

 - make sure that the base address is at least one PAGE_SIZE below
   DEFAULT_MAP_WINDOW so we have a clear page between the base and
   DEFAULT_MAP_WINDOW.

On 64-bit Book3S with 64K pages, that works out to be

PAGE_SIZE = 0x0000 0000 0001 0000
PAGE_MASK = 0xFFFF FFFF FFFF 0000

DEFAULT_MAP_WINDOW = DEFAULT_MAP_WINDOW_USER64 = TASK_SIZE_128TB
                   = 0x0000_8000_0000_0000

DEFAULT_MAP_WINDOW - PAGE_SIZE = 0x0000 7FFF FFFF 0000

It took a while (and a conversation with my wife who studied pure
maths!) but I am convinced that the modulo preserves the page-alignement
of the patching address.

One thing I did realise is that patching_addr can be zero at the end of
this process. That seems dubious and slightly error-prone to me - is
the patching process robust to that or should we exclude it?

Anyway, if I have the maths right, that there are 0x7fffffff or ~2
billion possible locations for the patching page, which is just shy of
31 bits of entropy.

I think this compares pretty favourably to most (K)ASLR implementations?

What's the range if built with 4k pages?

Kind regards,
Daniel

> +
> +	ptep = get_locked_pte(patching_mm, patching_addr, &ptl);
> +	BUG_ON(!ptep);
> +	pte_unmap_unlock(ptep, ptl);
> +}
> +
>  static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);
>  
>  static int text_area_cpu_up(unsigned int cpu)
> -- 
> 2.27.0
