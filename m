Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 15 Dec 2016 08:17:28 -0800
Message-Id: <1481818648-36201-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH] Revert "Revert "kdump, vmcoreinfo: report memory sections virtual addresses""
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Xunlei Pang <xlpang@redhat.com>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This reverts commit 49fd897573c97b0eaf10f47d850027d78c456cd7.

Reverting back to commit 0549a3c because the values are used by crash
and other tools already. I expected this commit would not go through given
the unresolved comments. I want it to be easy to resolve major memory
section positions when KASLR memory randomization is enabled.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/kernel/machine_kexec_64.c | 3 +++
 include/linux/kexec.h              | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 2e3c34b..05f3367 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -339,6 +339,9 @@ void arch_crash_save_vmcoreinfo(void)
 			      kaslr_offset());
 	VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
 	VMCOREINFO_PHYS_BASE(phys_base);
+	VMCOREINFO_PAGE_OFFSET(PAGE_OFFSET);
+	VMCOREINFO_VMALLOC_START(VMALLOC_START);
+	VMCOREINFO_VMEMMAP_START(VMEMMAP_START);
 }
 
 /* arch-dependent functionality related to kexec file-based syscall */
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index e98e546..ff9c876 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -285,6 +285,12 @@ phys_addr_t paddr_vmcoreinfo_note(void);
 	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
 #define VMCOREINFO_PHYS_BASE(value) \
 	vmcoreinfo_append_str("PHYS_BASE=%lx\n", (unsigned long)value)
+#define VMCOREINFO_PAGE_OFFSET(value) \
+	vmcoreinfo_append_str("PAGE_OFFSET=%lx\n", (unsigned long)value)
+#define VMCOREINFO_VMALLOC_START(value) \
+	vmcoreinfo_append_str("VMALLOC_START=%lx\n", (unsigned long)value)
+#define VMCOREINFO_VMEMMAP_START(value) \
+	vmcoreinfo_append_str("VMEMMAP_START=%lx\n", (unsigned long)value)
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
-- 
2.8.0.rc3.226.g39d4020
