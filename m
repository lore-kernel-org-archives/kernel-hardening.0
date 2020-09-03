Return-Path: <SRS0=/zxM=CM=lists.openwall.com=kernel-hardening-return-19753-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D02C43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:52:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 37060206EF
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KicJSqu+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 37060206EF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19753-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11305 invoked by uid 550); 3 Sep 2020 21:52:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10234 invoked from network); 3 Sep 2020 21:52:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=niBSeaSbgvRvlB35MBxx98Nw+20RftQpbuI5pjBM80I=;
        b=KicJSqu+xVTyfixy3duLdJz55bxWRU3qA5qutCjSiukroOXIqFG0/1lD3QJeDVIqMC
         hZ6NZa7w9Qs1p1rJ4Alr8OVZgM7Zw7wnpZVEMqp9fetWV7i08ZFQCV9dvLbQsymap8Sa
         WEtcBNRNrgLCnUJf91oNzu8Xfg8xBZ6/pJAwg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=niBSeaSbgvRvlB35MBxx98Nw+20RftQpbuI5pjBM80I=;
        b=FjBg+vufYv/A29G42uN3Iw7Y4G1MFJ916AmoM8uFkxSDvntP7xthQPg2rxxnsxXsWe
         QnCeEkT4McSOORP8AUjsbOGU0w55KWPpYTxcZ9BVXmT/U74tE/sxQpXfYkyqLUrRUy5w
         XyT6rMBLaIrpM0JY+oa/h+i6jVetUyat+pRcSwDcYgcqhupqkYo8md/U5cjsfbuejBn6
         /zKNdtokPE6sRQI+BEiICzEiH6MnIb+S+R4khE9eRrOCWOhiqq6A91VwLzkeD3aj9mM6
         AjyXINIMa5brkZEqSExxbEFC5qtSRTStU3ll9rN0ZQCdujpRdkwr1LSWEJqnqfFBjz/R
         Xe4w==
X-Gm-Message-State: AOAM530AFuiJbsktcvfWZOORRoxtpldfDyU+WLHrMJQmsmY/q+X0eNk7
	K4Iwc2ESIzEslra6+0JltxLjQw==
X-Google-Smtp-Source: ABdhPJwa48YSM6ExHujIeVMJjTdMKXdlCG8evKNumN+cGLnV5tqHACBkFFTWQTDxLZ9gej+518XXtg==
X-Received: by 2002:a17:90a:f198:: with SMTP id bv24mr5394608pjb.117.1599169956918;
        Thu, 03 Sep 2020 14:52:36 -0700 (PDT)
Date: Thu, 3 Sep 2020 14:52:35 -0700
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
Subject: Re: [PATCH v2 06/28] objtool: Don't autodetect vmlinux.o
Message-ID: <202009031452.FD826A9748@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-7-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-7-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:31PM -0700, Sami Tolvanen wrote:
> With LTO, we run objtool on vmlinux.o, but don't want noinstr
> validation. This change requires --vmlinux to be passed to objtool
> explicitly.
> 
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Looks right to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
