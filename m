Return-Path: <SRS0=nIiM=QD=lists.openwall.com=kernel-hardening-return-21494-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B31C433EF
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Nov 2021 13:21:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E52D261B31
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Nov 2021 13:21:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E52D261B31
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 9901 invoked by uid 550); 16 Nov 2021 13:21:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9880 invoked from network); 16 Nov 2021 13:21:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1637068863;
	bh=Sl6WuLnqTU5TtnSO/QxFeyGJuRtLYuKL8EqqmhmDJXE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=MPT0whG2bQpz0Y8+0rTOzk/Lt9c8RRm7MpZUKNOWWeP09PrTuZbxrGsGMCDBVFtIB
	 73aZZDq3UHdFL++Ub3OxRSnL3yZgntpKyZsNEZe8JaDLPYS2yUL+Vf9WsvhhtP0pGY
	 tjqCDNMkJTzaDuHazCXWjzVHrqqtiLkYOTTXFlu0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1637068862;
	bh=Sl6WuLnqTU5TtnSO/QxFeyGJuRtLYuKL8EqqmhmDJXE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=Gh53x5MAbxqanSOf9Z+qToC4xT79AG5yx757N80jyZsGwNIA803bfe57ViasAsXQi
	 4z92/voDtClOm88EHF5A+G0dQSjdu5NI1LOynI7X+wrinp8pr0XgpF0ALZd0R3BPPB
	 joY1Qno04GjG9pkA6f892MOy/dAQoO90oGkz0myw=
Message-ID: <d751a5dd17550b21f890e3efcf70d5228451767d.camel@HansenPartnership.com>
Subject: Re: [ELISA Safety Architecture WG] [PATCH v2 0/2] Introduce the
 pkill_on_warn parameter
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Petr Mladek <pmladek@suse.com>, Alexander Popov <alex.popov@linux.com>
Cc: Gabriele Paoloni <gpaoloni@redhat.com>, Lukas Bulwahn
 <lukas.bulwahn@gmail.com>, Robert Krutsch <krutsch@gmail.com>, Linus
 Torvalds <torvalds@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Paul McKenney <paulmck@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Peter
 Zijlstra <peterz@infradead.org>, Joerg Roedel <jroedel@suse.de>, Maciej
 Rozycki <macro@orcam.me.uk>, Muchun Song <songmuchun@bytedance.com>, Viresh
 Kumar <viresh.kumar@linaro.org>, Robin Murphy <robin.murphy@arm.com>, Randy
 Dunlap <rdunlap@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, Kees
 Cook <keescook@chromium.org>, Luis Chamberlain <mcgrof@kernel.org>, Wei Liu
 <wl@xen.org>, John Ogness <john.ogness@linutronix.de>,  Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Jann Horn
 <jannh@google.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark
 Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Dave
 Hansen <dave.hansen@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Laura
 Abbott <labbott@kernel.org>, David S Miller <davem@davemloft.net>, Borislav
 Petkov <bp@alien8.de>, Arnd Bergmann <arnd@arndb.de>, Andrew Scull
 <ascull@google.com>, Marc Zyngier <maz@kernel.org>,  Jessica Yu
 <jeyu@kernel.org>, Iurii Zaikin <yzaikin@google.com>, Rasmus Villemoes
 <linux@rasmusvillemoes.dk>, Wang Qing <wangqing@vivo.com>, Mel Gorman
 <mgorman@suse.de>, Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
 Andrew Klychkov <andrew.a.klychkov@gmail.com>, Mathieu Chouquet-Stringer
 <me@mathieu.digital>, Daniel Borkmann <daniel@iogearbox.net>, Stephen Kitt
 <steve@sk2.org>, Stephen Boyd <sboyd@kernel.org>,  Thomas Bogendoerfer
 <tsbogend@alpha.franken.de>, Mike Rapoport <rppt@kernel.org>, Bjorn
 Andersson <bjorn.andersson@linaro.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org, 
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-arch
 <linux-arch@vger.kernel.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>, linux-fsdevel
 <linux-fsdevel@vger.kernel.org>, notify@kernel.org,  main@lists.elisa.tech,
 safety-architecture@lists.elisa.tech,  devel@lists.elisa.tech, Shuah Khan
 <shuah@kernel.org>
Date: Tue, 16 Nov 2021 08:20:57 -0500
In-Reply-To: <YZNuyssYsAB0ogUD@alley>
References: <20211027233215.306111-1-alex.popov@linux.com>
	 <ac989387-3359-f8da-23f9-f5f6deca4db8@linux.com>
	 <CAHk-=wgRmjkP3+32XPULMLTkv24AkA=nNLa7xxvSg-F0G1sJ9g@mail.gmail.com>
	 <77b79f0c-48f2-16dd-1d00-22f3a1b1f5a6@linux.com>
	 <CAKXUXMx5Oi-dNVKB+8E-pdrz+ooELMZf=oT_oGXKFrNWejz=fg@mail.gmail.com>
	 <22828e84-b34f-7132-c9e9-bb42baf9247b@redhat.com>
	 <cf57fb34-460c-3211-840f-8a5e3d88811a@linux.com> <YZNuyssYsAB0ogUD@alley>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2021-11-16 at 09:41 +0100, Petr Mladek wrote:
[...]
> If I wanted to implement a super-reliable panic() I would
> use some external device that would cause power-reset when
> the watched device is not responding.

They're called watchdog timers.  We have a whole subsystem full of
them:

drivers/watchdog

We used them in old cluster HA systems to guarantee successful recovery
of shared state from contaminated cluster members, but I think they'd
serve the reliable panic need equally well.  Most server class systems
today have them built in (on the BMC if they don't have a separate
mechanism), they're just not usually activated.

James


