Return-Path: <SRS0=JJNz=5J=lists.openwall.com=kernel-hardening-return-18186-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC93C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:41:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7365E2076E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 16:41:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQVuRiwP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7365E2076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18186-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23638 invoked by uid 550); 24 Mar 2020 16:41:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23604 invoked from network); 24 Mar 2020 16:41:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585068058;
	bh=J+sBi6OHsndQd9FEdmPuvq1csEI2nMeek82p0CfttsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JQVuRiwPCKjU04UpPRdYIydTIWN34Ckes2kwAEmqluB0EKanARLo3M1eOhvELfmKr
	 GFiHWNcdlqcOPIN9axBc1chyGXlS1EC5VEpRpQHzGoKlR7l5Qyeme+J5qumqThb7UW
	 eOdgdNj3L3ayY3B9dqHS4JxVHtn/rlcVfLxEum4w=
Date: Tue, 24 Mar 2020 17:40:56 +0100
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
Subject: Re: [RFC PATCH 20/21] list: Format CHECK_DATA_CORRUPTION error
 messages consistently
Message-ID: <20200324164056.GB2518746@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-21-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-21-will@kernel.org>

On Tue, Mar 24, 2020 at 03:36:42PM +0000, Will Deacon wrote:
> The error strings printed when list data corruption is detected are
> formatted inconsistently.
> 
> Satisfy my inner-pedant by consistently using ':' to limit the message
> from its prefix and drop the terminating full stops where they exist.
> 
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
