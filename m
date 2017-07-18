From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:16 -0700
Message-Id: <20170718223333.110371-6-thgarnie@google.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC 05/22] xen: Adapt assembly for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use the new _ASM_GET_PTR macro which get a
symbol reference while being PIE compatible. Modify the RELOC macro that
was using an assignment generating a non-relative reference.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/xen/xen-asm.h  | 3 ++-
 arch/x86/xen/xen-head.S | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/xen-asm.h b/arch/x86/xen/xen-asm.h
index 465276467a47..3b1c8a2e77d8 100644
--- a/arch/x86/xen/xen-asm.h
+++ b/arch/x86/xen/xen-asm.h
@@ -2,8 +2,9 @@
 #define _XEN_XEN_ASM_H
 
 #include <linux/linkage.h>
+#include <asm/asm.h>
 
-#define RELOC(x, v)	.globl x##_reloc; x##_reloc=v
+#define RELOC(x, v)	.globl x##_reloc; x##_reloc: _ASM_PTR v
 #define ENDPATCH(x)	.globl x##_end; x##_end=.
 
 /* Pseudo-flag used for virtual NMI, which we don't implement yet */
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 72a8e6adebe6..ab2462396bd8 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -23,14 +23,15 @@ ENTRY(startup_xen)
 
 	/* Clear .bss */
 	xor %eax,%eax
-	mov $__bss_start, %_ASM_DI
-	mov $__bss_stop, %_ASM_CX
+	_ASM_GET_PTR(__bss_start, %_ASM_DI)
+	_ASM_GET_PTR(__bss_stop, %_ASM_CX)
 	sub %_ASM_DI, %_ASM_CX
 	shr $__ASM_SEL(2, 3), %_ASM_CX
 	rep __ASM_SIZE(stos)
 
-	mov %_ASM_SI, xen_start_info
-	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
+	_ASM_GET_PTR(xen_start_info, %_ASM_AX)
+	mov %_ASM_SI, (%_ASM_AX)
+	_ASM_GET_PTR(init_thread_union+THREAD_SIZE, %_ASM_SP)
 
 	jmp xen_start_kernel
 
-- 
2.13.2.932.g7449e964c-goog
