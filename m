Return-Path: <SRS0=7U/9=Y5=lists.openwall.com=kernel-hardening-return-17290-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DATE_IN_PAST_06_12,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FE3C5DF60
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 19:55:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1BB3F21D6C
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 Nov 2019 19:55:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BB3F21D6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17290-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18232 invoked by uid 550); 5 Nov 2019 19:55:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18190 invoked from network); 5 Nov 2019 19:55:08 -0000
Date: Tue, 5 Nov 2019 09:15:51 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 11/17] arm64: disable function graph tracing with SCS
Message-ID: <20191105091301.GB4743@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com>
 <20191101221150.116536-12-samitolvanen@google.com>
 <20191104171132.GB2024@lakrids.cambridge.arm.com>
 <CABCJKufDnLjP9vA-wSW0gSY05Cbr=NOpJ-WCh-bdj2ZNq7VNXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKufDnLjP9vA-wSW0gSY05Cbr=NOpJ-WCh-bdj2ZNq7VNXw@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Mon, Nov 04, 2019 at 03:44:39PM -0800, Sami Tolvanen wrote:
> On Mon, Nov 4, 2019 at 9:11 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > Can you please elaborate on _how_ this is incompatible in the commit
> > message?
> >
> > For example, it's not clear to me if you mean that's functionally
> > incompatible, or if you're trying to remove return-altering gadgets.
> >
> > If there's a functional incompatibility, please spell that out a bit
> > more clearly. Likewise if this is about minimizing the set of places
> > that can mess with control-flow outside of usual function conventions.
> 
> Sure, I'll add a better description in v5. In this case, the return
> address is modified in the kernel stack, which means the changes are
> ignored with SCS.

Ok, that makes sense to me. I'd suggest something like:

| The graph tracer hooks returns by modifying frame records on the
| (regular) stack, but with SCS the return address is taken from the
| shadow stack, and the value in the frame record has no effect. As we
| don't currently have a mechanism to determine the corresponding slot
| on the shadow stack (and to pass this through the ftrace
| infrastructure), for now let's disable the graph tracer when SCS is
| enabled.

... as I suspect with some rework of the trampoline and common ftrace
code we'd be able to correctly manipulate the shadow stack for this.
Similarly, if clang gained -fpatchable-funciton-etnry, we'd get that for
free.

Thanks,
Mark.
