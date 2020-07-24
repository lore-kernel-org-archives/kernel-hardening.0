Return-Path: <SRS0=D0nO=BD=lists.openwall.com=kernel-hardening-return-19441-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D68C433E1
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 17:48:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 42B43206F6
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 17:48:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42B43206F6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19441-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5557 invoked by uid 550); 24 Jul 2020 17:48:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5537 invoked from network); 24 Jul 2020 17:48:25 -0000
Date: Fri, 24 Jul 2020 13:48:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Jann
 Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200724134811.01704cbf@oasis.local.home>
In-Reply-To: <20200724134020.3160dc7c@oasis.local.home>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
	<20200719155033.24201-3-oscar.carter@gmx.com>
	<20200721140545.445f0258@oasis.local.home>
	<20200724161921.GA3123@ubuntu>
	<20200724123528.36ea9c9e@oasis.local.home>
	<20200724171418.GB3123@ubuntu>
	<20200724133656.76c75629@oasis.local.home>
	<20200724134020.3160dc7c@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jul 2020 13:40:20 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 24 Jul 2020 13:36:56 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Which BTW, is supported by the following architectures:


> >   x86  

Ah, you can lose support on x86 if you don't enable DYNAMIC_FTRACE,
which is stupid to do. I only enabled disabling of DYNAMIC_FTRACE on
x86 to test it, as not all architectures have it, and I currently only
test on x86.

Without DYNAMIC_FTRACE enabled, you *always* call into the ftrace
infrastructure for *every* function. This adds something like 15 to 20%
overhead to the kernel. Did I say it was stupid to do so?

If you are going through all this work because some randconfig causes
this warning because it enables CONFIG_FUNCTION_TRACER but without
DYNAMIC_FTRACE enabled, then I strongly suggest you start spending your
time elsewhere, because it will be a big NAK on my part to add all this
intrusive code for a config used only for debugging the non
DYNAMIC_FTRACE case.

-- Steve
