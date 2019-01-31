From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 00/27] x86: PIE support and option to extend KASLR randomization
Date: Thu, 31 Jan 2019 11:24:07 -0800
Message-Id: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jonathan Corbet <corbet@lwn.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Marek <michal.lkml@markovi.net>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Steven Rostedt <rostedt@goodmis.org>, Joerg Roedel <joro@8bytes.org>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Stefano Stabellini <sstabellini@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, Jason Baron <jbaron@akamai.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Thomas Garnier <thgarnie@google.com>, Baoquan He <bhe@redhat.com>, Alexander Popov <alex.popov@linux.com>, Jordan Borgner <mail@jordan-borgner.de>, Nathan Chancellor <natechancellor@gmail.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, "H.J. Lu" <hjl.tools@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, Nadav Amit <namit@vmware.com>, Yonghong Song <yhs@fb.com>, Nick Desaulniers <ndesaulniers@google.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, Jann Horn <jannh@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, Masami Hiramatsu <mhiramat@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, Nayna Jain <nayna@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Jan Kiszka <jan.kiszka@siemens.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, Jan Beulich <JBeulich@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, =?UTF-8?q?Rafael=20=C3=81vila=20de=20Esp=C3=ADndola?= <rafael@espindo.la>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Nicholas Piggin <npiggin@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Song Liu <songliubraving@fb.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Michael Forney <forney@google.com>, Palmer Dabbelt <palmer@sifive.com>, James Hogan <jhogan@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, nixiaoming <nixiaoming@huawei.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-crypto@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-pm@vger.kernel.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

There has been no major concern in the latest iterations. I am interested on
what would be the best way to slowly integrate this patchset upstream.

Changes:
 - patch v6:
   - Rebase on latest changes in jump tables and crypto.
   - Fix wording on couple commits.
   - Revisit checkpatch warnings.
   - Moving to @chromium.org.
 - patch v5:
   - Adapt new crypto modules for PIE.
   - Improve per-cpu commit message.
   - Fix xen 32-bit build error with .quad.
   - Remove extra code for ftrace.
 - patch v4:
   - Simplify early boot by removing global variables.
   - Modify the mcount location script for __mcount_loc intead of the address
     read in the ftrace implementation.
   - Edit commit description to explain better where the kernel can be located.
   - Streamlined the testing done on each patch proposal. Always testing
     hibernation, suspend, ftrace and kprobe to ensure no regressions.
 - patch v3:
   - Update on message to describe longer term PIE goal.
   - Minor change on ftrace if condition.
   - Changed code using xchgq.
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
KASLR randomization range from 1G to 3G. The chosen range is the one currently
available, future changes will allow the kernel module to have a wider
randomization range.

Thanks a lot to Ard Biesheuvel & Kees Cook on their feedback on compiler
changes, PIE support and KASLR in general. Thanks to Roland McGrath on his
feedback for using -pie versus --emit-relocs and details on compiler code
generation.

