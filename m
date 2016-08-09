Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Tue,  9 Aug 2016 09:51:22 -0700
Message-Id: <1470761483-62501-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v3 1/2] x86/KASLR: Fix physical memory calculation on KASLR memory randomization
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Thomas Garnier <thgarnie@google.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Initialize KASLR memory randomization after max_pfn is initialized. Also
ensure the size is rounded up. Could have create problems on machines
with more than 1Tb of memory on certain random addresses.

Fixes: 021182e52fe0 ("Enable KASLR for physical mapping memory regions")
Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160805
---
 arch/x86/kernel/setup.c | 8 ++++++--
 arch/x86/mm/kaslr.c     | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index bcabb88..dc50644 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -936,8 +936,6 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
-	kernel_randomize_memory();
-
 	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	setup_memory_map();
 	parse_setup_data();
@@ -1055,6 +1053,12 @@ void __init setup_arch(char **cmdline_p)
 
 	max_possible_pfn = max_pfn;
 
+	/*
+	 * Define random base addresses for memory sections after max_pfn is
+	 * defined and before each memory section base is used.
+	 */
+	kernel_randomize_memory();
+
 #ifdef CONFIG_X86_32
 	/* max_low_pfn get updated here */
 	find_low_pfn_range();
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 26dccd6..ec8654f 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -97,7 +97,7 @@ void __init kernel_randomize_memory(void)
 	 * add padding if needed (especially for memory hotplug support).
 	 */
 	BUG_ON(kaslr_regions[0].base != &page_offset_base);
-	memory_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT) +
+	memory_tb = DIV_ROUND_UP(max_pfn << PAGE_SHIFT, 1UL << TB_SHIFT) +
 		CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
 
 	/* Adapt phyiscal memory region size based on available memory */
-- 
2.8.0.rc3.226.g39d4020
