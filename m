Return-Path: <SRS0=oDyh=FP=lists.openwall.com=kernel-hardening-return-20601-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3E1C433FE
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 19:40:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 84BB523EB1
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 19:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 84BB523EB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20601-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5174 invoked by uid 550); 11 Dec 2020 19:40:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5146 invoked from network); 11 Dec 2020 19:40:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1nS5LJe0V9gmSV6AI/CjiJWRU085g+HSabHeZYnNbME=;
        b=qsqg3dEZdz6yTY0b8lWmwlvvFlCl6x/6RcbpcNM5RjlQi43vCEWHYEvpvNFMgtwSJf
         92LLLXxQ2DMnh4n9P483SaIxEmprkCDc/K+JgapPX/ZZKy6aK5r4eyyfdBCtEQJhwn4x
         ouvYwbD1s6MDLHCs5KHgP2Xw3/OELzfJnu8FvoDrq3GDDw87fJYBXVbaSaOYc+0Nu1UD
         fiQbuk0q8gz7/5IDoWj0ON2iPNs+pAeF9Qty6DbvjfFV/8Wzmt8DsLQLeqTz1ozLVtyQ
         R0+WXz2Fbj8SqfTG7PiaJGfy0Ipx3UtxFa3GxMJFuDwuXo9nyWaQPdc+rxYInzhIXbQ8
         nCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1nS5LJe0V9gmSV6AI/CjiJWRU085g+HSabHeZYnNbME=;
        b=Lsp4yDhKMB0WB4o/uhSuzOlNFE030Qr/vtKnCYiIpFGcNCUaHIdKkPZ76HQzqBg96p
         5Dx36PIuSntI53EGs9X0ltdrs+lzRd6qniqSJQxgObZ49N75LpVldvuWoPZ6c/d9z06o
         wW6VI6jTCuQAtzAbBWgmW+xAfnzgkvGYOnIE5Ri7T87HW7BCn8wnDDojpVZhIfakIANj
         Lbdo729+kO0Gjlblxxm5ecwUb8b3Lghh1ytlE5r6XMW4H7SAzbd6z1q9jOgSM2Wge1zV
         J07LMVzV2LxW9dQnhP6VnAQgYrKNSAUrAhrNaJjEKXbNsMT0nCKMUgwhkchiop6k/dOY
         5Lgg==
X-Gm-Message-State: AOAM533XEw0nLtB0VfK0rykd49fNLFwlENpUjyhXlidb7sqoWgTuWw/5
	yUCdYTKrMa2kh2ILYl3LwnPDC93ULycoLTaO1D/o3w==
X-Google-Smtp-Source: ABdhPJwTNai3fHjKtb9PFnSMalWQiVwNiqLsoEASGl1SfmNeaqyA+50KfMn1XqggqOylimJDfCS3u1qZ+Mz6kJGjBMs=
X-Received: by 2002:a67:80c8:: with SMTP id b191mr15432571vsd.36.1607715634310;
 Fri, 11 Dec 2020 11:40:34 -0800 (PST)
MIME-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <20201211184633.3213045-7-samitolvanen@google.com> <202012111131.E41AFFCDB@keescook>
In-Reply-To: <202012111131.E41AFFCDB@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 11 Dec 2020 11:40:23 -0800
Message-ID: <CABCJKueCJhwRL1T1k6EYpUy_-Rj85K98iz5FO6K+dZLY25z8_Q@mail.gmail.com>
Subject: Re: [PATCH v9 06/16] kbuild: lto: add a default list of used symbols
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Dec 11, 2020 at 11:32 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Dec 11, 2020 at 10:46:23AM -0800, Sami Tolvanen wrote:
> > With CONFIG_LTO_CLANG, LLVM bitcode has not yet been compiled into a
> > binary when the .mod files are generated, which means they don't yet
> > contain references to certain symbols that will be present in the final
> > binaries. This includes intrinsic functions, such as memcpy, memmove,
> > and memset [1], and stack protector symbols [2]. This change adds a
> > default symbol list to use with CONFIG_TRIM_UNUSED_KSYMS when Clang's
> > LTO is used.
> >
> > [1] https://llvm.org/docs/LangRef.html#standard-c-c-library-intrinsics
> > [2] https://llvm.org/docs/LangRef.html#llvm-stackprotector-intrinsic
> >
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> > ---
> >  init/Kconfig                | 1 +
> >  scripts/lto-used-symbollist | 5 +++++
> >  2 files changed, 6 insertions(+)
> >  create mode 100644 scripts/lto-used-symbollist
> >
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 0872a5a2e759..e88c919c1bf1 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -2297,6 +2297,7 @@ config TRIM_UNUSED_KSYMS
> >  config UNUSED_KSYMS_WHITELIST
> >       string "Whitelist of symbols to keep in ksymtab"
> >       depends on TRIM_UNUSED_KSYMS
> > +     default "scripts/lto-used-symbollist" if LTO_CLANG
> >       help
> >         By default, all unused exported symbols will be un-exported from the
> >         build when TRIM_UNUSED_KSYMS is selected.
> > diff --git a/scripts/lto-used-symbollist b/scripts/lto-used-symbollist
> > new file mode 100644
> > index 000000000000..38e7bb9ebaae
> > --- /dev/null
> > +++ b/scripts/lto-used-symbollist
> > @@ -0,0 +1,5 @@
> > +memcpy
> > +memmove
> > +memset
> > +__stack_chk_fail
> > +__stack_chk_guard
> > --
> > 2.29.2.576.ga3fc446d84-goog
> >
>
> bikeshed: Should this filename use some kind of extension, like
> lto-user-symbols.txt or .list, to make it more human-friendly?

Sure, I can rename this in the next version. Does anyone have strong
opinions about the name and/or extension?

Sami
