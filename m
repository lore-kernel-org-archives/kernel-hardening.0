Return-Path: <SRS0=gw3P=4V=lists.openwall.com=kernel-hardening-return-18057-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07DBC3F2D1
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Mar 2020 09:22:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB52F20732
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Mar 2020 09:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LDG8TcPS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB52F20732
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18057-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28320 invoked by uid 550); 4 Mar 2020 09:22:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28300 invoked from network); 4 Mar 2020 09:22:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Xz1gqS8mHQf0FeXfh5Zn6ODmAjqLlTi3e7QpQPXzA9Q=; b=LDG8TcPSz6KerDK5RXGKXHL0+s
	nd+daixZ03zWZPBsZex2W0SE2BU+bLdvHBFIbasjYsjLE9O6AcvIE4aklaE3c2rh36+IES5zOiJKo
	CZHk/ZIgcOCzatmD7F0LvmIA2106SZonTNmKrjs8DuOvT6kzu3GSWHE0zWKaxMKARsPaQGewBXixa
	ItobUKdK8g+0ymqN8mZ30rSgQf5HEI0PdCrTHBXpOW9woanZqUxWXgFDIr91oXYH//OaNr2XpNsGu
	Foq59USFJcUjcKrB2RUG0sl7wBvbaaaFVwnCCFfz9rz8IvgRMTSRUVdUbDAj+EcyeoS8xmPTFub7+
	KssVL8pg==;
Date: Wed, 4 Mar 2020 10:21:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Cao jin <caoj.fnst@cn.fujitsu.com>,
	Allison Randal <allison@lohutok.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	virtualization@lists.linux-foundation.org,
	Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <20200304092136.GI2596@hirez.programming.kicks-ass.net>
References: <20200228000105.165012-1-thgarnie@chromium.org>
 <202003022100.54CEEE60F@keescook>
 <20200303095514.GA2596@hirez.programming.kicks-ass.net>
 <CAJcbSZH1oON2VC2U8HjfC-6=M-xn5eU+JxHG2575iMpVoheKdA@mail.gmail.com>
 <6e7e4191612460ba96567c16b4171f2d2f91b296.camel@linux.intel.com>
 <202003031314.1AFFC0E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003031314.1AFFC0E@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 03, 2020 at 01:19:22PM -0800, Kees Cook wrote:
> On Tue, Mar 03, 2020 at 01:01:26PM -0800, Kristen Carlson Accardi wrote:
> > On Tue, 2020-03-03 at 07:43 -0800, Thomas Garnier wrote:
> > > On Tue, Mar 3, 2020 at 1:55 AM Peter Zijlstra <peterz@infradead.org>

> > > > But,... do we still need this in the light of that fine-grained
> > > > kaslr
> > > > stuff?
> > > > 
> > > > What is the actual value of this PIE crud in the face of that?
> > > 
> > > If I remember well, it makes it easier/better but I haven't seen a
> > > recent update on that. Is that accurate Kees?
> > 
> > I believe this patchset is valuable if people are trying to brute force
> > guess the kernel location, but not so awesome in the event of
> > infoleaks. In the case of the current fgkaslr implementation, we only
> > randomize within the existing text segment memory area - so with PIE
> > the text segment base can move around more, but within that it wouldn't
> > strengthen anything. So, if you have an infoleak, you learn the base
> > instantly, and are just left with the same extra protection you get
> > without PIE.
> 
> Right -- PIE improves both non- and fg- KASLR similarly, in the sense
> that the possible entropy for base offset is expanded. It also opens the
> door to doing even more crazy things. 

So I'm really confused. I see it increases the aslr range, but I'm still
not sure why we care in the face of fgkaslr. Current kaslr is completely
broken because the hardware leaks more bits than we currently have, even
without the kernel itself leaking an address.

But leaking a single address is not a problem with fgkaslr.

> (e.g. why keep the kernel text all
> in one contiguous chunk?)

Dear gawd, please no. Also, we're limited to 2G text, that's just not a
lot of room. I'm really going to object when people propose we introduce
direct PLT for x86.

> And generally speaking, it seems a nice improvement to me, as it gives
> the kernel greater addressing flexibility.

But at what cost; it does unspeakable ugly to the asm. And didn't a
kernel compiled with the extended PIE range produce a measurably slower
kernel due to all the ugly?

So maybe I'm slow, but please spell out the benefit, because I'm not
seeing it.
