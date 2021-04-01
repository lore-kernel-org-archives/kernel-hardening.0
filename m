Return-Path: <SRS0=G7l2=I6=lists.openwall.com=kernel-hardening-return-21117-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8F6C433ED
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 19:49:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 531F060FDB
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 19:49:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 531F060FDB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21117-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10019 invoked by uid 550); 1 Apr 2021 19:48:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9992 invoked from network); 1 Apr 2021 19:48:56 -0000
Date: Thu, 1 Apr 2021 19:48:30 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Roy Yang <royyang@google.com>
Cc: keescook@chromium.org, akpm@linux-foundation.org, alex.popov@linux.com,
	ard.biesheuvel@linaro.org, catalin.marinas@arm.com, corbet@lwn.net,
	david@redhat.com, elena.reshetova@intel.com, glider@google.com,
	jannh@google.com, kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, luto@kernel.org, mark.rutland@arm.com,
	peterz@infradead.org, rdunlap@infradead.org, rppt@linux.ibm.com,
	tglx@linutronix.de, vbabka@suse.cz, will@kernel.org, x86@kernel.org
Subject: Re: [PATCH] Where we are for this patch?
Message-ID: <YGYjjpoj1uMn1VEd@zeniv-ca.linux.org.uk>
References: <20210330205750.428816-1-keescook@chromium.org>
 <20210401191744.1685896-1-royyang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401191744.1685896-1-royyang@google.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Thu, Apr 01, 2021 at 12:17:44PM -0700, Roy Yang wrote:
> Both Android and Chrome OS really want this feature; For Container-Optimized OS, we have customers
> interested in the defense too.
> 
> Thank you very much.
> 
> Change-Id: I1eb1b726007aa8f9c374b934cc1c690fb4924aa3

	You forgot to tell what patch you are refering to.  Your
Change-Id (whatever the hell that is) doesn't help at all.  Don't
assume that keys in your internal database make sense for the
rest of the world, especially when they appear to contain a hash
of something...
