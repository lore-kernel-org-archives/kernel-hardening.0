Return-Path: <SRS0=9ftN=YW=lists.openwall.com=kernel-hardening-return-17155-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10568CA9EAE
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 23:02:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5107520874
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 23:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="G6q4TjVx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5107520874
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17155-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16153 invoked by uid 550); 29 Oct 2019 23:02:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16118 invoked from network); 29 Oct 2019 23:02:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gj4I2e9np+ABg1fiWmCdoCCuD7MPQ/dMJG48/Df5Wsc=;
        b=G6q4TjVx3CqtV8p29Cff7c6W3UG54qYCOtFDTbhSS7DDw+WW1bP2eBvamOedaig8uF
         h5lfsay39HinGe9j0BCEB+poHCn8Gui7WU2KQZEDyhpQspIIkHSvsmOBMLabEe6rruMR
         JSyRzTixew4bfZzX/dtSGZc1sfX6wlSlhVCUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gj4I2e9np+ABg1fiWmCdoCCuD7MPQ/dMJG48/Df5Wsc=;
        b=qPKQZqBq5ffANFtX8uNw+DxnN17SJJyrIefCdT9Tx4+7yG3G25+qqJG+5yDoAiobMR
         3vKYtjylDBlOOc/tK+LpfoVaWi9sj6xwtLVNG/JBD5PfKZ3WtIZd6ri+cq4nA4oEzoMB
         LpIXU30pgJCd8Fb5wsq1r08VeCLLH6vOcKfDo2Y58oZQJj3/uURD6niit4dT6pFJ2VsO
         pj9WpINNuNbrFggRNS2xq9UrL8UPfnMrWWv3VNO7RJlkTxQ1kxUjsT9P9Fxnz1gecANm
         zVG4wR0FOLpAYZEYe8Wc34gdfIAeJecB+qf+a8J0Y4+JHmWH6ovdeWXgo5b7lMohaEYy
         0H+A==
X-Gm-Message-State: APjAAAWGflgtOs750yxTkOwPT4Z6hherJio+1HSlg04+n0kgtDqh6v9W
	qMGcV7eMwPNYLGpfXpQDpZt15g==
X-Google-Smtp-Source: APXvYqyBdXhgu4rolc+XvhattXES8Ylc6xiH5n4bwmYlBM6lz3srQcJLE/1uWUceHnGoPi2duJMBVQ==
X-Received: by 2002:a63:f04d:: with SMTP id s13mr1081841pgj.298.1572390158329;
        Tue, 29 Oct 2019 16:02:38 -0700 (PDT)
Date: Tue, 29 Oct 2019 16:02:36 -0700
From: Kees Cook <keescook@chromium.org>
To: Russell Currey <ruscur@russell.cc>
Cc: linuxppc-dev@lists.ozlabs.org, christophe.leroy@c-s.fr, joel@jms.id.au,
	mpe@ellerman.id.au, ajd@linux.ibm.com, dja@axtens.net,
	npiggin@gmail.com, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 0/4] Implement STRICT_MODULE_RWX for powerpc
Message-ID: <201910291601.F161FBBAB2@keescook>
References: <20191014051320.158682-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014051320.158682-1-ruscur@russell.cc>

On Mon, Oct 14, 2019 at 04:13:16PM +1100, Russell Currey wrote:
> v3 cover letter here:
> https://lists.ozlabs.org/pipermail/linuxppc-dev/2019-October/198023.html
> 
> Only minimal changes since then:
> 
> - patch 2/4 commit message update thanks to Andrew Donnellan
> - patch 3/4 made neater thanks to Christophe Leroy
> - patch 3/4 updated Kconfig description thanks to Daniel Axtens

I continue to be excited about this work. :) Is there anything holding
it back from landing in linux-next?

-Kees

> 
> Russell Currey (4):
>   powerpc/mm: Implement set_memory() routines
>   powerpc/kprobes: Mark newly allocated probes as RO
>   powerpc/mm/ptdump: debugfs handler for W+X checks at runtime
>   powerpc: Enable STRICT_MODULE_RWX
> 
>  arch/powerpc/Kconfig                   |  2 +
>  arch/powerpc/Kconfig.debug             |  6 ++-
>  arch/powerpc/configs/skiroot_defconfig |  1 +
>  arch/powerpc/include/asm/set_memory.h  | 32 ++++++++++++++
>  arch/powerpc/kernel/kprobes.c          |  3 ++
>  arch/powerpc/mm/Makefile               |  1 +
>  arch/powerpc/mm/pageattr.c             | 60 ++++++++++++++++++++++++++
>  arch/powerpc/mm/ptdump/ptdump.c        | 21 ++++++++-
>  8 files changed, 123 insertions(+), 3 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/set_memory.h
>  create mode 100644 arch/powerpc/mm/pageattr.c
> 
> -- 
> 2.23.0
> 

-- 
Kees Cook
