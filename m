Return-Path: <SRS0=0NGJ=6F=lists.openwall.com=kernel-hardening-return-18582-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B239C38A30
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 01:12:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DF4622084D
	for <kernel-hardening@archiver.kernel.org>; Tue, 21 Apr 2020 01:12:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF4622084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18582-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29963 invoked by uid 550); 21 Apr 2020 01:12:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29943 invoked from network); 21 Apr 2020 01:12:17 -0000
Date: Mon, 20 Apr 2020 21:12:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Catalin Marinas
 <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Ard
 Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland
 <mark.rutland@arm.com>, Masahiro Yamada <masahiroy@kernel.org>, Michal
 Marek <michal.lkml@markovi.net>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dave Martin
 <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, Laura Abbott
 <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Jann
 Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 01/12] add support for Clang's Shadow Call Stack
 (SCS)
Message-ID: <20200420211201.7fea9561@oasis.local.home>
In-Reply-To: <20200420171727.GB24386@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
	<20200416161245.148813-1-samitolvanen@google.com>
	<20200416161245.148813-2-samitolvanen@google.com>
	<20200420171727.GB24386@willie-the-truck>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Apr 2020 18:17:28 +0100
Will Deacon <will@kernel.org> wrote:

> > +ifdef CONFIG_SHADOW_CALL_STACK
> > +CC_FLAGS_SCS	:= -fsanitize=shadow-call-stack
> > +KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
> > +export CC_FLAGS_SCS
> > +endif  
> 
> CFLAGS_SCS would seem more natural to me, although I see ftrace does it this
> way.

The CC_FLAGS_FTRACE was added by Heiko Carstens, and the "CC_FLAGS_"
appears to be a common usage in s390 :-)

That said, I like the CC_FLAGS_ notation, because the Linux build
system uses CFLAGS_* as commands:

  CFLAGS_foo.o = x
  CFLAGS_REMOVE_foo.o = y

And "CC_FLAGS_" is only for new flags and easy to search for.

-- Steve
