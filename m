Return-Path: <SRS0=LjPC=FH=lists.openwall.com=kernel-hardening-return-20513-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB98CC6369E
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 00:01:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8105D20C56
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 00:01:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8105D20C56
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20513-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17717 invoked by uid 550); 3 Dec 2020 00:01:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17694 invoked from network); 3 Dec 2020 00:01:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfjgZXZpIq5fZzABqVm3ochfUst+vG1roSThKbX3esM=;
        b=aKU+Elxn2oMCSfhsrlmIncnG+eVufUmT2zZGZTURg6obiMVmWLv2CQrsZALP8JHr6v
         80wrfU2Kj3rw9JzGE1+ad3sYmQZQVz6coBP/qWBA1CluJ2fZQ9zFZ4l6/vlEm63POXgw
         PoXOTvefcAuxzcoYa6jNF36cSIGxuqPsczhvBBhEyt1it/5x6Z9UoRq1nyzo8Q/oPO6y
         8tFie1CBzkzTNDEZnK/uXLIeFNGsuWQZQvA6FlTiEpIBKkZpLzj9c+okfN8BIcEDQF66
         yCFvYhAsRmLuryGfPwmqK9NiVqvG5a5hjCVx77mxrjmWl+oxa/bmaXsQ2vt2BC7OXv3G
         fQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TfjgZXZpIq5fZzABqVm3ochfUst+vG1roSThKbX3esM=;
        b=T2FKaggatRA8/uoR19fBy8gtmhQ191tSundtUf2mx9nPWBc6Tj2M5WOzOs9sUKhD7D
         f2kveSs/ONmvr5f/zabd4PBW7l9RP6h9smiaIB0MZRhg9Vde9/pBfqOzNvNMceJDGo4Q
         HyELz7ncwUusFWHvQy3ewPzj9y0PHfVE3pI3EtyDzsHvFx4UuRmXGQdAJp/c1T2PYVPg
         PzOVox6qTRYi3I4Vg1sZN26eTJATB80IKsUws45z73EPUXyhGRehPfvP/OZ5JmbSwUGe
         a00FpFxtbcnzLeWjDN+o4WeL0oavJpQ3H0RyxMIFzoA4sYuxp706TcKc4xiYvxtw+YQG
         yC/g==
X-Gm-Message-State: AOAM53325JvCoMh0EMHi60RSNzhGUL35vgibt93E7Tk/YSAIhaltMv8k
	XlDPpxtXPdkX+HM+thzgiROgzMpfDBhf+20YbPKaJw==
X-Google-Smtp-Source: ABdhPJzlujdkqv4BrCfZTRRGmpK19lQ/Z9l2aUuOfXxVaHuxefVyErqf509JoPqL0nZR4gxpFozulWm1c0trs5O9RLg=
X-Received: by 2002:a62:7905:0:b029:197:f300:5a2a with SMTP id
 u5-20020a6279050000b0290197f3005a2amr614586pfc.30.1606953691833; Wed, 02 Dec
 2020 16:01:31 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 2 Dec 2020 16:01:20 -0800
Message-ID: <CAKwvOdnJvGR9L8n+w3E6idCXkGyykkycqbjiPQNNQSoCHrabLg@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
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
> This patch series adds support for building the kernel with Clang's
> Link Time Optimization (LTO). In addition to performance, the primary
> motivation for LTO is to allow Clang's Control-Flow Integrity (CFI)
> to be used in the kernel. Google has shipped millions of Pixel
> devices running three major kernel versions with LTO+CFI since 2018.
>
> Most of the patches are build system changes for handling LLVM
> bitcode, which Clang produces with LTO instead of ELF object files,
> postponing ELF processing until a later stage, and ensuring initcall
> ordering.
>
> Note that arm64 support depends on Will's memory ordering patches
> [1]. I will post x86_64 patches separately after we have fixed the
> remaining objtool warnings [2][3].
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-next/lto
> [2] https://lore.kernel.org/lkml/20201120040424.a3wctajzft4ufoiw@treble/
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git/log/?h=objtool-vmlinux
>
> You can also pull this series from
>
>   https://github.com/samitolvanen/linux.git lto-v8
>
> ---
> Changes in v8:
>
>   - Cleaned up the LTO Kconfig options based on suggestions from
>     Nick and Kees.

Thanks Sami, for the series:

Tested-by: Nick Desaulniers <ndesaulniers@google.com>

(build and boot tested under emulation with
https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-next/lto
additionally rebased on top).

As with v7, if the series changes drastically for v9, please consider
dropping my tested by tag for the individual patches that change and I
will help re-test them.
-- 
Thanks,
~Nick Desaulniers
