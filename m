From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v2 00/27] x86: PIE support and option to extend KASLR randomization
Date: Tue, 13 Mar 2018 13:59:18 -0700
Message-Id: <20180313205945.245105-1-thgarnie@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Philippe Ombredanne <pombredanne@nexb.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Ashish Kalra <ashish@bluestacks.com>, Kyle McMartin <kyle@redhat.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Lukas Wunner <lukas@wunner.de>, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Jiri Slaby <jslaby@suse.cz>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, Daniel Micay <danielmicay@gmail.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Changes:
 - patch v2:
   - Adapt patch to work post KPTI and compiler changes
   - Redo all performance testing with latest configs and compilers
   - Simplify mov macro on PIE (MOVABS now)
   - Reduce GOT footprint
 - patch v1:
   - Simplify ftrace implementation.
   - Use gcc mstack-protector-guard-reg=%gs with PIE when possible.
 - rfc v3:
   - Use --emit-relocs instead of -pie to reduce dynamic relocation space on
     mapped memory. It also simplifies the relocation process.
   - Move the start the module section next to the kernel. Remove the need for
     -mcmodel=large on modules. Extends module space from 1 to 2G maximum.
   - Support for XEN PVH as 32-bit relocations can be ignored with
     --emit-relocs.
   - Support for GOT relocations previously done automatically with -pie.
   - Remove need for dynamic PLT in modules.
   - Support dymamic GOT for modules.
 - rfc v2:
   - Add support for global stack cookie while compiler default to fs without
     mcmodel=kernel
   - Change patch 7 to correctly jump out of the identity mapping on kexec load
     preserve.

These patches make the changes necessary to build the kernel as Position
Independent Executable (PIE) on x86_64. A PIE kernel can be relocated below
the top 2G of the virtual address space. It allows to optionally extend the
KASLR randomization range from 1G to 3G.

Thanks a lot to Ard Biesheuvel & Kees Cook on their feedback on compiler
changes, PIE support and KASLR in general. Thanks to Roland McGrath on his
feedback for using -pie versus --emit-relocs and details on compiler code
generation.

The patches:
 - 1-3, 5-13, 18-19: Change in assembly code to be PIE compliant.
 - 4: Add a new _ASM_GET_PTR macro to fetch a symbol address generically.
 - 14: Adapt percpu design to work correctly when PIE is enabled.
 - 15: Provide an option to default visibility to hidden except for key symbols.
       It removes errors between compilation units.
 - 16: Add PROVIDE_HIDDEN replacement on the linker script for weak symbols to
       reduce GOT footprint.
 - 17: Adapt relocation tool to handle PIE binary correctly.
 - 20: Add support for global cookie.
 - 21: Support ftrace with PIE (used on Ubuntu config).
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

diffstat:
 Documentation/x86/x86_64/mm.txt              |    3 
 arch/x86/Kconfig                             |   45 ++++++
 arch/x86/Makefile                            |   58 ++++++++
 arch/x86/boot/boot.h                         |    2 
 arch/x86/boot/compressed/Makefile            |    5 
 arch/x86/boot/compressed/misc.c              |   10 +
 arch/x86/crypto/aes-x86_64-asm_64.S          |   45 ++++--
 arch/x86/crypto/aesni-intel_asm.S            |    8 -
 arch/x86/crypto/aesni-intel_avx-x86_64.S     |    6 
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  |   42 +++---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |   44 +++---
 arch/x86/crypto/camellia-x86_64-asm_64.S     |    8 -
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |   44 +++---
 arch/x86/crypto/des3_ede-asm_64.S            |   96 +++++++++-----
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |    4 
 arch/x86/crypto/glue_helper-asm-avx.S        |    4 
 arch/x86/crypto/glue_helper-asm-avx2.S       |    6 
 arch/x86/crypto/sha256-avx2-asm.S            |   23 ++-
 arch/x86/entry/calling.h                     |    2 
 arch/x86/entry/entry_32.S                    |    3 
 arch/x86/entry/entry_64.S                    |   23 ++-
 arch/x86/include/asm/asm.h                   |    1 
 arch/x86/include/asm/bug.h                   |    2 
 arch/x86/include/asm/ftrace.h                |    6 
 arch/x86/include/asm/jump_label.h            |    8 -
 arch/x86/include/asm/kvm_host.h              |    6 
 arch/x86/include/asm/module.h                |   11 +
 arch/x86/include/asm/page_64_types.h         |    9 +
 arch/x86/include/asm/paravirt_types.h        |   12 +
 arch/x86/include/asm/percpu.h                |   25 ++-
 arch/x86/include/asm/pgtable_64_types.h      |    6 
 arch/x86/include/asm/pm-trace.h              |    2 
 arch/x86/include/asm/processor.h             |   12 +
 arch/x86/include/asm/sections.h              |    8 +
 arch/x86/include/asm/setup.h                 |    2 
 arch/x86/include/asm/stackprotector.h        |   19 ++
 arch/x86/kernel/Makefile                     |    6 
 arch/x86/kernel/acpi/wakeup_64.S             |   31 ++--
 arch/x86/kernel/asm-offsets.c                |    3 
 arch/x86/kernel/asm-offsets_32.c             |    3 
 arch/x86/kernel/asm-offsets_64.c             |    3 
 arch/x86/kernel/cpu/common.c                 |    7 -
 arch/x86/kernel/cpu/microcode/core.c         |    4 
 arch/x86/kernel/ftrace.c                     |   42 +++++-
 arch/x86/kernel/head64.c                     |   23 ++-
 arch/x86/kernel/head_32.S                    |    3 
 arch/x86/kernel/head_64.S                    |   41 +++++-
 arch/x86/kernel/kvm.c                        |    6 
 arch/x86/kernel/module.c                     |  181 ++++++++++++++++++++++++++-
 arch/x86/kernel/module.lds                   |    3 
 arch/x86/kernel/process.c                    |    5 
 arch/x86/kernel/relocate_kernel_64.S         |   16 +-
 arch/x86/kernel/setup_percpu.c               |    2 
 arch/x86/kernel/vmlinux.lds.S                |   13 +
 arch/x86/kvm/svm.c                           |    4 
 arch/x86/lib/cmpxchg16b_emu.S                |    8 -
 arch/x86/mm/dump_pagetables.c                |    3 
 arch/x86/power/hibernate_asm_64.S            |    4 
 arch/x86/tools/relocs.c                      |  169 +++++++++++++++++++++++--
 arch/x86/tools/relocs.h                      |    4 
 arch/x86/tools/relocs_common.c               |   15 +-
 arch/x86/xen/xen-asm.S                       |   12 -
 arch/x86/xen/xen-head.S                      |   11 -
 arch/x86/xen/xen-pvh.S                       |   13 +
 drivers/base/firmware_class.c                |    4 
 include/asm-generic/sections.h               |    6 
 include/asm-generic/vmlinux.lds.h            |   12 +
 include/linux/compiler.h                     |    7 +
 init/Kconfig                                 |   16 ++
 kernel/kallsyms.c                            |   16 +-
 kernel/trace/trace.h                         |    4 
 lib/dynamic_debug.c                          |    4 
 scripts/link-vmlinux.sh                      |   14 ++
 74 files changed, 1063 insertions(+), 315 deletions(-)
