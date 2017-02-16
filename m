From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 16 Feb 2017 13:54:38 -0800
Message-Id: <20170216215438.126111-4-thgarnie@google.com>
In-Reply-To: <20170216215438.126111-1-thgarnie@google.com>
References: <20170216215438.126111-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v4 4/4] KVM: VMX: Simplify segment_base
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, Thomas Garnier <thgarnie@google.com>, Kees Cook <keescook@chromium.org>, Lorenzo Stoakes <lstoakes@gmail.com>, Juergen Gross <jgross@suse.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rusty Russell <rusty@rustcorp.com.au>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The KVM segment_base function is confusing. This patch replaces integers
with appropriate flags, simplify constructs and add comments.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170213
---
 arch/x86/kvm/vmx.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 99167f20bc34..91e619269128 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2060,27 +2060,37 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
 static unsigned long segment_base(u16 selector)
 {
 	struct desc_struct *d;
-	unsigned long table_base;
+	struct desc_struct *table_base;
 	unsigned long v;
+	u32 high32;
 
-	if (!(selector & ~3))
+	if (!(selector & ~SEGMENT_RPL_MASK))
 		return 0;
 
-	table_base = get_current_gdt_rw_vaddr();
-
-	if (selector & 4) {           /* from ldt */
+	/* LDT selector */
+	if ((selector & SEGMENT_TI_MASK) == SEGMENT_LDT) {
 		u16 ldt_selector = kvm_read_ldt();
 
-		if (!(ldt_selector & ~3))
+		if (!(ldt_selector & ~SEGMENT_RPL_MASK))
 			return 0;
 
-		table_base = segment_base(ldt_selector);
+		table_base = (struct desc_struct *)segment_base(ldt_selector);
+	} else {
+		table_base = get_current_gdt_rw();
 	}
-	d = (struct desc_struct *)(table_base + (selector & ~7));
+
+	d = table_base + (selector >> 3);
 	v = get_desc_base(d);
 #ifdef CONFIG_X86_64
-       if (d->s == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
-               v |= ((unsigned long)((struct ldttss_desc64 *)d)->base3) << 32;
+	/*
+	 * Extend the virtual address if we have a system descriptor entry for
+	 * LDT or TSS (available or busy).
+	 */
+	if (d->s == 0 && (d->type == DESC_LDT || d->type == DESC_TSS ||
+			  d->type == 11/*Busy TSS */)) {
+		high32 = ((struct ldttss_desc64 *)d)->base3;
+		v |= (u64)high32 << 32;
+	}
 #endif
 	return v;
 }
-- 
2.11.0.483.g087da7b7c-goog
