Return-Path: <SRS0=Zyyv=CZ=lists.openwall.com=kernel-hardening-return-19906-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2C2C43461
	for <kernel-hardening@archiver.kernel.org>; Wed, 16 Sep 2020 15:09:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0C51E206B7
	for <kernel-hardening@archiver.kernel.org>; Wed, 16 Sep 2020 15:09:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ujz+S1Oq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C51E206B7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19906-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5143 invoked by uid 550); 16 Sep 2020 15:08:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3960 invoked from network); 16 Sep 2020 15:08:49 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 169662074C90
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1600268917;
	bh=b+dZfSYt921SZbqVi9d6jmG8B2GKXdUDhoo8NhJxV+k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Ujz+S1OqtosPp/8L9N3unu6wuJGss69KS6W/GHWBWqM4qfdWcRG/EKRgUKJbOEORc
	 x+qd/TTcA8Trl1XdmvODaLvWIGzELcQgFeVjLlgZi8uYhTVxlKm7dCUF532grSOPqk
	 Po96nXGPIm2UK+uUyzCR1OmHS74BMY4y3GHpUvus=
From: madvenka@linux.microsoft.com
To: kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	oleg@redhat.com,
	x86@kernel.org,
	madvenka@linux.microsoft.com
Subject: [PATCH v2 4/4] [RFC] arm/trampfd: Provide support for the trampoline file descriptor
Date: Wed, 16 Sep 2020 10:08:26 -0500
Message-Id: <20200916150826.5990-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200916150826.5990-1-madvenka@linux.microsoft.com>
References: <210d7cd762d5307c2aa1676705b392bd445f1baa>
 <20200916150826.5990-1-madvenka@linux.microsoft.com>

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

	- Define architecture specific register names
	- Architecture specific functions for:
		- system call init
		- code descriptor check
		- data descriptor check
	- Fill a page with a trampoline table,

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm/include/uapi/asm/ptrace.h |  21 +++++
 arch/arm/kernel/Makefile           |   1 +
 arch/arm/kernel/trampfd.c          | 124 +++++++++++++++++++++++++++++
 arch/arm/tools/syscall.tbl         |   1 +
 4 files changed, 147 insertions(+)
 create mode 100644 arch/arm/kernel/trampfd.c

diff --git a/arch/arm/include/uapi/asm/ptrace.h b/arch/arm/include/uapi/asm/ptrace.h
index e61c65b4018d..598047768f9b 100644
--- a/arch/arm/include/uapi/asm/ptrace.h
+++ b/arch/arm/include/uapi/asm/ptrace.h
@@ -151,6 +151,27 @@ struct pt_regs {
 #define ARM_r0		uregs[0]
 #define ARM_ORIG_r0	uregs[17]
 
+/*
+ * These register names are to be used by 32-bit applications.
+ */
+enum reg_32_name {
+	arm_min,
+	arm_r0 = arm_min,
+	arm_r1,
+	arm_r2,
+	arm_r3,
+	arm_r4,
+	arm_r5,
+	arm_r6,
+	arm_r7,
+	arm_r8,
+	arm_r9,
+	arm_r10,
+	arm_r11,
+	arm_r12,
+	arm_max,
+};
+
 /*
  * The size of the user-visible VFP state as seen by PTRACE_GET/SETVFPREGS
  * and core dumps.
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 89e5d864e923..652c54c2f19a 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -105,5 +105,6 @@ obj-$(CONFIG_SMP)		+= psci_smp.o
 endif
 
 obj-$(CONFIG_HAVE_ARM_SMCCC)	+= smccc-call.o
+obj-$(CONFIG_TRAMPFD)		+= trampfd.o
 
 extra-y := $(head-y) vmlinux.lds
diff --git a/arch/arm/kernel/trampfd.c b/arch/arm/kernel/trampfd.c
new file mode 100644
index 000000000000..45146ed489e8
--- /dev/null
+++ b/arch/arm/kernel/trampfd.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Trampoline FD - ARM support.
+ *
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (c) 2020, Microsoft Corporation.
+ */
+
+#include <linux/thread_info.h>
+#include <linux/trampfd.h>
+
+#define TRAMPFD_CODE_SIZE		28
+
+/*
+ * trampfd syscall.
+ */
+void trampfd_arch(struct trampfd_info *info)
+{
+	info->code_size = TRAMPFD_CODE_SIZE;
+	info->ntrampolines = PAGE_SIZE / info->code_size;
+	info->code_offset = TRAMPFD_CODE_PGOFF << PAGE_SHIFT;
+	info->reserved = 0;
+}
+
+/*
+ * trampfd code descriptor check.
+ */
+int trampfd_code_arch(struct trampfd_code *code)
+{
+	int	ntrampolines;
+	int	min, max;
+
+	min = arm_min;
+	max = arm_max;
+	ntrampolines = PAGE_SIZE / TRAMPFD_CODE_SIZE;
+
+	if (code->reg < min || code->reg >= max)
+		return -EINVAL;
+
+	if (!code->ntrampolines || code->ntrampolines > ntrampolines)
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * trampfd data descriptor check.
+ */
+int trampfd_data_arch(struct trampfd_data *data)
+{
+	int	min, max;
+
+	min = arm_min;
+	max = arm_max;
+
+	if (data->reg < min || data->reg >= max)
+		return -EINVAL;
+	return 0;
+}
+
+#define MOVW(ins, reg, imm32)						\
+{									\
+	u16	*_imm16 = (u16 *) &(imm32);	/* little endian */	\
+	int	_hw, _opcode;						\
+									\
+	for (_hw = 0; _hw < 2; _hw++) {					\
+		/* movw or movt */					\
+		_opcode = _hw ? 0xe3400000 : 0xe3000000;		\
+		*ins++ = _opcode | (_imm16[_hw] >> 12) << 16 |		\
+			 (reg) << 12 | (_imm16[_hw] & 0xFFF);		\
+	}								\
+}
+
+#define LDR(ins, reg)							\
+{									\
+	*ins++ = 0xe5900000 | (reg) << 16 | (reg) << 12;		\
+}
+
+#define BX(ins, reg)							\
+{									\
+	*ins++ = 0xe12fff10 | (reg);					\
+}
+
+void trampfd_code_fill(struct trampfd *trampfd, char *addr)
+{
+	char		*eaddr = addr + PAGE_SIZE;
+	int		creg = trampfd->code_reg - arm_min;
+	int		dreg = trampfd->data_reg - arm_min;
+	u32		*code = trampfd->code;
+	u32		*data = trampfd->data;
+	u32		*instruction = (u32 *) addr;
+	int		i;
+
+	for (i = 0; i < trampfd->ntrampolines; i++, code++, data++) {
+		/*
+		 * movw creg, code & 0xFFFF
+		 * movt creg, code >> 16
+		 */
+		MOVW(instruction, creg, code);
+
+		/*
+		 * ldr	creg, [creg]
+		 */
+		LDR(instruction, creg);
+
+		/*
+		 * movw dreg, data & 0xFFFF
+		 * movt dreg, data >> 16
+		 */
+		MOVW(instruction, dreg, data);
+
+		/*
+		 * ldr	dreg, [dreg]
+		 */
+		LDR(instruction, dreg);
+
+		/*
+		 * bx	creg
+		 */
+		BX(instruction, creg);
+	}
+	addr = (char *) instruction;
+	memset(addr, 0, eaddr - addr);
+}
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index d5cae5ffede0..85dcbc9e08ee 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -452,3 +452,4 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
+440	common	trampfd				sys_trampfd
-- 
2.17.1

