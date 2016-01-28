Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Jan 2016 17:09:06 -0700
From: David Brown <david.brown@linaro.org>
Message-ID: <20160128000906.GA42530@davidb.org>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
 <1453226922-16831-4-git-send-email-keescook@chromium.org>
 <20160127211105.GA41450@davidb.org>
 <CAGXu5j+DLRoVE88a9++jVfEkN90HDiAaDAMnT2TrKqtMZ_yOww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5j+DLRoVE88a9++jVfEkN90HDiAaDAMnT2TrKqtMZ_yOww@mail.gmail.com>
Subject: [kernel-hardening] [PATCH] arm64: make CONFIG_DEBUG_RODATA non-optional
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, yalin wang <yalin.wang2010@gmail.com>, Zi Shen Lim <zlim.lnx@gmail.com>, Yang Shi <yang.shi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <lauraa@codeaurora.org>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Steve Capper <steve.capper@linaro.org>, Jeremy Linton <jeremy.linton@arm.com>, Mark Salter <msalter@redhat.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

>From 2efef8aa0f8f7f6277ffebe4ea6744fc93d54644 Mon Sep 17 00:00:00 2001
From: David Brown <david.brown@linaro.org>
Date: Wed, 27 Jan 2016 13:58:44 -0800

This removes the CONFIG_DEBUG_RODATA option and makes it always
enabled.

Signed-off-by: David Brown <david.brown@linaro.org>
---
v1: This is in the same spirit as the x86 patch, removing allowing
this option to be config selected.  The associated patch series adds a
runtime option for the same thing.  However, it does affect the way
some things are mapped, and could possibly result in either increased
memory usage, or a performance hit (due to TLB misses from 4K pages).

I've tested this on a Hikey 96board (hi6220-hikey.dtb), both with and
without 'rodata=off' on the command line.

 arch/arm64/Kconfig              |  3 +++
 arch/arm64/Kconfig.debug        | 10 ----------
 arch/arm64/kernel/insn.c        |  2 +-
 arch/arm64/kernel/vmlinux.lds.S |  5 +----
 arch/arm64/mm/mmu.c             | 12 ------------
 5 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8cc6228..ffa617a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -201,6 +201,9 @@ config KERNEL_MODE_NEON
 config FIX_EARLYCON_MEM
 	def_bool y
 
+config DEBUG_RODATA
+	def_bool y
+
 config PGTABLE_LEVELS
 	int
 	default 2 if ARM64_16K_PAGES && ARM64_VA_BITS_36
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index e13c4bf..db994ec 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -48,16 +48,6 @@ config DEBUG_SET_MODULE_RONX
           against certain classes of kernel exploits.
           If in doubt, say "N".
 
-config DEBUG_RODATA
-	bool "Make kernel text and rodata read-only"
-	help
-	  If this is set, kernel text and rodata will be made read-only. This
-	  is to help catch accidental or malicious attempts to change the
-	  kernel's executable code. Additionally splits rodata from kernel
-	  text so it can be made explicitly non-executable.
-
-          If in doubt, say Y
-
 config DEBUG_ALIGN_RODATA
 	depends on DEBUG_RODATA && ARM64_4K_PAGES
 	bool "Align linker sections up to SECTION_SIZE"
diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
index 7371455..a04bdef 100644
--- a/arch/arm64/kernel/insn.c
+++ b/arch/arm64/kernel/insn.c
@@ -95,7 +95,7 @@ static void __kprobes *patch_map(void *addr, int fixmap)
 
 	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
 		page = vmalloc_to_page(addr);
-	else if (!module && IS_ENABLED(CONFIG_DEBUG_RODATA))
+	else if (!module)
 		page = virt_to_page(addr);
 	else
 		return addr;
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e3928f5..f80903c 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -65,12 +65,9 @@ PECOFF_FILE_ALIGNMENT = 0x200;
 #if defined(CONFIG_DEBUG_ALIGN_RODATA)
 #define ALIGN_DEBUG_RO			. = ALIGN(1<<SECTION_SHIFT);
 #define ALIGN_DEBUG_RO_MIN(min)		ALIGN_DEBUG_RO
-#elif defined(CONFIG_DEBUG_RODATA)
+#else
 #define ALIGN_DEBUG_RO			. = ALIGN(1<<PAGE_SHIFT);
 #define ALIGN_DEBUG_RO_MIN(min)		ALIGN_DEBUG_RO
-#else
-#define ALIGN_DEBUG_RO
-#define ALIGN_DEBUG_RO_MIN(min)		. = ALIGN(min);
 #endif
 
 SECTIONS
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 58faeaa..3b411b7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -313,7 +313,6 @@ static void create_mapping_late(phys_addr_t phys, unsigned long virt,
 				phys, virt, size, prot, late_alloc);
 }
 
-#ifdef CONFIG_DEBUG_RODATA
 static void __init __map_memblock(phys_addr_t start, phys_addr_t end)
 {
 	/*
@@ -347,13 +346,6 @@ static void __init __map_memblock(phys_addr_t start, phys_addr_t end)
 	}
 
 }
-#else
-static void __init __map_memblock(phys_addr_t start, phys_addr_t end)
-{
-	create_mapping(start, __phys_to_virt(start), end - start,
-			PAGE_KERNEL_EXEC);
-}
-#endif
 
 static void __init map_mem(void)
 {
@@ -410,7 +402,6 @@ static void __init map_mem(void)
 
 static void __init fixup_executable(void)
 {
-#ifdef CONFIG_DEBUG_RODATA
 	/* now that we are actually fully mapped, make the start/end more fine grained */
 	if (!IS_ALIGNED((unsigned long)_stext, SWAPPER_BLOCK_SIZE)) {
 		unsigned long aligned_start = round_down(__pa(_stext),
@@ -428,10 +419,8 @@ static void __init fixup_executable(void)
 				aligned_end - __pa(__init_end),
 				PAGE_KERNEL);
 	}
-#endif
 }
 
-#ifdef CONFIG_DEBUG_RODATA
 void mark_rodata_ro(void)
 {
 	create_mapping_late(__pa(_stext), (unsigned long)_stext,
@@ -439,7 +428,6 @@ void mark_rodata_ro(void)
 				PAGE_KERNEL_ROX);
 
 }
-#endif
 
 void fixup_init(void)
 {
-- 
2.7.0
