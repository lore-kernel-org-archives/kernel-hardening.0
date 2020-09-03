Return-Path: <SRS0=teG7=CM=lists.openwall.com=kernel-hardening-return-19754-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E773BC43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:56:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3E343205CB
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:56:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Seros2DT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E343205CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19754-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13937 invoked by uid 550); 3 Sep 2020 21:56:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13905 invoked from network); 3 Sep 2020 21:56:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+qkcq0KaVk7HSQBAkByrnKJ1sZBfvqUX0j4GLf7P4Ho=;
        b=Seros2DTlS5cvJrc6eXGVeiAHZSqw0rR2qykzMdKQEtfa4XdwNdSID5ZkvediVM9AJ
         O7omW08AaLWNFuSJ2HD93Wkv2v202rCTP6thwQMutIbbVLf7kd+B9GMFYWvsh9yIgl4o
         wj2jIiZYQWQu0rnmAlwzd4ky0DUpgiwfDRBxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+qkcq0KaVk7HSQBAkByrnKJ1sZBfvqUX0j4GLf7P4Ho=;
        b=eXwtfwm4RwVTXfME1WyhqaLQHshpZ+/OIwegFpNETSbaBp7slm3ajVs+MrKede8hJ5
         3IWKA9SbWKA2N26u3tTtVV2gzIzNpAwa1gh6+pvHHqsdh5Gyc5hNyCW5FvRzz5QNmV1p
         Z7hoAhdn4dxv5HCS69hIw9jVcxhq6UIW8mIRo7VHTgvG9RuBe9BsnBYjwUDtKlVn+W/T
         C4U1Qy4OAxVsVfYZqrR1+tMVu4XRBZ9nUMqhtsWCYYMx9X73H3BmWAKwu/K4ayjoEvz3
         NguDOBh1we6tfdmnV+egaORp07nyEBoBw4juyUEPEAI3I488UPyZI2pPHuZGEj6vRuBn
         nSsA==
X-Gm-Message-State: AOAM532cQdrwzMhjupr3CsEHZPnL22FcUnT10quFTHrTZmDoPQ0XrmHz
	JAyH/RhuBGgSepavmmXxRQ5Iew==
X-Google-Smtp-Source: ABdhPJyOa4sKb29bYinReMEHv5PsZTZST1EHUNe/55RA0OQy4wRKFNRcU2420Azk0bfn+Y9cX+tWeg==
X-Received: by 2002:a62:fccf:: with SMTP id e198mr5659849pfh.183.1599170170933;
        Thu, 03 Sep 2020 14:56:10 -0700 (PDT)
Date: Thu, 3 Sep 2020 14:56:09 -0700
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
Subject: Re: [PATCH v2 07/28] kbuild: add support for objtool mcount
Message-ID: <202009031455.A305DD4F97@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-8-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-8-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:32PM -0700, 'Sami Tolvanen' via Clang Built Linux wrote:
> This change adds build support for using objtool to generate
> __mcount_loc sections.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Looks right to me. (There is probably an argument to be made to do all
of the tooling detection in the Kconfig, but that's a larger issues and
orthogonal to this fix, IMO.)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
