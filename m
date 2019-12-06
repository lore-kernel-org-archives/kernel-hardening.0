Return-Path: <SRS0=GXKb=Z4=lists.openwall.com=kernel-hardening-return-17470-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A558C43603
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 10:27:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 78E082173E
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Dec 2019 10:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tElAXxhI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 78E082173E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17470-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3991 invoked by uid 550); 6 Dec 2019 10:27:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3968 invoked from network); 6 Dec 2019 10:27:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=pdXLIKpg3JXjHzP1R+FhyT61kSYZ0R5GHtKm8shFGFY=; b=tElAXxhIaUE0cbbrKUyldTYeN
	rI5U06X2wbEhLBxKwUvD6Y5/FkkkENjC2P6PSRajEvjUDwLFVyldb/0+z9XceAOTsKl5J4fSE75Pp
	6ypHl1ezvB2BRFzZQhrQotRWQCyV188HJaFq+blO3CAUknapwqKSV3vcbY1StTau5db9lwA8I27Cm
	Erz2o/ktpuezAoT305MDh0W4ViYP2Q0wZa9QEAwX8GM184VDH/ubDuNr1PgPOiVSF97MK/kZR39/H
	cskmoRajoQsiqnsL9Khxfc8o9Ni4fM5xije0s0PVE8Yf8TY5mMwrnOKpZ3q6xONjmQovJzxQ2/H27
	M1wv2kA9w==;
Date: Fri, 6 Dec 2019 11:26:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20191206102649.GC2844@hirez.programming.kicks-ass.net>
References: <20191205000957.112719-1-thgarnie@chromium.org>
 <20191205000957.112719-5-thgarnie@chromium.org>
 <20191205090355.GC2810@hirez.programming.kicks-ass.net>
 <CAJcbSZF+vGE6ZseiQfcis2NMcimmpwvov_P-tZe--z5UxJPDdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZF+vGE6ZseiQfcis2NMcimmpwvov_P-tZe--z5UxJPDdg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Dec 05, 2019 at 09:01:50AM -0800, Thomas Garnier wrote:
> On Thu, Dec 5, 2019 at 1:04 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Dec 04, 2019 at 04:09:41PM -0800, Thomas Garnier wrote:
> >
> > > @@ -1625,7 +1627,11 @@ first_nmi:
> > >       addq    $8, (%rsp)      /* Fix up RSP */
> > >       pushfq                  /* RFLAGS */
> > >       pushq   $__KERNEL_CS    /* CS */
> > > -     pushq   $1f             /* RIP */
> > > +     pushq   $0              /* Future return address */
> >
> > We're building an IRET frame, the IRET frame does not have a 'future
> > return address' field.
> 
> I assumed that's the target RIP after iretq.

It is. But it's still the (R)IP field of the IRET frame. Calling it
anything else is just confusing. The frame is 5 words: SS, (R)SP, (R)FLAGS,
CS, (R)IP.

> > > +     pushq   %rdx            /* Save RAX */
> > > +     leaq    1f(%rip), %rdx  /* RIP */
> >
> > nonsensical comment
> 
> That was the same comment from the push $1f that I changed.

Yes, but there it made sense since the PUSH actually created that field
of the frame, here it is nonsensical. What this instruction does is put
the address of the '1f' label into RDX, which is then stuck into the
(R)IP field on the next instruction.

> > > +     movq    %rdx, 8(%rsp)   /* Put 1f on return address */
> > > +     popq    %rdx            /* Restore RAX */
