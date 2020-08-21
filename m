Return-Path: <SRS0=SAFY=B7=lists.openwall.com=kernel-hardening-return-19662-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5C8C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri, 21 Aug 2020 23:03:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 120D82076E
	for <kernel-hardening@archiver.kernel.org>; Fri, 21 Aug 2020 23:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 120D82076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19662-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1420 invoked by uid 550); 21 Aug 2020 23:02:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1388 invoked from network); 21 Aug 2020 23:02:53 -0000
IronPort-SDR: GzEZKAKfUAKtCn3/tPi2FR1NLaJbnuf1ma3uf7oXfICA5oP8vkavshljV8TJrFMAd4K0/D7Fu0
 nZE5eu1E7h5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="135714742"
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="135714742"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: ToGmx6dS8MqJfWdeMn8gS85sydet1IIwHZhopRPEpLlrhZIQI12Cn7bDwDzvyQqiuYnCbfRP41
 Vaio4ho7wJqA==
X-IronPort-AV: E=Sophos;i="5.76,338,1592895600"; 
   d="scan'208";a="473214632"
Message-ID: <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Miroslav Benes <mbenes@suse.cz>, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com, 
	x86@kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com, 
	live-patching@vger.kernel.org, Hongjiu Lu <hongjiu.lu@intel.com>, 
	joe.lawrence@redhat.com
Date: Fri, 21 Aug 2020 16:02:24 -0700
In-Reply-To: <20200722213313.aetl3h5rkub6ktmw@treble>
References: <20200717170008.5949-1-kristen@linux.intel.com>
	 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
	 <202007220738.72F26D2480@keescook> <20200722160730.cfhcj4eisglnzolr@treble>
	 <202007221241.EBC2215A@keescook>
	 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
	 <20200722213313.aetl3h5rkub6ktmw@treble>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2020-07-22 at 16:33 -0500, Josh Poimboeuf wrote:
> On Wed, Jul 22, 2020 at 12:56:10PM -0700, Kristen Carlson Accardi
> wrote:
> > On Wed, 2020-07-22 at 12:42 -0700, Kees Cook wrote:
> > > On Wed, Jul 22, 2020 at 11:07:30AM -0500, Josh Poimboeuf wrote:
> > > > On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
> > > > > On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes
> > > > > wrote:
> > > > > > Let me CC live-patching ML, because from a quick glance
> > > > > > this is
> > > > > > something 
> > > > > > which could impact live patching code. At least it
> > > > > > invalidates
> > > > > > assumptions 
> > > > > > which "sympos" is based on.
> > > > > 
> > > > > In a quick skim, it looks like the symbol resolution is using
> > > > > kallsyms_on_each_symbol(), so I think this is safe? What's a
> > > > > good
> > > > > selftest for live-patching?
> > > > 
> > > > The problem is duplicate symbols.  If there are two static
> > > > functions
> > > > named 'foo' then livepatch needs a way to distinguish them.
> > > > 
> > > > Our current approach to that problem is "sympos".  We rely on
> > > > the
> > > > fact
> > > > that the second foo() always comes after the first one in the
> > > > symbol
> > > > list and kallsyms.  So they're referred to as foo,1 and foo,2.
> > > 
> > > Ah. Fun. In that case, perhaps the LTO series has some solutions.
> > > I
> > > think builds with LTO end up renaming duplicate symbols like
> > > that, so
> > > it'll be back to being unique.
> > > 
> > 
> > Well, glad to hear there might be some precendence for how to solve
> > this, as I wasn't able to think of something reasonable off the top
> > of
> > my head. Are you speaking of the Clang LTO series? 
> > https://lore.kernel.org/lkml/20200624203200.78870-1-samitolvanen@google.com/
> 
> I'm not sure how LTO does it, but a few more (half-brained) ideas
> that
> could work:
> 
> 1) Add a field in kallsyms to keep track of a symbol's original
> offset
>    before randomization/re-sorting.  Livepatch could use that field
> to
>    determine the original sympos.
> 
> 2) In fgkaslr code, go through all the sections and mark the ones
> which
>    have duplicates (i.e. same name).  Then when shuffling the
> sections,
>    skip a shuffle if it involves a duplicate section.  That way all
> the
>    duplicates would retain their original sympos.
> 
> 3) Livepatch could uniquely identify symbols by some feature other
> than
>    sympos.  For example:
> 
>    Symbol/function size - obviously this would only work if
> duplicately
>    named symbols have different sizes.
> 
>    Checksum - as part of a separate feature we're also looking at
> giving
>    each function its own checksum, calculated based on its
> instruction
>    opcodes.  Though calculating checksums at runtime could be
>    complicated by IP-relative addressing.
> 
> I'm thinking #1 or #2 wouldn't be too bad.  #3 might be harder.
> 

Hi there! I was trying to find a super easy way to address this, so I
thought the best thing would be if there were a compiler or linker
switch to just eliminate any duplicate symbols at compile time for
vmlinux. I filed this question on the binutils bugzilla looking to see
if there were existing flags that might do this, but H.J. Lu went ahead
and created a new one "-z unique", that seems to do what we would need
it to do. 

https://sourceware.org/bugzilla/show_bug.cgi?id=26391

When I use this option, it renames any duplicate symbols with an
extension - for example duplicatefunc.1 or duplicatefunc.2. You could
either match on the full unique name of the specific binary you are
trying to patch, or you match the base name and use the extension to
determine original position. Do you think this solution would work? If
so, I can modify livepatch to refuse to patch on duplicated symbols if
CONFIG_FG_KASLR and when this option is merged into the tool chain I
can add it to KBUILD_LDFLAGS when CONFIG_FG_KASLR and livepatching
should work in all cases. 

