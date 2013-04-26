Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 Apr 2013 12:03:25 -0700
Message-Id: <1367003005-5560-7-git-send-email-keescook@chromium.org>
In-Reply-To: <1367003005-5560-1-git-send-email-keescook@chromium.org>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 6/6] x86: kaslr: report kernel offset on panic
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

When the system panics, include the kernel offset in the report to assist
in debugging.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/setup.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index fae9134..95a33b1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -830,6 +830,18 @@ static void __init trim_low_memory_range(void)
 }
 	
 /*
+ * Dump out kernel offset information on panic.
+ */
+static int
+dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
+{
+	pr_emerg("Kernel Offset: 0x%lx\n",
+		 (unsigned long)&_text - __START_KERNEL);
+
+	return 0;
+}
+
+/*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
  * for initialization.  Note, the efi init code path is determined by the
@@ -1249,3 +1261,15 @@ void __init i386_reserve_resources(void)
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
