Return-Path: <SRS0=2TOT=AU=lists.openwall.com=kernel-hardening-return-19265-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0363EC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jul 2020 04:02:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 61156206E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Jul 2020 04:02:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 61156206E2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19265-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25955 invoked by uid 550); 9 Jul 2020 04:01:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25839 invoked from network); 9 Jul 2020 04:01:23 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: [PATCH v2 4/5] powerpc/lib: Add LKDTM accessor for patching addr
Date: Wed,  8 Jul 2020 23:03:15 -0500
Message-Id: <20200709040316.12789-5-cmr@informatik.wtf>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200709040316.12789-1-cmr@informatik.wtf>
References: <20200709040316.12789-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

When live patching a STRICT_RWX kernel, a mapping is installed at a
"patching address" with temporary write permissions. Provide a
LKDTM-only accessor function for this address in preparation for a LKDTM
test which attempts to "hijack" this mapping by writing to it from
another CPU.

Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/include/asm/code-patching.h | 4 ++++
 arch/powerpc/lib/code-patching.c         | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index eacc9102c251..ffc6dfdbbf8e 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -187,4 +187,8 @@ static inline unsigned long ppc_kallsyms_lookup_name(const char *name)
 				 ___PPC_RA(__REG_R1) | PPC_LR_STKOFF)
 #endif /* CONFIG_PPC64 */
 
+#ifdef CONFIG_LKDTM
+unsigned long read_cpu_patching_addr(unsigned int cpu);
+#endif
+
 #endif /* _ASM_POWERPC_CODE_PATCHING_H */
diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 80fe3864f377..a12db2092947 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -51,6 +51,13 @@ int raw_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
 static struct mm_struct *patching_mm __ro_after_init;
 static unsigned long patching_addr __ro_after_init;
 
+#ifdef CONFIG_LKDTM
+unsigned long read_cpu_patching_addr(unsigned int cpu)
+{
+	return patching_addr;
+}
+#endif
+
 void __init poking_init(void)
 {
 	spinlock_t *ptl; /* for protecting pte table */
-- 
2.27.0

