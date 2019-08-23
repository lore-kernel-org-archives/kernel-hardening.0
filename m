Return-Path: <SRS0=FRJp=WT=lists.openwall.com=kernel-hardening-return-16799-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C5ACC3A5A2
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Aug 2019 14:10:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C9E6A22CEC
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Aug 2019 14:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePjWhxaj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9E6A22CEC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16799-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30260 invoked by uid 550); 23 Aug 2019 14:10:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30227 invoked from network); 23 Aug 2019 14:10:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=opYWgrOITMqtIWM1DIp6q8aXTDStrIYwPjuisdTHDTs=;
        b=ePjWhxajtLE5X1ZsqEaeT4SRlhl7S6UIR0e9onPRja/lIOyPCqrAH5nQQMLir9qMT+
         Z8CJuM7oDZDBGWXjBls9sxsQiqYxgEd4pnpikClQmsgG2Uq67GwD4yFd8dn5Jh7snZnK
         bZkBC20gCNfo5+ffKCLUZIP/p16e4BURHDL3SuH8r3ERyU/DlgAmls7K6F40BSvV92pa
         WidIw6ign50p7F9CTSTsstlbil6xoo80wfA9KJg1nLSPva6xqkLCV8QHg5tCNlZTkVbV
         nTfWoOKtF0HjbecUGjT7fj8crObOgAwVGEYR5JGnAV/p4Lh1dPXawjOckR2uBLgdmjoZ
         Basw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=opYWgrOITMqtIWM1DIp6q8aXTDStrIYwPjuisdTHDTs=;
        b=AAwTaCfWcpNHW0ruu0ndTpw01eFcgB1U2RNb5Y0GWClq68Uyq6V+A7/FrIcgdem/CS
         kNpbrMUUZQPVT22Zr3oOth2smS80M8CtHf0QyEa/rDfNAlQWh3S6wD06hxtqERuZURTb
         hX7h4xCVGmml1OB6NO4jmi5Dy+uDABcbb5kXAhOrXtuzlQr76Ke6KeuklSZ/FMmU0FVt
         Nq9wtioY8zsTWvAsWC98KNhPznJSQbMnD301I0YfpE2gtHuZda2x6Ch05I47HUVO2KUE
         iLKCZZP+NFmdj348gFNQh6soJFVB3QDbp+KfoHL123Dk5Pt71LuP6ruxiESM87SaTu9N
         p0gw==
X-Gm-Message-State: APjAAAUPggO9/P5xEPqSrxcsY+z4EAxh8ZmhMTbdux/zRx2ruzoM8BIN
	7NfdMfXy3AL69WwA0+xbq9LiCqENqiLAczFJT3Jjtg==
X-Google-Smtp-Source: APXvYqz5NRu/ERlRzxw3rF2jKPRrIJhWzJbU6BxIxCdmIAeSOkGj7Auyueiy49MjvYzGkOSynM9vS4MfzmHVqvlKujs=
X-Received: by 2002:aca:4b88:: with SMTP id y130mr3341867oia.157.1566569400110;
 Fri, 23 Aug 2019 07:10:00 -0700 (PDT)
MIME-Version: 1.0
References: <1566563895-2081-1-git-send-email-levonshe@yandex.com>
In-Reply-To: <1566563895-2081-1-git-send-email-levonshe@yandex.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 23 Aug 2019 16:09:34 +0200
Message-ID: <CAG48ez0Zm3LcAWf0n1XLXz3Ko_kyNJ0SyVXcGE4WfZje09R8CA@mail.gmail.com>
Subject: Re: [RFC] security hardening: block write to read_only pages of a
 target process.
To: Lev Olshvang <levonshe@yandex.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 23, 2019 at 2:38 PM Lev Olshvang <levonshe@yandex.com> wrote:
> Target process is not a current process.
> It is a foreign process in the terminogy of page fault handler.
>
> Typically debuggers, such as gdb, write to read-only code [text]
> sections of target process.
> This patch introduce kernel hardening configuration option.
> When enabled, it will stop attacks modifying code or jump tables.

This patch is missing context. What, at a high level, is your goal
with this patch? My guess is that you're trying to close gaps in the
protection that SELinux provides with "execmod" rules, and that you
want to ensure that an attacker who is exploiting a memory corruption
bug still can't modify machine code in the process being exploited.

You should CC appropriate kernel developers and lists for the code
you're modifying; see Documentation/process/submitting-patches.rst,
section "5) Select the recipients for your patch".

> Onky Code of arch_vma_access_permitted() function was extended to
> check foreign vma vm_flags.
>
> New logic denies to accept page fault caused by page protection violation.
>
> Separatly applied for x86,powerpc and unicore32
> arch_vma_access_permitted() function is not referenced in unicore32 and um
> architectures and seems to be obsolete,IMHO.

I think you're putting your checks in the wrong place.
If you put security checks into architecture-specific parts of the
codebase, then someone who wants to modify those checks might only
change some of the copies; and then the security checks become
inconsistent across architectures.
But also, there is already a function parameter at a higher level that
controls this behavior: In fs/proc/base.c, the function mem_rw() calls
access_remote_vm() with the flag FOLL_FORCE, which controls whether
overwriting non-writable memory is allowed. If you want to prevent the
use of /proc/*/mem to overwrite non-writable memory, then you can just
make it configurable whether that flag is used in that function.


> diff --git a/security/Kconfig b/security/Kconfig
> index 0d65594..03ff948 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> +config PROTECT_READONLY_USER_MEMORY
> +       bool "protect read only process memory"
> +       depends on !(CONFIG_CROSS_MEMORY_ATTACH)

Why this "depends on" rule? CONFIG_CROSS_MEMORY_ATTACH only controls
the process_vm_readv() and process_vm_writev() syscalls, and those
can't modify read-only memory because process_vm_rw_single_vec()
doesn't set FOLL_FORCE.

Also, I think the CONFIG_ prefix shouldn't be used inside Kconfig.

> +       help
> +         Protects read only memory of process code and PLT table from possible attack
> +         through /proc/PID/mem.
> +         Forbid writes to READ ONLY user pages of foreign process
> +         Mostly advised for embedded and production system.
> +         Disables process_vm_writev() syscall used in MP computing.

You are introducing a kernel config flag, but no corresponding sysctl,
which means that changing the flag requires recompiling the kernel.
If your intent really is to strengthen SELinux execmod rules as I
guessed, then you could also perform a check against the SELinux
context of the tracer in mem_open(), or something like that - then you
might not need to make this configurable via kconfig anymore.
