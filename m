Return-Path: <SRS0=azr8=VT=lists.openwall.com=kernel-hardening-return-16535-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49307C7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 21:50:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A03A321951
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 21:50:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A03A321951
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16535-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1295 invoked by uid 550); 22 Jul 2019 21:50:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1261 invoked from network); 22 Jul 2019 21:50:24 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: net82_1eb9f15d55954
X-Filterd-Recvd-Size: 1676
Message-ID: <d96cf801c5cf68e785e8dfd9dba0994fcff20017.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
From: Joe Perches <joe@perches.com>
To: Stephen Kitt <steve@sk2.org>
Cc: Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>, 
	jannh@google.com, kernel-hardening@lists.openwall.com, corbet@lwn.net, 
	linux-kernel@vger.kernel.org, Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Mon, 22 Jul 2019 14:50:09 -0700
In-Reply-To: <20190722230102.442137dc@heffalump.sk2.org>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
	 <20190629181537.7d524f7d@sk2.org> <201907021024.D1C8E7B2D@keescook>
	 <20190706144204.15652de7@heffalump.sk2.org>
	 <201907221047.4895D35B30@keescook>
	 <15f2be3cde69321f4f3a48d60645b303d66a600b.camel@perches.com>
	 <20190722230102.442137dc@heffalump.sk2.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2019-07-22 at 23:01 +0200, Stephen Kitt wrote:
> How about you submit your current patch set, and I follow up with the above
> adapted to stracpy?

OK, I will shortly after I figure out how to add kernel-doc
for stracpy/stracpy_pad to lib/string.c.

It doesn't seem appropriate to add the kernel-doc to string.h
as it would be separated from the others in string.c

Anyone got a clue here?  Jonathan?



