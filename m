Return-Path: <SRS0=Qtwx=5W=lists.openwall.com=kernel-hardening-return-18425-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A62C2BA19
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 14:57:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 630DC2486F
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 14:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tt8IJLqY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 630DC2486F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18425-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7864 invoked by uid 550); 6 Apr 2020 14:57:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30184 invoked from network); 6 Apr 2020 14:21:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Kts4XrENlqq0ihvP+vA42+Cejujha1YSf0CBRIdHH08=;
        b=tt8IJLqY9reW16SwD+ljWi+YLEG/VnpZCu5gWfZ8T4ZjKheEB6HPvN276ET4a95IjW
         PPeVgh978RSX1Lvkt5yBOgLvnKS9kHbCybpnH6AZ03gb2YZANwtNnTYve5CUwd2VmpmF
         RomUFG1l7k1ya+Zfu55opCCihaoN/azIuDyQ2ctqnBM2EgCi0yPuuP2QWsXkXyxP9BAJ
         2aFVmpo5StdxnTFX1JwMHE+yOSsena4vbkHCoguHM9VKUFxelCHsz35OAVE/klHWA95N
         BqpC87R2VrvOTnmXQ1OZvf8l2F6/FTzFTGRY4Vf9uzzwT1qTUoG6cC0O4XAztizMzQ93
         SBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Kts4XrENlqq0ihvP+vA42+Cejujha1YSf0CBRIdHH08=;
        b=G4q8KWok6UKaGhyoLm1w0SfiylrKzyztHI757jqQcOpybvD5VQmla+HVSsAKaXNIHZ
         3juAqOHGwB+HqPB1Gz0zUzKtXof3zGmwgzdiI0MePQv+Hxj+vgOD4S+7tkQ7fr/r5Vxu
         nlyBqOP9SJ8kxT/nkHdKPGTM8xUlN4Y3wCMyqbbDs/xtAZwZ+uYyU5c9pxybsG1qKQ1X
         wIxaxulfqBW1rzyP35IdHtbeNeYbu7TvHvcXOq9jAIkwe9H0IKNjxN3NrWVJZ/SX3zzc
         yf1j4P9NZlFnTGypJ1XxTRxnEnt8s7uQhkM7ozTwqJFplyoFTwU0vpXJsJAUH/uXcdzv
         to3A==
X-Gm-Message-State: AGi0PuYbadJnsiCVNkzm9N3+OpWOePf01PNYmHlk/gIcal4Gyrs73RuK
	qM+vY3OgF5tqcDGhI8fCKbk13VWeRrgQGw==
X-Google-Smtp-Source: APiQypIWFhOG8MsYx6+Ue8jEFgmgrs1ssYSNm0Rpmeake36kaSpSTTzCwpwaZ4qqp7AwZrpkVivoug==
X-Received: by 2002:adf:b6ab:: with SMTP id j43mr20047168wre.109.1586182881041;
        Mon, 06 Apr 2020 07:21:21 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: arnd@arndb.de
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [RFC PATCH 1/5] security : hardening : prevent write to proces's read-only pages from another process
Date: Mon,  6 Apr 2020 17:20:41 +0300
Message-Id: <20200406142045.32522-2-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200406142045.32522-1-levonshe@gmail.com>
References: <20200406142045.32522-1-levonshe@gmail.com>

The purpose of this patch is produce hardened kernel for Embedded
or Production systems.

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

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 include/asm-generic/mm_hooks.h |  5 +++++
 security/Kconfig               | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/asm-generic/mm_hooks.h b/include/asm-generic/mm_hooks.h
index 4dbb177d1150..6e1fcce44cc2 100644
--- a/include/asm-generic/mm_hooks.h
+++ b/include/asm-generic/mm_hooks.h
@@ -25,6 +25,11 @@ static inline void arch_unmap(struct mm_struct *mm,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE)))
+		return false;
+#endif
 	/* by default, allow everything */
 	return true;
 }
diff --git a/security/Kconfig b/security/Kconfig
index cd3cc7da3a55..d92e79c90d67 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -143,6 +143,16 @@ config LSM_MMAP_MIN_ADDR
 	  this low address space will need the permission specific to the
 	  systems running LSM.
 
+config PROTECT_READONLY_USER_MEMORY
+	bool "Protect read only process memory"
+	help
+	  Protects read only memory of process code and PLT table
+	  from possible attack through /proc/PID/mem or through /dev/mem.
+	  Refuses to insert and stop at debuggers breakpoints (prtace,gdb)
+	  Mostly advised for embedded and production system.
+	  Stops attempts of the malicious process to modify read only memory of another process
+
+
 config HAVE_HARDENED_USERCOPY_ALLOCATOR
 	bool
 	help
-- 
2.17.1

