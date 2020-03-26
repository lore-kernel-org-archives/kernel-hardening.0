Return-Path: <SRS0=HyiT=5L=lists.openwall.com=kernel-hardening-return-18234-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F126C43331
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 16:31:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EDD0820719
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 16:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fMaF0p1e"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDD0820719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18234-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3431 invoked by uid 550); 26 Mar 2020 16:31:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3397 invoked from network); 26 Mar 2020 16:31:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZDF6On+HDyMfQFFmOzj2HQxDo1MqPfrIkTej+3BhvlQ=;
        b=fMaF0p1e3sw4WUqlnz+78vbRi0z7dyl2McMHXTD+sd1/6njnlDhaPruhcC8Rm/PONY
         h/KIZx8kfstf2SInDgM8Ia8ACWComL6cz15SRdgw2ZqSeVFDj6jKGl1qdbKgSajR39p6
         OWi/cobumFsmvp3qDjKwP7CpsIHjb95Q2VwBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZDF6On+HDyMfQFFmOzj2HQxDo1MqPfrIkTej+3BhvlQ=;
        b=rk2ptNYxcgxsYi4sc9cBAQHbBud9n1I7jJcFvJxDMxLHMWUWpjNYJHcF6gEDW9vi8e
         z2ZjuitqzL2D97LleiANhf+0p/cj2+Pp5n3uP4iKr0+s+8Enjtb9EW1SftgM/z53XPnB
         dBpRqNUYZbA97FgFV3JpyHXp/oSyXQuHOzuXk+FEbhAx1s+htkkzZ/HdDS+My0odGaoa
         5na/jmyvs/jBZz5RBpTwayGXFiRl82+mrt98XoKpYOx/rmiXQc1rFyfbapfAxm9ZYwn2
         UdspLi8ToW47b3RmlAmxvGernwJg2X5cdf8RS1Nx03rMR2pR8F/sku/v6RfJleMayzEU
         l6CA==
X-Gm-Message-State: ANhLgQ1cJfyjNXgiBInTcxgaJUfTLD0QjcSji55pDgCEy1ogg0VbUSQL
	1tLyf1A4EC9VnwbCVx2L6zrUzw==
X-Google-Smtp-Source: ADFU+vuLwI1ER/8Bbsjtmss9W6jlCzZe3fmKIOXRb2Ju4TVJZ9hfmc4Ba4cmo4/+h6Vgp2PYRi2lvA==
X-Received: by 2002:a17:90a:2541:: with SMTP id j59mr883153pje.128.1585240294536;
        Thu, 26 Mar 2020 09:31:34 -0700 (PDT)
Date: Thu, 26 Mar 2020 09:31:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <202003260926.83BC44B@keescook>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-6-keescook@chromium.org>
 <20200325132127.GB12236@lakrids.cambridge.arm.com>
 <202003251319.AECA788D63@keescook>
 <20200326111521.GA72909@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326111521.GA72909@C02TD0UTHF1T.local>

On Thu, Mar 26, 2020 at 11:15:21AM +0000, Mark Rutland wrote:
> On Wed, Mar 25, 2020 at 01:22:07PM -0700, Kees Cook wrote:
> > On Wed, Mar 25, 2020 at 01:21:27PM +0000, Mark Rutland wrote:
> > > On Tue, Mar 24, 2020 at 01:32:31PM -0700, Kees Cook wrote:
> > > > Allow for a randomized stack offset on a per-syscall basis, with roughly
> > > > 5 bits of entropy.
> > > > 
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > 
> > > Just to check, do you have an idea of the impact on arm64? Patch 3 had
> > > figures for x86 where it reads the TSC, and it's unclear to me how
> > > get_random_int() compares to that.
> > 
> > I didn't do a measurement on arm64 since I don't have a good bare-metal
> > test environment. I know Andy Lutomirki has plans for making
> > get_random_get() as fast as possible, so that's why I used it here.
> 
> Ok. I suspect I also won't get the chance to test that in the next few
> days, but if I do I'll try to share the results.

Okay, thanks! I can try a rough estimate under emulation, but I assume
that'll be mostly useless. :)

> My concern here was that, get_random_int() has to grab a spinlock and
> mess with IRQ masking, so has the potential to block for much longer,
> but that might not be an issue in practice, and I don't think that
> should block these patches.

Gotcha. I was already surprised by how "heavy" the per-cpu access was
when I looked at the resulting assembly (there looked to be preempt
stuff, etc). But my hope was that this is configurable so people can
measure for themselves if they want it, and most people who want this
feature have a high tolerance for performance trade-offs. ;)

> > I couldn't figure out if there was a comparable instruction like rdtsc
> > in aarch64 (it seems there's a cycle counter, but I found nothing in
> > the kernel that seemed to actually use it)?
> 
> AArch64 doesn't have a direct equivalent. The generic counter
> (CNTxCT_EL0) is the closest thing, but its nominal frequency is
> typically much lower than the nominal CPU clock frequency (unlike TSC
> where they're the same). The cycle counter (PMCCNTR_EL0) is part of the
> PMU, and can't be relied on in the same way (e.g. as perf reprograms it
> to generate overflow events, and it can stop for things like WFI/WFE).

Okay, cool; thanks for the details! It's always nice to confirm I didn't
miss some glaringly obvious solution. ;)

For a potential v2, should I add your reviewed-by or wait for your
timing analysis, etc?

-- 
Kees Cook
