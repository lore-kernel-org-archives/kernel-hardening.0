Return-Path: <SRS0=gHco=4U=lists.openwall.com=kernel-hardening-return-18048-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AE3C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 09:56:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4300C21556
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Mar 2020 09:56:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zrXbi+1X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4300C21556
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18048-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17725 invoked by uid 550); 3 Mar 2020 09:56:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17705 invoked from network); 3 Mar 2020 09:56:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xjAYzYZJidsTEHXSs//Oe4SJs+qAxcjB8dKxwUENenQ=; b=zrXbi+1XYsYg1hOUfgotstGR1s
	A/yiklisppTF0E9uRLa0vly9Whs1m5MF6QXAFqbz0RIOZTQ3IBkvmXEsEzAH7H4G/eUNCE9COhaKf
	Jt1sB06ShmrP6pL5etFIXieKzux9rI1PRF59uv6SLpF0G2BI2GBcdWRCspKTvO/2p1jLRtrNUi6Sh
	HA8kSw8UO5dmWtltons0CLJ0nXm+Y659s9TY0lr4a4KSUKIjb7SJaBWwJIkbCrpzdLCOQb8EEI+W+
	eVFHzpAPkRg2pOXnstpM7fhlRyhkazF7U53uvuy8CCxYkEUPSwaZ6iuVSdlA2OHKAJpd7ZHKu3O6I
	dRuWKx+w==;
Date: Tue, 3 Mar 2020 10:55:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
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
	Allison Randal <allison@lohutok.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <20200303095514.GA2596@hirez.programming.kicks-ass.net>
References: <20200228000105.165012-1-thgarnie@chromium.org>
 <202003022100.54CEEE60F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003022100.54CEEE60F@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 02, 2020 at 09:02:15PM -0800, Kees Cook wrote:
> On Thu, Feb 27, 2020 at 04:00:45PM -0800, Thomas Garnier wrote:
> > Minor changes based on feedback and rebase from v10.
> > 
> > Splitting the previous serie in two. This part contains assembly code
> > changes required for PIE but without any direct dependencies with the
> > rest of the patchset.
> > 
> > Note: Using objtool to detect non-compliant PIE relocations is not yet
> > possible as this patchset only includes the simplest PIE changes.
> > Additional changes are needed in kvm, xen and percpu code.
> > 
> > Changes:
> >  - patch v11 (assembly);
> >    - Fix comments on x86/entry/64.
> >    - Remove KASLR PIE explanation on all commits.
> >    - Add note on objtool not being possible at this stage of the patchset.
> 
> This moves us closer to PIE in a clean first step. I think these patches
> look good to go, and unblock the work in kvm, xen, and percpu code. Can
> one of the x86 maintainers pick this series up?

But,... do we still need this in the light of that fine-grained kaslr
stuff?

What is the actual value of this PIE crud in the face of that?
