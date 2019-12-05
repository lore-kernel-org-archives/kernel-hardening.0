Return-Path: <SRS0=GYR5=Z3=lists.openwall.com=kernel-hardening-return-17467-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C4AC43603
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 09:04:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 35BA5205ED
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Dec 2019 09:04:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VHHTxYpi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35BA5205ED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17467-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32563 invoked by uid 550); 5 Dec 2019 09:04:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32543 invoked from network); 5 Dec 2019 09:04:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=aSbWk7EeCpOIeMzv9/xkKVRKopCYH4/eSh8m9jVb3vY=; b=VHHTxYpiYZAEz9i8xE12I6Rb8
	rgRS896TtuujzBoN2nFGRRV80ROgK1VDafD7m9/MAsRTSce8r0gfFktZBwJmEnKyq6D+tCWB/wVFx
	ZduZOvp4x2W3Ytsh78jUHn0Zheprqm3szyYMITL1QBoNZoAVRBS/UXCM9KPSlcnqcEFE1L1VfxExE
	yB4/cvW5V3ZfdKypG1dUuA+kSZCCWWakLAGT6jY01pXUBUthu/hifAGswK0VBo20KtmCJoIWg7sun
	IXy5t0EsACo31AywxBKddaahDD60GwZNH9yGvvtWmG1PP5Ut+XajXe2SGt4BUVgG0XgxX4ZaEbQUH
	8vuS3Q5NA==;
Date: Thu, 5 Dec 2019 10:03:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20191205090355.GC2810@hirez.programming.kicks-ass.net>
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-5-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191205000957.112719-5-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Dec 04, 2019 at 04:09:41PM -0800, Thomas Garnier wrote:

> @@ -1625,7 +1627,11 @@ first_nmi:
>  	addq	$8, (%rsp)	/* Fix up RSP */
>  	pushfq			/* RFLAGS */
>  	pushq	$__KERNEL_CS	/* CS */
> -	pushq	$1f		/* RIP */
> +	pushq	$0		/* Future return address */

We're building an IRET frame, the IRET frame does not have a 'future
return address' field.

> +	pushq	%rdx		/* Save RAX */

fail..

> +	leaq	1f(%rip), %rdx	/* RIP */

nonsensical comment

> +	movq    %rdx, 8(%rsp)   /* Put 1f on return address */
> +	popq	%rdx		/* Restore RAX */

fail..

>  	iretq			/* continues at repeat_nmi below */
>  	UNWIND_HINT_IRET_REGS
>  1:
> -- 
> 2.24.0.393.g34dc348eaf-goog
> 
