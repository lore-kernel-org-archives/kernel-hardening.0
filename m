Return-Path: <SRS0=dClX=6A=lists.openwall.com=kernel-hardening-return-18539-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D77C2BB85
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:15:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3D03022240
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Apr 2020 16:15:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fu1W4Jaf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D03022240
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18539-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3565 invoked by uid 550); 16 Apr 2020 16:13:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3482 invoked from network); 16 Apr 2020 16:13:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hEmpFtr1j91FcLAOVORJZwbS3k3EwuLiK8/TK1VpwGo=;
        b=Fu1W4JafLiUsCjpI0xs77J2jpmJRZMinV4sL8sCdPHohAfwmN97YzbHE+Oipqmnuuh
         6TAJTu916+L1u2w9Ks3ld0MIQaXN7CDPnrkskTNLYZJUUo0/Un7kGBbRYGxs00nN7J1T
         FrPwhdGFpyomXA/iMLV2qWrvIxFG2u1nYHz6pCzt99WXNbZhlQHF9PpoKe6zO2+ygSQP
         WVN5y97cyuPRXeQr/YczdZO6CnG7xn8zTnwBWLX40CIuPIk0OTy4UGoSUqpWmUovfkno
         8SbPyULyLrSPAdPXoXKLLytN3niyVUXCSsJJh5GjgWsWrXsy1VgA3dv5kuhHbtT3fYVC
         x5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hEmpFtr1j91FcLAOVORJZwbS3k3EwuLiK8/TK1VpwGo=;
        b=EkK+DqDs6s7ewAwOMOHtuQI1Zt55tb+4cUVzyb4bQYBpLxfqcIp8+dRgmJC9kQOPp5
         T9mj/AeY3/LY2KO/ji6ROelmxvN/yO7MFJuuqrHoS1T+5OT7gEMZhvgHOBqxeWcFBOjg
         /6jLPrIsMHSvNqic+UDAT42Nt5IimKiDJkQv5Du2aiAzpnqBLWMfM6XvwnW2Nbs21btV
         dAhGitJ1xj8d3IYEOEiYXrqKSFbbglp91GSSeH4aMPvsFfJfhxon6wiPazLt/vhn86nI
         wyR04nFPFPVA+GsHs32MwEqR3MCfNWI4mFojFKtSLQa5Xl2CS2dueT26whrgmlxmJE4g
         aHgQ==
X-Gm-Message-State: AGi0PuYxUUqbPCYHCTj7bstdqLyq9Fsupqz14f3f2fdeSXzrCFeAfL/r
	HDPs85wj73qIkdW3o2apt+TaS0w9jX6T1SHB9gQ=
X-Google-Smtp-Source: APiQypLPF8BoOizeBk7USPwMZwndRxBD/5JMBPRvpOtqCm+DswJlOTQn/V/gu+fgQJfxg+pKko19qPXOmtCiDKBDsXA=
X-Received: by 2002:a37:7987:: with SMTP id u129mr32380183qkc.312.1587053596089;
 Thu, 16 Apr 2020 09:13:16 -0700 (PDT)
Date: Thu, 16 Apr 2020 09:12:44 -0700
In-Reply-To: <20200416161245.148813-1-samitolvanen@google.com>
Message-Id: <20200416161245.148813-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200416161245.148813-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 11/12] arm64: scs: add shadow stacks for SDEI
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This change adds per-CPU shadow call stacks for the SDEI handler.
Similarly to how the kernel stacks are handled, we add separate shadow
stacks for normal and critical events.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: James Morse <james.morse@arm.com>
Tested-by: James Morse <james.morse@arm.com>
---
 arch/arm64/include/asm/scs.h |   2 +
 arch/arm64/kernel/entry.S    |  14 ++++-
 arch/arm64/kernel/scs.c      | 106 +++++++++++++++++++++++++++++------
 arch/arm64/kernel/sdei.c     |   7 +++
 4 files changed, 112 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/scs.h b/arch/arm64/include/asm/scs.h
index c50d2b0c6c5f..8e327e14bc15 100644
--- a/arch/arm64/include/asm/scs.h
+++ b/arch/arm64/include/asm/scs.h
@@ -9,6 +9,7 @@
 #ifdef CONFIG_SHADOW_CALL_STACK
 
 extern void scs_init_irq(void);
