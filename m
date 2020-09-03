Return-Path: <SRS0=fpyj=CM=lists.openwall.com=kernel-hardening-return-19766-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331F0C43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:42:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 65D6E20716
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XY2V+aPz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65D6E20716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19766-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3786 invoked by uid 550); 3 Sep 2020 22:42:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3753 invoked from network); 3 Sep 2020 22:42:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TlwuOH2EQG6MCnppWuU43l955MakvluKpUTVDERTNO8=;
        b=XY2V+aPzW1+LDnPQgs8LCKdfsW+ukc0CH4hsERu2c197BquhpT6ytbY651mqbWroP5
         NoijPo4tmmhjTbE82fXMmxBiTTfrN9b+BObSgnEn5HC00srbReXMVw7CaVxDZQjvWDNb
         sLqtBJzVmvCGKIRCPcZC9IKz2mLH5Kg/+0yME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TlwuOH2EQG6MCnppWuU43l955MakvluKpUTVDERTNO8=;
        b=oPdedBrixJNxH8NkzVMtBF42J/9/nVvLnmu++mAXXmIyWFtLiVIhNipzKmQbJ2/rpY
         oGagm0u47bUdkW5UmS0L+AVaqOahcvNjc70zINW0q3blky5ZeE0XKXLWSkoRsI/EjiGa
         qEZ2n4ncHSuZ7ti69XBzmhHQ7+wIsfrmMFY6MWZIZ13tkhyyUSPL3ujlHyM7GLxukOsO
         czLtzhEjF4bZwCYvGwuRPkgs+tciTmI+ibi6pC1u4oyde+O9dNxq2aHxdotylReBneru
         UH9ZZrxLPxVgf5A/9heNh/IxMG/XzNnhzNwTrkHfUhQRq1o/pzr069yBW7mlst78T3Fv
         Kp6A==
X-Gm-Message-State: AOAM530rAQmBLo5pPBprvfdFyKVxRB25AKg4/DFCyst3uhB4HbgN44+G
	PckHjdawyZM3297FolzVnJu36w==
X-Google-Smtp-Source: ABdhPJyqBzmMfYaY/Mz5zx6mhtV8btCsnKX7oA2efoS7o6nY6a3yOyI6Ra3/iG5Srj/uMw3Z86qeLw==
X-Received: by 2002:a63:384b:: with SMTP id h11mr4827548pgn.113.1599172936031;
        Thu, 03 Sep 2020 15:42:16 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:42:13 -0700
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
Subject: Re: [PATCH v2 17/28] PCI: Fix PREL32 relocations for LTO
Message-ID: <202009031542.F6DA50F6@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-18-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-18-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:42PM -0700, Sami Tolvanen wrote:
> With Clang's Link Time Optimization (LTO), the compiler can rename
> static functions to avoid global naming collisions. As PCI fixup
> functions are typically static, renaming can break references
> to them in inline assembly. This change adds a global stub to
> DECLARE_PCI_FIXUP_SECTION to fix the issue when PREL32 relocations
> are used.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
