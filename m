Return-Path: <SRS0=iNz4=WB=lists.openwall.com=kernel-hardening-return-16713-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC702C0650F
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 17:29:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 230EE214C6
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Aug 2019 17:29:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="boGMj2jp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 230EE214C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16713-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26397 invoked by uid 550); 5 Aug 2019 17:29:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26379 invoked from network); 5 Aug 2019 17:29:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565026136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=UzPdUpvl0dRKl8TMGlyXuwODVXEURuPBgcAqGADqqlA=;
	b=boGMj2jpp6i9ocDKXpnCiTe/WAIP/gdEGzQ98H5WJGQg23ZuVuR23WOzIqPCm1l983a3fE
	jhLgXUcwmK2PHhOnFKlWihhyBRlkp3e85cLOaIaACpmSUx9chFUHFjiNMYrmwpVN496aMr
	Cbw+XyZ0dWKTd8PE4PZHeG/JAJv6kIc=
Date: Mon, 5 Aug 2019 19:28:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20190805172854.GF18785@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-5-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730191303.206365-5-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 30, 2019 at 12:12:48PM -0700, Thomas Garnier wrote:
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/entry/entry_64.S | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 3f5a978a02a7..4b588a902009 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1317,7 +1317,8 @@ ENTRY(error_entry)
>  	movl	%ecx, %eax			/* zero extend */
>  	cmpq	%rax, RIP+8(%rsp)
>  	je	.Lbstep_iret
> -	cmpq	$.Lgs_change, RIP+8(%rsp)
> +	leaq	.Lgs_change(%rip), %rcx
> +	cmpq	%rcx, RIP+8(%rsp)
>  	jne	.Lerror_entry_done
>  
>  	/*
> @@ -1514,10 +1515,10 @@ ENTRY(nmi)
>  	 * resume the outer NMI.
>  	 */
>  
> -	movq	$repeat_nmi, %rdx
> +	leaq	repeat_nmi(%rip), %rdx
>  	cmpq	8(%rsp), %rdx
>  	ja	1f
> -	movq	$end_repeat_nmi, %rdx
> +	leaq	end_repeat_nmi(%rip), %rdx
>  	cmpq	8(%rsp), %rdx
>  	ja	nested_nmi_out
>  1:
> @@ -1571,7 +1572,8 @@ nested_nmi:
>  	pushq	%rdx
>  	pushfq
>  	pushq	$__KERNEL_CS
> -	pushq	$repeat_nmi
> +	leaq	repeat_nmi(%rip), %rdx
> +	pushq	%rdx
>  
>  	/* Put stack back */
>  	addq	$(6*8), %rsp
> @@ -1610,7 +1612,11 @@ first_nmi:
>  	addq	$8, (%rsp)	/* Fix up RSP */
>  	pushfq			/* RFLAGS */
>  	pushq	$__KERNEL_CS	/* CS */
> -	pushq	$1f		/* RIP */
> +	pushq	$0		/* Future return address */
> +	pushq	%rax		/* Save RAX */
> +	leaq	1f(%rip), %rax	/* RIP */
> +	movq    %rax, 8(%rsp)   /* Put 1f on return address */
> +	popq	%rax		/* Restore RAX */

Can't you just use a callee-clobbered reg here instead of preserving
%rax?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
