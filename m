Return-Path: <SRS0=7aX9=5P=lists.openwall.com=kernel-hardening-return-18295-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0BBC43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 11:26:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AEE4520716
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 11:26:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEE4520716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18295-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1267 invoked by uid 550); 30 Mar 2020 11:26:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1232 invoked from network); 30 Mar 2020 11:26:37 -0000
Date: Mon, 30 Mar 2020 12:26:19 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] arm64: entry: Enable random_kstack_offset support
Message-ID: <20200330112619.GE1309@C02TD0UTHF1T.local>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-6-keescook@chromium.org>
 <20200325132127.GB12236@lakrids.cambridge.arm.com>
 <202003251319.AECA788D63@keescook>
 <20200326111521.GA72909@C02TD0UTHF1T.local>
 <202003260926.83BC44B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003260926.83BC44B@keescook>

On Thu, Mar 26, 2020 at 09:31:32AM -0700, Kees Cook wrote:
> On Thu, Mar 26, 2020 at 11:15:21AM +0000, Mark Rutland wrote:
> > On Wed, Mar 25, 2020 at 01:22:07PM -0700, Kees Cook wrote:
> > > On Wed, Mar 25, 2020 at 01:21:27PM +0000, Mark Rutland wrote:
> > > > On Tue, Mar 24, 2020 at 01:32:31PM -0700, Kees Cook wrote:
> > > > > Allow for a randomized stack offset on a per-syscall basis, with roughly
> > > > > 5 bits of entropy.
> > > > > 
> > > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > 
> > > > Just to check, do you have an idea of the impact on arm64? Patch 3 had
> > > > figures for x86 where it reads the TSC, and it's unclear to me how
> > > > get_random_int() compares to that.
> > > 
> > > I didn't do a measurement on arm64 since I don't have a good bare-metal
> > > test environment. I know Andy Lutomirki has plans for making
> > > get_random_get() as fast as possible, so that's why I used it here.
> > 
> > Ok. I suspect I also won't get the chance to test that in the next few
> > days, but if I do I'll try to share the results.
> 
> Okay, thanks! I can try a rough estimate under emulation, but I assume
> that'll be mostly useless. :)
> 
> > My concern here was that, get_random_int() has to grab a spinlock and
> > mess with IRQ masking, so has the potential to block for much longer,
> > but that might not be an issue in practice, and I don't think that
> > should block these patches.
> 
> Gotcha. I was already surprised by how "heavy" the per-cpu access was
> when I looked at the resulting assembly (there looked to be preempt
> stuff, etc). But my hope was that this is configurable so people can
> measure for themselves if they want it, and most people who want this
> feature have a high tolerance for performance trade-offs. ;)
> 
> > > I couldn't figure out if there was a comparable instruction like rdtsc
> > > in aarch64 (it seems there's a cycle counter, but I found nothing in
> > > the kernel that seemed to actually use it)?
> > 
> > AArch64 doesn't have a direct equivalent. The generic counter
> > (CNTxCT_EL0) is the closest thing, but its nominal frequency is
> > typically much lower than the nominal CPU clock frequency (unlike TSC
> > where they're the same). The cycle counter (PMCCNTR_EL0) is part of the
> > PMU, and can't be relied on in the same way (e.g. as perf reprograms it
> > to generate overflow events, and it can stop for things like WFI/WFE).
> 
> Okay, cool; thanks for the details! It's always nice to confirm I didn't
> miss some glaringly obvious solution. ;)
> 
> For a potential v2, should I add your reviewed-by or wait for your
> timing analysis, etc?

I'd rather not give an R-b until I've seen numbers, but please don't
block waiting for that. For the moment, feel free to add:

Acked-by: Mark Rutland <mark.rutland@arm.com>

... and it's down to Will and Catalin to make the call for arm64.

Thanks,
Mark.
