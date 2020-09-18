Return-Path: <SRS0=PB0Z=C3=lists.openwall.com=kernel-hardening-return-19951-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C54C43464
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 21:29:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 783AA2311C
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Sep 2020 21:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="W+/RKJ9p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 783AA2311C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19951-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19495 invoked by uid 550); 18 Sep 2020 21:29:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19457 invoked from network); 18 Sep 2020 21:29:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GaeOhHfh8L1DCmfaELuYzcrF6n6HIXLIYRNTzqsV79Y=;
        b=W+/RKJ9pTVfHlLkwso1szh6HtM1ljwgfll2m1S7UpWBfhGNOhcAgS0vcics0UCB6P6
         dN86cdQ1w9MJuw6LvS3fM80dVq9dvH5tMXxpAqqbGZHk658zN870WIKFcsCTayCfDtNQ
         T7NafpHvlBEzNZ5MQFycOCV7aKSjbwjKdKCPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GaeOhHfh8L1DCmfaELuYzcrF6n6HIXLIYRNTzqsV79Y=;
        b=JyeRrhOd0qCt7y7X+PwQFMXp0Cl0TGqah/MHZepv8+TCz9EhZkhGw+x91qUNI5DAa1
         d/2tfXbgZuPdll08aw39GB1Ir4h4Y0pgjysGFeFJE1Df1uvQMD/zXvM1nA0wNZhT0ZMg
         XBZnqSJ1w7r2cXMdyHcypKYHqaiRv5tKtyRtcT3HLZ5ztymSoIKZ4cxX+k7LiFxAmt1q
         RdvShCDKegyY3FJlnkqhI2FfiF8IijgGYJHAHTfwdLXglY+ADJaepLMzbjZBamMnhnvw
         uLaLUytwe5XUgPjBHn9MSKiU+TZSfpzMK2BjwPjZYc5vFDl5AmFiFGP7v6pl0IQ2SgZB
         eyJg==
X-Gm-Message-State: AOAM533L2vM+xGQxuCW52HMgl7AbJXIf8emHliLuzhHTbxN5v3go2eYX
	z+Vl36PRSGsYiJptQkpcecl9cA==
X-Google-Smtp-Source: ABdhPJyRQsmmFdjwcGkpqBzOOW1CFrolZnNpgZgaeJg1rXVSbKFTb9+lQpAZIZvZVlks1h2iMqNz4w==
X-Received: by 2002:a17:90a:ad48:: with SMTP id w8mr14636473pjv.179.1600464578722;
        Fri, 18 Sep 2020 14:29:38 -0700 (PDT)
Date: Fri, 18 Sep 2020 14:29:37 -0700
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
Subject: Re: [PATCH v3 17/30] init: lto: ensure initcall ordering
Message-ID: <202009181428.3C45B57DA@keescook>
References: <20200918201436.2932360-1-samitolvanen@google.com>
 <20200918201436.2932360-18-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918201436.2932360-18-samitolvanen@google.com>

On Fri, Sep 18, 2020 at 01:14:23PM -0700, Sami Tolvanen wrote:
> With LTO, the compiler doesn't necessarily obey the link order for
> initcalls, and initcall variables need globally unique names to avoid
> collisions at link time.
> 
> This change exports __KBUILD_MODNAME and adds the initcall_id() macro,
> which uses it together with __COUNTER__ and __LINE__ to help ensure
> these variables have unique names, and moves each variable to its own
> section when LTO is enabled, so the correct order can be specified using
> a linker script.
> 
> The generate_initcall_ordering.pl script uses nm to find initcalls from
> the object files passed to the linker, and generates a linker script
> that specifies the same order for initcalls that we would have without
> LTO. With LTO enabled, the script is called in link-vmlinux.sh through
> jobserver-exec to limit the number of jobs spawned.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Thanks for the update; using jobserver-exec looks much better for
controlling the build resources. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
