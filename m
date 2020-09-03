Return-Path: <SRS0=Ljkb=CM=lists.openwall.com=kernel-hardening-return-19776-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C91C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:48:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2C2C320716
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:48:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Oywi+Oec"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C2C320716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19776-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21527 invoked by uid 550); 3 Sep 2020 22:48:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20462 invoked from network); 3 Sep 2020 22:48:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N0kZAZSHXumzFlr+P3KSPa/xm/RvLBA66H9sz+ks+Hk=;
        b=Oywi+Oecms9EF3LovMy4YD4zvKOmcmZdnBLP+RpPo6vJNZvq4Wn2exUrN/cYyBRvkj
         QpHAOCzGUNXF3wIsqPQqbSCg3YTtavUaX+FrsM9NvoAyqfJuCJ9m05znPNWTjs0F38rh
         A9mlrLTr/MJ+vIHnNL9G8CGzKKp8or3nRT3jg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N0kZAZSHXumzFlr+P3KSPa/xm/RvLBA66H9sz+ks+Hk=;
        b=p1jLXz6vCxhyoYxAjpum+Md/0c6LETWeXlvQ5vm1lzf7cgTqtu13+/NWV3rvcg2tnI
         rWniic5lz9rWguTL/wzC9m8HmtccODjdCuWep3gfzBl7seqnbSpWqjFB8/LHnm3+nQJh
         NAvG1+k0yvVmmJUfJDcLqZqAetScsOxVwHuLrKmUZI34QWFpzTrQWwNQkIpOzY/+9UuE
         nGjioP5C028LT8W38SKcPPsoB1CgNJ6M5Ttag7fvAhKzHBoRrIPzyDFrdBjO7VGk6e1F
         8t/gy1QjXR5EUgZzpRxVTO+V8eACYDFoS7GU6O0FLEvX6cokrK0U3SoF+uaVHBt4sV+E
         fmNA==
X-Gm-Message-State: AOAM530k50CS1MD7arP4gc7tfzW5XxuADqZjkrD5FhNryfupp3gpURia
	prIjkd/KICr3Mx0hYxKcYUHv/g==
X-Google-Smtp-Source: ABdhPJzhSDd0wUjK+CLAjJOCS+RRpwDZiMWAA9QXCsfZew5vqJTkaYMpTKaYMs063H+/576UYhDU1A==
X-Received: by 2002:a63:f546:: with SMTP id e6mr4666553pgk.7.1599173318626;
        Thu, 03 Sep 2020 15:48:38 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:48:36 -0700
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
Subject: Re: [PATCH v2 28/28] x86, build: allow LTO_CLANG and THINLTO to be
 selected
Message-ID: <202009031548.84902F3F@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-29-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-29-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:53PM -0700, Sami Tolvanen wrote:
> Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

I think it might be worth detailing why these arguments aren't handled
in the normal fashion under Clang's LTO. Regardless, it's needed to make
it work, so:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
