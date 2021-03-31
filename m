Return-Path: <SRS0=7NjS=I5=lists.openwall.com=kernel-hardening-return-21104-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F1EC433B4
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 20:56:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7A9AF60BBB
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Mar 2021 20:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A9AF60BBB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21104-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11593 invoked by uid 550); 31 Mar 2021 20:55:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11483 invoked from network); 31 Mar 2021 20:55:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uk0/1LocoDticB91SF6FsgWpOKPsEr1Pb6N+E6L28KI=;
        b=nMBirdlJwaYEBDE8wICv0IcZbYumBG5x88i0jDmsPtEGCWerkbUkn/zXjtlou+AAnB
         CdCWfgp1k4EvjGaJ2pw+8HaBQeHDD+DkwHQbkP6CfxrFShjNk6a9uKNXN3ySmAr3ly/v
         g28hvtAPNP3f2K6+JoZ04rIfIXHvlInu+TnD0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk0/1LocoDticB91SF6FsgWpOKPsEr1Pb6N+E6L28KI=;
        b=RrHDg+JXrMvRBqTpYmz7/757twRh2E99tANCgMfjzHbc9HLQpsdMkSByEg2Edx+Vw7
         43bjpuHNmfPSiPk51f6SZEGKoisUNt8ECu5cH8Nzm/rxPgtcxEjImuT6luaQSYn9uQEX
         erl6RthHzvsGNIu/pyCLLjVmYLfTkyfPDAG+BfDd/dtPI1885FxzuMYj+W3HPDUPPx/s
         oNh883ioWlduiBQ97lbXaqS5UlpawE5muPGH/WISxvG23uQE3k0hTUmJ2qBCdpBuZvQU
         NMSW9aM3BkK5jhM/aFEXVM0WkkZWZw6e6CzNhwgE5Nad63MKCecfHPnitdOYWpiAiUar
         sxnA==
X-Gm-Message-State: AOAM530CdEVUU2+3mwuGtKHvDiKPvx3eCxVi17tlKJJ+8gOYttrOXPwZ
	UggkJTuhw2zOthLcE8T7EsSLzg==
X-Google-Smtp-Source: ABdhPJxuZ4BQCPoxOylqJ3K76DbwLF1JG4WceF9FhoFaFhbPpIbgQh3MG6jfYpIbOhAacKq366q+2w==
X-Received: by 2002:a63:4d0:: with SMTP id 199mr4929010pge.304.1617224106706;
        Wed, 31 Mar 2021 13:55:06 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 6/6] lkdtm: Add REPORT_STACK for checking stack offsets
Date: Wed, 31 Mar 2021 13:54:58 -0700
Message-Id: <20210331205458.1871746-7-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331205458.1871746-1-keescook@chromium.org>
References: <20210331205458.1871746-1-keescook@chromium.org>
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=fb815901a1ccc1d9c4ca5c3e3cd3729b7f382fe2; i=b69wRsxT78r/3tM1mGa7N6ME6+rlXyFg15giRWRwPAQ=; m=aFqgiEE+nAZdug79A1F+fVTg9ZceUb0WPE8cbHqssVg=; p=ZQ32/kILkW5AD3nBZHO0VMTp4prIPkm7+DdhCHX8KdA=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmBk4aIACgkQiXL039xtwCbSHQ/9GzS gwvyLm8xntGCfjZejzEAhSquCH/XGhwif40B/hY9NAzXrbKiOwzU378qbpWgxBePgTlGb3sKLB76C BHzMBpf5qbdOAWFHSbdkoLA6VoZ1Kc3Dv9lcZSpDekbhvjLhR4V2Up7yRhqEThy93+6AVcwGzBeac 6QWH01G3TAAqKsFLpV9ZjQOFxfS/obFaV/xK3RDHbKoY2jf6sGJnK2Y9hxRZMfyEnp2BFg0kdKSUr 0z5xDyHM3Xb+7TwBGwqGzP+TwPUBrXWtXKAjslca0S4ZQE/HBo8zsilyPvfhCl2T+esWB9qNJZbtx F6wRFNO6xcNLkF9VMP+8KyI2ikBpFMuEDmouAY3QkyENQiacPe4k9q5vDMvoe3EU/3NbOlJaO/0pw zbKdqFzN5b1HaJ3rgpeElBRbDH+CwqFTApO1mqZoi7KDqHaTym70Phz2P6Sovw36ctUn239DBf3Oi pEGi7NduC0vXBzrKcsFkivSl3imbBCo8t+qK+Ah4Nauc16qTQzMXY/twnQTuci/QVKWeq2BFnxBRK aOqgMXU7IVl7fXQL3QqIPaOez0kfnckLCHLNHqYEqVW1Zzgv+3gmrg12l5NAMYP2S2yWkU60izEcP dZeEdUXsNKOPqT0E3QzWksz9tPpec3mAH42JwcVawRfuRleF4XoNyiqWIrkXk9is=
Content-Transfer-Encoding: 8bit

