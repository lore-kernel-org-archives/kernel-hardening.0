Return-Path: <SRS0=BW1O=FP=lists.openwall.com=kernel-hardening-return-20600-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDFAC4361B
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 19:38:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1F67A23D50
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Dec 2020 19:38:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F67A23D50
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20600-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1866 invoked by uid 550); 11 Dec 2020 19:38:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1840 invoked from network); 11 Dec 2020 19:38:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VNfUmoHugTzMNVPlGX+wnRh5Cf/stQAzYSuLpPo56Do=;
        b=FEC9uEup9Neav9R+6U+sr3qeNh7Pg8WcbZYYXZwTn8O8CiG2ftP1IPYk0zCyjiYFSF
         c94oFOC9/6e94fHGubU93cGjPF1HGZHYHPragsSfEBUJ7FdZnpViexh6U4PPA/zRRum+
         eJUlsS8wc4R+iMPuouzj/+4aQfrfbSeOVoqX8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VNfUmoHugTzMNVPlGX+wnRh5Cf/stQAzYSuLpPo56Do=;
        b=pE7To5bOOoiA5QVACqzv8kHUSEzgFCk9vI81TYqenciO8dW83msdoyzeyDFZnCSJAt
         /0TmrCRRRTWNaHipr9JTBxzZjy9EM7riCPhz70m75h3nYqrTa7qxo+Q0eyU9mjUIXTHr
         8wl3p2m3dpu32y9WpG2MUM+97zh4fx6h/o0zOpfT4Ip9ptcmuU5P/oXMe4Xdv4u6/A9V
         y51HT+9UhtdQHxy94NH6O2pNdTEoQT1FhcWjTi0DM74LgvqQ04t615HHaQsQYuyRpXPM
         PGi7IxKM3pqeg3pGOJ1/WRFs7UPxlMz3BRVOqpQBXvKKBoQedvmNZ95YrFRphwlMmhLm
         sCtw==
X-Gm-Message-State: AOAM532SZVR/EZeeW+5teczfmRh6Xfv5a/d3O0CyLQygl9CDOecr0+l3
	kD4oPz6rLgfdfKOwnAUHd41RIA==
X-Google-Smtp-Source: ABdhPJyVEoQImRCMu3zSXvZnm5dHPPI8XqAV4RWpzzfXPBlCN0XEN9HOeEk46yg5rZ5bTGUzmtXFMg==
X-Received: by 2002:a63:f456:: with SMTP id p22mr13270729pgk.360.1607715515417;
        Fri, 11 Dec 2020 11:38:35 -0800 (PST)
Date: Fri, 11 Dec 2020 11:38:33 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v9 00/16] Add support for Clang LTO
Message-ID: <202012111134.209A6D311@keescook>
References: <20201211184633.3213045-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>

On Fri, Dec 11, 2020 at 10:46:17AM -0800, Sami Tolvanen wrote:
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
>   https://github.com/samitolvanen/linux.git lto-v9
> 
> ---
> Changes in v9:
> 
>   - Added HAS_LTO_CLANG dependencies to LLVM=1 and LLVM_IAS=1 to avoid
>     issues with mismatched toolchains.
> 
>   - Dropped the .mod patch as Masahiro landed a better solution to
>     the split line issue in commit 7d32358be8ac ("kbuild: avoid split
>     lines in .mod files").
> 
>   - Updated CC_FLAGS_LTO to use -fvisibility=hidden to avoid weak symbol
>     visibility issues with ThinLTO on x86.
> 
>   - Changed LTO_CLANG_FULL to depend on !COMPILE_TEST to prevent
>     timeouts in automated testing.
> 
>   - Added a dependency to CPU_LITTLE_ENDIAN to ARCH_SUPPORTS_LTO_CLANG
>     in arch/arm64/Kconfig.
> 
>   - Added a default symbol list to fix an issue with TRIM_UNUSED_KSYMS.

This continues to look good to me. I'd like to see it in -next ASAP so
we can continue to find any little needed tweaks. Since it works in the
general case, we can add on top of this series once it's in -next.

Masahiro, let me know if you'd rather I not carry this in -next. AFAICT,
the bulk of the changes in the build system continue to be confined to
the LTO-only cases, so it should not be disruptive to anyone doing
non-LTO builds.

-- 
Kees Cook
