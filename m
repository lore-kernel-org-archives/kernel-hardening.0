From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 25/27] x86/pie: Add option to build the kernel as PIE
Date: Thu, 31 Jan 2019 11:24:32 -0800
Message-Id: <20190131192533.34130-26-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Add the CONFIG_X86_PIE option which builds the kernel as a Position
Independent Executable (PIE). The kernel is currently build with the
mcmodel=kernel option which forces it to stay on the top 2G of the
virtual address space. With PIE, the kernel will be able to move below
the current limit.

The --emit-relocs linker option was kept instead of using -pie to limit
the impact on mapped sections. Any incompatible relocation will be
catch by the arch/x86/tools/relocs binary at compile time.

If segment based stack cookies are enabled, try to use the compiler
option to select the segment register. If not available, automatically
enabled global stack cookie in auto mode. Otherwise, recommend
compiler update or global stack cookie option.

Performance/Size impact:

Size of vmlinux (Default configuration):
 File size:
 - PIE disabled: +0.18%
 - PIE enabled: -1.977% (less relocations)
 .text section:
 - PIE disabled: same
 - PIE enabled: same

Size of vmlinux (Ubuntu configuration):
 File size:
 - PIE disabled: +0.21%
 - PIE enabled: +10%
 .text section:
 - PIE disabled: same
 - PIE enabled: +0.001%

The size increase is mainly due to not having access to the 32-bit signed
relocation that can be used with mcmodel=kernel. A small part is due to reduced
optimization for PIE code. This bug [1] was opened with gcc to provide a better
code generation for kernel PIE.

Hackbench (50% and 1600% on thread/process for pipe/sockets):
 - PIE disabled: no significant change (avg -/+ 0.5% on latest test).
 - PIE enabled: between -1% to +1% in average (default and Ubuntu config).

Kernbench (average of 10 Half and Optimal runs):
 Elapsed Time:
 - PIE disabled: no significant change (avg -0.5%)
 - PIE enabled: average -0.5% to +0.5%
 System Time:
 - PIE disabled: no significant change (avg -0.1%)
 - PIE enabled: average -0.4% to +0.4%.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82303

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/Kconfig  |  8 ++++++++
 arch/x86/Makefile | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c3ad1b0ae1a1..e4316b8ed130 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2237,6 +2237,14 @@ config X86_GLOBAL_STACKPROTECTOR
 
 	   If unsure, say N
 
+config X86_PIE
+	bool
+	depends on X86_64
+	select DEFAULT_HIDDEN_SYMS
+	select WEAK_PROVIDE_HIDDEN
+	select DYNAMIC_MODULE_BASE
+	select MODULE_REL_CRCS if MODVERSIONS
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 5e9c1b02cf87..f72f78510059 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -60,6 +60,8 @@ endif
 KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
 KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
+stackglobal := $(call cc-option-yn, -mstack-protector-guard=global)
+
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
@@ -130,14 +132,55 @@ else
 
         KBUILD_CFLAGS += -mno-red-zone
 ifdef CONFIG_X86_PIE
+        KBUILD_CFLAGS += -fPIE
         KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/x86/kernel/module.lds
+
+        # Relax relocation in both CFLAGS and LDFLAGS to support older compilers
+        KBUILD_CFLAGS += $(call cc-option,-Wa$(comma)-mrelax-relocations=no)
+        LDFLAGS_vmlinux += $(call ld-option,--no-relax)
+        KBUILD_LDFLAGS_MODULE += $(call ld-option,--no-relax)
+
+        # Stack validation is not yet support due to self-referenced switches
+ifdef CONFIG_STACK_VALIDATION
+        $(warning CONFIG_STACK_VALIDATION is not yet supported for x86_64 pie \
+	        build.)
+        SKIP_STACK_VALIDATION := 1
+        export SKIP_STACK_VALIDATION
+endif
+
+ifndef CONFIG_CC_STACKPROTECTOR_NONE
+ifndef CONFIG_X86_GLOBAL_STACKPROTECTOR
+        stackseg-flag := -mstack-protector-guard-reg=%gs
+        ifeq ($(call cc-option-yn,$(stackseg-flag)),n)
+                # Try to enable global stack cookie if possible
+                ifeq ($(stackglobal), y)
+                        $(warning Cannot use CONFIG_CC_STACKPROTECTOR_* while \
+                                building a position independent kernel. \
+                                Default to global stack protector \
+                                (CONFIG_X86_GLOBAL_STACKPROTECTOR).)
+                        CONFIG_X86_GLOBAL_STACKPROTECTOR := y
+                        KBUILD_CFLAGS += -DCONFIG_X86_GLOBAL_STACKPROTECTOR
+                        KBUILD_AFLAGS += -DCONFIG_X86_GLOBAL_STACKPROTECTOR
+                else
+                        $(error echo Cannot use \
+                                CONFIG_CC_STACKPROTECTOR_(REGULAR|STRONG|AUTO) \
+                                while building a position independent binary. \
+                                Update your compiler or use \
+                                CONFIG_X86_GLOBAL_STACKPROTECTOR)
+                endif
+        else
+                KBUILD_CFLAGS += $(stackseg-flag)
+        endif
+endif
+endif
+
 else
         KBUILD_CFLAGS += -mcmodel=kernel
 endif
 endif
 
 ifdef CONFIG_X86_GLOBAL_STACKPROTECTOR
-        ifeq ($(call cc-option, -mstack-protector-guard=global),)
+        ifeq ($(stackglobal), n)
                 $(error Cannot use CONFIG_X86_GLOBAL_STACKPROTECTOR: \
                         -mstack-protector-guard=global not supported \
                         by compiler)
-- 
2.20.1.495.gaa96b0ce6b-goog
