Return-Path: <SRS0=RT0g=BD=lists.openwall.com=kernel-hardening-return-19443-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B749C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 18:35:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BC6592065E
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 18:35:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC6592065E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19443-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27845 invoked by uid 550); 24 Jul 2020 18:35:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27823 invoked from network); 24 Jul 2020 18:35:11 -0000
Date: Fri, 24 Jul 2020 14:34:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Jann
 Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200724143457.27755412@oasis.local.home>
In-Reply-To: <20200724175500.GD3123@ubuntu>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
	<20200719155033.24201-3-oscar.carter@gmx.com>
	<20200721140545.445f0258@oasis.local.home>
	<20200724161921.GA3123@ubuntu>
	<20200724123528.36ea9c9e@oasis.local.home>
	<20200724171418.GB3123@ubuntu>
	<20200724133656.76c75629@oasis.local.home>
	<20200724134020.3160dc7c@oasis.local.home>
	<20200724175500.GD3123@ubuntu>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jul 2020 19:55:00 +0200
Oscar Carter <oscar.carter@gmx.com> wrote:

> > Which one of the above is this patch set for?  
> 
> This patch is the result of a warning obtained with the following:
> 
> make allmodconfig ARCH=powerpc
> make ARCH=powerpc CROSS_COMPILE=powerpc-linux-gnu- -j4
> 
> And with the -Wcast-function-type enabled in the top level makefile.

Looking into powerpc I found this:

arch/powerpc/include/asm/ftrace.h:

  #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
  #define ARCH_SUPPORTS_FTRACE_OPS 1
  #endif


arch/powerpc/Kconfig:

	select HAVE_DYNAMIC_FTRACE_WITH_REGS	if MPROFILE_KERNEL
[..]

  config MPROFILE_KERNEL
	depends on PPC64 && CPU_LITTLE_ENDIAN && FUNCTION_TRACER
	def_bool $(success,$(srctree)/arch/powerpc/tools/gcc-check-mprofile-kernel.sh $(CC) -I$(srctree)/include -D__KERNEL__)

So, it looks like you need to be 64bit PowerPC, Little Endian, and gcc
needs to support -mprofile.

Otherwise, it falls back to the old way that does the type casting.

If you are really concerned about this, I would recommend adding
support to the architecture you care about, and then this will no
longer be an issue.

The funny part is, you can still add support for ftrace_ops, without
adding support for DYNAMIC_FTRACE_WITH_REGS, if you only care about not
having to do that typecast.

My NAK still stands. I wont let an intrusive patch be added to the
ftrace core code to deal with an unsupported feature in an architecture.

I would be will to add that linker trick to remove the warning. Or we
just use that warning as incentive to get architecture developers to
implement this feature ;-)

-- Steve
