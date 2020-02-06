Return-Path: <SRS0=ujxR=32=lists.openwall.com=kernel-hardening-return-17710-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADF7C2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 14:53:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 367AE20838
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 14:53:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kkG5AvKq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 367AE20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17710-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7326 invoked by uid 550); 6 Feb 2020 14:53:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7303 invoked from network); 6 Feb 2020 14:53:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qAWbALPQo8/7ZJiptwDEhRrrdBNpEoxar+lbkVRuAXo=; b=kkG5AvKqs7FgbTx1sDRnpdMTZc
	BzBObTMElPe+LuKQATTxfQxOvzCr3lBLeGAPdfZafBDKaD6N+Fky8AcloGDTeDfemb1S9o3tCt5b5
	VkwP0brh0w4wzD18UdcrDhuClv2L6gzwKCJLEFR+ZbYALVSceI2+qwGF0tgRyP2yTuGegFc9hv7iI
	bgoJ8j2XLkrtmkg5E3CXbXjDyKxQUox1dMxnAmCa9sFuohwnzWxKUz7Cg5bLsKE/M7Q6PPhlYZuh0
	15zhBPgDeNPdYUSxuBsvE53LMnBRjYeWXa9LizeXtRg8Wz9V9+7J1SjVOs4mK/e9B1qCad6uZ6vD7
	l+u1K4uQ==;
Date: Thu, 6 Feb 2020 15:52:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
Message-ID: <20200206145253.GT14914@hirez.programming.kicks-ass.net>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-9-kristen@linux.intel.com>
 <20200206103830.GW14879@hirez.programming.kicks-ass.net>
 <202002060356.BDFEEEFB6C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202002060356.BDFEEEFB6C@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Feb 06, 2020 at 04:06:17AM -0800, Kees Cook wrote:
> On Thu, Feb 06, 2020 at 11:38:30AM +0100, Peter Zijlstra wrote:
> > On Wed, Feb 05, 2020 at 02:39:47PM -0800, Kristen Carlson Accardi wrote:
> > > +static long __start___ex_table_addr;
> > > +static long __stop___ex_table_addr;
> > > +static long _stext;
> > > +static long _etext;
> > > +static long _sinittext;
> > > +static long _einittext;
> > 
> > Should you not also adjust __jump_table, __mcount_loc,
> > __kprobe_blacklist and possibly others that include text addresses?
> 
> These don't appear to be sorted at build time. 

The ORC tables are though:

  57fa18994285 ("scripts/sorttable: Implement build-time ORC unwind table sorting")

> AIUI, the problem with
> ex_table and kallsyms is that they're preprocessed at build time and
> opaque to the linker's relocation generation.

I was under the impression these tables no longer had relocation data;
that since they're part of the main kernel, the final link stage could
completely resolve them.

That said, I now see we actually have .rela__extable .rela.orc_unwind_ip
etc.

> For example, looking at __jump_table, it gets sorted at runtime:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/jump_label.c#n474

For now, yes. Depends a bit on how hard people are pushing on getting
jump_labels working earlier and ealier in boot.

> As you're likely aware, we have a number of "special"
> sections like this, currently collected manually, see *_TEXT:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/vmlinux.lds.S#n128

Right.

> I think we can actually add (most of) these to fg-kaslr's awareness (at
> which point their order will be shuffled respective to other sections,
> but with their content order unchanged), but it'll require a bit of
> linker work. I'll mention this series's dependency on the linker's
> orphaned section handling in another thread...

I have some patches pending where we rely on link script order. That's
data sections though, so I suppose that's safe for the moment.

