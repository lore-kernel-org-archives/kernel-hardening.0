Return-Path: <SRS0=lGfg=KF=lists.openwall.com=kernel-hardening-return-21259-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0650C433B4
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 May 2021 01:12:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EEAAB6112F
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 May 2021 01:12:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEAAB6112F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21259-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19660 invoked by uid 550); 10 May 2021 01:12:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19640 invoked from network); 10 May 2021 01:12:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1620609126;
	bh=x2gGptb1afI/ezHs0O8XaEYRbGWZuQr1p1oLQy4q6Iw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PsykP65fPWil10yBdaN+TV260LHnVIO1GNUlokxYTLJMTuFAZPqNqBv6VpL7/Sgi/
	 /zkHwCxNsoOGgzUV5inffKDhjte3h3bbkthKv8CHeyjrtXVrkzQg4Gs/OGe1ChG0Dc
	 LT3ukFWo/2VAKyRLC0xJMbfHIL9B/26I5ra0PP0s=
Date: Sun, 9 May 2021 18:12:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: legion@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, Linux Containers
 <containers@lists.linux-foundation.org>, linux-mm@kvack.org, Christian
 Brauner <christian.brauner@ubuntu.com>, "Eric W . Biederman"
 <ebiederm@xmission.com>, Jann Horn <jannh@google.com>, Jens Axboe
 <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v11 0/9] Count rlimits in each user namespace
Message-Id: <20210509181205.f0ce806919858efa0e0e0d20@linux-foundation.org>
In-Reply-To: <cover.1619094428.git.legion@kernel.org>
References: <cover.1619094428.git.legion@kernel.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 Apr 2021 14:27:07 +0200 legion@kernel.org wrote:

> These patches are for binding the rlimit counters to a user in user namespace.

It's at v11 and no there has been no acking or reviewing activity?  Or
have you not been tracking these?

