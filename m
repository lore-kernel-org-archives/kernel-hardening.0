Reply-To: kernel-hardening@lists.openwall.com
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 12 Aug 2016 16:27:45 +0100
Message-Id: <1471015666-23125-7-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
References: <1471015666-23125-1-git-send-email-catalin.marinas@arm.com>
Subject: [kernel-hardening] [PATCH 6/7] arm64: xen: Enable user access before a privcmd hvc call
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com, Julien Grall <julien.grall@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Privcmd calls are issued by the userspace. The kernel needs to enable
access to TTBR0_EL1 as the hypervisor would issue stage 1 translations
to user memory via AT instructions. Since AT instructions are not
affected by the PAN bit (ARMv8.1), we only need the explicit
uaccess_enable/disable if the TTBR0 PAN option is enabled.

Cc: Julien Grall <julien.grall@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/xen/hypercall.S | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/xen/hypercall.S b/arch/arm64/xen/hypercall.S
index 329c8027b0a9..4c509f4f4dcc 100644
--- a/arch/arm64/xen/hypercall.S
+++ b/arch/arm64/xen/hypercall.S
@@ -91,6 +91,24 @@ ENTRY(privcmd_call)
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
+	uaccess_enable x6, x7, x8
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
