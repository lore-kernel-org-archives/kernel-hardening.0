From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:30 -0700
Message-Id: <20170718223333.110371-20-thgarnie@google.com>
In-Reply-To: <20170718223333.110371-1-thgarnie@google.com>
References: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC 19/22] x86/pie: Add option to build the kernel as PIE for x86_64
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Add the CONFIG_X86_PIE option which builds the kernel as a Position
Independent Executable (PIE). The kernel is currently build with the
mcmodel=kernel option which forces it to stay on the top 2G of the
virtual address space. With PIE, the kernel will be able to move below
the -2G limit increasing the KASLR range from 1GB to 3GB.

The modules do not support PIE due to how they are linked. Disable PIE
for them and default to mcmodel=kernel for now.

The PIE configuration is not yet compatible with XEN_PVH. Xen PVH
generates 32-bit assembly and uses a long jump to transition to 64-bit.
A long jump require an absolute reference that is not compatible with
PIE.

Performance/Size impact:

Hackbench (50% and 1600% loads):
 - PIE disabled: no significant change (-0.50% / +0.50%)
 - PIE enabled: 7% to 8% on half load, 10% on heavy load.

These results are aligned with the different research on user-mode PIE
impact on cpu intensive benchmarks (around 10% on x86_64).

slab_test (average of 10 runs):
 - PIE disabled: no significant change (-1% / +1%)
 - PIE enabled: 3% to 4%

Kernbench (average of 10 Half and Optimal runs):
 Elapsed Time:
 - PIE disabled: no significant change (-0.22% / +0.06%)
 - PIE enabled: around 0.50%
 System Time:
 - PIE disabled: no significant change (-0.99% / -1.28%)
 - PIE enabled: 5% to 6%

Size of vmlinux (Ubuntu configuration):
 File size:
 - PIE disabled: 472928672 bytes (-0.000169% from baseline)
 - PIE enabled: 216878461 bytes (-54.14% from baseline)
 .text sections:
 - PIE disabled: 9373572 bytes (+0.04% from baseline)
 - PIE enabled: 9499138 bytes (+1.38% from baseline)

The big decrease in vmlinux file size is due to the lower number of
relocations appended to the file.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/Kconfig  | 6 ++++++
 arch/x86/Makefile | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 781521b7cf9e..b26ee6751021 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2080,6 +2080,12 @@ config RANDOMIZE_MEMORY_PHYSICAL_PADDING
 
 	   If unsure, leave at the default value.
 
+config X86_PIE
+	bool
+	depends on X86_64 && !XEN_PVH
+	select DEFAULT_HIDDEN
+	select MODULE_REL_CRCS if MODVERSIONS
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1e902f926be3..452a9621af8f 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -45,8 +45,12 @@ export REALMODE_CFLAGS
 export BITS
 
 ifdef CONFIG_X86_NEED_RELOCS
+ifdef CONFIG_X86_PIE
+        LDFLAGS_vmlinux := -pie -shared -Bsymbolic
+else
         LDFLAGS_vmlinux := --emit-relocs
 endif
+endif
 
 #
 # Prevent GCC from generating any FP code by mistake.
@@ -132,7 +136,12 @@ else
         KBUILD_CFLAGS += $(cflags-y)
 
         KBUILD_CFLAGS += -mno-red-zone
+ifdef CONFIG_X86_PIE
+        KBUILD_CFLAGS += -fPIC
+        KBUILD_CFLAGS_MODULE += -fno-PIC -mcmodel=kernel
+else
         KBUILD_CFLAGS += -mcmodel=kernel
+endif
 
         # -funit-at-a-time shrinks the kernel .text considerably
         # unfortunately it makes reading oopses harder.
-- 
2.13.2.932.g7449e964c-goog
