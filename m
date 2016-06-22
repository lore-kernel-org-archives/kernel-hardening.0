Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Jun 2016 17:47:06 -0700
Message-Id: <1466556426-32664-10-git-send-email-keescook@chromium.org>
In-Reply-To: <1466556426-32664-1-git-send-email-keescook@chromium.org>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v7 9/9] x86/mm: Memory hotplug support for KASLR memory randomization (x86_64)
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, x86@kernel.org, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Add a new option (CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING) to define
the padding used for the physical memory mapping section when KASLR
memory is enabled. It ensures there is enough virtual address space when
CONFIG_MEMORY_HOTPLUG is used. The default value is 10 terabytes. If
CONFIG_MEMORY_HOTPLUG is not used, no space is reserved increasing the
entropy available.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig    | 15 +++++++++++++++
 arch/x86/mm/kaslr.c |  7 ++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index adab3fef3bb4..214b3fadbc11 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2010,6 +2010,21 @@ config RANDOMIZE_MEMORY
 
 	   If unsure, say N.
 
+config RANDOMIZE_MEMORY_PHYSICAL_PADDING
+	hex "Physical memory mapping padding" if EXPERT
+	depends on RANDOMIZE_MEMORY
+	default "0xa" if MEMORY_HOTPLUG
+	default "0x0"
+	range 0x1 0x40 if MEMORY_HOTPLUG
+	range 0x0 0x40
+	---help---
+	   Define the padding in terabytes added to the existing physical
+	   memory size during kernel memory randomization. It is useful
+	   for memory hotplug support but reduces the entropy available for
+	   address randomization.
+
+	   If unsure, leave at the default value.
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 4f91dc273062..3e9875f7fdda 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -114,8 +114,13 @@ void __init kernel_randomize_memory(void)
 	if (!kaslr_memory_enabled())
 		return;
 
+	/*
+	 * Update Physical memory mapping to available and
+	 * add padding if needed (especially for memory hotplug support).
+	 */
 	BUG_ON(kaslr_regions[0].base != &page_offset_base);
-	memory_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT);
+	memory_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT) +
+		CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
 
 	/* Adapt phyiscal memory region size based on available memory */
 	if (memory_tb < kaslr_regions[0].size_tb)
-- 
2.7.4
