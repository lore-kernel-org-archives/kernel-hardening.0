Return-Path: <SRS0=HwbF=FH=lists.openwall.com=kernel-hardening-return-20514-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428BCC6369E
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 00:08:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5130D20C56
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 00:08:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5130D20C56
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20514-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24018 invoked by uid 550); 3 Dec 2020 00:08:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23995 invoked from network); 3 Dec 2020 00:08:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kEzbS1TJpZr1zlUaIzJZNjxvOX/ycdroxO9B6D39hfs=;
        b=XgE4hFlRnyVhoAVXKZpoORytuCszXHlvqvjFiWoMfDwKLHMBAJiLtfdxPUF1Ds0rUD
         hMy53TCCB3trdymTPnhD/EpvivzoOAAQAXZxETeYSC6+cHzGVMjT4trKGbcy7mVBPbhc
         EU9XgJtJIhJthGXtFVvljVzi3G5x0AhpPonp2pZCSVp8N7AtEqRR1TIcbgMo+e0jsZ0Z
         Hc665Mzj1QqTEsrYINBIu3TQZCrLkjHzzC62HS4Y70oidn18XQ6vsN8XwIZCJ0FsFltb
         h9glLD+E7xt4OobgWoc6JZBfXamL35QVqKIzdutURzOaZO1KrXt6o7P69HgMN+nPfgD4
         oNFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kEzbS1TJpZr1zlUaIzJZNjxvOX/ycdroxO9B6D39hfs=;
        b=QXiNDoO+s4rITuuU3hn+HxVZsFdmCWgi274TqpzDWHgWWBOIKHKYQvX0DTXX1YP5Q9
         NgA3Z14UQ6GgxoCa8YWCfW+dQFYKnATxBlyUSHBYS1rulyWFofAhWcPdxE2rNJPJoRzW
         v9SHc7jB2TgTbKnjxmyKCUe82ADF7Mq32/lDcuNBwY/kPyczU89RSgKEl1+EcKvKFL7o
         u8xQc9BRaU3OFIttIB0UNHTxSY+s7qcWZMRGNtnYPuDnEWXeglPxSsotM1qJ+BDt5vuH
         TNz6EXU+9kN9cjUzNxHg50fMqbbMdIXJEh0ty5rDn9V3yGUdYEHh4hAQt+1Agi/R0p1l
         EIOg==
X-Gm-Message-State: AOAM530dmdc8Ba2iVG0NFQ9WMZeDOZ+t575pmxvBF5XFt//6SLeUdx8W
	AoJkUqjUePWCWKH5cDlhf0mNHiVZYqa9BKIFp2M7dg==
X-Google-Smtp-Source: ABdhPJxh5zUiuI3zegBWmp1u5W+iEQWahGQXosx3cw1T/85XuGQ1Dy4mBr13tbY0tFMQnXyVMrg3wK85B+/nchXJ1Jw=
X-Received: by 2002:a17:90a:2e8c:: with SMTP id r12mr413591pjd.101.1606954085432;
 Wed, 02 Dec 2020 16:08:05 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com> <20201201213707.541432-3-samitolvanen@google.com>
In-Reply-To: <20201201213707.541432-3-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 2 Dec 2020 16:07:54 -0800
Message-ID: <CAKwvOdmfbsTN6GtHwvkgJ=12mBhUzmAgSGtnvA-bRw4tYYZ+BQ@mail.gmail.com>
Subject: Re: [PATCH v8 02/16] kbuild: add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 1, 2020 at 1:37 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> This change adds build system support for Clang's Link Time
> Optimization (LTO). With -flto, instead of ELF object files, Clang
> produces LLVM bitcode, which is compiled into native code at link
> time, allowing the final binary to be optimized globally. For more
> details, see:
>
>   https://llvm.org/docs/LinkTimeOptimization.html
>
> The Kconfig option CONFIG_LTO_CLANG is implemented as a choice,
> which defaults to LTO being disabled. To use LTO, the architecture
> must select ARCH_SUPPORTS_LTO_CLANG and support:
>
>   - compiling with Clang,
>   - compiling inline assembly with Clang's integrated assembler,
>   - and linking with LLD.
>
> While using full LTO results in the best runtime performance, the
> compilation is not scalable in time or memory. CONFIG_THINLTO
> enables ThinLTO, which allows parallel optimization and faster
> incremental builds. ThinLTO is used by default if the architecture
> also selects ARCH_SUPPORTS_THINLTO:
>
>   https://clang.llvm.org/docs/ThinLTO.html
>
> To enable LTO, LLVM tools must be used to handle bitcode files. The
> easiest way is to pass the LLVM=1 option to make:
>
>   $ make LLVM=1 defconfig
>   $ scripts/config -e LTO_CLANG
>   $ make LLVM=1
>
> Alternatively, at least the following LLVM tools must be used:
>
>   CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm
>
> To prepare for LTO support with other compilers, common parts are
> gated behind the CONFIG_LTO option, and LTO can be disabled for
> specific files by filtering out CC_FLAGS_LTO.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
-- 
Thanks,
~Nick Desaulniers
