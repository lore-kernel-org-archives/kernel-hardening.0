Return-Path: <SRS0=cen+=VT=lists.openwall.com=kernel-hardening-return-16536-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D17C7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 21:57:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 979DB21955
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 21:57:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 979DB21955
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwn.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16536-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9770 invoked by uid 550); 22 Jul 2019 21:57:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9738 invoked from network); 22 Jul 2019 21:57:44 -0000
Date: Mon, 22 Jul 2019 15:57:30 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Joe Perches <joe@perches.com>
Cc: Stephen Kitt <steve@sk2.org>, Kees Cook <keescook@chromium.org>, Nitin
 Gote <nitin.r.gote@intel.com>, jannh@google.com,
 kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Rasmus
 Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <20190722155730.08dfd4e3@lwn.net>
In-Reply-To: <d96cf801c5cf68e785e8dfd9dba0994fcff20017.camel@perches.com>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
	<20190629181537.7d524f7d@sk2.org>
	<201907021024.D1C8E7B2D@keescook>
	<20190706144204.15652de7@heffalump.sk2.org>
	<201907221047.4895D35B30@keescook>
	<15f2be3cde69321f4f3a48d60645b303d66a600b.camel@perches.com>
	<20190722230102.442137dc@heffalump.sk2.org>
	<d96cf801c5cf68e785e8dfd9dba0994fcff20017.camel@perches.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit

On Mon, 22 Jul 2019 14:50:09 -0700
Joe Perches <joe@perches.com> wrote:

> On Mon, 2019-07-22 at 23:01 +0200, Stephen Kitt wrote:
> > How about you submit your current patch set, and I follow up with the above
> > adapted to stracpy?  
> 
> OK, I will shortly after I figure out how to add kernel-doc
> for stracpy/stracpy_pad to lib/string.c.
> 
> It doesn't seem appropriate to add the kernel-doc to string.h
> as it would be separated from the others in string.c
> 
> Anyone got a clue here?  Jonathan?

If the functions themselves are fully defined in the .h file, I'd just add
the kerneldoc there as well.  That's how it's usually done, and you want
to keep the documentation and the prototypes together.

jon
