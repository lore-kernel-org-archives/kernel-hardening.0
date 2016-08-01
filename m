Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Mon,  1 Aug 2016 10:08:00 -0700
Message-Id: <1470071280-78706-3-git-send-email-thgarnie@google.com>
In-Reply-To: <1470071280-78706-1-git-send-email-thgarnie@google.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v1 2/2] x86/power/64: Fix __PAGE_OFFSET usage on restore
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Yinghai Lu <yinghai@kernel.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When KASLR memory randomization is used, __PAGE_OFFSET is a global
variable changed during boot. The assembly code was using the variable
as an immediate value to calculate the cr3 physical address. The
physical address was incorrect resulting to a GP fault.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/power/hibernate_asm_64.S | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 8eee0e9..8db4905 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -23,6 +23,16 @@
 #include <asm/processor-flags.h>
 #include <asm/frame.h>
 
+/*
+ * A global variable holds the page_offset when KASLR memory randomization
+ * is enabled.
+ */
+#ifdef CONFIG_RANDOMIZE_MEMORY
+#define __PAGE_OFFSET_REF __PAGE_OFFSET
+#else
+#define __PAGE_OFFSET_REF $__PAGE_OFFSET
+#endif
+
 ENTRY(swsusp_arch_suspend)
 	movq	$saved_context, %rax
 	movq	%rsp, pt_regs_sp(%rax)
@@ -72,7 +82,7 @@ ENTRY(restore_image)
 	/* code below has been relocated to a safe page */
 ENTRY(core_restore_code)
 	/* switch to temporary page tables */
-	movq	$__PAGE_OFFSET, %rcx
+	movq	__PAGE_OFFSET_REF, %rcx
 	subq	%rcx, %rax
 	movq	%rax, %cr3
 	/* flush TLB */
-- 
2.8.0.rc3.226.g39d4020
