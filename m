Return-Path: <SRS0=chPU=YO=lists.openwall.com=kernel-hardening-return-17074-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F9FCA9EB5
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 09:15:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BE75220873
	for <kernel-hardening@archiver.kernel.org>; Mon, 21 Oct 2019 09:15:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lhQih9us"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE75220873
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17074-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15587 invoked by uid 550); 21 Oct 2019 09:15:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15561 invoked from network); 21 Oct 2019 09:15:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571649340;
	bh=u7f4Jzabn9wcp0GNP0aGJ8DQeoDFxKaLNe/XQiZCh3g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lhQih9usCWZFyrqRYHSlhFjhOzTd6Wskq7PvLRgeauFSlUAkOb9TjhVjGtywqv+TS
	 uKESoqrQxNZATz+pnxmw/nrASmiA1G+0A1g5ydaZznLD8x5PPdC3hgLEcGiiZ8fgsI
	 gz8KGed6lyCT5vhLpEHmLLOxU3dFyX7GelMJ6vXM=
Date: Mon, 21 Oct 2019 18:15:34 +0900
From: Masami Hiramatsu <mhiramat@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel
 <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Kees Cook
 <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Mark Rutland
 <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Masami
 Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 11/18] kprobes: disable kretprobes with SCS
Message-Id: <20191021181534.4d8edb330e6fb19cd7f7e39f@kernel.org>
In-Reply-To: <20191018130429.5df61f6b@gandalf.local.home>
References: <20191018161033.261971-1-samitolvanen@google.com>
	<20191018161033.261971-12-samitolvanen@google.com>
	<20191018130429.5df61f6b@gandalf.local.home>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Oct 2019 13:04:29 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> [ Added Masami ]
> 
> On Fri, 18 Oct 2019 09:10:26 -0700
> Sami Tolvanen <samitolvanen@google.com> wrote:
> 
> > With CONFIG_KRETPROBES, function return addresses are modified to
> > redirect control flow to kretprobe_trampoline. This is incompatible with
> > return address protection.
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  arch/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index a222adda8130..4646e3b34925 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -171,7 +171,7 @@ config ARCH_USE_BUILTIN_BSWAP
> >  
> >  config KRETPROBES
> >  	def_bool y
> > -	depends on KPROBES && HAVE_KRETPROBES
> > +	depends on KPROBES && HAVE_KRETPROBES && ROP_PROTECTION_NONE
> 
> Again, this belongs in the arch code.

+1, below patch (from Steve) looks good to me.

Thank you,

> 
> -- Steve
> 
> >  
> >  config USER_RETURN_NOTIFIER
> >  	bool
> 
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 41a9b4257b72..65557d7e6b5e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -166,7 +166,7 @@ config ARM64
>  	select HAVE_STACKPROTECTOR
>  	select HAVE_SYSCALL_TRACEPOINTS
>  	select HAVE_KPROBES
> -	select HAVE_KRETPROBES
> +	select HAVE_KRETPROBES if ROP_PROTECTION_NONE
>  	select HAVE_GENERIC_VDSO
>  	select IOMMU_DMA if IOMMU_SUPPORT
>  	select IRQ_DOMAIN


-- 
Masami Hiramatsu <mhiramat@kernel.org>
