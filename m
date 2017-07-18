From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 18 Jul 2017 15:33:11 -0700
Message-Id: <20170718223333.110371-1-thgarnie@google.com>
Subject: [kernel-hardening] x86: PIE support and option to extend KASLR randomization
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Matthias Kaehlcke <mka@chromium.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Christopher Li <sparse@chrisli.org>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Peter Foley <pefoley2@pefoley.com>, Steven Rostedt <rostedt@goodmis.org>, Tim Chen <tim.c.chen@linux.intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Paul Bolle <pebolle@tiscali.nl>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org, kvm@vger.kernel.org, linux-pm@vger.kernel.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

These patches make the changes necessary to build the kernel as Position
Independent Executable (PIE) on x86_64. A PIE kernel can be relocated below
the top 2G of the virtual address space. It allows to optionally extend the
KASLR randomization range from 1G to 3G.

Thanks a lot to Ard Biesheuvel & Kees Cook on their feedback on compiler
changes, PIE support and KASLR in general.

The patches:
 - 1-3, 5-15: Change in assembly code to be PIE compliant.
 - 4: Add a new _ASM_GET_PTR macro to fetch a symbol address generically.
 - 16: Adapt percpu design to work correctly when PIE is enabled.
 - 17: Provide an option to default visibility to hidden except for key symbols.
       It removes errors between compilation units.
 - 18: Adapt relocation tool to handle PIE binary correctly.
 - 19: Add the CONFIG_X86_PIE option (off by default)
 - 20: Adapt relocation tool to generate a 64-bit relocation table.
 - 21: Add options to build modules as mcmodel=large and dynamically create a
       PLT for relative references out of range (adapted from arm64).
 - 22: Add the CONFIG_RANDOMIZE_BASE_LARGE option to increase relocation range
       from 1G to 3G (off by default).

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

diffstat:
 arch/x86/Kconfig                             |   37 +++++
 arch/x86/Makefile                            |   17 ++
 arch/x86/boot/boot.h                         |    2 
 arch/x86/boot/compressed/Makefile            |    5 
 arch/x86/boot/compressed/misc.c              |   10 +
 arch/x86/crypto/aes-x86_64-asm_64.S          |   45 +++---
 arch/x86/crypto/aesni-intel_asm.S            |   14 +
 arch/x86/crypto/aesni-intel_avx-x86_64.S     |    6 
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  |   42 ++---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |   44 +++---
 arch/x86/crypto/camellia-x86_64-asm_64.S     |    8 -
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |   50 +++---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |   44 +++---
 arch/x86/crypto/des3_ede-asm_64.S            |   96 ++++++++-----
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |    4 
 arch/x86/crypto/glue_helper-asm-avx.S        |    4 
 arch/x86/crypto/glue_helper-asm-avx2.S       |    6 
 arch/x86/entry/entry_64.S                    |   26 ++-
 arch/x86/include/asm/asm.h                   |   13 +
 arch/x86/include/asm/bug.h                   |    2 
 arch/x86/include/asm/jump_label.h            |    8 -
 arch/x86/include/asm/kvm_host.h              |    6 
 arch/x86/include/asm/module.h                |   16 ++
 arch/x86/include/asm/page_64_types.h         |    9 +
 arch/x86/include/asm/paravirt_types.h        |   12 +
 arch/x86/include/asm/percpu.h                |   25 ++-
 arch/x86/include/asm/pm-trace.h              |    2 
 arch/x86/include/asm/processor.h             |    8 -
 arch/x86/include/asm/setup.h                 |    2 
 arch/x86/kernel/Makefile                     |    2 
 arch/x86/kernel/acpi/wakeup_64.S             |   31 ++--
 arch/x86/kernel/cpu/common.c                 |    4 
 arch/x86/kernel/head64.c                     |   28 +++
 arch/x86/kernel/head_64.S                    |   47 +++++-
 arch/x86/kernel/kvm.c                        |    6 
 arch/x86/kernel/module-plts.c                |  198 +++++++++++++++++++++++++++
 arch/x86/kernel/module.c                     |   18 +-
 arch/x86/kernel/module.lds                   |    4 
 arch/x86/kernel/relocate_kernel_64.S         |    2 
 arch/x86/kernel/setup_percpu.c               |    2 
 arch/x86/kernel/vmlinux.lds.S                |   13 +
 arch/x86/kvm/svm.c                           |    4 
 arch/x86/lib/cmpxchg16b_emu.S                |    8 -
 arch/x86/power/hibernate_asm_64.S            |    4 
 arch/x86/tools/relocs.c                      |  134 +++++++++++++++---
 arch/x86/tools/relocs.h                      |    4 
 arch/x86/tools/relocs_common.c               |   15 +-
 arch/x86/xen/xen-asm.S                       |   12 -
 arch/x86/xen/xen-asm.h                       |    3 
 arch/x86/xen/xen-head.S                      |    9 -
 include/asm-generic/sections.h               |    6 
 include/linux/compiler.h                     |    8 +
 init/Kconfig                                 |    9 +
 kernel/kallsyms.c                            |   16 +-
 54 files changed, 868 insertions(+), 282 deletions(-)
