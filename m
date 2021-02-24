Return-Path: <SRS0=JZt3=H2=lists.openwall.com=kernel-hardening-return-20824-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4544BC433E6
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 20:39:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3D32664E09
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Feb 2021 20:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D32664E09
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20824-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5751 invoked by uid 550); 24 Feb 2021 20:39:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5725 invoked from network); 24 Feb 2021 20:39:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GZwVz+by9nHRK/VgqqFp4hya3sLU12ve4q94Q8a1TOw=;
        b=PkCcl/k7NfbtPwMQr8z5WhePJ8T22XJy9sfGUI5eow2vQmOTwG1B3B6CsQhjz6CARN
         hfN1R2ddWbMTYj9tE1Lwh+a/L635lr64afHtTZRdXvbYHBmR84iGmARmfeZH96r9Q2bl
         rylrULoicn3EwqmyKEvuCNlKTjG3ImD8g1etA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GZwVz+by9nHRK/VgqqFp4hya3sLU12ve4q94Q8a1TOw=;
        b=A64eI5JKFmhUKdF0l7/LQmlNSQdjSaGQpI68lqqve3TF8LtbrOSnZZKwuSZTetOsHq
         0pqyO7A4LBPosqjmTzhxV3GqMeZ6eX0QI4f2a6QAWdXwg+hz7gTd4sRYTGLTBANA6MQ/
         70uwyylz4ppcBN2GAe1gTM83CUyM4KrXdNF6I07+XaIyl6fdrjNrqPNO7XW1O49P3d9W
         tjcZ8y1yhCR6kulpSxn+iV2W4rpa01VYn4kCSSn+8b8xbCstYpj6QEk2qWPwQS+XbSMd
         eFZ9evmNzd9yozCx1wfTHlR8aOhoGz/4USfn4MDx4g8Jlq7RIdY9avLmqRE81KYj8b6k
         7zgQ==
X-Gm-Message-State: AOAM530cd9efsOUNxne2SJypKN7HYlE2YjP+FRSZWUYOabBJXI82a8Xh
	sVCLsBq5wJE7f4bkS8U94stiLQ==
X-Google-Smtp-Source: ABdhPJxYx1U060YI3/ocToHHmhrh3XN5Wc9YJIVgqhXdsuC8TDQUbe866zMWKSPIdD0ty9NbhhGm4g==
X-Received: by 2002:a17:902:8d82:b029:e2:e8f7:ac44 with SMTP id v2-20020a1709028d82b02900e2e8f7ac44mr34308993plo.60.1614199135689;
        Wed, 24 Feb 2021 12:38:55 -0800 (PST)
Date: Wed, 24 Feb 2021 12:38:54 -0800
From: Kees Cook <keescook@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-parisc@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: Re: [PATCH v9 01/16] tracing: move function tracer options to
 Kconfig (causing parisc build failures)
Message-ID: <202102241238.93BC4DCF@keescook>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-2-samitolvanen@google.com>
 <20210224201723.GA69309@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224201723.GA69309@roeck-us.net>

On Wed, Feb 24, 2021 at 12:17:23PM -0800, Guenter Roeck wrote:
> On Fri, Dec 11, 2020 at 10:46:18AM -0800, Sami Tolvanen wrote:
> > Move function tracer options to Kconfig to make it easier to add
> > new methods for generating __mcount_loc, and to make the options
> > available also when building kernel modules.
> > 
> > Note that FTRACE_MCOUNT_USE_* options are updated on rebuild and
> > therefore, work even if the .config was generated in a different
> > environment.
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> With this patch in place, parisc:allmodconfig no longer builds.
> 
> Error log:
> Arch parisc is not supported with CONFIG_FTRACE_MCOUNT_RECORD at scripts/recordmcount.pl line 405.
> make[2]: *** [scripts/mod/empty.o] Error 2
> 
> Due to this problem, CONFIG_FTRACE_MCOUNT_RECORD can no longer be
> enabled in parisc builds. Since that is auto-selected by DYNAMIC_FTRACE,
> DYNAMIC_FTRACE can no longer be enabled, and with it everything that
> depends on it.

Ew. Any idea why this didn't show up while it was in linux-next?

-- 
Kees Cook
