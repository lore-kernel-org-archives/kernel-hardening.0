From: Thomas Garnier <thgarnie@google.com>
Date: Wed,  4 Oct 2017 14:19:36 -0700
Message-Id: <20171004212003.28296-1-thgarnie@google.com>
Subject: [kernel-hardening] x86: PIE support and option to extend KASLR randomization
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, Rob Landley <rob@landley.net>, "H . J . Lu" <hjl.tools@gmail.com>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

These patches make the changes necessary to build the kernel as Position
Independent Executable (PIE) on x86_64. A PIE kernel can be relocated below
the top 2G of the virtual address space. It allows to optionally extend the
KASLR randomization range from 1G to 3G.

Thanks a lot to Ard Biesheuvel & Kees Cook on their feedback on compiler
changes, PIE support and KASLR in general. Thanks to Roland McGrath on his
feedback for using -pie versus --emit-relocs and details on compiler code
generation.

The patches:
 - 1-3, 5-1#, 17-18: Change in assembly code to be PIE compliant.
 - 4: Add a new _ASM_GET_PTR macro to fetch a symbol address generically.
 - 14: Adapt percpu design to work correctly when PIE is enabled.
 - 15: Provide an option to default visibility to hidden except for key symbols.
       It removes errors between compilation units.
 - 16: Adapt relocation tool to handle PIE binary correctly.
 - 19: Add support for global cookie.
 - 20: Support ftrace with PIE (used on Ubuntu config).
 - 21: Fix incorrect address marker on dump_pagetables.
 - 22: Add option to move the module section just after the kernel.
 - 23: Adapt module loading to support PIE with dynamic GOT.
 - 24: Make the GOT read-only.
 - 25: Add the CONFIG_X86_PIE option (off by default).
 - 26: Adapt relocation tool to generate a 64-bit relocation table.
 - 27: Add the CONFIG_RANDOMIZE_BASE_LARGE option to increase relocation range
       from 1G to 3G (off by default).

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

diffstat:
 Documentation/x86/x86_64/mm.txt              |    3 
 arch/x86/Kconfig                             |   37 ++++
 arch/x86/Makefile                            |   14 +
 arch/x86/boot/boot.h                         |    2 
 arch/x86/boot/compressed/Makefile            |    5 
 arch/x86/boot/compressed/misc.c              |   10 +
 arch/x86/crypto/aes-x86_64-asm_64.S          |   45 +++--
 arch/x86/crypto/aesni-intel_asm.S            |   14 +
 arch/x86/crypto/aesni-intel_avx-x86_64.S     |    6 
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  |   42 ++---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |   44 ++---
 arch/x86/crypto/camellia-x86_64-asm_64.S     |    8 -
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |   50 +++---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |   44 +++--
 arch/x86/crypto/des3_ede-asm_64.S            |   96 ++++++++----
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |    4 
 arch/x86/crypto/glue_helper-asm-avx.S        |    4 
 arch/x86/crypto/glue_helper-asm-avx2.S       |    6 
 arch/x86/entry/entry_32.S                    |    3 
 arch/x86/entry/entry_64.S                    |   29 ++-
 arch/x86/include/asm/asm.h                   |   13 +
 arch/x86/include/asm/bug.h                   |    2 
 arch/x86/include/asm/ftrace.h                |   23 ++-
 arch/x86/include/asm/jump_label.h            |    8 -
 arch/x86/include/asm/kvm_host.h              |    6 
 arch/x86/include/asm/module.h                |   14 +
 arch/x86/include/asm/page_64_types.h         |    9 +
 arch/x86/include/asm/paravirt_types.h        |   12 +
 arch/x86/include/asm/percpu.h                |   25 ++-
 arch/x86/include/asm/pgtable_64_types.h      |    6 
 arch/x86/include/asm/pm-trace.h              |    2 
 arch/x86/include/asm/processor.h             |   12 +
 arch/x86/include/asm/sections.h              |    4 
 arch/x86/include/asm/setup.h                 |    2 
 arch/x86/include/asm/stackprotector.h        |   19 +-
 arch/x86/kernel/acpi/wakeup_64.S             |   31 ++--
 arch/x86/kernel/asm-offsets.c                |    3 
 arch/x86/kernel/asm-offsets_32.c             |    3 
 arch/x86/kernel/asm-offsets_64.c             |    3 
 arch/x86/kernel/cpu/common.c                 |    7 
 arch/x86/kernel/cpu/microcode/core.c         |    4 
 arch/x86/kernel/ftrace.c                     |  168 ++++++++++++++--------
 arch/x86/kernel/head64.c                     |   32 +++-
 arch/x86/kernel/head_32.S                    |    3 
 arch/x86/kernel/head_64.S                    |   41 ++++-
 arch/x86/kernel/kvm.c                        |    6 
 arch/x86/kernel/module.c                     |  204 ++++++++++++++++++++++++++-
 arch/x86/kernel/module.lds                   |    3 
 arch/x86/kernel/process.c                    |    5 
 arch/x86/kernel/relocate_kernel_64.S         |    8 -
 arch/x86/kernel/setup_percpu.c               |    2 
 arch/x86/kernel/vmlinux.lds.S                |   13 +
 arch/x86/kvm/svm.c                           |    4 
 arch/x86/lib/cmpxchg16b_emu.S                |    8 -
 arch/x86/mm/dump_pagetables.c                |   11 -
 arch/x86/power/hibernate_asm_64.S            |    4 
 arch/x86/tools/relocs.c                      |  170 ++++++++++++++++++++--
 arch/x86/tools/relocs.h                      |    4 
 arch/x86/tools/relocs_common.c               |   15 +
 arch/x86/xen/xen-asm.S                       |   12 -
 arch/x86/xen/xen-head.S                      |    9 -
 arch/x86/xen/xen-pvh.S                       |   13 +
 drivers/base/firmware_class.c                |    4 
 include/asm-generic/sections.h               |    6 
 include/asm-generic/vmlinux.lds.h            |   12 +
 include/linux/compiler.h                     |    8 +
 init/Kconfig                                 |    9 +
 kernel/kallsyms.c                            |   16 +-
 kernel/trace/trace.h                         |    4 
 lib/dynamic_debug.c                          |    4 
 70 files changed, 1109 insertions(+), 363 deletions(-)
