Return-Path: <SRS0=HWH5=AF=lists.openwall.com=kernel-hardening-return-19134-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C986C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:02:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6BC54207E8
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jun 2020 21:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ERVcY1k3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BC54207E8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19134-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10007 invoked by uid 550); 24 Jun 2020 21:02:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9972 invoked from network); 24 Jun 2020 21:02:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F0CH5zhnz6ayOh3mQsnUEqy/k37rjt1CS3Xrl+QPqsk=;
        b=ERVcY1k3sSjCpLOAr8awDULH6hHwCvyEkuApK5Qd/yy5SDCViDdkIB8JSQ5L/xRD+d
         8Y592Pat2k/ChLh9OYujlbJnjlGNVLx/ZpfbEt1sE8kMlvWJzHlDhj0x+JLWI/sCQ71m
         Qc98XVDBN4Tj5eQLSTeQur2SwoHWInWoHJEhUCCE5GXRfarr8qGepXCtm5phPzsnQ/fx
         r0chNzaABXZLlufMpQ+880lEY1eRlM2cvfZqGUG3SBnyMqYm4bUW8z+wyLj5pHtSzavu
         pLpwIlYwlO/U6gNgApMNdpJIBGZ6tRJTmGgBOtagYfhNoPIS0UxFZGw9u/o29RNxq2va
         8lJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F0CH5zhnz6ayOh3mQsnUEqy/k37rjt1CS3Xrl+QPqsk=;
        b=a9OBR/A90yRyN5fUw95FANHncC7Hmmv6qf+BCNb7I90vNtintvrOQv8yhB1OtAv29g
         FBGeUj1oY301xHAcocBoYoc1g7o3YecettyLCNVMkfDElMqIeG3nV4zqRcmaEMQa3xEQ
         P/HeRPNCtw6aijqtyAhsNkmKc+EUN4Ee1OnrKA8+PJTA8RxJ1qpeDgcrmWeJ/Xe6OG1t
         MA6BkrGy764xJ6GPvEymkgnyxv/mLQn4eb0KE56LBYt9gahr5ZyVfy7aB7xqCzpIPbz9
         6pb4y3pmrAEYUCS/6iQFjrXdq396KdobfcCFh7y8dLvQOaBHZRuYsaWnt47OA15ledFB
         vPVQ==
X-Gm-Message-State: AOAM531px6HQG3dTSzqrS26wB/TTq56kPemxIKh0nmwwB55yL4Pg0EqY
	nhWToCPXaAaAHCnJDQS2KLYG/YFXxK3uPlHpU8++Rv+k
X-Google-Smtp-Source: ABdhPJy3pMPiQAGPmTVujSMRX6922OqjtLRlYCZUOTerucVNVRzOs/5XjS34LxJ/ndw7kmB1zYWqmSiQ8V38zGtrKuE=
X-Received: by 2002:a05:6a00:15ca:: with SMTP id o10mr31723451pfu.169.1593032530992;
 Wed, 24 Jun 2020 14:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200624203200.78870-8-samitolvanen@google.com>
In-Reply-To: <20200624203200.78870-8-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 24 Jun 2020 14:01:59 -0700
Message-ID: <CAKwvOdkY2M9+BgA5FELK+7bjv1sZYMuTmVOztCYijas_OHfVDQ@mail.gmail.com>
Subject: Re: [PATCH 07/22] kbuild: lto: merge module sections
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> LLD always splits sections with LTO, which increases module sizes. This
> change adds a linker script that merges the split sections in the final
> module and discards the .eh_frame section that LLD may generate.

For discarding .eh_frame, Kees is currently fighting with a series
that I would really like to see land that enables warnings on orphan
section placement.  I don't see any new flags to inhibit .eh_frame
generation, or discard it in the linker script, so I'd expect it to be
treated as an orphan section and kept.  Was that missed, or should
that be removed from the commit message?

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
> index ee66513a5b66..9ffec5fe1737 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -898,6 +898,8 @@ CC_FLAGS_LTO_CLANG += -fvisibility=default
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
> index 000000000000..65884c652bf2
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
> +               *(.bss..L* .bss..compoundliteral*)
> +       }
> +
> +       .data : {
> +               *(.data .data.[0-9a-zA-Z_]*)
> +               *(.data..L* .data..compoundliteral*)
> +       }
> +
> +       .rodata : {
> +               *(.rodata .rodata.[0-9a-zA-Z_]*)
> +               *(.rodata..L* .rodata..compoundliteral*)
> +       }
> +
> +       .text : { *(.text .text.[0-9a-zA-Z_]*) }
> +}
> --
> 2.27.0.212.ge8ba1cc988-goog
>


-- 
Thanks,
~Nick Desaulniers
