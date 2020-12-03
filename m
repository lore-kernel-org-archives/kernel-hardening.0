Return-Path: <SRS0=2q8s=FH=lists.openwall.com=kernel-hardening-return-20517-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB31C433FE
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 17:30:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 192D6207B3
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 17:30:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 192D6207B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20517-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24003 invoked by uid 550); 3 Dec 2020 17:30:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23962 invoked from network); 3 Dec 2020 17:30:23 -0000
Date: Thu, 3 Dec 2020 17:30:06 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: libc-alpha@sourceware.org, Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	kernel-hardening@lists.openwall.com,
	Topi Miettinen <toiwoton@gmail.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
Message-ID: <20201203173006.GH2830@gaia>
References: <cover.1606319495.git.szabolcs.nagy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1606319495.git.szabolcs.nagy@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Szabolcs,

On Fri, Nov 27, 2020 at 01:19:16PM +0000, Szabolcs Nagy wrote:
> This is v2 of
> https://sourceware.org/pipermail/libc-alpha/2020-November/119305.html
> 
> To enable BTI support, re-mmap executable segments instead of
> mprotecting them in case mprotect is seccomp filtered.
> 
> I would like linux to change to map the main exe with PROT_BTI when
> that is marked as BTI compatible. From the linux side i heard the
> following concerns about this:
> - it's an ABI change so requires some ABI bump. (this is fine with
>   me, i think glibc does not care about backward compat as nothing
>   can reasonably rely on the current behaviour, but if we have a
>   new bit in auxv or similar then we can save one mprotect call.)

I'm not concerned about the ABI change but there are workarounds like a
new auxv bit.

> - in case we discover compatibility issues with user binaries it's
>   better if userspace can easily disable BTI (e.g. removing the
>   mprotect based on some env var, but if kernel adds PROT_BTI and
>   mprotect is filtered then we have no reliable way to remove that
>   from executables. this problem already exists for static linked
>   exes, although admittedly those are less of a compat concern.)

This is our main concern. For static binaries, the linker could detect,
in theory, potential issues when linking and not set the corresponding
ELF information.

At runtime, a dynamic linker could detect issues and avoid enabling BTI.
In both cases, it's a (static or dynamic) linker decision that belongs
in user-space.

> - ideally PROT_BTI would be added via a new syscall that does not
>   interfere with PROT_EXEC filtering. (this does not conflict with
>   the current patches: even with a new syscall we need a fallback.)

This can be discussed as a long term solution.

> - solve it in systemd (e.g. turn off the filter, use better filter):
>   i would prefer not to have aarch64 (or BTI) specific policy in
>   user code. and there was no satisfying way to do this portably.

I agree. I think the best for now (as a back-portable glibc fix) is to
ignore the mprotect(PROT_EXEC|PROT_BTI) error that the dynamic loader
gets. BTI will be disabled if MDWX is enabled.

In the meantime, we should start (continue) looking at a solution that
works for both systemd and the kernel and be generic enough for other
architectures. The stateless nature of the current SECCOMP approach is
not suitable for this W^X policy. Kees had some suggestions here but the
thread seems to have died:

https://lore.kernel.org/kernel-hardening/202010221256.A4F95FD11@keescook/

-- 
Catalin
