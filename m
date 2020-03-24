Return-Path: <SRS0=Fb4A=5J=lists.openwall.com=kernel-hardening-return-18183-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333BCC54EEB
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:28:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E3FA20774
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:28:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xaHWyl5k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E3FA20774
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18183-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13567 invoked by uid 550); 24 Mar 2020 16:28:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13531 invoked from network); 24 Mar 2020 16:28:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585067302;
	bh=OwaKuYa+9PST2bZOdVKnZ0hlu4DJ0Q8E1oQGPjlNHno=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xaHWyl5k+iunZr/F/yLvuO1VnQ/BlNmfc5+iTDmwR79r08X32r7KVpME6hDbQXy6w
	 +ixeuUCtn0m6o70wDBGrLlIFnrtOO3MigjTiRmyQ3icXm+6sucMV8FrWqFyJyUk098
	 b311m4SPLQrNVwQbKCiNfN8ptJNhxWU4wU/bTwSE=
Date: Tue, 24 Mar 2020 17:28:20 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 17/21] linux/bit_spinlock.h: Include linux/processor.h
Message-ID: <20200324162820.GD2518046@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-18-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-18-will@kernel.org>

On Tue, Mar 24, 2020 at 03:36:39PM +0000, Will Deacon wrote:
> Needed for cpu_relax().

Is this needed now, or for the next patch?  And if for next patch, why
not just add it then?

thanks,

greg k-h
