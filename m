From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:23 -0700
Message-Id: <20170718223333.110371-13-thgarnie@google.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC 12/22] x86/boot/64: Adapt assembly for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Early at boot, the kernel is mapped at a temporary address while preparing
the page table. To know the changes needed for the page table with KASLR,
the boot code calculate the difference between the expected address of the
kernel and the one chosen by KASLR. It does not work with PIE because all
symbols in code are relatives. Instead of getting the future relocated
virtual address, you will get the current temporary mapping. The solution
is using global variables that will be relocated as expected.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/kernel/head_64.S | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 6225550883df..7e4f7a83a15a 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -78,8 +78,23 @@ startup_64:
 	call	__startup_64
 	popq	%rsi
 
-	movq	$(early_top_pgt - __START_KERNEL_map), %rax
+	movq    _early_top_pgt_offset(%rip), %rax
 	jmp 1f
+
+	/*
+	 * Position Independent Code takes only relative references in code
+	 * meaning a global variable address is relative to RIP and not its
+	 * future virtual address. Global variables can be used instead as they
+	 * are still relocated on the expected kernel mapping address.
+	 */
+	.align 8
+_early_top_pgt_offset:
+	.quad early_top_pgt - __START_KERNEL_map
+_init_top_offset:
+	.quad init_top_pgt - __START_KERNEL_map
+_va_jump:
+	.quad 2f
+
 ENTRY(secondary_startup_64)
 	/*
 	 * At this point the CPU runs in 64bit mode CS.L = 1 CS.D = 0,
@@ -98,7 +113,8 @@ ENTRY(secondary_startup_64)
 	/* Sanitize CPU configuration */
 	call verify_cpu
 
-	movq	$(init_top_pgt - __START_KERNEL_map), %rax
+	movq    _init_top_offset(%rip), %rax
+
 1:
 
 	/* Enable PAE mode, PGE and LA57 */
@@ -113,9 +129,8 @@ ENTRY(secondary_startup_64)
 	movq	%rax, %cr3
 
 	/* Ensure I am executing from virtual addresses */
-	movq	$1f, %rax
-	jmp	*%rax
-1:
+	jmp	*_va_jump(%rip)
+2:
 
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
@@ -211,11 +226,12 @@ ENTRY(secondary_startup_64)
 	 *	REX.W + FF /5 JMP m16:64 Jump far, absolute indirect,
 	 *		address given in m16:64.
 	 */
-	pushq	$.Lafter_lret	# put return address on stack for unwinder
+	leaq	.Lafter_lret(%rip), %rax
+	pushq	%rax		# put return address on stack for unwinder
 	xorq	%rbp, %rbp	# clear frame pointer
-	movq	initial_code(%rip), %rax
+	leaq	initial_code(%rip), %rax
 	pushq	$__KERNEL_CS	# set correct cs
-	pushq	%rax		# target address in negative space
+	pushq	(%rax)		# target address in negative space
 	lretq
 .Lafter_lret:
 ENDPROC(secondary_startup_64)
-- 
2.13.2.932.g7449e964c-goog
