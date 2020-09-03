Return-Path: <SRS0=I01K=CM=lists.openwall.com=kernel-hardening-return-19765-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6F2C43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:42:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 77C5C20716
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="GWCaNT3n"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77C5C20716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19765-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1966 invoked by uid 550); 3 Sep 2020 22:42:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1932 invoked from network); 3 Sep 2020 22:42:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t/oG9SCdq1xWr+ov4DXCG17oZgdOZVwWJcpUXXDNoEo=;
        b=GWCaNT3nM4fn50pBeGH+priah+inHtz/+o/HSxcFKJ+9g6L+7lcpaLmH1aFDCEt3sN
         cLNnfv5X6AEYL9NeIlpm/9yK+/MRS6sR6/uRRoPYye7RqP7/TVrQSHnggMT3tq9sR9hF
         zOPK2FA4z7TKMCX63xaseRtM1umBgGDIijy9M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t/oG9SCdq1xWr+ov4DXCG17oZgdOZVwWJcpUXXDNoEo=;
        b=GEOKBWVeLyEyVlCWLwq1KvDChSp/LhQafYb0RyKJcO3yZjGKPAr+PbQEaIzDpljQqo
         A4y8CIRNcyLVIgxB8IRZ16TmcEMCHgHvaY52kij2wCflycY8oYMIlzfHE2HBX81WdT5L
         +36AkHJca54ZIhOlcCI4fHBui+SNW047AK2M5WkTelKKKou8Sklvr3hjepE0zSofi6AZ
         cxQdkQtaZWS7Gm32Ni7x9o+d+0pCvadjb4lbCxFrkWHnzhAS24LZMxL3kYFIrEo47ynE
         PRM7HfR1ceQD7tZO+6N8dLAzIaVGfQT9m2Uw1IA8xm7vLKa6pZkoxi5IOAIC+xPCS0JX
         ftMA==
X-Gm-Message-State: AOAM531YRwJCIVSGmK50BWVDwIi+l0/0eNkZup76B4PA6jQlKYOM1Oas
	EL/rtXYnYuLpWVYdncg42DuA+A==
X-Google-Smtp-Source: ABdhPJzys++XSMZHn3WsTh+Gbvu5ZeD0Z5uwNitWJ8c9N8vmC+r+J+StAFQG3dzO4Nx2TrB3bIJMrw==
X-Received: by 2002:a17:90a:f298:: with SMTP id fs24mr5478610pjb.4.1599172910026;
        Thu, 03 Sep 2020 15:41:50 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:41:47 -0700
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
Subject: Re: [PATCH v2 16/28] init: lto: fix PREL32 relocations
Message-ID: <202009031541.40B54A2E51@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-17-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-17-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:41PM -0700, 'Sami Tolvanen' via Clang Built Linux wrote:
> With LTO, the compiler can rename static functions to avoid global
> naming collisions. As initcall functions are typically static,
> renaming can break references to them in inline assembly. This
> change adds a global stub with a stable name for each initcall to
> fix the issue when PREL32 relocations are used.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

This was a Delight(tm) to get right. Thanks for finding the right magic
here. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
