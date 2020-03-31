Return-Path: <SRS0=cjdT=5Q=lists.openwall.com=kernel-hardening-return-18335-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0127DC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 13:12:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 50F70206F5
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 13:12:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDyMaOIu"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50F70206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18335-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18332 invoked by uid 550); 31 Mar 2020 13:12:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18298 invoked from network); 31 Mar 2020 13:12:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585660319;
	bh=C4z6bLsgCUsUXpNs+07nkuMCLbbtGzUm2/UZT5f2VDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WDyMaOIuFYL2OPYRlanpB+zCrBj+VAdJdLyumi/WLOjuNjpmicwMmy761XmmzOuUf
	 w4tbemfSc178iooJo7SYmeCJalI49A0bXwz9TscqfPkHfEjkkga+X8QtcIMfvR2iCm
	 zQCjNN2n3yGIWKd8NdX9ZXfk+TOiL/vDYVSyf0O8=
Date: Tue, 31 Mar 2020 14:11:54 +0100
From: Will Deacon <will@kernel.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 08/21] Revert "list: Use WRITE_ONCE() when
 initializing list_head structures"
Message-ID: <20200331131153.GB30975@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-9-will@kernel.org>
 <20200330232505.GD19865@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330232505.GD19865@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 30, 2020 at 04:25:05PM -0700, Paul E. McKenney wrote:
> On Tue, Mar 24, 2020 at 03:36:30PM +0000, Will Deacon wrote:
> > This reverts commit 2f073848c3cc8aff2655ab7c46d8c0de90cf4e50.
> > 
> > There is no need to use WRITE_ONCE() to initialise a non-RCU 'list_head'.
> > 
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Will Deacon <will@kernel.org>
> 
> And attention to lockless uses of list_empty() here, correct?
> 
> Depending on the outcome of discussions on 3/21, I should have added in
> all three cases.

Yes, patch 3 is where this will get sorted. It looks like we'll have to
disable KCSAN around the READ_ONCE() over there, but I also need to finish
wrapping my head around list_empty_careful() because I'm deeply suspicious!

Will
