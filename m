Return-Path: <SRS0=ahfE=55=lists.openwall.com=kernel-hardening-return-18495-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD02C2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:32:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C34442072C
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LEpdUCde"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C34442072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18495-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17858 invoked by uid 550); 13 Apr 2020 15:32:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17826 invoked from network); 13 Apr 2020 15:32:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=w/t6B0ThoL3M1gLD5PipnJv8fPikg30LLF2tcIAiJd8=;
        b=LEpdUCdevt+hkKb5wKAydWfvAvZvctEjJ8f56A6ciIBO6vZhxBh9hEq4WIF+hPgZFh
         rE29kklXB5R8iH62PlG47UPvp1uU6BDiA/63mzS+hRemW/fsApz+7PxdkIpEt7TsvPlW
         JIbAjlxnhC0RgbMHmrN0EinMzhuQGtBjk3xv1S3xKDJgfL4tPvBfOcLelSsdX2ID1pKp
         UmG8QVomYmz1sx+gmf1z9kjlMbtb9NqzweHdE5ryCTrobvHeEeoIPGeX8JRhIJsVJzpW
         NAkWKOPqKyLjWm9IKnoclIWTjTK4O9GralXqAQ36lpnXzVU7f9U4wXYQtwATzNWCXtf9
         M/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=w/t6B0ThoL3M1gLD5PipnJv8fPikg30LLF2tcIAiJd8=;
        b=uKZhFOCZ5GEp0nxud55jVaJEG13fUVB/38NvmlBNE6guV/oAYgRfP1R7Vod9nPwxnl
         bIOYoOKbaUvSrHmokDE1wyIieSewLyHGIq4WWPAEJoQ4eQCGoR3nfYBA6Yp1Hi2lwCIJ
         nxdpYpVPawh/BDqRd1tebQBldlmGoRsfe9OyycFtMYn3FLorQ18KCq11NHCGNG65uOR3
         BqUknQaqsLs520nIUY9wS7GjpHN9i5YNyN2wNtsehvGFrlu+ty+t2Sp7tnQojfFRCQl3
         SKqSw1i9Av3iSEExLWSVZLndAVQOsmQwTAr9yIV2cmtObZ8xIL8YDCFw0OMDk7i8hCib
         8gCw==
X-Gm-Message-State: AGi0PubMCz2urXulrix6aGKAUXRI24Tk8HBg9Nvan7XnLu1uLjrKP1uX
	JVGNMRg8yhSNOeyW1RiYchm7FSOwFYU=
X-Google-Smtp-Source: APiQypJW5u9KYjdkBBwrKYGb9YGmIWMCVSKEzjw6lL0oifGmJ4yklna0kl15MfiGboMY81jRosCalQ==
X-Received: by 2002:a1c:6402:: with SMTP id y2mr11593649wmb.116.1586791948901;
        Mon, 13 Apr 2020 08:32:28 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.orh
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v3 0/5] hardening : prevent write to proces's read-only pages
Date: Mon, 13 Apr 2020 18:32:06 +0300
Message-Id: <20200413153211.29876-1-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1

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