The patches:
 - 1-2, 4-13, 18-19: Change in assembly code to be PIE compliant.
 - 3: Add a new _ASM_MOVABS macro to fetch a symbol address generically.
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
 Makefile                                     |    3 
 arch/x86/Kconfig                             |   45 ++++++
 arch/x86/Makefile                            |   58 ++++++++
 arch/x86/boot/boot.h                         |    2 
 arch/x86/boot/compressed/Makefile            |    5 
 arch/x86/boot/compressed/misc.c              |   10 +
 arch/x86/crypto/aegis128-aesni-asm.S         |    6 
 arch/x86/crypto/aegis128l-aesni-asm.S        |    8 -
 arch/x86/crypto/aegis256-aesni-asm.S         |    6 
 arch/x86/crypto/aes-x86_64-asm_64.S          |   45 ++++--
 arch/x86/crypto/aesni-intel_asm.S            |    8 -
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  |   42 +++---
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |   44 +++---
 arch/x86/crypto/camellia-x86_64-asm_64.S     |    8 -
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++---
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |   44 +++---
 arch/x86/crypto/des3_ede-asm_64.S            |   96 +++++++++-----
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |    4 
 arch/x86/crypto/glue_helper-asm-avx.S        |    4 
 arch/x86/crypto/glue_helper-asm-avx2.S       |    6 
 arch/x86/crypto/morus1280-avx2-asm.S         |    4 
 arch/x86/crypto/morus1280-sse2-asm.S         |    8 -
 arch/x86/crypto/morus640-sse2-asm.S          |    6 
 arch/x86/crypto/sha256-avx2-asm.S            |   23 ++-
 arch/x86/entry/calling.h                     |    2 
 arch/x86/entry/entry_32.S                    |    3 
 arch/x86/entry/entry_64.S                    |   23 ++-
 arch/x86/include/asm/alternative.h           |    6 
 arch/x86/include/asm/asm.h                   |    1 
 arch/x86/include/asm/jump_label.h            |    8 -
 arch/x86/include/asm/kvm_host.h              |    8 -
 arch/x86/include/asm/module.h                |   11 +
 arch/x86/include/asm/page_64_types.h         |   10 +
 arch/x86/include/asm/paravirt_types.h        |   12 +
 arch/x86/include/asm/percpu.h                |   25 ++-
 arch/x86/include/asm/pgtable_64_types.h      |    6 
 arch/x86/include/asm/pm-trace.h              |    2 
 arch/x86/include/asm/processor.h             |   13 +
 arch/x86/include/asm/sections.h              |    4 
 arch/x86/include/asm/setup.h                 |    2 
 arch/x86/include/asm/stackprotector.h        |   19 ++
 arch/x86/kernel/Makefile                     |    6 
 arch/x86/kernel/acpi/wakeup_64.S             |   31 ++--
 arch/x86/kernel/asm-offsets.c                |    3 
 arch/x86/kernel/asm-offsets_32.c             |    3 
 arch/x86/kernel/asm-offsets_64.c             |    3 
 arch/x86/kernel/cpu/common.c                 |    3 
 arch/x86/kernel/cpu/microcode/core.c         |    4 
 arch/x86/kernel/ftrace.c                     |   51 +++++++
 arch/x86/kernel/head64.c                     |   23 ++-
 arch/x86/kernel/head_32.S                    |    3 
 arch/x86/kernel/head_64.S                    |   31 +++-
 arch/x86/kernel/kvm.c                        |    6 
 arch/x86/kernel/module.c                     |  181 ++++++++++++++++++++++++++-
 arch/x86/kernel/module.lds                   |    3 
 arch/x86/kernel/process.c                    |    5 
 arch/x86/kernel/relocate_kernel_64.S         |    2 
 arch/x86/kernel/setup_percpu.c               |    5 
 arch/x86/kernel/vmlinux.lds.S                |   13 +
 arch/x86/kvm/svm.c                           |    4 
 arch/x86/kvm/vmx/vmx.c                       |    2 
 arch/x86/lib/cmpxchg16b_emu.S                |    8 -
 arch/x86/mm/dump_pagetables.c                |    3 
 arch/x86/platform/pvh/head.S                 |   14 +-
 arch/x86/power/hibernate_asm_64.S            |    4 
 arch/x86/tools/relocs.c                      |  173 +++++++++++++++++++++++--
 arch/x86/tools/relocs.h                      |    4 
 arch/x86/tools/relocs_common.c               |   15 +-
 arch/x86/xen/xen-asm.S                       |   12 -
 arch/x86/xen/xen-head.S                      |   11 -
 drivers/base/firmware_loader/main.c          |    4 
 include/asm-generic/sections.h               |    6 
 include/asm-generic/vmlinux.lds.h            |   12 +
 include/linux/compiler.h                     |    7 +
 init/Kconfig                                 |   16 ++
 kernel/kallsyms.c                            |   16 +-
 kernel/trace/trace.h                         |    4 
 lib/dynamic_debug.c                          |    4 
 scripts/link-vmlinux.sh                      |   14 ++
 scripts/recordmcount.c                       |   78 +++++++----
 81 files changed, 1130 insertions(+), 350 deletions(-)

Patchset is based on next-20190130.
