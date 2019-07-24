Return-Path: <SRS0=u8OI=VV=lists.openwall.com=kernel-hardening-return-16569-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BED4C7618B
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 07:11:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C3D0920665
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 07:11:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3D0920665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16569-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10004 invoked by uid 550); 24 Jul 2019 07:11:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9972 invoked from network); 24 Jul 2019 07:11:14 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: sail18_25ca87690f746
X-Filterd-Recvd-Size: 1645
Message-ID: <023c0194641abe411c2338e4eed9eec876888e48.camel@perches.com>
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Torvalds
	 <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>, Kees
 Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
 jannh@google.com,  kernel-hardening@lists.openwall.com, Andrew Morton
 <akpm@linux-foundation.org>
Date: Wed, 24 Jul 2019 00:10:58 -0700
In-Reply-To: <dab1b433-93c0-09ab-cceb-3db91b6ef353@rasmusvillemoes.dk>
References: <cover.1563889130.git.joe@perches.com>
	 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
	 <ce1320d8-60df-7c54-2348-6aabac63c24d@rasmusvillemoes.dk>
	 <c9ef2b56eaf36c8e5449b751ab6e5971b6b34311.camel@perches.com>
	 <dab1b433-93c0-09ab-cceb-3db91b6ef353@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2019-07-24 at 08:53 +0200, Rasmus Villemoes wrote:
> BUILD_BUG_ON(!__same_type())
> strscpy(dst, src, ARRAY_SIZE(dst))

Doing this without the temporary is less legible to read
the compiler error when someone improperly does:

	char *foo;
	char *bar;

	stracpy(foo, bar);


