Return-Path: <SRS0=/Oks=CN=lists.openwall.com=kernel-hardening-return-19785-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9397C28E83
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 09:31:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F1D35205CB
	for <kernel-hardening@archiver.kernel.org>; Fri,  4 Sep 2020 09:31:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X6cu6bl5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F1D35205CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19785-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7858 invoked by uid 550); 4 Sep 2020 09:31:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7826 invoked from network); 4 Sep 2020 09:31:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AmeBKqJuZ2TYIisYso2pvDzyPT9l4D3l0ti74pdTg0Q=; b=X6cu6bl5JfSrh+TTxe5dm2zPRs
	AiQRbmkSz8bxctpcVVoJUTd01rMGXmOZD1xc0lycH34bN7CSlyCqLAmrwqwCvYEoUSY+xKfGld4VF
	JCRTmA9yOGr8HSQxXZZp0fcn1pu0evfCQDOhepKW7Fvx2z1bnS0GryJLJoZGx3ZlwXYUUOxjPfb7o
	kNuyepr5MwWnzwadfXwDZlwm4lYlcJEpHE5ups2L1YChLhEQMmrIhMWEID06+tzQcEqI7jmdr7sob
	gpJDg9cOQ61U1G3nEJzIW6pFYKekrsm8QtKX7dNM5NR2hG8PpFQEbMW+z/TGELU/RTLT1iNbZlPUN
	SqJu+eqw==;
Date: Fri, 4 Sep 2020 11:31:04 +0200
From: peterz@infradead.org
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Kees Cook <keescook@chromium.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 05/28] objtool: Add a pass for generating __mcount_loc
Message-ID: <20200904093104.GH1362448@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-6-samitolvanen@google.com>
 <202009031450.31C71DB@keescook>
 <CABCJKueF1RbpOKHsA8yS_yMujzHi8dzAVz8APwpMJyMTTGhmDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKueF1RbpOKHsA8yS_yMujzHi8dzAVz8APwpMJyMTTGhmDA@mail.gmail.com>

On Thu, Sep 03, 2020 at 03:03:30PM -0700, Sami Tolvanen wrote:
> On Thu, Sep 3, 2020 at 2:51 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, Sep 03, 2020 at 01:30:30PM -0700, Sami Tolvanen wrote:
> > > From: Peter Zijlstra <peterz@infradead.org>
> > >
> > > Add the --mcount option for generating __mcount_loc sections
> > > needed for dynamic ftrace. Using this pass requires the kernel to
> > > be compiled with -mfentry and CC_USING_NOP_MCOUNT to be defined
> > > in Makefile.
> > >
> > > Link: https://lore.kernel.org/lkml/20200625200235.GQ4781@hirez.programming.kicks-ass.net/
> > > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> >
> > Hmm, I'm not sure why this hasn't gotten picked up yet. Is this expected
> > to go through -tip or something else?
> 
> Note that I picked up this patch from Peter's original email, to which
> I included a link in the commit message, but it wasn't officially
> submitted as a patch. However, the previous discussion seems to have
> died, so I included the patch in this series, as it cleanly solves the
> problem of whitelisting non-call references to __fentry__. I was
> hoping for Peter and Steven to comment on how they prefer to proceed
> here.

Right; so I'm obviously fine with this patch and I suppose I can pick it
(and the next) into tip/objtool/core, provided Steve is okay with this
approach.
