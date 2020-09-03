Return-Path: <SRS0=HBaF=CM=lists.openwall.com=kernel-hardening-return-19751-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0B3C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:50:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 18C6420709
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:50:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SlD5lTtn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18C6420709
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19751-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7233 invoked by uid 550); 3 Sep 2020 21:50:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7200 invoked from network); 3 Sep 2020 21:50:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9OR6JT/gDQkiw7Q3Fa+IeISt3W9FIEoweyBz21QtHYY=;
        b=SlD5lTtnmNwlNoqmJOqtx2+Yt4N1mjRl+6MJSYVsMfoK7/Vte9rczahAFAqHnyUmuV
         Sh7rwOVbBxjFQ8McJgNgBYopu598rgZcDcsmsFDuQmlnFjiaMgVEzupYqeqjeeE3eUEq
         lRP6kFMGcXoyupiZ9023vt2rn4Dd4rd9u4Z74=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9OR6JT/gDQkiw7Q3Fa+IeISt3W9FIEoweyBz21QtHYY=;
        b=SfKDlwnfYnmFrwFkwv6L34212PwBZX1ucZzTJtzs4/9tEJJL2017Csxven/ra74vOm
         2sHwFMng1MRVYmWphNV+0lyzvcOJpu1l2xoAyanXQFRo4s8FDdCJscp7kfkkptAAm2D4
         R4UtTvWa+Z1ImKnH6FUdHZf1/hZ7lavJMaBiOpsSteyqiMPthN5POq4zjDHg3571TyAJ
         V64Ye5qqZ0ghy4+p6yPAbdYdxs/OEydVyJJawwKPN8d118doPG7J+15zPYIUsq0pYdTy
         PmgV5ijI20COiHqUQD2eeJknGUfu2Rcl/uFv1a3npf+vIJgw0Lc4IOqgdw+HX9MFsuxd
         Mzog==
X-Gm-Message-State: AOAM531uh+/S8CSuT7UDWz1GRGfW/MB046OFaihkqhg9Ey1PJ+Gi2X0g
	3hShXibXp+GYSOm6Cv0oycTkJg==
X-Google-Smtp-Source: ABdhPJzv22i9c6AyREMh2qsXkXGwLuQNiCYhEpeSxCHuz3ZxEVmXaBNaH/fkJhsoZ2M5HPXWMnRolQ==
X-Received: by 2002:a65:648c:: with SMTP id e12mr4696062pgv.57.1599169805900;
        Thu, 03 Sep 2020 14:50:05 -0700 (PDT)
Date: Thu, 3 Sep 2020 14:50:03 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, Luca Stefani <luca.stefani.ge1@gmail.com>
Subject: Re: [PATCH v2 04/28] RAS/CEC: Fix cec_init() prototype
Message-ID: <202009031449.287535C@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-5-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-5-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:29PM -0700, Sami Tolvanen wrote:
> From: Luca Stefani <luca.stefani.ge1@gmail.com>
> 
> late_initcall() expects a function that returns an integer. Update the
> function signature to match.
> 
>  [ bp: Massage commit message into proper sentences. ]
> 
> Fixes: 9554bfe403nd ("x86/mce: Convert the CEC to use the MCE notifier")
> Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>

I don't see this in -next yet (next-20200903), but given Boris's SoB, I
suspect it just hasn't snuck it's way there from -tip. Regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
