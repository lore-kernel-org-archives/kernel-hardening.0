From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:26 -0700
Message-Id: <20170718223333.110371-16-thgarnie@google.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC 15/22] x86/boot/64: Use _text in a global for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

By default PIE generated code create only relative references so _text
points to the temporary virtual address. Instead use a global variable
so the relocation is done as expected.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/kernel/head64.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 46c3c73e7f43..4103e90ff128 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -45,7 +45,13 @@ static void __head *fixup_pointer(void *ptr, unsigned long physaddr)
 	return ptr - (void *)_text + (void *)physaddr;
 }
 
-void __head __startup_64(unsigned long physaddr)
+/*
+ * Use a global variable to properly calculate _text delta on PIE. By default
+ * a PIE binary do a RIP relative difference instead of the relocated address.
+ */
+unsigned long _text_offset = (unsigned long)(_text - __START_KERNEL_map);
+
+void __head notrace __startup_64(unsigned long physaddr)
 {
 	unsigned long load_delta, *p;
 	pgdval_t *pgd;
@@ -62,7 +68,7 @@ void __head __startup_64(unsigned long physaddr)
 	 * Compute the delta between the address I am compiled to run at
 	 * and the address I am actually running at.
 	 */
-	load_delta = physaddr - (unsigned long)(_text - __START_KERNEL_map);
+	load_delta = physaddr - _text_offset;
 
 	/* Is the address not 2M aligned? */
 	if (load_delta & ~PMD_PAGE_MASK)
-- 
2.13.2.932.g7449e964c-goog
