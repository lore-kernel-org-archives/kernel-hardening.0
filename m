Return-Path: <SRS0=sSXu=AN=lists.openwall.com=kernel-hardening-return-19202-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A940C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Jul 2020 08:21:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9A23320720
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Jul 2020 08:21:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QC3pfARo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A23320720
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19202-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1472 invoked by uid 550); 2 Jul 2020 08:20:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1437 invoked from network); 2 Jul 2020 08:20:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lYeUH98ECIdWEh43yZAHKXD5kblKbjXwCRAczr7OF8g=; b=QC3pfARojKciVxMrZBOx7jz1mN
	Pab8UojFGO1fmoOFkavzVJlTHdnSbAvvJmrl6qyTfz9JxQ0oVT9N3F3WQ8VDXAHtOt7Bhbc36Sn1D
	bnEyFCZg5ygqz/hsNcsmBmq4lNF0bm5ijX0J2cmZBSWR0Q9CWFlcuZMu8ctLIW6o49m83sHRa6RbY
	1MRzYZOf1YSuGKFdnptt9tybEqVUIQvpRKLyPHa++McjsktYpeEXl/KwxDq39uwxgXI3xJ6Oa9JYw
	mE1EgZGIdy98yvLtver8lS2emXEaRZOoWRizYYr1UaUpeQRcOUWx1Aq0gYAVOe8/cl0TXWgoDv0aE
	zeOwHtLg==;
Date: Thu, 2 Jul 2020 10:20:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Marco Elver <elver@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200702082040.GB4781@hirez.programming.kicks-ass.net>
References: <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
 <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
 <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
 <20200701160338.GN9247@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200701160338.GN9247@paulmck-ThinkPad-P72>

On Wed, Jul 01, 2020 at 09:03:38AM -0700, Paul E. McKenney wrote:

> But it looks like we are going to have to tell the compiler.

What does the current proposal look like? I can certainly annotate the
seqcount latch users, but who knows what other code is out there....
