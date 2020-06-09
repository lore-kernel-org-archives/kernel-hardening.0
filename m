Return-Path: <SRS0=bs8r=7W=lists.openwall.com=kernel-hardening-return-18939-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89358C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 18:39:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DD4E820691
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 18:39:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="muEdWnYf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD4E820691
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18939-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10067 invoked by uid 550); 9 Jun 2020 18:39:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10047 invoked from network); 9 Jun 2020 18:39:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oUUlKxLjSlKhbNUJ+/fS04FbBkWKQBhciBLdETtik1Q=;
        b=muEdWnYfglQpo6mlvoIfHWOj2y/b2HPEYx/I/P/+afdRB9/f6IdVu5VnGI/3lcvXLS
         I9FafGnjLFcRGiW36DCgnPzai2sfXVCBdgJRXMrqAW3e7b14inpyi/jwHBpjdNDnVDY1
         GBTg1KJ1wEa1aW+kWXIDPsZzAOyVi1GSGs3y4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oUUlKxLjSlKhbNUJ+/fS04FbBkWKQBhciBLdETtik1Q=;
        b=GFIxb9vDcyd8+fmV8IbboZ2Rrku7eHAK9/Jc60gCuSreuQyU3RBmfLctd+QX6Lwomx
         Y8LCpVGbs38DarT9FwfEnV10AlC49VRKMCe5rvWfLUsyqohof3s79giDYI+9Gs1N6ALa
         +xh2wAiqASHTOcUBfadI2s/BfCnlR/ItKxZTaWS8DNhAhywZPIyV/Y6LhYs8/VJyTtPv
         aHb/MP73t4u+E3w+3ZmCb6ZebhdgxwLr4zbkH6fu8hJu775mu8bu9W0Qy+l9QqOWJn26
         LYrgMEMJB+b0q8HrNQh2hNDh37THCYhsaXED3tGIWkwQbfOGEcEFeeSmiaqEwImNybtv
         42FA==
X-Gm-Message-State: AOAM5306V27m5udH9cSkosXzcLU5Hq3XWvnL0lALzF7CZ2+TLc1BYCFE
	gwpb6JUozQvzlRTCWyRMbDQqlw==
X-Google-Smtp-Source: ABdhPJwtO8ctv+axOrlGnu6BhxO/Dmuz6uhavpkS9vfR+Ml1dYIGadDqm0xyQLuzwR4BmnGnulrmGw==
X-Received: by 2002:a17:90b:4d10:: with SMTP id mw16mr6182260pjb.143.1591727953613;
        Tue, 09 Jun 2020 11:39:13 -0700 (PDT)
Date: Tue, 9 Jun 2020 11:39:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Jann Horn <jannh@google.com>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-kbuild@vger.kernel.org,
	the arch/x86 maintainers <x86@kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	kernel list <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org,
	notify@kernel.org
Subject: Re: [PATCH 1/5] gcc-plugins/stackleak: Exclude alloca() from the
 instrumentation logic
Message-ID: <202006091133.412F0E89@keescook>
References: <20200604134957.505389-1-alex.popov@linux.com>
 <20200604134957.505389-2-alex.popov@linux.com>
 <CAG48ez05JOvqzYGr3PvyQGwFURspFWvNvf-b8Y613PX0biug8w@mail.gmail.com>
 <70319f78-2c7c-8141-d751-07f28203db7c@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70319f78-2c7c-8141-d751-07f28203db7c@linux.com>

On Thu, Jun 04, 2020 at 06:23:38PM +0300, Alexander Popov wrote:
> On 04.06.2020 17:01, Jann Horn wrote:
> > On Thu, Jun 4, 2020 at 3:51 PM Alexander Popov <alex.popov@linux.com> wrote:
> >> Some time ago Variable Length Arrays (VLA) were removed from the kernel.
> >> The kernel is built with '-Wvla'. Let's exclude alloca() from the
> >> instrumentation logic and make it simpler. The build-time assertion
> >> against alloca() is added instead.
> > [...]
> >> +                       /* Variable Length Arrays are forbidden in the kernel */
> >> +                       gcc_assert(!is_alloca(stmt));
> > 
> > There is a patch series from Elena and Kees on the kernel-hardening
> > list that deliberately uses __builtin_alloca() in the syscall entry
> > path to randomize the stack pointer per-syscall - see
> > <https://lore.kernel.org/kernel-hardening/20200406231606.37619-4-keescook@chromium.org/>.
> 
> Thanks, Jann.
> 
> At first glance, leaving alloca() handling in stackleak instrumentation logic
> would allow to integrate stackleak and this version of random_kstack_offset.

Right, it seems there would be a need for this coverage to remain,
otherwise the depth of stack erasure might be incorrect.

It doesn't seem like the other patches strictly depend on alloca()
support being removed, though?

> Kees, Elena, did you try random_kstack_offset with upstream stackleak?

I didn't try that combination yet, no. It seemed there would likely
still be further discussion about the offset series first (though the
thread has been silent -- I'll rebase and resend it after rc2).

> It looks to me that without stackleak erasing random_kstack_offset can be
> weaker. I mean, if next syscall has a bigger stack randomization gap, the data
> on thread stack from the previous syscall is not overwritten and can be used. Am
> I right?

That's correct. I think the combination is needed, but I don't think
they need to be strictly tied together.

> Another aspect: CONFIG_STACKLEAK_METRICS can be used for guessing kernel stack
> offset, which is bad. It should be disabled if random_kstack_offset is on.

Agreed.

-- 
Kees Cook
