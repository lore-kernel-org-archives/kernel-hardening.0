From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jan 2018 23:56:07 -0800
Message-ID: <151703976714.26578.17488222459772354305.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 10/12] kvm, x86: update spectre-v1 mitigation
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Honig <ahonig@google.com>, gregkh@linuxfoundation.org, Paolo Bonzini <pbonzini@redhat.com>, alan@linux.intel.com, torvalds@linux-foundation.org, Jim Mattson <jmattson@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Commit 75f139aaf896 "KVM: x86: Add memory barrier on vmcs field lookup"
added a raw 'asm("lfence");' to prevent a bounds check bypass of
'vmcs_field_to_offset_table'. We can save an lfence in this path and
just use the common 'array_idx' helper designed for these types of
fixes.

Cc: Andrew Honig <ahonig@google.com>
Cc: Jim Mattson <jmattson@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/kvm/vmx.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 924589c53422..5345e68cc506 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -34,6 +34,7 @@
 #include <linux/tboot.h>
 #include <linux/hrtimer.h>
 #include <linux/frame.h>
+#include <linux/nospec.h>
 #include "kvm_cache_regs.h"
 #include "x86.h"
 
@@ -883,13 +884,18 @@ static const unsigned short vmcs_field_to_offset_table[] = {
 
 static inline short vmcs_field_to_offset(unsigned long field)
 {
-	BUILD_BUG_ON(ARRAY_SIZE(vmcs_field_to_offset_table) > SHRT_MAX);
+	const size_t sz = ARRAY_SIZE(vmcs_field_to_offset_table);
+	unsigned short offset;
 
-	if (field >= ARRAY_SIZE(vmcs_field_to_offset_table) ||
-	    vmcs_field_to_offset_table[field] == 0)
+	BUILD_BUG_ON(sz > SHRT_MAX);
+	if (field >= sz)
 		return -ENOENT;
 
-	return vmcs_field_to_offset_table[field];
+	field = array_idx(field, sz);
+	offset = vmcs_field_to_offset_table[field];
+	if (offset == 0)
+		return -ENOENT;
+	return offset;
 }
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
