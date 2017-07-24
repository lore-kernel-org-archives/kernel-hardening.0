Sender: Hans Liljestrand <ishkamiel@gmail.com>
From: Hans Liljestrand <liljestrandh@gmail.com>
Date: Mon, 24 Jul 2017 16:38:20 +0300
Message-Id: <20170724133824.27223-2-LiljestrandH@gmail.com>
In-Reply-To: <20170724133824.27223-1-LiljestrandH@gmail.com>
References: <20170724133824.27223-1-LiljestrandH@gmail.com>
Subject: [kernel-hardening] [RFC PATCH 1/5] x86: add CONFIG_X86_INTEL_MPX_KERNEL to Kconfig
To: kernel-hardening@lists.openwall.com
Cc: elena.reshetova@intel.com, dave.hansen@intel.com, keescook@chromium.org, hpa@zytor.com, Hans Liljestrand <LiljestrandH@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Add CONFIG_X86_INTEL_MPX_KERNEL for future kernel-space support for
Intel MPX. Currently depends on CPU_SUP_INTEL.

Signed-off-by: Hans Liljestrand <LiljestrandH@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/Kconfig | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0efb4c9497bc..b740a8604705 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1771,6 +1771,25 @@ config X86_INTEL_MPX
 
 	  If unsure, say N.
 
+config X86_INTEL_MPX_KERNEL
+	prompt "Intel MPX for kernel"
+	def_bool n
+	depends on CPU_SUP_INTEL
+	select CONSTRUCTORS
+	select GCC_PLUGINS
+	---help---
+	  MPX provides hardware features that can be used in
+	  conjunction with compiler-instrumented code to check
+	  memory references.  It is designed to detect buffer
+	  overflow or underflow bugs.
+
+	  This option enables MPXK, which is a slightly modified
+	  MPX instrumentation for in-kernel code.  This
+	  protection is modular and even when enabled covers
+	  only code that explicitly use this feature.
+
+	  If unsure, say N
+
 config X86_INTEL_MEMORY_PROTECTION_KEYS
 	prompt "Intel Memory Protection Keys"
 	def_bool y
-- 
2.11.0
