Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 12 May 2016 12:28:20 -0700
Message-Id: <1463081300-11127-5-git-send-email-thgarnie@google.com>
In-Reply-To: <1463081300-11127-1-git-send-email-thgarnie@google.com>
References: <1463081300-11127-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v5 4/4] x86, boot: Memory hotplug support for KASLR memory randomization
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
Based on next-20160511
---
 arch/x86/Kconfig    | 15 +++++++++++++++
 arch/x86/mm/kaslr.c |  7 ++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f5ed150..0e5087d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2005,6 +2005,21 @@ config RANDOMIZE_MEMORY
 
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
index 2415178..5e86082 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -88,8 +88,13 @@ void __init kernel_randomize_memory(void)
 	if (!kaslr_enabled())
 		return;
 
+	/*
+	 * Update Physical memory mapping to available and
+	 * add padding if needed (especially for memory hotplug support).
+	 */
 	BUG_ON(kaslr_regions[0].base != &page_offset_base);
-	mem_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT);
+	mem_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT) +
+		CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
 
 	if (mem_tb < kaslr_regions[0].size_tb)
 		kaslr_regions[0].size_tb = mem_tb;
-- 
2.8.0.rc3.226.g39d4020
