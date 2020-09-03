Return-Path: <SRS0=7V5N=CM=lists.openwall.com=kernel-hardening-return-19772-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F0CC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:45:52 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0EC6320716
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Zx5KJ4dv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EC6320716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19772-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13853 invoked by uid 550); 3 Sep 2020 22:45:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13818 invoked from network); 3 Sep 2020 22:45:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LpH2+c3Q5/rnXgDQMsrsJ9HiSsfoyzj1qvyyccEruIs=;
        b=Zx5KJ4dvVR2kYJ0RF1K2y79qhIcjc7yrsCRJoTz5s2zCxiKL8II6gShD3dRiuI5JuE
         CAqlIg/RCYIqxwgBTCdJCoxlCyAR33IC7dws/kSOZM0OWTmWQqku5KG5vBN3wHaXWX2J
         L3kWlvlx6YmS4Z9tOt3VwHxiD169ei5sQPoz8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LpH2+c3Q5/rnXgDQMsrsJ9HiSsfoyzj1qvyyccEruIs=;
        b=SCO5VC5Clxy+kP7Hbx4n/Xamq02bqf64Ql3YrGfbYuynTCERbPJ5NQzGa/BcsA23pW
         F8aGk3nycg4cjW+xlTZBHqcX9XKJUxWHej8B3As+VHoTw97U/OXUi+xnC+H8lp6L6CPP
         I90ykx5mN0x3youALCldN+iXh8rYAGdk5UUNDcT5EVqlQu3CYWPFm7xtzkYTzZc+van8
         UmQeFs41E18dNzs2MsstFZWxfudXrumifmVxXrKMBaP3c1el4x0WDGIie9RM/r5uulWH
         RmXGobnIRuZqdzXi8Ic95tWqeE7eJgyTMRyn6kmslVaOcQJmo6xXhXam/1tE6CPiWnSl
         8V6Q==
X-Gm-Message-State: AOAM5332vG0P12lZhX8Ktfe6LLYztdwuX6gE8OKCOZuB1xO//BWQqRe4
	ewz7zs+Ao08PezurYVkROZ6QvQ==
X-Google-Smtp-Source: ABdhPJw+gsOOUY6Clu21aqvi2zeFtbK32caDaCf93/U25KjvZIefQe4UypsHJhKhOKzenMYzI/0+7Q==
X-Received: by 2002:a17:902:82c7:: with SMTP id u7mr1398150plz.240.1599173133340;
        Thu, 03 Sep 2020 15:45:33 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:45:31 -0700
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
	x86@kernel.org
Subject: Re: [PATCH v2 24/28] KVM: arm64: disable LTO for the nVHE directory
Message-ID: <202009031545.42ECDC8F7F@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-25-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-25-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:49PM -0700, 'Sami Tolvanen' via Clang Built Linux wrote:
> We use objcopy to manipulate ELF binaries for the nvhe code,
> which fails with LTO as the compiler produces LLVM bitcode
> instead. Disable LTO for this code to allow objcopy to be used.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
