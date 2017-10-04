From: Thomas Garnier <thgarnie@google.com>
Date: Wed,  4 Oct 2017 14:20:01 -0700
Message-Id: <20171004212003.28296-26-thgarnie@google.com>
In-Reply-To: <20171004212003.28296-1-thgarnie@google.com>
References: <20171004212003.28296-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v3 25/27] x86/pie: Add option to build the kernel as PIE
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, Rob Landley <rob@landley.net>, "H . J . Lu" <hjl.tools@gmail.com>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
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

Performance/Size impact:
Size of vmlinux (Default configuration):
 File size:
 - PIE disabled: +0.000031%
 - PIE enabled: -3.210% (less relocations)
 .text section:
 - PIE disabled: +0.000644%
 - PIE enabled: +0.837%

Size of vmlinux (Ubuntu configuration):
 File size:
 - PIE disabled: -0.201%
 - PIE enabled: -0.082%
 .text section:
 - PIE disabled: same
 - PIE enabled: +1.319%

Size of vmlinux (Default configuration + ORC):
 File size:
 - PIE enabled: -3.167%
 .text section:
 - PIE enabled: +0.814%

Size of vmlinux (Ubuntu configuration + ORC):
 File size:
 - PIE enabled: -3.167%
 .text section:
 - PIE enabled: +1.26%

The size increase is mainly due to not having access to the 32-bit signed
relocation that can be used with mcmodel=kernel. A small part is due to reduced
optimization for PIE code. This bug [1] was opened with gcc to provide a better
code generation for kernel PIE.

Hackbench (50% and 1600% on thread/process for pipe/sockets):
 - PIE disabled: no significant change (avg +0.1% on latest test).
 - PIE enabled: between -0.50% to +0.86% in average (default and Ubuntu config).

slab_test (average of 10 runs):
 - PIE disabled: no significant change (-2% on latest run, likely noise).
 - PIE enabled: between -1% and +0.8% on latest runs.

Kernbench (average of 10 Half and Optimal runs):
 Elapsed Time:
 - PIE disabled: no significant change (avg -0.239%)
 - PIE enabled: average +0.07%
 System Time:
 - PIE disabled: no significant change (avg -0.277%)
 - PIE enabled: average +0.7%

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82303

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/Kconfig  | 8 ++++++++
 arch/x86/Makefile | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1e4b399c64e5..b92f96923712 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2141,6 +2141,14 @@ config X86_GLOBAL_STACKPROTECTOR
 	bool
 	depends on CC_STACKPROTECTOR
 
+config X86_PIE
+	bool
+	depends on X86_64
+	select DEFAULT_HIDDEN
+	select DYNAMIC_MODULE_BASE
+	select MODULE_REL_CRCS if MODVERSIONS
+	select X86_GLOBAL_STACKPROTECTOR if CC_STACKPROTECTOR
+
 config HOTPLUG_CPU
 	bool "Support for hot-pluggable CPUs"
 	depends on SMP
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 42774185a58a..c49855b4b1be 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -144,6 +144,7 @@ else
 
         KBUILD_CFLAGS += -mno-red-zone
 ifdef CONFIG_X86_PIE
+        KBUILD_CFLAGS += -fPIC
         KBUILD_LDFLAGS_MODULE += -T $(srctree)/arch/x86/kernel/module.lds
 else
         KBUILD_CFLAGS += -mcmodel=kernel
-- 
2.14.2.920.gcf0c67979c-goog
