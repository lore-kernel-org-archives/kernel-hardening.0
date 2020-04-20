Return-Path: <SRS0=QzCT=6E=lists.openwall.com=kernel-hardening-return-18575-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A95C54FD0
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 19:23:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 785012084D
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 19:23:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 785012084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18575-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26165 invoked by uid 550); 20 Apr 2020 19:23:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26142 invoked from network); 20 Apr 2020 19:23:22 -0000
Date: Mon, 20 Apr 2020 15:23:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Sami Tolvanen
 <samitolvanen@google.com>, Will Deacon <will@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard
 Biesheuvel <ard.biesheuvel@linaro.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, Ingo Molnar
 <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Kees Cook
 <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Marc Zyngier
 <maz@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers
 <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, Miguel Ojeda
 <miguel.ojeda.sandonis@gmail.com>, clang-built-linux@googlegroups.com,
 kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 04/12] scs: disable when function graph tracing is
 enabled
Message-ID: <20200420152306.2d45e3c4@gandalf.local.home>
In-Reply-To: <20200417154613.GB9529@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
	<20200416161245.148813-1-samitolvanen@google.com>
	<20200416161245.148813-5-samitolvanen@google.com>
	<20200417100039.GS20730@hirez.programming.kicks-ass.net>
	<20200417144620.GA9529@lakrids.cambridge.arm.com>
	<20200417152645.GH20730@hirez.programming.kicks-ass.net>
	<20200417154613.GB9529@lakrids.cambridge.arm.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Apr 2020 16:46:14 +0100
Mark Rutland <mark.rutland@arm.com> wrote:

> > > > And doesn't BPF also do stuff like this?  
> > > 
> > > Can BPF mess with return addresses now!?  
> > 
> > At least on x86 I think it does. But what do I know, I can't operate
> > that stuff. Rostedt might know.  
> 
> Sounds like I might need to do some digging...

May want to ping Alexei. It appears that if BPF adds a direct hook to a
function, it will prevent the function graph tracer from tracing it. :-/

-- Steve
