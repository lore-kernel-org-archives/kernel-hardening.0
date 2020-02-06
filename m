Return-Path: <SRS0=GhbS=32=lists.openwall.com=kernel-hardening-return-17724-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A0DC35247
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 19:41:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6BFD321775
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 19:41:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BFD321775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17724-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3289 invoked by uid 550); 6 Feb 2020 19:41:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3269 invoked from network); 6 Feb 2020 19:41:28 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="236084936"
Message-ID: <75f0bd0365857ba4442ee69016b63764a8d2ad68.camel@linux.intel.com>
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Thu, 06 Feb 2020 11:41:15 -0800
In-Reply-To: <202002060408.84005CEFFD@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-7-kristen@linux.intel.com>
	 <202002060408.84005CEFFD@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-02-06 at 04:26 -0800, Kees Cook wrote:
> On Wed, Feb 05, 2020 at 02:39:45PM -0800, Kristen Carlson Accardi
> wrote:
> > We will be using -ffunction-sections to place each function in
> > it's own text section so it can be randomized at load time. The
> > linker considers these .text.* sections "orphaned sections", and
> > will place them after the first similar section (.text). However,
> > we need to move _etext so that it is after both .text and .text.*
> > We also need to calculate text size to include .text AND .text.*
> 
> The dependency on the linker's orphan section handling is, I feel,
> rather fragile (during work on CFI and generally building kernels
> with
> Clang's LLD linker, we keep tripping over difference between how BFD
> and
> LLD handle orphans). However, this is currently no way to perform a
> section "pass through" where input sections retain their name as an
> output section. (If anyone knows a way to do this, I'm all ears).
> 
> Right now, you can only collect sections like this:
> 
>         .text :  AT(ADDR(.text) - LOAD_OFFSET) {
> 		*(.text.*)
> 	}
> 
> or let them be orphans, which then the linker attempts to find a
> "similar" (code, data, etc) section to put them near:
> https://sourceware.org/binutils/docs-2.33.1/ld/Orphan-Sections.html
> 
> So, basically, yes, this works, but I'd like to see BFD and LLD grow
> some kind of /PASSTHRU/ special section (like /DISCARD/), that would
> let
> a linker script specify _where_ these sections should roughly live.
> 
> Related thoughts:
> 
> I know x86_64 stack alignment is 16 bytes. I cannot find evidence for
> what function start alignment should be. It seems the linker is 16
> byte
> aligning these functions, when I think no alignment is needed for
> function starts, so we're wasting some memory (average 8 bytes per
> function, at say 50,000 functions, so approaching 512KB) between
> functions. If we can specify a 1 byte alignment for these orphan
> sections, that would be nice, as mentioned in the cover letter: we
> lose
> a 4 bits of entropy to this alignment, since all randomized function
> addresses will have their low bits set to zero.

So, when I was developing this patch set, I initially ignored the value
of sh_addralign and just packed the functions in one right after
another when I did the new layout. They were byte aligned :). I later
realized that I should probably pay attention to alignment and thus
started respecting the value that was in sh_addralign. There is
actually nothing stopping me from ignoring it again, other than I am
concerned that I will make runtime performance suffer even more than I
already have.

> 
> And we can't adjust function section alignment, or there is some
> benefit to a larger alignment, I would like to have a way for the
> linker
> to specify the inter-section padding (or fill) bytes. Right now, the
> FILL(0xnn) (or =0xnn) can be used to specify the padding bytes
> _within_
> a section, but not between sections. Right now, BFD appears to 0-pad. 
> I'd
> like that to be 0xCC so "guessing" addresses incorrectly will trigger
> a trap.

Padding the space between functions with int3 is easy to add during
boot time, and I've got it on my todo list.


