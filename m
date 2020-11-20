Return-Path: <SRS0=9MNU=E2=lists.openwall.com=kernel-hardening-return-20432-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DF2C56201
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 19:47:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 655BF206B6
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 19:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XzoPI1cr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 655BF206B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20432-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17740 invoked by uid 550); 20 Nov 2020 19:47:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17718 invoked from network); 20 Nov 2020 19:47:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=elr/neHdSPND1QBbHYVTIKRGGtBg1vE7OdThIsRU5pI=;
        b=XzoPI1crChRR6wLQGUnQdTruNmuVNj0hkcwU6yjn8xXrOzmnTuw8bZwNjYOSUMiNjn
         EBV38WHid50TNovyKvDuuqOK6ny2jvmInIM/dgDYVmxiGIxn7be54rsKduzrLe/jMV3q
         ANWN/74SZ1EEZvtawKD5ujXQl6B2YxxD3r8JI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=elr/neHdSPND1QBbHYVTIKRGGtBg1vE7OdThIsRU5pI=;
        b=MqXV95zSa3Cw9kJDi2APwo47gmyqbIgHSq4KgFpj4SaNCIzjwhBU36XR9wTxzn7h1N
         EsxUTCg0lfI+AJvDVAQGSK67NP5TYjFi7Gds9zfLoOjvyVbYvqwzXcXplMwfF4rj70tJ
         PXDoe3whZaUnM9k+2mxZJXzCkv0RLDncsAE3b3Co3Z5KuZgQg+r4G3aBdouNmcwLz3bC
         7cHkaautocBtL3RZ4boDeyORsiqvzXIWiiGJQqYJuTxYjsvUti9QCJaUy6l8tc2I1fSE
         0FInkuh3/u4iIQoLUbQvD4nfNFHMtUZJwG5e+QqhigCRTLAvcnOSG1fv6ww2KlR0yJrx
         hF2A==
X-Gm-Message-State: AOAM533nMT1UuTSU2j2WRYbqyPEomaKyEvxXZWLJ8kKC1g/cw3e9s9oU
	p/WmulaSPbf2iOY5/0ou4ss37g==
X-Google-Smtp-Source: ABdhPJwnsGzh6rI5stQsBcWRn8N0h8Ns8b+OJp9DPF9o8s3fODKrXmSZ/a2sub1vz+HM8LuYBAXNBw==
X-Received: by 2002:a62:ea09:0:b029:197:bad4:1e78 with SMTP id t9-20020a62ea090000b0290197bad41e78mr8311744pfh.22.1605901643516;
        Fri, 20 Nov 2020 11:47:23 -0800 (PST)
Date: Fri, 20 Nov 2020 11:47:21 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 02/17] kbuild: add support for Clang LTO
Message-ID: <202011201144.3F2BB70C@keescook>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-3-samitolvanen@google.com>
 <CAKwvOdnYTMzaahnBqdNYPz3KMdnkp=jZ4hxiqkTYzM5+BBdezA@mail.gmail.com>
 <CABCJKucj_jUwoiLc35R7qFe+cNKTWgT+gsCa5pPiY66+1--3Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKucj_jUwoiLc35R7qFe+cNKTWgT+gsCa5pPiY66+1--3Lg@mail.gmail.com>

On Fri, Nov 20, 2020 at 08:23:11AM -0800, Sami Tolvanen wrote:
> Changing the ThinLTO config to a choice and moving it after the main
> LTO config sounds like a good idea to me. I'll see if I can change
> this in v8. Thanks!

Originally, I thought this might be a bit ugly once GCC LTO is added,
but this could be just a choice like we're done for the stack
initialization. Something like an "LTO" choice of NONE, CLANG_FULL,
CLANG_THIN, and in the future GCC, etc.

-- 
Kees Cook
