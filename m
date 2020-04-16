Return-Path: <SRS0=V9Kv=6A=lists.openwall.com=kernel-hardening-return-18525-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F4EC2BB55
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 15:59:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3BF3B217D8
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 15:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mnQRTMIc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BF3B217D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18525-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20233 invoked by uid 550); 16 Apr 2020 15:59:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20201 invoked from network); 16 Apr 2020 15:59:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=feipUZjqbd8RBzgRB5BINxVf9AUJLyGnWTtgVx7x4qA=;
        b=mnQRTMIcI0tVKn8dE2WbuAKj5VvIsnkD0wqY72bJH1G1rcln2sq/tJttOyOgRvUNhp
         f2pcCsqetF9+ARdFIo0xUQWuLK/53M8lOtil1Zk9griCGFUWpBkntX/+rPEIXEMfuVWj
         IFhgGRU9uTpbUmPWUPxOG/CFmIfJ6Zu/utT3xIApu2gHte4gbg0+UQshDbwob08P682b
         pUv8Fqt2pRMX+ZhjWgjdnMWA2ixjrPkb5ub4JdORldsLs40PFcV1Wz3n1OHxvXJgVpPA
         NAJCOfzrh8Hl/zr8NjrVWxrdeQ8PbKn5UzW4gDuhdw0feAD8tWDS+lkJ+W3sTO11nI4B
         pO3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=feipUZjqbd8RBzgRB5BINxVf9AUJLyGnWTtgVx7x4qA=;
        b=MOy/ARx5dKX1lTmDn30NMshqbx5f6qyjR18vPSop8xQg1ejDvjQ+IBJSBqHJtYK1xY
         rNpj5x6UueD+F4o0X/T72cAplRtvVvl4Be28l77ogOG3F14v92/G0R4Lv4oMVl4xyvZB
         xpi+PUkToo97rMypFCLdfRMaqyNRWckthOu8rU5H5b6e9EAUYcEnETa4umi01AOMOVYc
         Zu70+s8KYWm7J/KmUANS/4TQxJ5fzwjzuWHO+eSvJICoTmb3OEh49BInaKrndUoNrKFR
         qZIRpLdu5tHakGTkH46OuN37OI+R6qhg7geGIbWNYHyX3pQTiyg7gSyhteRJfWyaaImv
         qGTg==
X-Gm-Message-State: AGi0PuYDaGmUaUyAc+NqFAyOHBqTAfY3VFCVcx8/o+cRsJGO7qTLf9xk
	MDdKp8x76BHQqxRk6ulR7PI=
X-Google-Smtp-Source: APiQypLudFkldCsXTJdbtxb6e9A+JOwz9m31bImmyYw2+xvOx25S9d42FkFHDlaYe096iPrbhF4xzw==
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr5220389wmg.147.1587052762778;
        Thu, 16 Apr 2020 08:59:22 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v3 0/5] hardening : prevent write to proces's read-only pages
Date: Thu, 16 Apr 2020 18:59:15 +0300
Message-Id: <20200416155917.28536-1-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1

v3 --> v4
	patch of v3 was mailformed . Sendimg again
	I removed architectures I can not test patch (PPC, unicore, um)
	I tested it only on arm and x86, x86_64
v2 --> v3
	Split patch to architecture independ part and separate patches
	for architectures that have arch_vma_access_permitted() handler.
	I tested it only on arm and x86
v1 --> v2
	I sent empty v1 patch, just resending
v0 --> v1
---
	Added sysctl_forbid_write_ro_mem to control whether to allow write
    or deny. (Advised by Kees Cook, KSPP issue 37)
    It has values range [0-2] and it gets the initial value from
    CONFIG_PROTECT_READONLY_USER_MEMORY (defaulted to 0, so it cant break)
    Setting it to 0 disables write checks.
    Setting it to 1 deny writes from other processes.
    Setting it to 2 deny writes from any processes including itself
----
v0
----

The purpose of this patch is produce hardened kernel for Embedded
or Production systems.
This patch shouild close issue 37 opened by Kees Cook in KSPP project

Typically debuggers, such as gdb, write to read-only code [text]
sections of target process.(ptrace)
This kind of page protectiion violation raises minor page fault, but
kernel's fault handler allows it by default.
This is clearly attack surface for adversary.

The proposed kernel hardening configuration option checks the type of
protection of the foreign vma and blocks writes to read only vma.

When enabled, it will stop attacks modifying code or jump tables, etc.

Code of arch_vma_access_permitted() function was extended to
check foreign vma flags.

Tested on x86_64 and ARM(QEMU) with dd command which writes to
/proc/PID/mem in r--p or r--xp of vma area addresses range

dd reports IO failure when tries to write to adress taken from
from /proc/PID/maps (PLT or code section)


Lev Olshvang (5):
  Hardening x86: Forbid writes to read-only memory pages of a process
  Hardening PowerPC: Forbid writes to read-only memory pages of a
    process
  Hardening um: Forbid writes to read-only memory pages of a process
  Hardening unicore32: Forbid writes to read-only memory pages of a
    process
  Hardening : PPC book3s64: Forbid writes to read-only memory pages of a
    process

 arch/powerpc/include/asm/mmu_context.h   | 9 +--------
 arch/powerpc/mm/book3s64/pkeys.c         | 5 -----
 arch/um/include/asm/mmu_context.h        | 8 +-------
 arch/unicore32/include/asm/mmu_context.h | 7 +------
 arch/x86/include/asm/mmu_context.h       | 8 +-------
 5 files changed, 4 insertions(+), 33 deletions(-)

--
2.17.1

