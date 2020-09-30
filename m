Return-Path: <SRS0=m0qU=DH=lists.openwall.com=kernel-hardening-return-20072-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDC9C4363D
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 21:10:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6A2362071E
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 21:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aznXL+Mf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A2362071E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20072-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3690 invoked by uid 550); 30 Sep 2020 21:10:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3655 invoked from network); 30 Sep 2020 21:10:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=43NmDXRdfvytQQYY6+SkI5I3v0G1ZKlfq1R/B+8Rbe8=;
        b=aznXL+Mf1oo937XoxBdAUWYbrGQBox+mHPLXOBi8fxELvJxmtN4Oh2fdCubtsfNRrA
         rDHSxjRXgFROvxwZKbrgkOQaw+IdYULTR8nRNYUFnd02K6q1DKbVRP6qGTIrAq/ntqIt
         uicIip4Sy8y/dZqila87XWTqZiy3eaEQT/WgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=43NmDXRdfvytQQYY6+SkI5I3v0G1ZKlfq1R/B+8Rbe8=;
        b=NNW51lhDW3wdD9TvTILV2L0jFNz2NrBGwN1zKGIBVk1bbIVb6FNw06Mk6IZ2+MhAZB
         HppmSjUZtMNHJjfS5o8f0heflGP2P+FIHJd3LI5zg89X2qYD/ecw49PZ5S2HIrkKYP4S
         dDteP11ymypQnGdDW3gBh9IS9u3wBIwj7URH/JDyYdAp1OcqAdwbcbDVxIYa/9AzmLy0
         rj0JZ9yHrr9s4SErwyqdouZEry/8f8dSUCz9ugGy4OijLwQw47L1TodFYP8lnJCqkrnB
         qOvE6i7HAmUxTmlG8ENeXtoJL478nE4MdJ/LmJ1Kxd2CRd0zkRupb2FqEpyOJIr2TDYW
         XG3w==
X-Gm-Message-State: AOAM533166Da2rLP7bOtdWM18OC8gbHz5R3UnhXhijCDl3AcHyacvAZH
	pgNK5p2d8qgToh6pSA0BhLJZaw==
X-Google-Smtp-Source: ABdhPJyw4kR2hvM1gD9zLPKC5ogvJTlrWuluJmqFM9fB7y/1oreMiPXLmURVREruQgKi3Vr48qMMIg==
X-Received: by 2002:a17:902:c40d:b029:d2:562d:db9 with SMTP id k13-20020a170902c40db02900d2562d0db9mr4239380plk.46.1601500235715;
        Wed, 30 Sep 2020 14:10:35 -0700 (PDT)
Date: Wed, 30 Sep 2020 14:10:33 -0700
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v4 00/29] Add support for Clang LTO
Message-ID: <202009301402.27A40DD1@keescook>
References: <20200929214631.3516445-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>

On Tue, Sep 29, 2020 at 02:46:02PM -0700, Sami Tolvanen wrote:
> Furthermore, patches 4-8 include Peter's patch for generating
> __mcount_loc with objtool, and build system changes to enable it on
> x86. With these patches, we no longer need to annotate functions
> that have non-call references to __fentry__ with LTO, which makes
> supporting dynamic ftrace much simpler.

Peter, can you take patches 4-8 into -tip? I think it'd make sense
to keep them together. Steven, it sounds like you're okay with the
changes (i.e. Sami showed the one concern you had was already handled)?
Getting these into v5.10 would be really really nice.

I'd really like to get the tree-spanning prerequisites nailed down
for this series. It's been difficult to coordinate given the multiple
maintainers. :)

Specifically these patches:

Peter Zijlstra (1):
  objtool: Add a pass for generating __mcount_loc

Sami Tolvanen (4):
  objtool: Don't autodetect vmlinux.o
  tracing: move function tracer options to Kconfig
  tracing: add support for objtool mcount
  x86, build: use objtool mcount

https://lore.kernel.org/lkml/20200929214631.3516445-5-samitolvanen@google.com/
https://lore.kernel.org/lkml/20200929214631.3516445-6-samitolvanen@google.com/
https://lore.kernel.org/lkml/20200929214631.3516445-7-samitolvanen@google.com/
https://lore.kernel.org/lkml/20200929214631.3516445-8-samitolvanen@google.com/
https://lore.kernel.org/lkml/20200929214631.3516445-9-samitolvanen@google.com/

Thanks!

-- 
Kees Cook