For validating the stack offset behavior, report the offset from a given
process's first seen stack address. A quick way to measure the entropy:

for i in $(seq 1 1000); do
	echo "REPORT_STACK" >/sys/kernel/debug/provoke-crash/DIRECT
done
offsets=$(dmesg | grep 'Stack offset' | cut -d: -f3 | sort | uniq -c | sort -n | wc -l)
echo "$(uname -m) bits of stack entropy: $(echo "obase=2; $offsets" | bc | wc -L)"

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/bugs.c  | 17 +++++++++++++++++
 drivers/misc/lkdtm/core.c  |  1 +
 drivers/misc/lkdtm/lkdtm.h |  1 +
 3 files changed, 19 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 110f5a8538e9..0e8254d0cf0b 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -134,6 +134,23 @@ noinline void lkdtm_CORRUPT_STACK_STRONG(void)
 	__lkdtm_CORRUPT_STACK((void *)&data);
 }
 
+static pid_t stack_pid;
+static unsigned long stack_addr;
+
+void lkdtm_REPORT_STACK(void)
+{
+	volatile uintptr_t magic;
+	pid_t pid = task_pid_nr(current);
+
+	if (pid != stack_pid) {
+		pr_info("Starting stack offset tracking for pid %d\n", pid);
+		stack_pid = pid;
+		stack_addr = (uintptr_t)&magic;
+	}
+
+	pr_info("Stack offset: %d\n", (int)(stack_addr - (uintptr_t)&magic));
+}
+
 void lkdtm_UNALIGNED_LOAD_STORE_WRITE(void)
 {
 	static u8 data[5] __attribute__((aligned(4))) = {1, 2, 3, 4, 5};
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index b2aff4d87c01..8024b6a5cc7f 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -110,6 +110,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(EXHAUST_STACK),
 	CRASHTYPE(CORRUPT_STACK),
 	CRASHTYPE(CORRUPT_STACK_STRONG),
+	CRASHTYPE(REPORT_STACK),
 	CRASHTYPE(CORRUPT_LIST_ADD),
 	CRASHTYPE(CORRUPT_LIST_DEL),
 	CRASHTYPE(STACK_GUARD_PAGE_LEADING),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 5ae48c64df24..99f90d3e5e9c 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -17,6 +17,7 @@ void lkdtm_LOOP(void);
 void lkdtm_EXHAUST_STACK(void);
 void lkdtm_CORRUPT_STACK(void);
 void lkdtm_CORRUPT_STACK_STRONG(void);
+void lkdtm_REPORT_STACK(void);
 void lkdtm_UNALIGNED_LOAD_STORE_WRITE(void);
 void lkdtm_SOFTLOCKUP(void);
 void lkdtm_HARDLOCKUP(void);
-- 
2.25.1

