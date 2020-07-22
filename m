Return-Path: <SRS0=ZzXj=BB=lists.openwall.com=kernel-hardening-return-19421-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EE6C433E6
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:56:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8064F20771
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8064F20771
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19421-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16108 invoked by uid 550); 22 Jul 2020 19:56:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16088 invoked from network); 22 Jul 2020 19:56:28 -0000
IronPort-SDR: 0iT3pwFFq9zymIe8Ypi/dqpGamV9Vrqc9iZ+49Y+go8bQ3EWHdYrX7Js4iOMdY3lC/wjrKJaz5
 X8AAHUmVEsRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="149593795"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="149593795"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: dp01G1YgXUZz1OxqW8lljzi0D0OzzYTa7bKaJ2Mo0oDFhpSjcg2Jrf8enws2LkIq4FTbEBDlrT
 fdd7QdYdtahw==
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="362820651"
Message-ID: <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de, mingo@redhat.com, 
 bp@alien8.de, arjan@linux.intel.com, x86@kernel.org,
 linux-kernel@vger.kernel.org,  kernel-hardening@lists.openwall.com,
 rick.p.edgecombe@intel.com,  live-patching@vger.kernel.org
Date: Wed, 22 Jul 2020 12:56:10 -0700
In-Reply-To: <202007221241.EBC2215A@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
	 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
	 <202007220738.72F26D2480@keescook> <20200722160730.cfhcj4eisglnzolr@treble>
	 <202007221241.EBC2215A@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2020-07-22 at 12:42 -0700, Kees Cook wrote:
> On Wed, Jul 22, 2020 at 11:07:30AM -0500, Josh Poimboeuf wrote:
> > On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
> > > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
> > > > Let me CC live-patching ML, because from a quick glance this is
> > > > something 
> > > > which could impact live patching code. At least it invalidates
> > > > assumptions 
> > > > which "sympos" is based on.
> > > 
> > > In a quick skim, it looks like the symbol resolution is using
> > > kallsyms_on_each_symbol(), so I think this is safe? What's a good
> > > selftest for live-patching?
> > 
> > The problem is duplicate symbols.  If there are two static
> > functions
> > named 'foo' then livepatch needs a way to distinguish them.
> > 
> > Our current approach to that problem is "sympos".  We rely on the
> > fact
> > that the second foo() always comes after the first one in the
> > symbol
> > list and kallsyms.  So they're referred to as foo,1 and foo,2.
> 
> Ah. Fun. In that case, perhaps the LTO series has some solutions. I
> think builds with LTO end up renaming duplicate symbols like that, so
> it'll be back to being unique.
> 

Well, glad to hear there might be some precendence for how to solve
this, as I wasn't able to think of something reasonable off the top of
my head. Are you speaking of the Clang LTO series? 
https://lore.kernel.org/lkml/20200624203200.78870-1-samitolvanen@google.com/

