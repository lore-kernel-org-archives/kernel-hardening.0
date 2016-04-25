Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Mon, 25 Apr 2016 09:37:13 -0700
Message-Id: <1461602233-67310-5-git-send-email-thgarnie@google.com>
In-Reply-To: <1461602233-67310-1-git-send-email-thgarnie@google.com>
References: <1461602233-67310-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH 4/4] x86, boot: Memory hotplug support for KASLR memory randomization
To: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, gthelen@google.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Add a new option (CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING) to define
the padding used for the physical memory mapping section when KASLR
memory is enabled. It ensures there is enough virtual address space when
CONFIG_MEMORY_HOTPLUG is used. The default value is 10 terabytes. If
CONFIG_MEMORY_HOTPLUG is not used, no space is reserved increasing the
entropy available.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160422
---
 arch/x86/Kconfig    | 15 +++++++++++++++
 arch/x86/mm/kaslr.c | 14 ++++++++++++--
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7c786d4..cc01b69 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2018,6 +2018,21 @@ config RANDOMIZE_MEMORY
 
 	   If unsure, say N.
 
+config RANDOMIZE_MEMORY_PHYSICAL_PADDING
+	hex "Physical memory mapping padding" if EXPERT
+	depends on RANDOMIZE_MEMORY
+	default "0xa" if MEMORY_HOTPLUG
+	default "0x0"
+	range 0x1 0x40 if MEMORY_HOTPLUG
+	range 0x0 0x40
+	---help---
+	   Define the padding in terabyte added to the existing physical memory
+	   size during kernel memory randomization. It is useful for memory
+	   hotplug support but reduces the entropy available for address
+	   randomization.
+
+	   If unsure, leave at the default value.
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 3b330a9..ef3dc19 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -68,15 +68,25 @@ void __init kernel_randomize_memory(void)
 {
 	size_t i;
 	unsigned long addr = memory_rand_start;
-	unsigned long padding, rand, mem_tb;
+	unsigned long padding, rand, mem_tb, page_offset_padding;
 	struct rnd_state rnd_st;
 	unsigned long remain_padding = memory_rand_end - memory_rand_start;
 
 	if (!kaslr_enabled())
 		return;
 
+	/*
+	 * Update Physical memory mapping to available and
+	 * add padding if needed (especially for memory hotplug support).
+	 */
+	page_offset_padding = CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+	page_offset_padding = max(1UL, page_offset_padding);
+#endif
+
 	BUG_ON(kaslr_regions[0].base != &page_offset_base);
-	mem_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT);
+	mem_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT) + page_offset_padding;
 
 	if (mem_tb < kaslr_regions[0].size_tb)
 		kaslr_regions[0].size_tb = mem_tb;
-- 
2.8.0.rc3.226.g39d4020
