Return-Path: <SRS0=8FB3=FM=lists.openwall.com=kernel-hardening-return-20543-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376D0C433FE
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 16:54:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0BDF723A79
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 16:54:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BDF723A79
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20543-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24203 invoked by uid 550); 8 Dec 2020 16:54:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24180 invoked from network); 8 Dec 2020 16:54:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l5zve3QgoBiHLvxkhbeIQQ8L+c1shM0AySo9iJPfdLI=;
        b=tcWjcUsoxU6SpDxMxfUujxhJGgNiN0OcrzVgHRXE+pbJuNC7SLmXfBUI75eINJCzON
         G0nY39F1EVNqZripZe6gbBqfZzjuLM84h1W0NmIJ9jvGryhhLgEOXTrybPsOQT8GLnc8
         KUcGz9aiF8dfaNJXcsm4ma4k42S8fJ72oEzmlNAlfhp/cRlYwKUgc/vMzXaoCHGAiAQz
         Fv8ITYgJz1voaC3m4n36riFKsJeJiarjPn95yOG7ac8eVlG7dHlzrZ6kvmUTf+Y5xSqG
         1a1WQigfWfhFFyxkOxdgAlObdqquWglgAenkMnogNlCbuvVFB7EBjDeKD1KOeC3meePi
         dfuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l5zve3QgoBiHLvxkhbeIQQ8L+c1shM0AySo9iJPfdLI=;
        b=P86+Dq35SbkCZv07hia7c5BEpN6P6xYUBSmUdgTiqJNWwrGTpct1zBdWJfvAHHvytB
         BP0CE0QhKqtoFp2l2IsikpcWrYjwLeQHiiwZgEDxeGVnKLgy1VRaKRoi207puqehiI7o
         OLUxr6Y+pyyYa8o5/Mk1eBWOPZN02vr0T9FMqRpmJDa++rxrOv8dKolVot1Rszfp3Zto
         bDITpwLXRu2932YG2+qTDaYI/Ll98hpyDGxP3c2Psky/hZtADc8OXuupaBkZehfB594R
         pPnPR+la/Xg3fROli2DZl+JDn7DR4LsWz6ouz7EYB2oNz43ESuZmlqqiWkeBOebVd5sF
         XmLQ==
X-Gm-Message-State: AOAM532NJaBe1Y4o2PV6rCFGVzqIrt/DbOWwxV3Y71EY7kIhrzJQfe0K
	WiFCZS5nqE1wiDVWkhBvBUFLIl8iKG7YCkuIqHBBEQ==
X-Google-Smtp-Source: ABdhPJxgg0AuBgAyNX33MRQChfKNjBy/l6I+d3qFW7cDxguUPeYCwHRH9XJaUc5ctnBi5qE5LUaYex6e2Q3DEwkWc2E=
X-Received: by 2002:a1f:b245:: with SMTP id b66mr17138078vkf.3.1607446436156;
 Tue, 08 Dec 2020 08:53:56 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com> <CAK8P3a0AyciKoHzrgtaLxP9boo8WqZCe8YfPBzGPQ14PW_2KgQ@mail.gmail.com>
In-Reply-To: <CAK8P3a0AyciKoHzrgtaLxP9boo8WqZCe8YfPBzGPQ14PW_2KgQ@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 8 Dec 2020 08:53:44 -0800
Message-ID: <CABCJKudbCD3s0RcSVzbnn4MV=DadKOxOxar3jfiPWucX4JGxCg@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Arnd Bergmann <arnd@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 8, 2020 at 5:55 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> On Tue, Dec 8, 2020 at 1:15 PM Arnd Bergmann <arnd@kernel.org> wrote:
> > On Tue, Dec 1, 2020 at 10:37 PM 'Sami Tolvanen' via Clang Built Linux <clang-built-linux@googlegroups.com> wrote:
> >
> > - many builds complain about thousands of duplicate symbols in the kernel, e.g.
> >   ld.lld: error: duplicate symbol: qrtr_endpoint_post
> >  >>> defined in net/qrtr/qrtr.lto.o
> >  >>> defined in net/qrtr/qrtr.o
> >  ld.lld: error: duplicate symbol: init_module
> >  >>> defined in crypto/842.lto.o
> >  >>> defined in crypto/842.o
> >  ld.lld: error: duplicate symbol: init_module
> >  >>> defined in net/netfilter/nfnetlink_log.lto.o
> >  >>> defined in net/netfilter/nfnetlink_log.o
> >  ld.lld: error: duplicate symbol: vli_from_be64
> >  >>> defined in crypto/ecc.lto.o
> >  >>> defined in crypto/ecc.o
> >  ld.lld: error: duplicate symbol: __mod_of__plldig_clk_id_device_table
> >  >>> defined in drivers/clk/clk-plldig.lto.o
> >  >>> defined in drivers/clk/clk-plldig.o
>
> A small update here: I see this behavior with every single module
> build, including 'tinyconfig' with one module enabled, and 'defconfig'.

The .o file here is a thin archive of the bitcode files for the
module. We compile .lto.o from that before modpost, because we need an
ELF binary to process, and then reuse the .lto.o file when linking the
final module.

At no point should we link the .o file again, especially not with
.lto.o, because that would clearly cause every symbol to be
duplicated, so I'm not sure what goes wrong here. Here's the relevant
part of scripts/Makefile.modfinal:

ifdef CONFIG_LTO_CLANG
# With CONFIG_LTO_CLANG, reuse the object file we compiled for modpost to
# avoid a second slow LTO link
prelink-ext := .lto
...
$(modules): %.ko: %$(prelink-ext).o %.mod.o scripts/module.lds FORCE
        +$(call if_changed,ld_ko_o)

Sami