+extern int scs_init_sdei(void);
 
 static __always_inline void scs_save(struct task_struct *tsk)
 {
@@ -27,6 +28,7 @@ static inline void scs_overflow_check(struct task_struct *tsk)
 #else /* CONFIG_SHADOW_CALL_STACK */
 
 static inline void scs_init_irq(void) {}
+static inline int scs_init_sdei(void) { return 0; }
 static inline void scs_save(struct task_struct *tsk) {}
 static inline void scs_overflow_check(struct task_struct *tsk) {}
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c33264ce7258..768cd7abd32c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1058,13 +1058,16 @@ SYM_CODE_START(__sdei_asm_handler)
 
 	mov	x19, x1
 
+#if defined(CONFIG_VMAP_STACK) || defined(CONFIG_SHADOW_CALL_STACK)
+	ldrb	w4, [x19, #SDEI_EVENT_PRIORITY]
+#endif
+
 #ifdef CONFIG_VMAP_STACK
 	/*
 	 * entry.S may have been using sp as a scratch register, find whether
 	 * this is a normal or critical event and switch to the appropriate
 	 * stack for this CPU.
 	 */
-	ldrb	w4, [x19, #SDEI_EVENT_PRIORITY]
 	cbnz	w4, 1f
 	ldr_this_cpu dst=x5, sym=sdei_stack_normal_ptr, tmp=x6
 	b	2f
@@ -1074,6 +1077,15 @@ SYM_CODE_START(__sdei_asm_handler)
 	mov	sp, x5
 #endif
 
+#ifdef CONFIG_SHADOW_CALL_STACK
+	/* Use a separate shadow call stack for normal and critical events */
+	cbnz	w4, 3f
+	ldr_this_cpu dst=x18, sym=sdei_shadow_call_stack_normal_ptr, tmp=x6
+	b	4f
+3:	ldr_this_cpu dst=x18, sym=sdei_shadow_call_stack_critical_ptr, tmp=x6
+4:
+#endif
+
 	/*
 	 * We may have interrupted userspace, or a guest, or exit-from or
 	 * return-to either of these. We can't trust sp_el0, restore it.
diff --git a/arch/arm64/kernel/scs.c b/arch/arm64/kernel/scs.c
index eaadf5430baa..dddb7c56518b 100644
--- a/arch/arm64/kernel/scs.c
+++ b/arch/arm64/kernel/scs.c
@@ -10,31 +10,105 @@
 #include <asm/pgtable.h>
 #include <asm/scs.h>
 
-DEFINE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
+#define DECLARE_SCS(name)						\
+	DECLARE_PER_CPU(unsigned long *, name ## _ptr);			\
+	DECLARE_PER_CPU(unsigned long [SCS_SIZE/sizeof(long)], name)
 
-#ifndef CONFIG_SHADOW_CALL_STACK_VMAP
-DEFINE_PER_CPU(unsigned long [SCS_SIZE/sizeof(long)], irq_shadow_call_stack)
-	__aligned(SCS_SIZE);
+#ifdef CONFIG_SHADOW_CALL_STACK_VMAP
+#define DEFINE_SCS(name)						\
+	DEFINE_PER_CPU(unsigned long *, name ## _ptr)
+#else
+/* Allocate a static per-CPU shadow stack */
+#define DEFINE_SCS(name)						\
+	DEFINE_PER_CPU(unsigned long *, name ## _ptr);			\
+	DEFINE_PER_CPU(unsigned long [SCS_SIZE/sizeof(long)], name)	\
+		__aligned(SCS_SIZE)
+#endif /* CONFIG_SHADOW_CALL_STACK_VMAP */
+
+DECLARE_SCS(irq_shadow_call_stack);
+DECLARE_SCS(sdei_shadow_call_stack_normal);
+DECLARE_SCS(sdei_shadow_call_stack_critical);
+
+DEFINE_SCS(irq_shadow_call_stack);
+#ifdef CONFIG_ARM_SDE_INTERFACE
+DEFINE_SCS(sdei_shadow_call_stack_normal);
+DEFINE_SCS(sdei_shadow_call_stack_critical);
 #endif
 
+static int scs_alloc_percpu(unsigned long * __percpu *ptr, int cpu)
+{
+	unsigned long *p;
+
+	p = __vmalloc_node_range(PAGE_SIZE, SCS_SIZE,
+				 VMALLOC_START, VMALLOC_END,
+				 GFP_SCS, PAGE_KERNEL,
+				 0, cpu_to_node(cpu),
+				 __builtin_return_address(0));
+
+	if (!p)
+		return -ENOMEM;
+	per_cpu(*ptr, cpu) = p;
+
+	return 0;
+}
+
+static void scs_free_percpu(unsigned long * __percpu *ptr, int cpu)
+{
+	unsigned long *p = per_cpu(*ptr, cpu);
+
+	if (p) {
+		per_cpu(*ptr, cpu) = NULL;
+		vfree(p);
+	}
+}
+
+static void scs_free_sdei(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		scs_free_percpu(&sdei_shadow_call_stack_normal_ptr, cpu);
+		scs_free_percpu(&sdei_shadow_call_stack_critical_ptr, cpu);
+	}
+}
+
 void scs_init_irq(void)
 {
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-#ifdef CONFIG_SHADOW_CALL_STACK_VMAP
-		unsigned long *p;
+		if (IS_ENABLED(CONFIG_SHADOW_CALL_STACK_VMAP))
+			WARN_ON(scs_alloc_percpu(&irq_shadow_call_stack_ptr,
+						 cpu));
+		else
+			per_cpu(irq_shadow_call_stack_ptr, cpu) =
+				per_cpu(irq_shadow_call_stack, cpu);
+	}
+}
 
-		p = __vmalloc_node_range(PAGE_SIZE, SCS_SIZE,
-					 VMALLOC_START, VMALLOC_END,
-					 GFP_SCS, PAGE_KERNEL,
-					 0, cpu_to_node(cpu),
-					 __builtin_return_address(0));
+int scs_init_sdei(void)
+{
+	int cpu;
 
-		per_cpu(irq_shadow_call_stack_ptr, cpu) = p;
-#else
-		per_cpu(irq_shadow_call_stack_ptr, cpu) =
-			per_cpu(irq_shadow_call_stack, cpu);
-#endif /* CONFIG_SHADOW_CALL_STACK_VMAP */
+	if (!IS_ENABLED(CONFIG_ARM_SDE_INTERFACE))
+		return 0;
+
+	for_each_possible_cpu(cpu) {
+		if (IS_ENABLED(CONFIG_SHADOW_CALL_STACK_VMAP)) {
+			if (scs_alloc_percpu(
+				&sdei_shadow_call_stack_normal_ptr, cpu) ||
+			    scs_alloc_percpu(
+				&sdei_shadow_call_stack_critical_ptr, cpu)) {
+				scs_free_sdei();
+				return -ENOMEM;
+			}
+		} else {
+			per_cpu(sdei_shadow_call_stack_normal_ptr, cpu) =
+				per_cpu(sdei_shadow_call_stack_normal, cpu);
+			per_cpu(sdei_shadow_call_stack_critical_ptr, cpu) =
+				per_cpu(sdei_shadow_call_stack_critical, cpu);
+		}
 	}
+
+	return 0;
 }
diff --git a/arch/arm64/kernel/sdei.c b/arch/arm64/kernel/sdei.c
index d6259dac62b6..2854b9f7760a 100644
--- a/arch/arm64/kernel/sdei.c
+++ b/arch/arm64/kernel/sdei.c
@@ -13,6 +13,7 @@
 #include <asm/kprobes.h>
 #include <asm/mmu.h>
 #include <asm/ptrace.h>
+#include <asm/scs.h>
 #include <asm/sections.h>
 #include <asm/stacktrace.h>
 #include <asm/sysreg.h>
@@ -162,6 +163,12 @@ unsigned long sdei_arch_get_entry_point(int conduit)
 			return 0;
 	}
 
+	if (scs_init_sdei()) {
+		if (IS_ENABLED(CONFIG_VMAP_STACK))
+			free_sdei_stacks();
+		return 0;
+	}
+
 	sdei_exit_mode = (conduit == SMCCC_CONDUIT_HVC) ? SDEI_EXIT_HVC : SDEI_EXIT_SMC;
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-- 
2.26.1.301.g55bc3eb7cb9-goog

