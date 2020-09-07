Return-Path: <SRS0=rFaa=CQ=lists.openwall.com=kernel-hardening-return-19796-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC40C43461
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Sep 2020 15:27:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 82F4721481
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Sep 2020 15:27:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="HF6kxwrZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82F4721481
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19796-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18271 invoked by uid 550); 7 Sep 2020 15:26:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18239 invoked from network); 7 Sep 2020 15:26:58 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 087FQVsc024407
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1599492392;
	bh=IR6uGigyFtGDGIA+2OM5ZSYgDCjCsPA/08OP3wwPpmI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HF6kxwrZWb/RyvWw0lecR13yfGnI7g+SVYuZ3GDrpLhjeQQBDFe3oweHMbptemm66
	 SshCNN/29Q2UvC9TLvqIwjxGc087kf+LNwwYemZ9X8N179UEkHP+whZYbBQFKBslQI
	 QLRVSs1kmDEgwP5nA60GQLqD2M/mdvIvnBM0aTB/FKDPseKBNZcIq2a2D/0zPSmgKn
	 AEmqSmPA7h2X4LFcI6QPvPonC70Ag3cB7mKCBtL8/C97R4MKbM4UHwkDKT0yrD5ghL
	 Zfzv833opPYiVtdnMgBuia+Ds748+7ZOS+r2vFL3fF0+vwlBvikfS9mHMkE8AAJya3
	 YQxpECBRYEZSg==
X-Nifty-SrcIP: [209.85.215.179]
X-Gm-Message-State: AOAM53114ATCOShiSG+usqS2zAuuM0tAJYRrHh+IhOjbmPB7sYqvuXUw
	cXsmbwaI/ragCsykJx5iFc8/y9XuikX64k8cECU=
X-Google-Smtp-Source: ABdhPJzWMpKJKkob3tKKbsRMggvPdqUmZIz53kyp4B311hdgI26YjoFRx5atEqEpQRhRX5rjh34sk2xeMQI+Eblelz8=
X-Received: by 2002:a62:e116:: with SMTP id q22mr9587524pfh.179.1599492391141;
 Mon, 07 Sep 2020 08:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com> <20200903203053.3411268-14-samitolvanen@google.com>
In-Reply-To: <20200903203053.3411268-14-samitolvanen@google.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Tue, 8 Sep 2020 00:25:54 +0900
X-Gmail-Original-Message-ID: <CAK7LNARnh-7a8Lq-y2u72cnk2uxSuWxjaZ8Y-JHCYu5gwt7Ekg@mail.gmail.com>
Message-ID: <CAK7LNARnh-7a8Lq-y2u72cnk2uxSuWxjaZ8Y-JHCYu5gwt7Ekg@mail.gmail.com>
Subject: Re: [PATCH v2 13/28] kbuild: lto: merge module sections
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Sep 4, 2020 at 5:31 AM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> LLD always splits sections with LTO, which increases module sizes. This
> change adds a linker script that merges the split sections in the final
> module.
>
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  Makefile               |  2 ++
>  scripts/module-lto.lds | 26 ++++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
>  create mode 100644 scripts/module-lto.lds
>
> diff --git a/Makefile b/Makefile
> index c69e07bd506a..bb82a4323f1d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -921,6 +921,8 @@ CC_FLAGS_LTO_CLANG += -fvisibility=default
>  # Limit inlining across translation units to reduce binary size
>  LD_FLAGS_LTO_CLANG := -mllvm -import-instr-limit=5
>  KBUILD_LDFLAGS += $(LD_FLAGS_LTO_CLANG)
> +
> +KBUILD_LDS_MODULE += $(srctree)/scripts/module-lto.lds
>  endif
>
>  ifdef CONFIG_LTO
> diff --git a/scripts/module-lto.lds b/scripts/module-lto.lds
> new file mode 100644
> index 000000000000..cbb11dc3639a
> --- /dev/null
> +++ b/scripts/module-lto.lds
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
> + * -ffunction-sections, which increases the size of the final module.
> + * Merge the split sections in the final binary.
> + */
> +SECTIONS {
> +       __patchable_function_entries : { *(__patchable_function_entries) }
> +
> +       .bss : {
> +               *(.bss .bss.[0-9a-zA-Z_]*)
> +               *(.bss..L*)
> +       }
> +
> +       .data : {
> +               *(.data .data.[0-9a-zA-Z_]*)
> +               *(.data..L*)
> +       }
> +
> +       .rodata : {
> +               *(.rodata .rodata.[0-9a-zA-Z_]*)
> +               *(.rodata..L*)
> +       }
> +
> +       .text : { *(.text .text.[0-9a-zA-Z_]*) }
> +}
> --
> 2.28.0.402.g5ffc5be6b7-goog
>


After I apply https://patchwork.kernel.org/patch/11757323/,
is it possible to do like this ?


#ifdef CONFIG_LTO
SECTIONS {
     ...
};
#endif

in scripts/module.lds.S


-- 
Best Regards
Masahiro Yamada
