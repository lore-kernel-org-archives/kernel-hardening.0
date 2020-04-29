Return-Path: <SRS0=w6oR=6N=lists.openwall.com=kernel-hardening-return-18670-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB4DC83001
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 02:04:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7944820731
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Apr 2020 02:04:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7944820731
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18670-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17761 invoked by uid 550); 29 Apr 2020 02:04:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17678 invoked from network); 29 Apr 2020 02:04:25 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@lists.ozlabs.org,
	kernel-hardening@lists.openwall.com
Subject: [RFC PATCH v2 1/5] powerpc/mm: Introduce temporary mm
Date: Tue, 28 Apr 2020 21:05:27 -0500
Message-Id: <20200429020531.20684-2-cmr@informatik.wtf>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200429020531.20684-1-cmr@informatik.wtf>
References: <20200429020531.20684-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

x86 supports the notion of a temporary mm which restricts access to
temporary PTEs to a single CPU. A temporary mm is useful for situations
where a CPU needs to perform sensitive operations (such as patching a
STRICT_KERNEL_RWX kernel) requiring temporary mappings without exposing
said mappings to other CPUs. A side benefit is that other CPU TLBs do
not need to be flushed when the temporary mm is torn down.

Mappings in the temporary mm can be set in the userspace portion of the
address-space.

Interrupts must be disabled while the temporary mm is in use. HW
breakpoints, which may have been set by userspace as watchpoints on
addresses now within the temporary mm, are saved and disabled when
loading the temporary mm. The HW breakpoints are restored when unloading
the temporary mm. All HW breakpoints are indiscriminately disabled while
the temporary mm is in use.

Based on x86 implementation:

commit cefa929c034e
("x86/mm: Introduce temporary mm structs")

Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/include/asm/debug.h       |  1 +
 arch/powerpc/include/asm/mmu_context.h | 54 ++++++++++++++++++++++++++
 arch/powerpc/kernel/process.c          |  5 +++
 3 files changed, 60 insertions(+)

diff --git a/arch/powerpc/include/asm/debug.h b/arch/powerpc/include/asm/debug.h
index 7756026b95ca..b945bc16c932 100644
--- a/arch/powerpc/include/asm/debug.h
+++ b/arch/powerpc/include/asm/debug.h
@@ -45,6 +45,7 @@ static inline int debugger_break_match(struct pt_regs *regs) { return 0; }
 static inline int debugger_fault_handler(struct pt_regs *regs) { return 0; }
 #endif
 
+void __get_breakpoint(struct arch_hw_breakpoint *brk);
 void __set_breakpoint(struct arch_hw_breakpoint *brk);
 bool ppc_breakpoint_available(void);
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index 360367c579de..57a8695fe63f 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -10,6 +10,7 @@
 #include <asm/mmu.h>	
 #include <asm/cputable.h>
 #include <asm/cputhreads.h>
+#include <asm/debug.h>
 
 /*
  * Most if the context management is out of line
@@ -270,5 +271,58 @@ static inline int arch_dup_mmap(struct mm_struct *oldmm,
 	return 0;
 }
 
+struct temp_mm {
+	struct mm_struct *temp;
+	struct mm_struct *prev;
+	bool is_kernel_thread;
+	struct arch_hw_breakpoint brk;
+};
+
+static inline void init_temp_mm(struct temp_mm *temp_mm, struct mm_struct *mm)
+{
+	temp_mm->temp = mm;
+	temp_mm->prev = NULL;
+	temp_mm->is_kernel_thread = false;
+	memset(&temp_mm->brk, 0, sizeof(temp_mm->brk));
+}
+
+static inline void use_temporary_mm(struct temp_mm *temp_mm)
+{
+	lockdep_assert_irqs_disabled();
+
+	temp_mm->is_kernel_thread = current->mm == NULL;
+	if (temp_mm->is_kernel_thread)
+		temp_mm->prev = current->active_mm;
+	else
+		temp_mm->prev = current->mm;
+
+	/*
+	 * Hash requires a non-NULL current->mm to allocate a userspace address
+	 * when handling a page fault. Does not appear to hurt in Radix either.
+	 */
+	current->mm = temp_mm->temp;
+	switch_mm_irqs_off(NULL, temp_mm->temp, current);
+
+	if (ppc_breakpoint_available()) {
+		__get_breakpoint(&temp_mm->brk);
+		if (temp_mm->brk.type != 0)
+			hw_breakpoint_disable();
+	}
+}
+
+static inline void unuse_temporary_mm(struct temp_mm *temp_mm)
+{
+	lockdep_assert_irqs_disabled();
+
+	if (temp_mm->is_kernel_thread)
+		current->mm = NULL;
+	else
+		current->mm = temp_mm->prev;
+	switch_mm_irqs_off(NULL, temp_mm->prev, current);
+
+	if (ppc_breakpoint_available() && temp_mm->brk.type != 0)
+		__set_breakpoint(&temp_mm->brk);
+}
+
 #endif /* __KERNEL__ */
 #endif /* __ASM_POWERPC_MMU_CONTEXT_H */
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 9c21288f8645..ec4cf890d92c 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -800,6 +800,11 @@ static inline int set_breakpoint_8xx(struct arch_hw_breakpoint *brk)
 	return 0;
 }
 
+void __get_breakpoint(struct arch_hw_breakpoint *brk)
+{
+	memcpy(brk, this_cpu_ptr(&current_brk), sizeof(*brk));
+}
+
 void __set_breakpoint(struct arch_hw_breakpoint *brk)
 {
 	memcpy(this_cpu_ptr(&current_brk), brk, sizeof(*brk));
-- 
2.26.1

