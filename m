Return-Path: <SRS0=ZAiM=CM=lists.openwall.com=kernel-hardening-return-19750-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 203DBC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:47:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 695EE20639
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 21:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dNJhSL8+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 695EE20639
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19750-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3770 invoked by uid 550); 3 Sep 2020 21:47:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3733 invoked from network); 3 Sep 2020 21:47:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sW3+i9jb9GQGw/rihL3rmHov3DBg+oJBsubVzV/94sk=;
        b=dNJhSL8+ekFbBcMLYdOiVh2ALsNUoTTm1VSxi4CeqOTnyYIMwnEHHJ7S/BtXgtuNOk
         9HqSyGbwVU8WVdgO3Jvvq84XO+8XGzQl7x2oGWzDQCtlULUhdTtXclp3ZyOgcr4wIXRy
         ix3S72ob+JcdrTSNj6CS0A74L/1LVWKFX9qdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sW3+i9jb9GQGw/rihL3rmHov3DBg+oJBsubVzV/94sk=;
        b=eVPkTwvY4WIh8AVn0aUBqGkxjhqTYDQAgUQgctRaIgIuwPDkQawBHBXFjXCcBJC9MF
         iCIJiTGELwWVfa85+EYoQXBZQP7edSv7ayfM1+L3IFQGZHsL8sNYimvpUqPfTHPzqCXw
         S207pTi0vm+V0j6Zig3kVLoBoClyC7PxdU5/3jWMfWqVOov9dmQZ4G0NSGeSyL70OzFO
         Xz1DvDmwEI9xYUgWeOBidobaDL+2mSRLXEGfFoeBAuaPQxvOwK8LeZ0JI6fzyLB3pQb9
         Cq3zwnwjW4ceW9r06yfrtOjmj9WSvmUkVRk7cBJbW+wAyq7TzLe5p8c1VOAfQLzggDvv
         MsVw==
X-Gm-Message-State: AOAM532/9JmvtHEqCFXgVC02Hle4hLc4hQ20I//1m67kn5MuiZzoSKUu
	vqaDeH/UZIi26YvsCVpKyjKuyQ==
X-Google-Smtp-Source: ABdhPJxA6AeZszGsabAFYmE7VAtam1/8zONcRaynFdaMlGHOxLgKqDQnRgIOet6kCjwYkvC+MGEMtQ==
X-Received: by 2002:a63:e157:: with SMTP id h23mr4839131pgk.239.1599169646252;
        Thu, 03 Sep 2020 14:47:26 -0700 (PDT)
Date: Thu, 3 Sep 2020 14:47:24 -0700
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
Subject: Re: [PATCH v2 03/28] lib/string.c: implement stpcpy
Message-ID: <202009031446.3865FE82B@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-4-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-4-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:28PM -0700, Sami Tolvanen wrote:
> From: Nick Desaulniers <ndesaulniers@google.com>
> 
> LLVM implemented a recent "libcall optimization" that lowers calls to
> `sprintf(dest, "%s", str)` where the return value is used to
> `stpcpy(dest, str) - dest`. This generally avoids the machinery involved
> in parsing format strings.  `stpcpy` is just like `strcpy` except it
> returns the pointer to the new tail of `dest`.  This optimization was
> introduced into clang-12.
> 
> Implement this so that we don't observe linkage failures due to missing
> symbol definitions for `stpcpy`.
> 
> Similar to last year's fire drill with:
> commit 5f074f3e192f ("lib/string.c: implement a basic bcmp")
> 
> The kernel is somewhere between a "freestanding" environment (no full libc)
> and "hosted" environment (many symbols from libc exist with the same
> type, function signature, and semantics).
> 
> As H. Peter Anvin notes, there's not really a great way to inform the
> compiler that you're targeting a freestanding environment but would like
> to opt-in to some libcall optimizations (see pr/47280 below), rather than
> opt-out.
> 
> Arvind notes, -fno-builtin-* behaves slightly differently between GCC
> and Clang, and Clang is missing many __builtin_* definitions, which I
> consider a bug in Clang and am working on fixing.
> 
> Masahiro summarizes the subtle distinction between compilers justly:
>   To prevent transformation from foo() into bar(), there are two ways in
>   Clang to do that; -fno-builtin-foo, and -fno-builtin-bar.  There is
>   only one in GCC; -fno-buitin-foo.
> 
> (Any difference in that behavior in Clang is likely a bug from a missing
> __builtin_* definition.)
> 
> Masahiro also notes:
>   We want to disable optimization from foo() to bar(),
>   but we may still benefit from the optimization from
>   foo() into something else. If GCC implements the same transform, we
>   would run into a problem because it is not -fno-builtin-bar, but
>   -fno-builtin-foo that disables that optimization.
> 
>   In this regard, -fno-builtin-foo would be more future-proof than
>   -fno-built-bar, but -fno-builtin-foo is still potentially overkill. We
>   may want to prevent calls from foo() being optimized into calls to
>   bar(), but we still may want other optimization on calls to foo().
> 
> It seems that compilers today don't quite provide the fine grain control
> over which libcall optimizations pseudo-freestanding environments would
> prefer.
> 
> Finally, Kees notes that this interface is unsafe, so we should not
> encourage its use.  As such, I've removed the declaration from any
> header, but it still needs to be exported to avoid linkage errors in
> modules.
> 
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Suggested-by: Andy Lavr <andy.lavr@gmail.com>
> Suggested-by: Arvind Sankar <nivedita@alum.mit.edu>
> Suggested-by: Joe Perches <joe@perches.com>
> Suggested-by: Masahiro Yamada <masahiroy@kernel.org>
> Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

As you mentioned, this is in -next already (via -mm). I think I sent a
tag for this before, but maybe akpm missed it, so for good measure:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
