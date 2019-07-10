Return-Path: <SRS0=7nXh=VH=lists.openwall.com=kernel-hardening-return-16403-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40752C73C7C
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Jul 2019 08:47:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8F10C20838
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Jul 2019 08:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F10C20838
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16403-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11426 invoked by uid 550); 10 Jul 2019 08:47:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11394 invoked from network); 10 Jul 2019 08:47:08 -0000
Date: Wed, 10 Jul 2019 11:46:56 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Xi Ruoyao <xry111@mengyan1223.wang>
Cc: Kees Cook <keescook@chromium.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, Jessica Yu <jeyu@kernel.org>,
	kernel-hardening@lists.openwall.com,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel oops loading i915 after "x86/asm: Pin sensitive CR4 bits"
 (873d50d58)
Message-ID: <20190710084656.GB5447@altlinux.org>
References: <e5baec48e5c362256a631a2d55fbc30251ab5e83.camel@mengyan1223.wang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5baec48e5c362256a631a2d55fbc30251ab5e83.camel@mengyan1223.wang>

Hi,

On Wed, Jul 10, 2019 at 01:44:17PM +0800, Xi Ruoyao wrote:
> Hello,
> 
> When I try to build and run the latest mainline kernel, it Oops loading i915
> module:
> 
> BUG: unable to handle page fault for address: ffffffff9edc1598
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0003) - permissions violation
> PGD 1a20c067 P4D 1a20c067 PUD 1a20d063 PMD 8000000019e000e1 
> Oops: 0003 [#1] SMP PTI
> 
> The complete log is attached.
> 
> Bisection tells "x86/asm: Pin sensitive CR4 bits" (873d50d58) is the first "bad"
> commit.  I can revert it and also "x86/asm: Pin sensitive CR0 bits" (8dbec27a2)
> to make the kernel "seems to" work.
> 
> I'm not a kernel expert so I can't tell if there is a bug in Kees' patch, or his
> patch exploits a bug in i915 or module loader.

This seems to be a kernel bug introduced after v5.2, see
https://lore.kernel.org/lkml/CAHk-=wjh+h_-fd-gJz=wor42ZNmqq46QnB90jyfzqmKLsLFWOg@mail.gmail.com/


-- 
ldv
