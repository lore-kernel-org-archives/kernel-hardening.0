Return-Path: <SRS0=LBZR=DJ=lists.openwall.com=kernel-hardening-return-20085-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C67C4363D
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Oct 2020 14:13:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4600C206DD
	for <kernel-hardening@archiver.kernel.org>; Fri,  2 Oct 2020 14:13:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jIxXL97f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4600C206DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20085-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32028 invoked by uid 550); 2 Oct 2020 14:13:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32005 invoked from network); 2 Oct 2020 14:13:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1601648000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T8R1XgQI7k4cK5q1LMAze0lbj0we9wkSuLhijnQjdY4=;
	b=jIxXL97fgKS9jwteVh9H03knarsGTvXqdIqSk0HItgAMFHydlC+y/UrmJUzhY1WgFH9fc/
	NSWlgKg4y34O2ilkA9L3opSRT92pxWipvq3ders2w07JNaHURmHCxRCz/24OVklySqc/h+
	utujEff2mFKsSP7KZZE4hYPQNNyTv9Q=
X-MC-Unique: KaOFE74rOgejG5g4BEKn6g-1
Date: Fri, 2 Oct 2020 09:13:03 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miroslav Benes <mbenes@suse.cz>,
	Sami Tolvanen <samitolvanen@google.com>,
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
	x86@kernel.org, jthierry@redhat.com
Subject: Re: [PATCH v4 04/29] objtool: Add a pass for generating __mcount_loc
Message-ID: <20201002141303.hyl72to37wudoi66@treble>
References: <20200929214631.3516445-1-samitolvanen@google.com>
 <20200929214631.3516445-5-samitolvanen@google.com>
 <alpine.LSU.2.21.2010011504340.6689@pobox.suse.cz>
 <20201001133612.GQ2628@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201001133612.GQ2628@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13

On Thu, Oct 01, 2020 at 03:36:12PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 01, 2020 at 03:17:07PM +0200, Miroslav Benes wrote:
> 
> > I also wonder about making 'mcount' command separate from 'check'. Similar 
> > to what is 'orc' now. But that could be done later.
> 
> I'm not convinced more commands make sense. That only begets us the
> problem of having to run multiple commands.

Agreed, it gets hairy when we need to combine things.  I think "orc" as
a separate subcommand was a mistake.

We should change to something like

  objtool run [--check] [--orc] [--mcount]
  objtool dump [--orc] [--mcount]

-- 
Josh

