Return-Path: <SRS0=rD8C=5Q=lists.openwall.com=kernel-hardening-return-18316-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E60C43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EEA85206DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 04:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="aa7Y09bC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="pJiRJMWO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEA85206DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18316-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17772 invoked by uid 550); 31 Mar 2020 04:49:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17599 invoked from network); 31 Mar 2020 04:49:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=fm1; bh=j31fQE86XUAg1
	3xgkmTRfBdrUL53tEWPF3K3/cROCJY=; b=aa7Y09bC6z7iniz0c7hM8dl8Lm+ZJ
	U7X0FwcIHe6BCfTuCbZUxmeSLqI9R/Oib4nlnnZJJ2P/4Rk0IpF+peaTlH2r9Cxi
	WbSt6Tf6bRo2qUYjWS5WToE3JJOvM0tzMb1ZDaNHAeueiPNyqQXdcssot99jjcPx
	xH9a6W/xzElveLSjy4bkDX31jsqdX2p9djbd+93sSnb4eAYSa4+5qXmOkzl1Knfk
	O1FRR83M1ayCmUdEyb3zsph41xRp8ydHWW69qTHg7hp25vgDz9Ii7jNrhplTbbY5
	HNoqTGBfuMmSGc21yBg7ATM5e9yA8VFZJpElyB/c5DgMDFGE4NjntLacA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:in-reply-to:message-id:mime-version:references:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=j31fQE86XUAg13xgkmTRfBdrUL53tEWPF3K3/cROCJY=; b=pJiRJMWO
	qvZolekZGS4avsQ6fP9dvS4SXVwn0OOTg+1mY9bKUgW9W4JdxfnPhyInf5P9IG4a
	l3AcQcDcyUd0FpQnpWWkFZOOyhPJebVrxEqQw6Cy33h0jNDMoLh0cS0lxCQ50JMS
	+5Yk6ezkAq+MnLJZqxWq1Z9TLHqPJOJ2jLmdD+Fjstu3oZUKlmB5+d//dhaWVSjh
	lFh8d+EPHdI5y4+tlHw76kIJCX0iWCJqyTc1INvXn92j8wlQ5sorNy3jm/j/Q4te
	OHT3Bs5IzJuvNTNgiEbT6TsN42bRL9V3duk7xQHzNIkgLMHBRkwXxgCmQ/QhFCvj
	5Qx+9d0m4qe4sg==
X-ME-Sender: <xms:scuCXmiWhxVmU5dLI7jY1BtXpCwdCodOjkeXp4jxSrzhnZSkbdoZZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeiiedgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefhvf
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddurdeghedrvd
    duvddrvdefleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:scuCXuEQGJTDzUk2NuG0Ba9jTUXTxzh3kERWKjWFjqcUOkxUso3QIA>
    <xmx:scuCXlx3n2RJffJ3RPla53snAU9j38koCDaRoUyefLgz_2SjlR-lbg>
    <xmx:scuCXlouAbidK04hABbNTfd0NdauxjOmtp0Q7rkRSI0dxdFuXQU2Jw>
    <xmx:scuCXl2DUVSROL0hvnd9Bh376xPDnpDiTY4oUa_KZimoW28giThHaA>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v7 2/7] powerpc/kprobes: Mark newly allocated probes as RO
Date: Tue, 31 Mar 2020 15:48:20 +1100
Message-Id: <20200331044825.591653-3-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331044825.591653-1-ruscur@russell.cc>
References: <20200331044825.591653-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_STRICT_KERNEL_RWX=y and CONFIG_KPROBES=y, there will be one
W+X page at boot by default.  This can be tested with
CONFIG_PPC_PTDUMP=y and CONFIG_PPC_DEBUG_WX=y set, and checking the
kernel log during boot.

powerpc doesn't implement its own alloc() for kprobes like other
architectures do, but we couldn't immediately mark RO anyway since we do
a memcpy to the page we allocate later.  After that, nothing should be
allowed to modify the page, and write permissions are removed well
before the kprobe is armed.

The memcpy() would fail if >1 probes were allocated, so use
patch_instruction() instead which is safe for RO.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/kernel/kprobes.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index 2d27ec4feee4..bfab91ded234 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -24,6 +24,8 @@
 #include <asm/sstep.h>
 #include <asm/sections.h>
 #include <linux/uaccess.h>
+#include <linux/set_memory.h>
+#include <linux/vmalloc.h>
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
 DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
@@ -102,6 +104,16 @@ kprobe_opcode_t *kprobe_lookup_name(const char *name, unsigned int offset)
 	return addr;
 }
 
+void *alloc_insn_page(void)
+{
+	void *page = vmalloc_exec(PAGE_SIZE);
+
+	if (page)
+		set_memory_ro((unsigned long)page, 1);
+
+	return page;
+}
+
 int arch_prepare_kprobe(struct kprobe *p)
 {
 	int ret = 0;
@@ -124,11 +136,8 @@ int arch_prepare_kprobe(struct kprobe *p)
 	}
 
 	if (!ret) {
-		memcpy(p->ainsn.insn, p->addr,
-				MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+		patch_instruction(p->ainsn.insn, *p->addr);
 		p->opcode = *p->addr;
-		flush_icache_range((unsigned long)p->ainsn.insn,
-			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
 	}
 
 	p->ainsn.boostable = 0;
-- 
2.26.0

