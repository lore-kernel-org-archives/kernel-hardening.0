Return-Path: <SRS0=hJdl=32=lists.openwall.com=kernel-hardening-return-17720-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3C6C33CAC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:37:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CC5AC20838
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:37:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC5AC20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17720-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7780 invoked by uid 550); 6 Feb 2020 17:37:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7753 invoked from network); 6 Feb 2020 17:37:12 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="220510906"
Message-ID: <c9946c229f6f53379deeef00fbdee88fe2fdd96e.camel@linux.intel.com>
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Arjan van
 de Ven <arjan@linux.intel.com>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, X86 ML <x86@kernel.org>, LKML
 <linux-kernel@vger.kernel.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>
Date: Thu, 06 Feb 2020 09:36:59 -0800
In-Reply-To: <202002060353.A6A064A@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-9-kristen@linux.intel.com>
	 <CALCETrVnCAzj0atoE1hLjHgmWjWAKVdSLm-UMtukUwWgr7-N9Q@mail.gmail.com>
	 <202002060353.A6A064A@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-02-06 at 03:56 -0800, Kees Cook wrote:
> On Wed, Feb 05, 2020 at 05:17:11PM -0800, Andy Lutomirski wrote:
> > On Wed, Feb 5, 2020 at 2:39 PM Kristen Carlson Accardi
> > <kristen@linux.intel.com> wrote:
> > > At boot time, find all the function sections that have separate
> > > .text
> > > sections, shuffle them, and then copy them to new locations.
> > > Adjust
> > > any relocations accordingly.
> > > 
> > > +       sort(base, num_syms, sizeof(int), kallsyms_cmp,
> > > kallsyms_swp);
> > 
> > Hah, here's a huge bottleneck.  Unless you are severely
> > memory-constrained, never do a sort with an expensive swap function
> > like this.  Instead allocate an array of indices that starts out as
> > [0, 1, 2, ...].  Sort *that* where the swap function just swaps the
> > indices.  Then use the sorted list of indices to permute the actual
> > data.  The result is exactly one expensive swap per item instead of
> > one expensive swap per swap.
> 
> I think there are few places where memory-vs-speed need to be
> examined.
> I remain surprised about how much memory the entire series already
> uses
> (58MB in my local tests), but I suspect this is likely dominated by
> the
> two factors: a full copy of the decompressed kernel, and that the
> "allocator" in the image doesn't really implement free():
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/decompress/mm.h#n55
> 

Yes - that was a huge issue (that free() doesn't actually...). Having
to do the copy really caused me to need to bump up the boot heap.
Thankfully, this is a readily solvable problem.

I think there's a temptation to focus too hard on the boot latency.
While I measured this on a reasonably fast system, we aren't talking
minutes of latency here, just a second or a second and a half. I know
there are those who sweat the milliseconds on booting vms, but I expect
they might just turn this feature off anyway. That said, there are
absolutely a lot of great ideas for improving things here that I am
excited to try should people be interested enough in this feature for
me to take it to the next stage.



