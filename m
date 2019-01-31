From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 13/27] x86/boot/64: Build head64.c as mcmodel large when PIE is enabled
Date: Thu, 31 Jan 2019 11:24:20 -0800
Message-Id: <20190131192533.34130-14-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Mimi Zohar <zohar@linux.ibm.com>, Juergen Gross <jgross@suse.com>, Nayna Jain <nayna@linux.ibm.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Thomas Garnier <thgarnie@google.com>, Jan Kiszka <jan.kiszka@siemens.com>, Nick Desaulniers <ndesaulniers@google.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The __startup_64 function assumes all symbols have relocated addresses
instead of the current boot virtual address. PIE generated code favor
relative addresses making all virtual and physical address math incorrect.
If PIE is enabled, build head64.c as mcmodel large instead to ensure absolute
references on all memory access. Add a global __force_order variable required
when using a large model with read_cr* functions.

To build head64.c as mcmodel=large, disable the retpoline gcc flags.
This code is used at early boot and removed later, it doesn't need
retpoline mitigation.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/kernel/Makefile | 6 ++++++
 arch/x86/kernel/head64.c | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 00b7e27bc2b7..1f98f52eab9f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -22,6 +22,12 @@ CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_head64.o = -pg
 endif
 
+ifdef CONFIG_X86_PIE
+# Remove PIE and retpoline flags that are incompatible with mcmodel=large
+CFLAGS_REMOVE_head64.o += -fPIE -mindirect-branch=thunk-extern -mindirect-branch-register
+CFLAGS_head64.o = -mcmodel=large
+endif
+
 KASAN_SANITIZE_head$(BITS).o				:= n
 KASAN_SANITIZE_dumpstack.o				:= n
 KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 16b1cbd3a61e..22e81275495b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -63,6 +63,9 @@ EXPORT_SYMBOL(vmemmap_base);
 
 #define __head	__section(.head.text)
 
+/* Required for read_cr3 when building as PIE */
+unsigned long __force_order;
+
 static void __head *fixup_pointer(void *ptr, unsigned long physaddr)
 {
 	return ptr - (void *)_text + (void *)physaddr;
-- 
2.20.1.495.gaa96b0ce6b-goog
