Return-Path: <SRS0=SxF7=GM=lists.openwall.com=kernel-hardening-return-20613-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADA0C433DB
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 00:29:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D03E0208E4
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 00:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D03E0208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20613-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1619 invoked by uid 550); 9 Jan 2021 00:29:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1599 invoked from network); 9 Jan 2021 00:29:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eveSrO3foL1YR94SADi/xGNY6RU/HiTPaoR//1jI2bc=;
        b=cemTR8rQ+v7aAc1j8X9bSjTtMv/2eIij1J0jQdOW7eNBqbQFCd58aSYpax3rZVT2eY
         aoIsHA/4koMVUbI+TLf/cwAkcwY2XCmvpLcT//0ZhklFs+Yz+KCOHvj4iDKgepwwDCy2
         psVcFqYTpa0VlbUiLHsCrmO18jt6/WbjHzn9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eveSrO3foL1YR94SADi/xGNY6RU/HiTPaoR//1jI2bc=;
        b=eWS7DIQ0K+aY0t6AUH60V0ZhENjqtUk2+TdX649cK3UjTa8OBL5wq7LEKxOAXno3K3
         4y3IcnCsTXSvL+fdbd4b7u6wTRo0WsqG4bcMPRs4WH1HBvQu94i37FbuuMrfG17nsOci
         d1j9O8taAu88OD9Y/APacG+tbWeJa/LFsS+knCSEsVzyE8pugLvkxsUW8yuQFLNG/S2i
         jW9/HS2b9rqBo9BK7+Fas024eNfzlYB2VVLrDY1CUoploaiSaoNKCrqmFgKU5Fp9yV5v
         C+wsc5owj6RPP7B391NZztfJgdeJKjngbtzwhA58r1HcEvIBgrVyNcXrcGBlv0JMRQw5
         cojA==
X-Gm-Message-State: AOAM533t2OeYJg0La3C9qxqrbKfwxYLZ1z+j0dTnpGyCkh4dl5b0U5yv
	OjXtRmGA/mv3nKEypa0Yo2mfAg==
X-Google-Smtp-Source: ABdhPJxOK52D16pcAwbT6jFjbq8GC4r4IJlAOsTNR/onet1CRy5aKa4cGbW3hXo1Ls7QfN7irIfQYg==
X-Received: by 2002:a17:90a:db08:: with SMTP id g8mr6363172pjv.163.1610152148560;
        Fri, 08 Jan 2021 16:29:08 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Will Deacon <will@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	clang-built-linux@googlegroups.com,
	linux-arch@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-pci@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kernel-hardening@lists.openwall.com,
	Nick Desaulniers <ndesaulniers@google.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 00/16] Add support for Clang LTO
Date: Fri,  8 Jan 2021 16:27:13 -0800
Message-Id: <161015202326.2511797.6087273163265436487.b4-ty@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
References: <20201211184633.3213045-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 11 Dec 2020 10:46:17 -0800, Sami Tolvanen wrote:
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
> [...]

Applied to kspp/lto/v5.11-rc2, thanks!

I'll let 0-day grind on this over the weekend and toss it in -next on
Monday if there aren't any objections.

[01/16] tracing: move function tracer options to Kconfig
        https://git.kernel.org/kees/c/3b15cdc15956
[02/16] kbuild: add support for Clang LTO
        https://git.kernel.org/kees/c/833174494976
[03/16] kbuild: lto: fix module versioning
        https://git.kernel.org/kees/c/6eb20c5338a0
[04/16] kbuild: lto: limit inlining
        https://git.kernel.org/kees/c/f6db4eff0691
[05/16] kbuild: lto: merge module sections
        https://git.kernel.org/kees/c/d03e46783689
[06/16] kbuild: lto: add a default list of used symbols
        https://git.kernel.org/kees/c/81bfbc27b122
[07/16] init: lto: ensure initcall ordering
        https://git.kernel.org/kees/c/7918ea64195d
[08/16] init: lto: fix PREL32 relocations
        https://git.kernel.org/kees/c/a51d9615ffb5
[09/16] PCI: Fix PREL32 relocations for LTO
        https://git.kernel.org/kees/c/dc83615370e7
[10/16] modpost: lto: strip .lto from module names
        https://git.kernel.org/kees/c/5c0312ef3ca0
[11/16] scripts/mod: disable LTO for empty.c
        https://git.kernel.org/kees/c/3d05432db312
[12/16] efi/libstub: disable LTO
        https://git.kernel.org/kees/c/b12eba00cb87
[13/16] drivers/misc/lkdtm: disable LTO for rodata.o
        https://git.kernel.org/kees/c/ed02e86f1752
[14/16] arm64: vdso: disable LTO
        https://git.kernel.org/kees/c/d73692f0f527
[15/16] arm64: disable recordmcount with DYNAMIC_FTRACE_WITH_REGS
        https://git.kernel.org/kees/c/09b812ac146f
[16/16] arm64: allow LTO to be selected
        https://git.kernel.org/kees/c/1354b8946c46

-- 
Kees Cook

