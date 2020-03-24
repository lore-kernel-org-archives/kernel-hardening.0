Return-Path: <SRS0=v5IP=5J=lists.openwall.com=kernel-hardening-return-18209-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B91C10DCE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:08:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8EEF72074D
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 21:08:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dcbn27CT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EEF72074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18209-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19910 invoked by uid 550); 24 Mar 2020 21:08:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19875 invoked from network); 24 Mar 2020 21:08:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585084095;
	bh=Ts2q4lc5rS0zE3p9NKfuZ3OCIDyXTdzeBDRNZoAYpTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Dcbn27CTP2jdEE8Ft12vQNu+KMxtzPKAyV+xeoInVKlIwjJB9hsf+U831sbsfiY9s
	 79yCeVkuICil1S4IFAkNrKNbTMyHP2iMAWtYIjJJIG5KnsML5NtKNjADY/lmxvnjTc
	 vpdD56t4J55t5JoPQSl+f0JSXuFSCmOpP/2m/gK8=
Date: Tue, 24 Mar 2020 21:08:09 +0000
From: Will Deacon <will@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 17/21] linux/bit_spinlock.h: Include linux/processor.h
Message-ID: <20200324210808.GA19527@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-18-will@kernel.org>
 <20200324162820.GD2518046@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324162820.GD2518046@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 24, 2020 at 05:28:20PM +0100, Greg KH wrote:
> On Tue, Mar 24, 2020 at 03:36:39PM +0000, Will Deacon wrote:
> > Needed for cpu_relax().
> 
> Is this needed now, or for the next patch?  And if for next patch, why
> not just add it then?

If the next patch correctly included linux/list_bl.h like it was supposed
to, then yes, it's needed there. I'll sort that out and fold this in for
v2.

Cheers,

Will
