Return-Path: <SRS0=3FVa=37=lists.openwall.com=kernel-hardening-return-17783-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12C8C35242
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Feb 2020 23:54:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3D3AA206DA
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Feb 2020 23:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XB7DUxrO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D3AA206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17783-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32173 invoked by uid 550); 11 Feb 2020 23:54:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32135 invoked from network); 11 Feb 2020 23:54:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BDlxFx20QE0gAgkEMA+u4mAwlJYSDizranolCfN6FSU=;
        b=XB7DUxrOlRWKCxIVzsmwUiozIyPNm+XipqRy+ojNQXQ4il5NSGcySle4DA3copkxR0
         txpPB/fPke36xIv/qe2phszSj0yMMBhZ7SSIKgC8wlYAX/nwLnydJ9528PktuoKka0Xo
         FIQk6kwnmb94p+mMQF56OxOJi3mG8ahbOTuU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BDlxFx20QE0gAgkEMA+u4mAwlJYSDizranolCfN6FSU=;
        b=ub9daydfis+RqmLaEGzatu3DhQ2WocWe5zu1n5ETfrSWtB6E2gj6D89S93No6Dmtr2
         YFDMgA82GuIeC+6pDu6bqWRyjjEwZPXFwPaIPKrjk7TVtnXkM3ch7JfLou3hLPjrDkrp
         WZsWxFcW2vl/CsNHXJeUJ7RmzBBxeDlHlOhVDvZuZcJTpV8IUyiuhapV/6JF3qCu6lEh
         YTj2bs2CfXqKIXut7/yLGfPTos2eEgJpDWzwzkgFWVRC1UWYI/e+91DTTBX1mGpZBnKJ
         x2hReBPHOEmJkYckVZ39cBq0rE+TjugYoGgX/eSeFu7ndTv5vDlONfs9+IEycs9s1yGc
         U1DQ==
X-Gm-Message-State: APjAAAX2zC3WHeCKtWTPjI/VYUFbJhMoCySDhxbvNW1wRh/NEYD9BPoa
	pqbsZRTxqtnKgSVgLzZzGxHvQA==
X-Google-Smtp-Source: APXvYqwqQSXGq4Fmc5d6MiCNIFPhP1UefR6VzsmHhkS/fi/pcrd5lNid2Jli/7N0q+/799PEFAxbdw==
X-Received: by 2002:a17:902:708b:: with SMTP id z11mr5645748plk.121.1581465248817;
        Tue, 11 Feb 2020 15:54:08 -0800 (PST)
Date: Tue, 11 Feb 2020 15:54:06 -0800
From: Kees Cook <keescook@chromium.org>
To: shuah <shuah@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Hector Marco-Gisbert <hecmargi@upv.es>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Jason Gunthorpe <jgg@mellanox.com>, Jann Horn <jannh@google.com>,
	Russell King <linux@armlinux.org.uk>, x86@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 7/7] selftests/exec: Add READ_IMPLIES_EXEC tests
Message-ID: <202002111549.CF18B7B3B@keescook>
References: <20200210193049.64362-1-keescook@chromium.org>
 <20200210193049.64362-8-keescook@chromium.org>
 <4f8a5036-dc2a-90ad-5fc8-69560a5dd78e@kernel.org>
 <202002111124.0A334167@keescook>
 <c09c345a-786f-25d2-1ee5-65f9cb23db6d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c09c345a-786f-25d2-1ee5-65f9cb23db6d@kernel.org>

On Tue, Feb 11, 2020 at 02:06:53PM -0700, shuah wrote:
> On 2/11/20 12:25 PM, Kees Cook wrote:
> > On Tue, Feb 11, 2020 at 11:11:21AM -0700, shuah wrote:
> > > On 2/10/20 12:30 PM, Kees Cook wrote:
> > > > In order to check the matrix of possible states for handling
> > > > READ_IMPLIES_EXEC across native, compat, and the state of PT_GNU_STACK,
> > > > add tests for these execution conditions.
> > > > 
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > 
> > > No issues for this to go through tip.
> > > 
> > > A few problems to fix first. This fails to compile when 32-bit libraries
> > > aren't installed. It should fail the 32-bit part and run other checks.
> > 
> > Do you mean the Makefile should detect the missing compat build deps and
> > avoid building them? Testing compat is pretty important to this test, so
> > it seems like missing the build deps causing the build to fail is the
> > correct action here. This is likely true for the x86/ selftests too.
> > 
> > What would you like this to do?
> > 
> 
> selftests/x86 does this already and runs the dependency check in
> x86/Makefile.
> 
> 
> check_cc.sh:# check_cc.sh - Helper to test userspace compilation support
> Makefile:CAN_BUILD_I386 := $(shell ./check_cc.sh $(CC)
> trivial_32bit_program.c -m32)
> Makefile:CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC)
> trivial_64bit_program.c)
> Makefile:CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC)
> trivial_program.c -no-pie)
> 
> Take a look and see if you can leverage this.

I did before, and it can certainly be done, but their stuff is somewhat
specific to x86_64/ia32. I'm looking at supporting _all_ compat for any
64-bit architecture. I can certainly write some similar build tooling,
but the question I have for you is one of coverage:

If a builder is 64-bit, it needs to be able to produce 32-bit compat
binaries for testing, otherwise the test is incomplete. (i.e. the tests
will only be able to test native behavior and not compat). This doesn't
seem like an "XFAIL" situation to me, and it doesn't seem right to
silently pass. It seems like the build should explicitly fail because
the needed prerequisites are missing. Do you instead want me to just
have it skip building the compat binaries if it can't build them?

-- 
Kees Cook
