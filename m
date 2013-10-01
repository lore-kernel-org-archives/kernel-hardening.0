Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue,  1 Oct 2013 12:37:24 -0700
Message-Id: <1380656245-29975-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1380656245-29975-1-git-send-email-keescook@chromium.org>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 6/7] x86, kaslr: report kernel offset on panic
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

When the system panics, include the kernel offset in the report to assist
in debugging.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/setup.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..1708862 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -824,6 +824,20 @@ static void __init trim_low_memory_range(void)
 }
 	
 /*
+ * Dump out kernel offset information on panic.
+ */
+static int
+dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
+{
+	pr_emerg("Kernel Offset: 0x%lx from 0x%lx "
+		 "(relocation range: 0x%lx-0x%lx)\n",
+		 (unsigned long)&_text - __START_KERNEL, __START_KERNEL,
+		 __START_KERNEL_map, MODULES_VADDR-1);
+
+	return 0;
+}
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
  * for initialization.  Note, the efi init code path is determined by the
@@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
 }
 
 #endif /* CONFIG_X86_32 */
+
+static struct notifier_block kernel_offset_notifier = {
+	.notifier_call = dump_kernel_offset
+};
+
+static int __init register_kernel_offset_dumper(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list,
+					&kernel_offset_notifier);
+	return 0;
+}
+__initcall(register_kernel_offset_dumper);
-- 
1.7.9.5
