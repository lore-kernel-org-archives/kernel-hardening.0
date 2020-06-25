Return-Path: <SRS0=Amzz=AG=lists.openwall.com=kernel-hardening-return-19160-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C07C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 07:47:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0615120789
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 07:47:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UIuIqigV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0615120789
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19160-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32062 invoked by uid 550); 25 Jun 2020 07:47:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32030 invoked from network); 25 Jun 2020 07:47:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jlp9yRmob93dOT2KqKFc9+KfQV0pPJXXFdCgHBP2kM0=; b=UIuIqigVl3WX7R1skgg/Iif4x9
	hy/pTl2n1RYBArKVSpmY8DjS2unkPxAVMZxi3vZw7HkiMQ+Q+KOu3kiQG6sz78NeMA4DjcPNCGbbC
	ieWTzZr/0PFbRVojQSNhSqU5Ygr0XL2gN/oeuqxuiR3yrMqgmnRta6jruo86RnRYVv3F8szsLT28j
	IJP5z91KUq5xvrgosAkmgdhmv1RD+jV8oL87ketaFGyEAK09VPwLfB5LapFSpaYn4XQkDKv3Z97sc
	mhFdebUs1E6/vlLnkbP5Ta5PkZAqSKNE5SxdS4jK+SauMNXF8v8mFghUbAWe7Ae9OCr1g2cf+23N+
	DBACpvNw==;
Date: Thu, 25 Jun 2020 09:47:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 05/22] kbuild: lto: postpone objtool
Message-ID: <20200625074716.GX4817@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-6-samitolvanen@google.com>
 <20200624211908.GT4817@hirez.programming.kicks-ass.net>
 <20200624214925.GB120457@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624214925.GB120457@google.com>

On Wed, Jun 24, 2020 at 02:49:25PM -0700, Sami Tolvanen wrote:
> On Wed, Jun 24, 2020 at 11:19:08PM +0200, Peter Zijlstra wrote:
> > On Wed, Jun 24, 2020 at 01:31:43PM -0700, Sami Tolvanen wrote:
> > > diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> > > index 30827f82ad62..12b115152532 100644
> > > --- a/include/linux/compiler.h
> > > +++ b/include/linux/compiler.h
> > > @@ -120,7 +120,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
> > >  /* Annotate a C jump table to allow objtool to follow the code flow */
> > >  #define __annotate_jump_table __section(.rodata..c_jump_table)
> > >  
> > > -#ifdef CONFIG_DEBUG_ENTRY
> > > +#if defined(CONFIG_DEBUG_ENTRY) || defined(CONFIG_LTO_CLANG)
> > >  /* Begin/end of an instrumentation safe region */
> > >  #define instrumentation_begin() ({					\
> > >  	asm volatile("%c0:\n\t"						\
> > 
> > Why would you be doing noinstr validation for lto builds? That doesn't
> > make sense.
> 
> This is just to avoid a ton of noinstr warnings when we run objtool on
> vmlinux.o, but I'm also fine with skipping noinstr validation with LTO.

Right, then we need to make --no-vmlinux work properly when
!DEBUG_ENTRY, which I think might be buggered due to us overriding the
argument when the objname ends with "vmlinux.o".

> > > +ifdef CONFIG_STACK_VALIDATION
> > > +ifneq ($(SKIP_STACK_VALIDATION),1)
> > > +cmd_ld_ko_o +=								\
> > > +	$(objtree)/tools/objtool/objtool				\
> > > +		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
> > > +		--module						\
> > > +		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
> > > +		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
> > > +		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
> > > +		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
> > > +		$(@:.ko=$(prelink-ext).o);
> > > +
> > > +endif # SKIP_STACK_VALIDATION
> > > +endif # CONFIG_STACK_VALIDATION
> > 
> > What about the objtool invocation from link-vmlinux.sh ?
> 
> What about it? The existing objtool_link invocation in link-vmlinux.sh
> works fine for our purposes as well.

Well, I was wondering why you're adding yet another objtool invocation
while we already have one.
