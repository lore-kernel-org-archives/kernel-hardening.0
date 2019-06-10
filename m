From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 2/5] x86/vsyscall: Add a new vsyscall=xonly mode
Date: Mon, 10 Jun 2019 13:25:28 -0700
Message-Id: <131caabf9d127db1a077525f978e1f1f74f9088f.1560198181.git.luto@kernel.org>
In-Reply-To: <cover.1560198181.git.luto@kernel.org>
References: <cover.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

With vsyscall emulation on, we still expose a readable vsyscall page
that contains syscall instructions that validly implement the
vsyscalls.  We need this because certain dynamic binary
instrumentation tools attempt to read the call targets of call
instructions in the instrumented code.  If the instrumented code
uses vsyscalls, then the vsyscal page needs to contain readable
code.

Unfortunately, leaving readable memory at a deterministic address
can be used to help various ASLR bypasses, so we gain some hardening
value if we disallow vsyscall reads.

Given how rarely the vsyscall page needs to be readable, add a
mechanism to make the vsyscall page be execute only.

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |  7 ++++-
 arch/x86/Kconfig                              | 30 +++++++++++++------
 arch/x86/entry/vsyscall/vsyscall_64.c         | 19 +++++++++---
 3 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index e1a3525d07f2..d96a770e99f0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5084,7 +5084,12 @@
 			targets for exploits that can control RIP.
 
 			emulate     [default] Vsyscalls turn into traps and are
-			            emulated reasonably safely.
+			            emulated reasonably safely.  The vsyscall
+				    page is readable.
+
+			xonly       Vsyscalls turn into traps and are
+			            emulated reasonably safely.  The vsyscall
+				    page is not readable.
 
 			none        Vsyscalls don't work at all.  This makes
 			            them quite hard to use for exploits but
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 818b361094ed..054033cc4b1b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2288,23 +2288,35 @@ choice
 	  it can be used to assist security vulnerability exploitation.
 
 	  This setting can be changed at boot time via the kernel command
-	  line parameter vsyscall=[emulate|none].
+	  line parameter vsyscall=[emulate|xonly|none].
 
 	  On a system with recent enough glibc (2.14 or newer) and no
 	  static binaries, you can say None without a performance penalty
 	  to improve security.
 
-	  If unsure, select "Emulate".
+	  If unsure, select "Emulate execution only".
 
 	config LEGACY_VSYSCALL_EMULATE
-		bool "Emulate"
+		bool "Full emulation"
 		help
-		  The kernel traps and emulates calls into the fixed
-		  vsyscall address mapping. This makes the mapping
-		  non-executable, but it still contains known contents,
-		  which could be used in certain rare security vulnerability
-		  exploits. This configuration is recommended when userspace
-		  still uses the vsyscall area.
+		  The kernel traps and emulates calls into the fixed vsyscall
+		  address mapping. This makes the mapping non-executable, but
+		  it still contains readable known contents, which could be
+		  used in certain rare security vulnerability exploits. This
+		  configuration is recommended when legacy using userspace
+		  that still uses vsyscalls along with legacy binary
+		  instrumentation tools that require code to be readable.
+
+	config LEGACY_VSYSCALL_XONLY
+		bool "Emulate execution only"
+		help
+		  The kernel traps and emulates calls into the fixed vsyscall
+		  address mapping and does not allow reads.  This
+		  configuration is recommended when userspace might use the
+		  legacy vsyscall area but support for legacy binary
+		  instrumentation of legacy code is not needed.  It mitigates
+		  certain uses of the vsyscall area as an ASLR-bypassing
+		  buffer.
 
 	config LEGACY_VSYSCALL_NONE
 		bool "None"
diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index d9d81ad7a400..fd306ba4b4ad 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -42,9 +42,11 @@
 #define CREATE_TRACE_POINTS
 #include "vsyscall_trace.h"
 
-static enum { EMULATE, NONE } vsyscall_mode =
+static enum { EMULATE, XONLY, NONE } vsyscall_mode =
 #ifdef CONFIG_LEGACY_VSYSCALL_NONE
 	NONE;
+#elif defined(CONFIG_LEGACY_VSYSCALL_XONLY)
+	XONLY;
 #else
 	EMULATE;
 #endif
@@ -54,6 +56,8 @@ static int __init vsyscall_setup(char *str)
 	if (str) {
 		if (!strcmp("emulate", str))
 			vsyscall_mode = EMULATE;
+		else if (!strcmp("xonly", str))
+			vsyscall_mode = XONLY;
 		else if (!strcmp("none", str))
 			vsyscall_mode = NONE;
 		else
@@ -284,13 +288,20 @@ static const char *gate_vma_name(struct vm_area_struct *vma)
 static const struct vm_operations_struct gate_vma_ops = {
 	.name = gate_vma_name,
 };
-static struct vm_area_struct gate_vma = {
+static struct vm_area_struct rx_gate_vma = {
 	.vm_start	= VSYSCALL_ADDR,
 	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
 	.vm_page_prot	= PAGE_READONLY_EXEC,
 	.vm_flags	= VM_READ | VM_EXEC,
 	.vm_ops		= &gate_vma_ops,
 };
+static struct vm_area_struct xo_gate_vma = {
+	.vm_start	= VSYSCALL_ADDR,
+	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
+	.vm_page_prot	= PAGE_READONLY_EXEC,
+	.vm_flags	= VM_EXEC,
+	.vm_ops		= &gate_vma_ops,
+};
 
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
@@ -300,7 +311,7 @@ struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 #endif
 	if (vsyscall_mode == NONE)
 		return NULL;
-	return &gate_vma;
+	return vsyscall_mode == XONLY ? &xo_gate_vma : &rx_gate_vma;
 }
 
 int in_gate_area(struct mm_struct *mm, unsigned long addr)
@@ -357,7 +368,7 @@ void __init map_vsyscall(void)
 	extern char __vsyscall_page;
 	unsigned long physaddr_vsyscall = __pa_symbol(&__vsyscall_page);
 
-	if (vsyscall_mode != NONE) {
+	if (vsyscall_mode == EMULATE) {
 		__set_fixmap(VSYSCALL_PAGE, physaddr_vsyscall,
 			     PAGE_KERNEL_VVAR);
 		set_vsyscall_pgtable_user_bits(swapper_pg_dir);
-- 
2.21.0
