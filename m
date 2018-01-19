From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Jan 2018 16:02:31 -0800
Message-ID: <151632015123.21271.9060883997507739532.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151632009605.21271.11304291057104672116.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v4 09/10] kvm, x86: fix spectre-v1 mitigation
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Honig <ahonig@google.com>, stable@vger.kernel.org, gregkh@linuxfoundation.org, Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de, alan@linux.intel.com, torvalds@linux-foundation.org, akpm@linux-foundation.org, Jim Mattson <jmattson@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Commit 75f139aaf896 "KVM: x86: Add memory barrier on vmcs field lookup"
added a raw 'asm("lfence");' to prevent a bounds check bypass of
'vmcs_field_to_offset_table'. This does not work for some AMD cpus, see
the 'ifence' helper, and it otherwise does not use the common
'array_ptr' helper designed for these types of fixes. Convert this to
use 'array_ptr'.

Cc: Andrew Honig <ahonig@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/kvm/vmx.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c829d89e2e63..20b9b0b5e336 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -34,6 +34,7 @@
 #include <linux/tboot.h>
 #include <linux/hrtimer.h>
 #include <linux/frame.h>
+#include <linux/nospec.h>
 #include "kvm_cache_regs.h"
 #include "x86.h"
 
@@ -898,21 +899,15 @@ static const unsigned short vmcs_field_to_offset_table[] = {
 
 static inline short vmcs_field_to_offset(unsigned long field)
 {
-	BUILD_BUG_ON(ARRAY_SIZE(vmcs_field_to_offset_table) > SHRT_MAX);
-
-	if (field >= ARRAY_SIZE(vmcs_field_to_offset_table))
-		return -ENOENT;
+	const unsigned short *offset;
 
-	/*
-	 * FIXME: Mitigation for CVE-2017-5753.  To be replaced with a
-	 * generic mechanism.
-	 */
-	asm("lfence");
+	BUILD_BUG_ON(ARRAY_SIZE(vmcs_field_to_offset_table) > SHRT_MAX);
 
-	if (vmcs_field_to_offset_table[field] == 0)
+	offset = array_ptr(vmcs_field_to_offset_table, field,
+			ARRAY_SIZE(vmcs_field_to_offset_table));
+	if (!offset || *offset == 0)
 		return -ENOENT;
-
-	return vmcs_field_to_offset_table[field];
+	return *offset;
 }
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
