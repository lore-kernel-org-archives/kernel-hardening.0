Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri,  2 Sep 2016 16:02:12 +0100
Message-Id: <1472828533-28197-7-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH v2 6/7] arm64: xen: Enable user access before a privcmd hvc call
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, AKASHI Takahiro <takahiro.akashi@linaro.org>, Julien Grall <julien.grall@arm.com>, Stefano Stabellini <sstabellini@kernel.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Privcmd calls are issued by the userspace. The kernel needs to enable
access to TTBR0_EL1 as the hypervisor would issue stage 1 translations
to user memory via AT instructions. Since AT instructions are not
affected by the PAN bit (ARMv8.1), we only need the explicit
uaccess_enable/disable if the TTBR0 PAN option is enabled.

Reviewed-by: Julien Grall <julien.grall@arm.com>
Acked-by: Stefano Stabellini <sstabellini@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/xen/hypercall.S | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/xen/hypercall.S b/arch/arm64/xen/hypercall.S
index 329c8027b0a9..211620dde4de 100644
--- a/arch/arm64/xen/hypercall.S
+++ b/arch/arm64/xen/hypercall.S
@@ -49,6 +49,7 @@
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include <asm/uaccess.h>
 #include <xen/interface/xen.h>
 
 
@@ -91,6 +92,24 @@ ENTRY(privcmd_call)
 	mov x2, x3
 	mov x3, x4
 	mov x4, x5
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	/*
+	 * Privcmd calls are issued by the userspace. The kernel needs to
+	 * enable access to TTBR0_EL1 as the hypervisor would issue stage 1
+	 * translations to user memory via AT instructions. Since AT
+	 * instructions are not affected by the PAN bit (ARMv8.1), we only
+	 * need the explicit uaccess_enable/disable if the TTBR0 PAN option is
+	 * enabled.
+	 */
+	uaccess_enable x6, x7
+#endif
 	hvc XEN_IMM
+
+#ifdef CONFIG_ARM64_TTBR0_PAN
+	/*
+	 * Disable userspace access from kernel once the hyp call completed.
+	 */
+	uaccess_disable x6
+#endif
 	ret
 ENDPROC(privcmd_call);
