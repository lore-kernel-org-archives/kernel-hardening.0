Return-Path: <SRS0=1wSO=XU=lists.openwall.com=kernel-hardening-return-16935-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF603C432C2
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Sep 2019 21:50:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3EA5621D7A
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Sep 2019 21:50:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="K7O5+35b"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EA5621D7A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16935-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22417 invoked by uid 550); 25 Sep 2019 21:50:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22385 invoked from network); 25 Sep 2019 21:50:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569448212;
	bh=0hElOx3BzQbrRg4qLp+t1hnvhiKVtH9mNvFATszNKeU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K7O5+35b6Ac+m64iTBbK2S6SB+lhgxNCKhjM7IcdVSDsv1wm7VwMvx8Y6X/oB6XEk
	 4u5uDYsizKBl250xDMeM150DYHz5cAUc3Ysh6oykM1xh2Oz8ds2ZhW5teJoNQwajnj
	 9nIEmyflO26x5euUTVsqw+gs4DY2MTPCjo/SjYYI=
Date: Wed, 25 Sep 2019 14:50:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Stephen
 Kitt <steve@sk2.org>, Kees Cook <keescook@chromium.org>, Nitin Gote
 <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com, Rasmus Villemoes
 <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
Message-Id: <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org>
In-Reply-To: <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
References: <cover.1563889130.git.joe@perches.com>
	<ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Jul 2019 06:51:36 -0700 Joe Perches <joe@perches.com> wrote:

> Several uses of strlcpy and strscpy have had defects because the
> last argument of each function is misused or typoed.
> 
> Add macro mechanisms to avoid this defect.
> 
> stracpy (copy a string to a string array) must have a string
> array as the first argument (dest) and uses sizeof(dest) as the
> count of bytes to copy.
> 
> These mechanisms verify that the dest argument is an array of
> char or other compatible types like u8 or s8 or equivalent.
> 
> A BUILD_BUG is emitted when the type of dest is not compatible.
> 

I'm still reluctant to merge this because we don't have code in -next
which *uses* it.  You did have a patch for that against v1, I believe? 
Please dust it off and send it along?

