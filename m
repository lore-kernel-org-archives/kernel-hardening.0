Return-Path: <SRS0=d2BI=WC=lists.openwall.com=kernel-hardening-return-16723-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4865FC433FF
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 12:36:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7D9BB2070D
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 12:36:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="rpYluB+0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D9BB2070D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16723-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17737 invoked by uid 550); 6 Aug 2019 12:36:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17717 invoked from network); 6 Aug 2019 12:36:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565094957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=/baoBnl555yEK9Sb0AHXq+5MmjYESUmH8xNQFOW4lcs=;
	b=rpYluB+0V9WpMd/PVZ3+lnW3sUMoHqX3/OAtZAipQtVETGnicb8fwic/jxg3R4vdx9YGBp
	JWr8HFtR6TEwF7XKf7B7+fLtI2QHPqT0yOpMp7QGcbY5mKNWmQBsRJUTsOkkDg5q+hCsPk
	cSEjGrrPvYUSyrMAXxKgUhhX/UE4Q2c=
Date: Tue, 6 Aug 2019 14:35:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Kees Cook <keescook@chromium.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20190806123552.GB25897@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-5-thgarnie@chromium.org>
 <20190805172854.GF18785@zn.tnic>
 <CAJcbSZGedSfZZ5rveH2+_3q7pvmMyDGLxmZU41Nno=ZBX8kN=w@mail.gmail.com>
 <20190806050851.GA25897@zn.tnic>
 <20190806083032.GN2332@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190806083032.GN2332@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)

+ rostedt.

Steve, pls have a look at the patch at the beginning of this thread as
it touches the reentrant NMI magic. :)

Thx.

On Tue, Aug 06, 2019 at 10:30:32AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 06, 2019 at 07:08:51AM +0200, Borislav Petkov wrote:
> > On Mon, Aug 05, 2019 at 10:50:30AM -0700, Thomas Garnier wrote:
> > > I saw that %rdx was used for temporary usage and restored before the
> > > end so I assumed that it was not an option.
> > 
> > PUSH_AND_CLEAR_REGS saves all regs earlier so I think you should be
> > able to use others. Like SAVE_AND_SWITCH_TO_KERNEL_CR3/RESTORE_CR3, for
> > example, uses %r15 and %r14.
> 
> AFAICT the CONFIG_DEBUG_ENTRY thing he's changing is before we setup
> pt_regs.
> 
> Also consider the UNWIND hint that's in there, it states we only have
> the IRET frame on stack, not a full regs set.

Ok, after discussing it on IRC, I guess let's leave it like that. I
guess little ugly is better than a lot more ugly if we're wanting to
attempt to free up some regs here to save us the rax preservation.
Probably not worth the effort by a long shot.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
