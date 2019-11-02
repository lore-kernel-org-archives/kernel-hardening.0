Return-Path: <SRS0=Aobh=Y2=lists.openwall.com=kernel-hardening-return-17251-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEABCA9EC7
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Nov 2019 10:45:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F2FFA20679
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 Nov 2019 10:45:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="jU8HtMgP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2FFA20679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17251-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27737 invoked by uid 550); 2 Nov 2019 10:45:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27690 invoked from network); 2 Nov 2019 10:45:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
	s=201909; t=1572691520;
	bh=Jtyqd/wuFAS1+Aoh4ImFCwFhrDrs+nQrk2XwCSuohFM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jU8HtMgPJ5LVOjaQcPJMyylrWpWUU1hddriM0diG7HPFhaqMSKxA47FydNm0U3BE2
	 7BOLrxB9DPxAEzRxBiGhApn4cLGOF/Ml2YMDs3ua2+fUlqmnefxqyeYqeF1EcbgLxi
	 XsnnFrXMxEUbIAzBD1enonawlvRDZ18ZvtL1TZ8Re1el5XkHNn1U9se5Ch4VpbBgYb
	 6GxBJmnV9ADH6BfdClBQsuQb31o/6yB2HYM1hiLRyoxOf5mB9rMv5GzWdHyA+vvWwP
	 lzzN+hrl024/OdwXL1S/yRGgKO2IlYjC/ba/kMkd/qEstWj8PfWUg+bm58oc10thsw
	 wrAXoNSVTSfGA==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>, christophe.leroy@c-s.fr, joel@jms.id.au, ajd@linux.ibm.com, dja@axtens.net, npiggin@gmail.com, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 2/5] powerpc/kprobes: Mark newly allocated probes as RO
In-Reply-To: <20191030073111.140493-3-ruscur@russell.cc>
References: <20191030073111.140493-1-ruscur@russell.cc> <20191030073111.140493-3-ruscur@russell.cc>
Date: Sat, 02 Nov 2019 21:45:18 +1100
Message-ID: <8736f636bl.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain

Russell Currey <ruscur@russell.cc> writes:
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
> Thus mark newly allocated probes as read-only once it's safe to do so.
>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
>  arch/powerpc/kernel/kprobes.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
> index 2d27ec4feee4..2610496de7c7 100644
> --- a/arch/powerpc/kernel/kprobes.c
> +++ b/arch/powerpc/kernel/kprobes.c
> @@ -24,6 +24,7 @@
>  #include <asm/sstep.h>
>  #include <asm/sections.h>
>  #include <linux/uaccess.h>
> +#include <linux/set_memory.h>
>  
>  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> @@ -131,6 +132,8 @@ int arch_prepare_kprobe(struct kprobe *p)
>  			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
>  	}
>  
> +	set_memory_ro((unsigned long)p->ainsn.insn, 1);
> +

That comes from:
	p->ainsn.insn = get_insn_slot();


Which ends up in __get_insn_slot() I think. And that looks very much
like it's going to hand out multiple slots per page, which isn't going
to work because you've just marked the whole page RO.

So I would expect this to crash on the 2nd kprobe that's installed. Have
you tested it somehow?

I think this code should just use patch_instruction() rather than
memcpy().

cheers
