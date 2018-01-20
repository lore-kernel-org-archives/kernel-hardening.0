From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 20 Jan 2018 13:06:46 -0800
Message-ID: <151648240659.34747.15384224757929711746.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v4.1 09/10] kvm, x86: update spectre-v1 mitigation
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Honig <ahonig@google.com>, gregkh@linuxfoundation.org, Paolo Bonzini <pbonzini@redhat.com>, alan@linux.intel.com, torvalds@linux-foundation.org, Jim Mattson <jmattson@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

Commit 75f139aaf896 "KVM: x86: Add memory barrier on vmcs field lookup"
added a raw 'asm("lfence");' to prevent a bounds check bypass of
'vmcs_field_to_offset_table'. We can save an lfence in this path and
just use the common 'array_ptr' helper designed for these types of
fixes.

Cc: Andrew Honig <ahonig@google.com>
Cc: Jim Mattson <jmattson@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/kvm/vmx.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index d1e25dba3112..62af077cd975 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -34,6 +34,7 @@
 #include <linux/tboot.h>
 #include <linux/hrtimer.h>
 #include <linux/frame.h>
+#include <linux/nospec.h>
 #include "kvm_cache_regs.h"
 #include "x86.h"
 
@@ -883,13 +884,15 @@ static const unsigned short vmcs_field_to_offset_table[] = {
 
 static inline short vmcs_field_to_offset(unsigned long field)
 {
+	const unsigned short *offset;
+
 	BUILD_BUG_ON(ARRAY_SIZE(vmcs_field_to_offset_table) > SHRT_MAX);
 
-	if (field >= ARRAY_SIZE(vmcs_field_to_offset_table) ||
-	    vmcs_field_to_offset_table[field] == 0)
+	offset = array_ptr(vmcs_field_to_offset_table, field,
+			ARRAY_SIZE(vmcs_field_to_offset_table));
+	if (!offset || *offset == 0)
 		return -ENOENT;
-
-	return vmcs_field_to_offset_table[field];
+	return *offset;
 }
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
