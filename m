From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:24 -0700
Message-Id: <20170718223333.110371-14-thgarnie@google.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC 13/22] x86/power/64: Adapt assembly for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/power/hibernate_asm_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index ce8da3a0412c..6fdd7bbc3c33 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -24,7 +24,7 @@
 #include <asm/frame.h>
 
 ENTRY(swsusp_arch_suspend)
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
 	movq	%rsi, pt_regs_si(%rax)
@@ -115,7 +115,7 @@ ENTRY(restore_registers)
 	movq	%rax, %cr4;  # turn PGE back on
 
 	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	pt_regs_sp(%rax), %rsp
 	movq	pt_regs_bp(%rax), %rbp
 	movq	pt_regs_si(%rax), %rsi
-- 
2.13.2.932.g7449e964c-goog
