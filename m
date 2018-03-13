From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 25/27] x86/pie: Add option to build the kernel as PIE
Date: Tue, 13 Mar 2018 13:59:43 -0700
Message-Id: <20180313205945.245105-26-thgarnie@google.com>
In-Reply-To: <20180313205945.245105-1-thgarnie@google.com>
References: <20180313205945.245105-1-thgarnie@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Philippe Ombredanne <pombredanne@nexb.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Ashish Kalra <ashish@bluestacks.com>, Kyle McMartin <kyle@redhat.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Lukas Wunner <lukas@wunner.de>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Jiri Slaby <jslaby@suse.cz>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
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

Signed-off-by: Thomas Garnier <thgarnie@google.com>

merge pie
---
 arch/x86/Kconfig  |  8 ++++++++
 arch/x86/Makefile | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index df4134fd3247..4b1615e661d6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2252,6 +2252,14 @@ config X86_GLOBAL_STACKPROTECTOR
 
 	   If unsure, say N
 
+config X86_PIE
+	bool
+	depends on X86_64
+	select DEFAULT_HIDDEN
+	select WEAK_PROVIDE_HIDDEN
+	select DYNAMIC_MODULE_BASE
+	select MODULE_REL_CRCS if MODVERSIONS
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index f24d200c0d9d..ab0cf88c7059 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -61,6 +61,8 @@ endif
 KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
 KBUILD_CFLAGS += $(call cc-option,-mno-avx,)
 
+stackglobal := $(call cc-option-yn, -mstack-protector-guard=global)
+
 ifeq ($(CONFIG_X86_32),y)
         BITS := 32
         UTS_MACHINE := i386
@@ -136,7 +138,48 @@ else
 
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
@@ -147,7 +190,7 @@ endif
 endif
 
 ifdef CONFIG_X86_GLOBAL_STACKPROTECTOR
-        ifeq ($(call cc-option, -mstack-protector-guard=global),)
+        ifeq ($(stackglobal), n)
                 $(error Cannot use CONFIG_X86_GLOBAL_STACKPROTECTOR: \
                         -mstack-protector-guard=global not supported \
                         by compiler)
-- 
2.16.2.660.g709887971b-goog
