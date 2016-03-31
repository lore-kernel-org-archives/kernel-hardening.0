Reply-To: kernel-hardening@lists.openwall.com
From: Matt Redfearn <matt.redfearn@imgtec.com>
Date: Thu, 31 Mar 2016 10:05:39 +0100
Message-ID: <1459415142-3412-9-git-send-email-matt.redfearn@imgtec.com>
In-Reply-To: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
References: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] [PATCH v2 08/11] MIPS: Add CONFIG_RELOCATABLE Kconfig option
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, kernel-hardening@lists.openwall.com, Matt
 Redfearn <matt.redfearn@imgtec.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Add option to KConfig to enable the kernel to relocate itself at
runtime.

Relocation is supported R2 and later of the MIPS architecture, 32bit
and 64bit. The platform is also required to provide support through
plat_get_fdt() added in a later patch.

Signed-off-by: Matt Redfearn <matt.redfearn@imgtec.com>
---

Changes in v2: None

 arch/mips/Kconfig | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 6f55e1a5d645..4bf1814e57a5 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -473,6 +473,7 @@ config MIPS_MALTA
 	select SYS_SUPPORTS_MULTITHREADING
 	select SYS_SUPPORTS_SMARTMIPS
 	select SYS_SUPPORTS_ZBOOT
+	select SYS_SUPPORTS_RELOCATABLE
 	select USE_OF
 	select ZONE_DMA32 if 64BIT
 	select BUILTIN_DTB
@@ -516,6 +517,7 @@ config MIPS_SEAD3
 	select SYS_SUPPORTS_SMARTMIPS
 	select SYS_SUPPORTS_MICROMIPS
 	select SYS_SUPPORTS_MIPS16
+	select SYS_SUPPORTS_RELOCATABLE
 	select USB_EHCI_BIG_ENDIAN_DESC
 	select USB_EHCI_BIG_ENDIAN_MMIO
 	select USE_OF
@@ -1156,6 +1158,13 @@ config ISA_DMA_API
 config HOLES_IN_ZONE
 	bool
 
+config SYS_SUPPORTS_RELOCATABLE
+	bool
+	help
+	 Selected if the platform supports relocating the kernel.
+	 The platform must provide plat_get_fdt() if it selects CONFIG_USE_OF
+	 to allow access to command line and entropy sources.
+
 #
 # Endianness selection.  Sufficiently obscure so many users don't know what to
 # answer,so we try hard to limit the available choices.  Also the use of a
@@ -2478,6 +2487,15 @@ config NUMA
 config SYS_SUPPORTS_NUMA
 	bool
 
+config RELOCATABLE
+	bool "Relocatable kernel"
+	depends on SYS_SUPPORTS_RELOCATABLE && (CPU_MIPS32_R2 || CPU_MIPS64_R2 || CPU_MIPS32_R6 || CPU_MIPS64_R6)
+	help
+	  This builds a kernel image that retains relocation information
+	  so it can be loaded someplace besides the default 1MB.
+	  The relocations make the kernel binary about 15% larger,
+	  but are discarded at runtime
+
 config RELOCATION_TABLE_SIZE
 	hex "Relocation table size"
 	depends on RELOCATABLE
-- 
2.5.0
