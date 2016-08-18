Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 18 Aug 2016 07:47:12 -0700
Message-Id: <1471531632-23003-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v1] kdump, vmcoreinfo: report memory sections virtual addresses
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Xunlei Pang <xlpang@redhat.com>, Thomas Garnier <thgarnie@google.com>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, keescook@chromium.org, kernel-hardening@lists.openwall.com, surovegin@google.com
List-ID: <kernel-hardening.lists.openwall.com>

KASLR memory randomization can randomize the base of the physical memory
mapping (PAGE_OFFSET), vmalloc (VMALLOC_START) and vmemmap
(VMEMMAP_START). Adding these variables on VMCOREINFO so tools can
easily identify the base of each memory section.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160817
---
 arch/x86/kernel/machine_kexec_64.c | 3 +++
 include/linux/kexec.h              | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index fc3389f..b1f15a2 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -338,6 +338,9 @@ void arch_crash_save_vmcoreinfo(void)
 	vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
 			      kaslr_offset());
 	VMCOREINFO_PHYS_BASE(phys_base);
+	VMCOREINFO_PAGE_OFFSET(PAGE_OFFSET);
+	VMCOREINFO_VMALLOC_START(VMALLOC_START);
+	VMCOREINFO_VMEMMAP_START(VMEMMAP_START);
 }
 
 /* arch-dependent functionality related to kexec file-based syscall */
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d3ae429..cd3874c 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -261,6 +261,12 @@ phys_addr_t paddr_vmcoreinfo_note(void);
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
