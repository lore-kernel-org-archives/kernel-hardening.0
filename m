Return-Path: <SRS0=7JU/=55=lists.openwall.com=kernel-hardening-return-18494-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD08C2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:00:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CE0D62072D
	for <kernel-hardening@archiver.kernel.org>; Mon, 13 Apr 2020 15:00:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ll9hdqjW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE0D62072D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18494-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19936 invoked by uid 550); 13 Apr 2020 15:00:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19901 invoked from network); 13 Apr 2020 15:00:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:status:lines;
        bh=rUizTQPX2nyMPOOecf8xS9LwtaSU+2YXL7nj+p7VS8g=;
        b=ll9hdqjWbsIqTIZoTjDBIexMuAefKH1goU0yjr5pE8K27zrpc7uQ2kMUDiSbeZSZMB
         2+kul45mpVoyD6viIRIm04cVaW7rX7fQa6YSJ+1L8JIVD9Qg4p4rgMa5vlQk6d0kwDB4
         mBz8blnaRY/H+9N86XV4gehhxKFcrM3af7lI2KWUnnmWfEjcTPBW3N4AzYSvLHCL6hXR
         QiThkemY/nR9uOlMhgE499lCtGmyuGVy2j2SFnaNHYIuIr4ozd3XIeaMQ8Hp6hsxGd1k
         DZ51irHRm+/iyKbtx6UHGCMgpOdtA/bVoCVFu+IzkZj1vZxRoRL788uFpfEetySebZl1
         Gvhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:status:lines;
        bh=rUizTQPX2nyMPOOecf8xS9LwtaSU+2YXL7nj+p7VS8g=;
        b=QB+95HubTXuKhOAzN1fWIwNS4ZEMijJHsXukdTuG4XatPW0BiYgwTqCqDR/TiY+jRe
         VJJ0B0JBNbnnJlKeVWJR7PMFcUe6WobJ2kcL4fDY+gEqYuw+zyGCjMYbj0l69Q0JrgSS
         Uewew/OwIxBSVVl7wZmWoaN/oY8HZNoOoXNL9GCQTML46ADbarMfLGN4bwNUudsXOakq
         lQeg92o4PKNHfggB30RlEGEbtKQ6tcv2c6Sn4OZ1Tz2RwFUEF3dY+y9J7yiVf7JYhswZ
         76F/ckLz9f/6hOXNJKTvtaLFwVBalcnTfMhnAukwUfRlV1t3Fa1DqTjfEdpCaEsgkfql
         67Ig==
X-Gm-Message-State: AGi0Pub4nbsaztbNOBz+k4gcfPe/q59Mwnq0HuLpCIOm2dd6qHgJsgkY
	lPt44KY5u/EkDGv+brd1G6s=
X-Google-Smtp-Source: APiQypIsvT3FLNMWUC3842q7RcIeN/NaRmxxxOBw0yw1tqx21lKXtk4hvT0Xw/3itjEpN7toO+PpmA==
X-Received: by 2002:adf:e403:: with SMTP id g3mr18361291wrm.121.1586789992578;
        Mon, 13 Apr 2020 07:59:52 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.orh
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v1 0/1] hardening : prevent write to proces's read-only pages
Date: Mon, 13 Apr 2020 17:59:37 +0300
Message-Id: <20200413145942.27686-1-levonshe@gmail.com>
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

Lev Olshvang (1):
  hardening: Do not allow writes to read-only process memory

 arch/powerpc/include/asm/mmu_context.h   | 16 ++++++------
 arch/powerpc/mm/book3s64/pkeys.c         |  8 +++---
 arch/um/include/asm/mmu_context.h        | 13 +++++-----
 arch/unicore32/include/asm/mmu_context.h | 13 +++++-----
 arch/x86/include/asm/mmu_context.h       |  9 ++++---
 arch/x86/mm/fault.c                      |  2 +-
 include/asm-generic/mm_hooks.h           | 12 ++++-----
 include/linux/mm.h                       | 20 ++++++++++++++-
 kernel/sysctl.c                          | 31 ++++++++++++++++--------
 mm/util.c                                |  2 ++
 security/Kconfig                         | 17 +++++++++----
 11 files changed, 93 insertions(+), 50 deletions(-)

--
2.17.1

