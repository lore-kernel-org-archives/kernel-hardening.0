Return-Path: <SRS0=ryy/=ZL=lists.openwall.com=kernel-hardening-return-17400-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDDBC43141
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2019 21:44:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D43792240E
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 Nov 2019 21:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CskvMQnM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D43792240E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17400-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16267 invoked by uid 550); 19 Nov 2019 21:44:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16247 invoked from network); 19 Nov 2019 21:44:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=hEs8XB3Y6sr5dsTMlOy3Hk1jBfgLbuzBiCtYU82IvOM=; b=CskvMQnM/3qww5l3SSio73ihq
	6uvAZeiu/mVQOwJHSS5LkfQhpuRYDG/YrVcAeB3DC1gSx/8ziAzsfg2qyMmu4sajlQ800hBM7XNxY
	lhzeeB3LBtC2xRqm/bstiC++DOSf24hCfypWE/QyFrZB2APcuOHP/Yj5ksLcY4i7GJvPX6B+7KONB
	hGUhcWlalsV53G68h8jaCMFXJlbFm+sZ84n5KATQ+d5ZtGoqBkfkmUaDFjG8VJxG8mBIU+cJq4LPE
	sU5WM4DfUYVBQKchaBifM6CTE9fRPEJ0NuNQsrqnPSxeFw18ZRnqivFpmbX1xpns7+5ehqGtgPrns
	zjSsRCT5Q==;
Date: Tue, 19 Nov 2019 22:43:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Tianlin Li <tli@digitalocean.com>, kernel-hardening@lists.openwall.com,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Greentime Hu <green.hu@gmail.com>,
	Vincent Chen <deanbo422@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Jessica Yu <jeyu@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [RFC PATCH] kernel/module: have the callers of set_memory_*()
 check the return value
Message-ID: <20191119214351.GQ3079@worktop.programming.kicks-ass.net>
References: <20191119155149.20396-1-tli@digitalocean.com>
 <201911190849.131691D@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911190849.131691D@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 19, 2019 at 09:07:34AM -0800, Kees Cook wrote:
> > diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
> > index bda949fd84e8..7ea1338821d6 100644
> > --- a/arch/arm/kernel/ftrace.c
> > +++ b/arch/arm/kernel/ftrace.c
> > @@ -59,13 +59,15 @@ static unsigned long adjust_address(struct dyn_ftrace *rec, unsigned long addr)
> >  
> >  int ftrace_arch_code_modify_prepare(void)
> >  {
> > -	set_all_modules_text_rw();
> > -	return 0;
> > +	return set_all_modules_text_rw();
> >  }
> >  
> >  int ftrace_arch_code_modify_post_process(void)
> >  {
> > -	set_all_modules_text_ro();
> > +	int ret;
> 
> Blank line here...
> 
> > +	ret = set_all_modules_text_ro();
> > +	if (ret)
> > +		return ret;
> >  	/* Make sure any TLB misses during machine stop are cleared. */
> >  	flush_tlb_all();
> >  	return 0;
> 
> Are callers of these ftrace functions checking return values too?

Aside from the fact that I just deleted the set_all_modules_text_*()
functions, ftrace actually does check the return value. It prvides a
nice WARN and kills ftrace dead.

> > diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
> > index 171773257974..97a89c38f6b9 100644
> > --- a/arch/arm64/kernel/ftrace.c
> > +++ b/arch/arm64/kernel/ftrace.c
> > @@ -115,9 +115,11 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
> >  			}
> >  
> >  			/* point the trampoline to our ftrace entry point */
> > -			module_disable_ro(mod);
> > +			if (module_disable_ro(mod))
> > +				return -EINVAL;
> >  			*dst = trampoline;
> > -			module_enable_ro(mod, true);
> > +			if (module_enable_ro(mod, true))
> > +				return -EINVAL;
> >  
> >  			/*
> >  			 * Ensure updated trampoline is visible to instruction

Patching dead code again:

  https://lkml.kernel.org/r/20191029165832.33606-5-mark.rutland@arm.com


