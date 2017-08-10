From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 10 Aug 2017 10:26:12 -0700
Message-Id: <20170810172615.51965-21-thgarnie@google.com>
In-Reply-To: <20170810172615.51965-1-thgarnie@google.com>
References: <20170810172615.51965-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v2 20/23] x86/pie: Add option to build the kernel as PIE for x86_64
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Garnier <thgarnie@google.com>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Christopher Li <sparse@chrisli.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Markus Trippelsdorf <markus@trippelsdorf.de>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Peter Foley <pefoley2@pefoley.com>, Tim Chen <tim.c.chen@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Michal Hocko <mhocko@suse.com>, Matthew Wilcox <mawilcox@microsoft.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
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
 arch/x86/Kconfig  | 7 +++++++
 arch/x86/Makefile | 9 +++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2632fa8e8945..a419f4110872 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2132,6 +2132,13 @@ config X86_GLOBAL_STACKPROTECTOR
 	bool
 	depends on CC_STACKPROTECTOR
 
+config X86_PIE
+	bool
+	depends on X86_64 && !XEN_PVH
+	select DEFAULT_HIDDEN
+	select MODULE_REL_CRCS if MODVERSIONS
+	select X86_GLOBAL_STACKPROTECTOR if CC_STACKPROTECTOR
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 66af2704f096..05e01588b5af 100644
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
@@ -141,7 +145,12 @@ else
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
2.14.0.434.g98096fd7a8-goog
