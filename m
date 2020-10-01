Return-Path: <SRS0=yZ1b=DI=lists.openwall.com=kernel-hardening-return-20076-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1154CC4727F
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Oct 2020 13:36:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1B9E4207F7
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Oct 2020 13:36:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rkoYrYmb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B9E4207F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20076-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28666 invoked by uid 550); 1 Oct 2020 13:36:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28646 invoked from network); 1 Oct 2020 13:36:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fKHBx2l1x20GN0S3b+jTfen0uwxhiVfe2eiMSbpdaJc=; b=rkoYrYmb5/6jzedCCWXFLJn1Js
	Su3dhZ5KWDv1MASUxHWIyi0HHPm/ePgWAlqmlPl7vX0YAy66AJdPY+/xm0WAUYoRmEBX+mO+6T8+V
	Icj9pc59qTGH/yoN90T+98J5m6GdmDo4o+YQ6Qcwfvu5StJC1CMj+dZsOTyf/c9HP8WlPBGOb+o0Q
	6D9yVgyZ+6MFyhrDwUasgeNYH4HtwuVAWOPmdotfUbYA/8kLlXOVNla6GYLXq1AzitcCts/t+cL5h
	IEg2Eshs26M+j10DrIY85wx56KguUB9k4rNB/xtXHnDIekBqXSRpUNU87NEPTQuVilHGV1nifj4NB
	bclif4ew==;
Date: Thu, 1 Oct 2020 15:36:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, jthierry@redhat.com, jpoimboe@redhat.com
Subject: Re: [PATCH v4 04/29] objtool: Add a pass for generating __mcount_loc
Message-ID: <20201001133612.GQ2628@hirez.programming.kicks-ass.net>
References: <20200929214631.3516445-1-samitolvanen@google.com>
 <20200929214631.3516445-5-samitolvanen@google.com>
 <alpine.LSU.2.21.2010011504340.6689@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2010011504340.6689@pobox.suse.cz>

On Thu, Oct 01, 2020 at 03:17:07PM +0200, Miroslav Benes wrote:

> I also wonder about making 'mcount' command separate from 'check'. Similar 
> to what is 'orc' now. But that could be done later.

I'm not convinced more commands make sense. That only begets us the
problem of having to run multiple commands.
