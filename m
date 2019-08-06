Return-Path: <SRS0=sI+o=WC=lists.openwall.com=kernel-hardening-return-16724-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF33BC31E40
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 14:19:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4913B20818
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 14:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4913B20818
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16724-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25711 invoked by uid 550); 6 Aug 2019 14:18:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3730 invoked from network); 6 Aug 2019 14:00:31 -0000
Date: Tue, 6 Aug 2019 09:59:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20190806135942.xnuovr4vbanbxneb@home.goodmis.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-5-thgarnie@chromium.org>
 <20190805172854.GF18785@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805172854.GF18785@zn.tnic>
User-Agent: NeoMutt/20170113 (1.7.2)

On Mon, Aug 05, 2019 at 07:28:54PM +0200, Borislav Petkov wrote:
> >  1:
> > @@ -1571,7 +1572,8 @@ nested_nmi:
> >  	pushq	%rdx
> >  	pushfq
> >  	pushq	$__KERNEL_CS
> > -	pushq	$repeat_nmi
> > +	leaq	repeat_nmi(%rip), %rdx
> > +	pushq	%rdx
> >  
> >  	/* Put stack back */
> >  	addq	$(6*8), %rsp
> > @@ -1610,7 +1612,11 @@ first_nmi:
> >  	addq	$8, (%rsp)	/* Fix up RSP */
> >  	pushfq			/* RFLAGS */
> >  	pushq	$__KERNEL_CS	/* CS */
> > -	pushq	$1f		/* RIP */
> > +	pushq	$0		/* Future return address */
> > +	pushq	%rax		/* Save RAX */
> > +	leaq	1f(%rip), %rax	/* RIP */
> > +	movq    %rax, 8(%rsp)   /* Put 1f on return address */
> > +	popq	%rax		/* Restore RAX */
> 
> Can't you just use a callee-clobbered reg here instead of preserving
> %rax?

As Peter stated later in this thread, we only have the IRQ stack frame saved
here, because we just took an NMI, and this is the logic to determine if it
was a nested NMI or not (where we have to be *very* careful about touching the
stack!)

That said, the code modified here is to test the NMI nesting logic (only
enabled with CONFIG_DEBUG_ENTRY), and what it is doing is re-enabling NMIs
before calling the first NMI handler, to help trigger nested NMIs without the
need of a break point or page fault (iret enables NMIs again).

This code is in the path of the "first nmi" (we confirmed that this is not
nested), which means that it should be safe to push onto the stack.

Yes, we need to save and restore whatever reg we used. The only comment I
would make is to use %rdx instead of %rax as that has been our "scratch"
register used before saving pt_regs. Just to be consistent.

-- Steve


