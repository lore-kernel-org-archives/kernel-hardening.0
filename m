Return-Path: <SRS0=bVYD=55=lists.openwall.com=kernel-hardening-return-18501-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CEFC2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 17:14:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2E9DC2063A
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 17:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AGrrrp1Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E9DC2063A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18501-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21571 invoked by uid 550); 13 Apr 2020 17:13:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21535 invoked from network); 13 Apr 2020 17:13:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pvznC/k/6yS5kBsWNllr1DX6BjWvfpkCIMM35l/endc=;
        b=AGrrrp1Qa7iMNFBZwsMBgsRWlZape0tqPOrNXX/RiDZqcs64Rq5KDuK9F0d9PWppXt
         7veJuIi1nPGacFf/p5tT0yDzZa48REQ9TXyTAsQr+OrlBZPX8hnBFrlTAS7+hdbg1gSg
         PzqMxor7ASl2xhb1lLViF5tCeHStzrPev93gM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pvznC/k/6yS5kBsWNllr1DX6BjWvfpkCIMM35l/endc=;
        b=XoYzO8BarawxFOf6Pj4WbW2o1Zs1zeiD+ndlU0y+WG4yHYBlxTQqpxEdr0aDAlKHj5
         mQLRXOLrdev3zWr1hPmfqkWT/6GDsG5p9F4De+HEpCgZATa8X2I2yxM+2SivwYkmI4JS
         DX3uEk4PTyN27fE0deFLNUgP+dZnZwrscB8gK/RP9QbkH+S+MlJwCAoaSMhpcnFqyeXx
         yzrjnVvmSuo3lHcC3PBgsVJCprSkZ9YLdak1moYB5J49+dufSV7+mma4Os9oFM5h+0cl
         +lyDyv3CEfI9MpWgaKJINIqFSZNegQh/+F14om3dZtjZWcSkQT8OiCjFn4vTPEei/DLJ
         t/ig==
X-Gm-Message-State: AGi0PubqFCzfaZQVdjs0npejjzcHirIcCS9gj1nL9t6WrdAzTy2CqaiJ
	P7yrIm4UbZxuU1mbEgIRlA7nFg==
X-Google-Smtp-Source: APiQypIwB3pzdHgBzH4xUeheZrgGxUtVgQSaT4JDFg7F3y9sQ8WplYc9SXBwHcEoxZ4MZmiU5Hdf8Q==
X-Received: by 2002:a17:90a:bf86:: with SMTP id d6mr1046041pjs.180.1586798026348;
        Mon, 13 Apr 2020 10:13:46 -0700 (PDT)
Date: Mon, 13 Apr 2020 10:13:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Lev Olshvang <levonshe@gmail.com>
Cc: keescook@chromium.orh, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3 0/5] hardening : prevent write to proces's read-only
 pages
Message-ID: <202004131012.23C551D90@keescook>
References: <20200413153211.29876-1-levonshe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413153211.29876-1-levonshe@gmail.com>

On Mon, Apr 13, 2020 at 06:32:06PM +0300, Lev Olshvang wrote:
> v2 --> v3
> 	Split patch to architecture independ part and separate patches
> 	for architectures that have arch_vma_access_permitted() handler.
> 	I tested it only on arm and x86

Hi; thanks for the update!

It looks like you sent patches inverted (you're showing the removals,
not the additions) and are missing the new function that does the test?

Please make sure you're testing the patches you send (rather than your
local tree). :)

-Kees


> v1 --> v2
> 	I sent empty v1 patch, just resending
> v0 --> v1
> ---
> 	Added sysctl_forbid_write_ro_mem to control whether to allow write
>     or deny. (Advised by Kees Cook, KSPP issue 37)
>     It has values range [0-2] and it gets the initial value from
>     CONFIG_PROTECT_READONLY_USER_MEMORY (defaulted to 0, so it cant break)
>     Setting it to 0 disables write checks.
>     Setting it to 1 deny writes from other processes.
>     Setting it to 2 deny writes from any processes including itself
> ----
> v0
> ----
> 
> The purpose of this patch is produce hardened kernel for Embedded
> or Production systems.
> This patch shouild close issue 37 opened by Kees Cook in KSPP project
> 
> Typically debuggers, such as gdb, write to read-only code [text]
> sections of target process.(ptrace)
> This kind of page protectiion violation raises minor page fault, but
> kernel's fault handler allows it by default.
> This is clearly attack surface for adversary.
> 
> The proposed kernel hardening configuration option checks the type of
> protection of the foreign vma and blocks writes to read only vma.
> 
> When enabled, it will stop attacks modifying code or jump tables, etc.
> 
> Code of arch_vma_access_permitted() function was extended to
> check foreign vma flags.
> 
> Tested on x86_64 and ARM(QEMU) with dd command which writes to
> /proc/PID/mem in r--p or r--xp of vma area addresses range
> 
> dd reports IO failure when tries to write to adress taken from
> from /proc/PID/maps (PLT or code section)
> 
> 
> Lev Olshvang (5):
>   Hardening x86: Forbid writes to read-only memory pages of a process
>   Hardening PowerPC: Forbid writes to read-only memory pages of a
>     process
>   Hardening um: Forbid writes to read-only memory pages of a process
>   Hardening unicore32: Forbid writes to read-only memory pages of a
>     process
>   Hardening : PPC book3s64: Forbid writes to read-only memory pages of a
>     process
> 
>  arch/powerpc/include/asm/mmu_context.h   | 9 +--------
>  arch/powerpc/mm/book3s64/pkeys.c         | 5 -----
>  arch/um/include/asm/mmu_context.h        | 8 +-------
>  arch/unicore32/include/asm/mmu_context.h | 7 +------
>  arch/x86/include/asm/mmu_context.h       | 8 +-------
>  5 files changed, 4 insertions(+), 33 deletions(-)
> 
> -- 
> 2.17.1
> 

-- 
Kees Cook
