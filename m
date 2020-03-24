Return-Path: <SRS0=xZdb=5J=lists.openwall.com=kernel-hardening-return-18188-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F8EC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:43:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9A2AB2076E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:43:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvPkMF4E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A2AB2076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18188-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26461 invoked by uid 550); 24 Mar 2020 16:43:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26421 invoked from network); 24 Mar 2020 16:43:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585068174;
	bh=F5trW5ADWsv/2B2og+hJh/rRyTBedzD44xQ2ildnw6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cvPkMF4EW43aTAYf7ebcRR12fM2r0IdNbhbwRi+5xTqVEr2O88zXQXwi4mMPZBA6M
	 3sShx80ruCzBZnbrk9+AEFyBrMPeIS/qqytmK7su8MBAlHMz0SncJDlCDO6k4I3mq4
	 74PWoLwRq6eF8NBzPO1QAyV6VgLeoyehNKz66MBg=
Date: Tue, 24 Mar 2020 17:42:52 +0100
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
Subject: Re: [RFC PATCH 14/21] plist: Use CHECK_DATA_CORRUPTION instead of
 explicit {BUG,WARN}_ON()
Message-ID: <20200324164252.GD2518746@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-15-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-15-will@kernel.org>

On Tue, Mar 24, 2020 at 03:36:36PM +0000, Will Deacon wrote:
> CHECK_DATA_CORRUPTION() allows detected data corruption to result
> consistently in either a BUG() or a WARN() depending on
> CONFIG_BUG_ON_DATA_CORRUPTION.
> 
> Use CHECK_DATA_CORRUPTION() to report plist integrity checking failures,
> rather than explicit use of BUG_ON() and WARN_ON().
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
