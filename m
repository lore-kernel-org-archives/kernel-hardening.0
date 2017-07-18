From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:19 -0700
Message-Id: <20170718223333.110371-9-thgarnie@google.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC 08/22] x86/entry/64: Adapt assembly for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/entry/entry_64.S | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index a9a8027a6c0e..691c4755269b 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -195,12 +195,15 @@ entry_SYSCALL_64_fastpath:
 	ja	1f				/* return -ENOSYS (already in pt_regs->ax) */
 	movq	%r10, %rcx
 
+	/* Ensures the call is position independent */
+	leaq	sys_call_table(%rip), %r11
+
 	/*
 	 * This call instruction is handled specially in stub_ptregs_64.
 	 * It might end up jumping to the slow path.  If it jumps, RAX
 	 * and all argument registers are clobbered.
 	 */
-	call	*sys_call_table(, %rax, 8)
+	call	*(%r11, %rax, 8)
 .Lentry_SYSCALL_64_after_fastpath_call:
 
 	movq	%rax, RAX(%rsp)
@@ -333,7 +336,8 @@ ENTRY(stub_ptregs_64)
 	 * RAX stores a pointer to the C function implementing the syscall.
 	 * IRQs are on.
 	 */
-	cmpq	$.Lentry_SYSCALL_64_after_fastpath_call, (%rsp)
+	leaq	.Lentry_SYSCALL_64_after_fastpath_call(%rip), %r11
+	cmpq	%r11, (%rsp)
 	jne	1f
 
 	/*
@@ -1109,7 +1113,8 @@ ENTRY(error_entry)
 	movl	%ecx, %eax			/* zero extend */
 	cmpq	%rax, RIP+8(%rsp)
 	je	.Lbstep_iret
-	cmpq	$.Lgs_change, RIP+8(%rsp)
+	leaq	.Lgs_change(%rip), %rcx
+	cmpq	%rcx, RIP+8(%rsp)
 	jne	.Lerror_entry_done
 
 	/*
@@ -1324,10 +1329,10 @@ ENTRY(nmi)
 	 * resume the outer NMI.
 	 */
 
-	movq	$repeat_nmi, %rdx
+	leaq	repeat_nmi(%rip), %rdx
 	cmpq	8(%rsp), %rdx
 	ja	1f
-	movq	$end_repeat_nmi, %rdx
+	leaq	end_repeat_nmi(%rip), %rdx
 	cmpq	8(%rsp), %rdx
 	ja	nested_nmi_out
 1:
@@ -1381,7 +1386,8 @@ nested_nmi:
 	pushq	%rdx
 	pushfq
 	pushq	$__KERNEL_CS
-	pushq	$repeat_nmi
+	leaq	repeat_nmi(%rip), %rdx
+	pushq	%rdx
 
 	/* Put stack back */
 	addq	$(6*8), %rsp
@@ -1419,7 +1425,9 @@ first_nmi:
 	addq	$8, (%rsp)	/* Fix up RSP */
 	pushfq			/* RFLAGS */
 	pushq	$__KERNEL_CS	/* CS */
-	pushq	$1f		/* RIP */
+	pushq	%rax		/* Support Position Independent Code */
+	leaq	1f(%rip), %rax	/* RIP */
+	xchgq	%rax, (%rsp)	/* Restore RAX, put 1f */
 	INTERRUPT_RETURN	/* continues at repeat_nmi below */
 1:
 #endif
-- 
2.13.2.932.g7449e964c-goog
