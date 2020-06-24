Return-Path: <SRS0=hF3K=AF=lists.openwall.com=kernel-hardening-return-19145-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB1CC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:45:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AC6032081A
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kAzFiuub"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC6032081A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19145-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7963 invoked by uid 550); 24 Jun 2020 21:45:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7929 invoked from network); 24 Jun 2020 21:45:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2I1W9/xF2d1Vj6fXUSW50a6lcRysW14cejGyX/KQrUE=;
        b=kAzFiuub3JptGeF8CNTcnC+CeP/FsxM38jl9PiZjmZ2NQEKCzf5W55HotGQ3RFsl47
         OU28gJzz3nFm0K+qZFZj3aI4XkCmA0i32hx7kEqSPXYASiEOFWG196YJXulcZC3Y9dyz
         7yrrrZ4gUvmMXog64rqdi3irHXMSe28OJl0jht0IedPAX5FdSbei28cHde7gFfC8WQTO
         Th94MFJ7oKpcHcW0N9ISYWBLrKFqFcAygWKu8Bgdc273Y+lpnMx+5Oa57A1RVV779WXs
         N9wCMhhfGA+gmYVaSfQFrOgexBHpRg0exI1Q7NtzxhM5Ml3G7MxFC3aUmhMIk7wXvif6
         SpYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2I1W9/xF2d1Vj6fXUSW50a6lcRysW14cejGyX/KQrUE=;
        b=aafKtVDjtKgfWBs7WaoY6ECBU2QOJjz0iTpjKjoPC4oSnmy+Q6ej/Z0NKChXgPBdmC
         biH1tC8mwtZ4zOm1pCjWXsDkJ/TdtzymMMxVTnU1Qiy1Nte3cfsKQ2vr4hj9D9US/w/Z
         13DrDPjzCoQvMdXnQwgfYiZw1E42OTZlwZ4iR6guYr3Qo+vrpw7UHB3jryxXZbxWOqfM
         I6aorALwChggfcm6WDSnLlp46Xjl5W9jDiVsc4rLvuZ5JhNWzq4wp5Ls8SxM5u1dxXnK
         IyEvefp4Z6oY2JZrqkfh6PhkaH8UNmYe7uK1AUW1edJamP+MB6bYtMRoJFG81QLx6sxP
         aIhw==
X-Gm-Message-State: AOAM530DnHu6kgrSX4fdeJ4hG3mMi17BIbxb2raxG2kl+T2TgI+cs735
	gAyQNttJ27xeYCuuOxXMPDZjKg==
X-Google-Smtp-Source: ABdhPJxJmUZYMRaQyfOp9XANW1+HBk5Vx8x0dWsfSmu7dydDXvUxNLtKKWPkOY7MNgSE/tyVCHzLvA==
X-Received: by 2002:a17:90b:916:: with SMTP id bo22mr7503001pjb.100.1593035136962;
        Wed, 24 Jun 2020 14:45:36 -0700 (PDT)
Date: Wed, 24 Jun 2020 14:45:30 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 04/22] kbuild: lto: fix recordmcount
Message-ID: <20200624214530.GA120457@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com>
 <20200624212737.GV4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624212737.GV4817@hirez.programming.kicks-ass.net>

On Wed, Jun 24, 2020 at 11:27:37PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 24, 2020 at 01:31:42PM -0700, Sami Tolvanen wrote:
> > With LTO, LLVM bitcode won't be compiled into native code until
> > modpost_link. This change postpones calls to recordmcount until after
> > this step.
> > 
> > In order to exclude specific functions from inspection, we add a new
> > code section .text..nomcount, which we tell recordmcount to ignore, and
> > a __nomcount attribute for moving functions to this section.
> 
> I'm confused, you only add this to functions in ftrace itself, which is
> compiled with:
> 
>  KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))
> 
> and so should not have mcount/fentry sites anyway. So what's the point
> of ignoring them further?
> 
> This Changelog does not explain.

Normally, recordmcount ignores each ftrace.o file, but since we are
running it on vmlinux.o, we need another way to stop it from looking
at references to mcount/fentry that are not calls. Here's a comment
from recordmcount.c:

  /*
   * The file kernel/trace/ftrace.o references the mcount
   * function but does not call it. Since ftrace.o should
   * not be traced anyway, we just skip it.
   */

But I agree, the commit message could use more defails. Also +Steven
for thoughts about this approach.

Sami
