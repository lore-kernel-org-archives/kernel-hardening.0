From: Tom Lendacky <thomas.lendacky@amd.com>
References: <20171011203027.11248-1-thgarnie@google.com>
 <22e56a56-978a-738f-52b9-2d0c17839c9e@amd.com>
 <CAJcbSZEzEGuby155zQZJqEbi1EO1v2bue+DB1oAXZfwMVOoySg@mail.gmail.com>
Message-ID: <18a89941-c80d-7007-574b-584f39f90f49@amd.com>
Date: Thu, 12 Oct 2017 11:28:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAJcbSZEzEGuby155zQZJqEbi1EO1v2bue+DB1oAXZfwMVOoySg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v1 00/27] x86: PIE support and option to extend KASLR
 randomization
To: Thomas Garnier <thgarnie@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, "=?UTF-8?Q?Jan_H_._Sch=c3=b6nherr?=" <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, virtualization@lists.linux-foundation.org, xen-devel <xen-devel@lists.xenproject.org>, linux-arch <linux-arch@vger.kernel.org>, Sparse Mailing-list <linux-sparse@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/12/2017 10:34 AM, Thomas Garnier wrote:
> On Wed, Oct 11, 2017 at 2:34 PM, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> On 10/11/2017 3:30 PM, Thomas Garnier wrote:
>>> Changes:
>>>    - patch v1:
>>>      - Simplify ftrace implementation.
>>>      - Use gcc mstack-protector-guard-reg=%gs with PIE when possible.
>>>    - rfc v3:
>>>      - Use --emit-relocs instead of -pie to reduce dynamic relocation space on
>>>        mapped memory. It also simplifies the relocation process.
>>>      - Move the start the module section next to the kernel. Remove the need for
>>>        -mcmodel=large on modules. Extends module space from 1 to 2G maximum.
>>>      - Support for XEN PVH as 32-bit relocations can be ignored with
>>>        --emit-relocs.
>>>      - Support for GOT relocations previously done automatically with -pie.
>>>      - Remove need for dynamic PLT in modules.
>>>      - Support dymamic GOT for modules.
>>>    - rfc v2:
>>>      - Add support for global stack cookie while compiler default to fs without
>>>        mcmodel=kernel
>>>      - Change patch 7 to correctly jump out of the identity mapping on kexec load
>>>        preserve.
>>>
>>> These patches make the changes necessary to build the kernel as Position
>>> Independent Executable (PIE) on x86_64. A PIE kernel can be relocated below
>>> the top 2G of the virtual address space. It allows to optionally extend the
>>> KASLR randomization range from 1G to 3G.
>>
>> Hi Thomas,
>>
>> I've applied your patches so that I can verify that SME works with PIE.
>> Unfortunately, I'm running into build warnings and errors when I enable
>> PIE.
>>
>> With CONFIG_STACK_VALIDATION=y I receive lots of messages like this:
>>
>>    drivers/scsi/libfc/fc_exch.o: warning: objtool: fc_destroy_exch_mgr()+0x0: call without frame pointer save/setup
>>
>> Disabling CONFIG_STACK_VALIDATION suppresses those.
> 
> I ran into that, I plan to fix it in the next iteration.
> 
>>
>> But near the end of the build, I receive errors like this:
>>
>>    arch/x86/kernel/setup.o: In function `dump_kernel_offset':
>>    .../arch/x86/kernel/setup.c:801:(.text+0x32): relocation truncated to fit: R_X86_64_32S against symbol `_text' defined in .text section in .tmp_vmlinux1
>>    .
>>    . about 10 more of the above type messages
>>    .
>>    make: *** [vmlinux] Error 1
>>    Error building kernel, exiting
>>
>> Are there any config options that should or should not be enabled when
>> building with PIE enabled?  Is there a compiler requirement for PIE (I'm
>> using gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.5))?
> 
> I never ran into these ones and I tested compilers older and newer.
> What was your exact configuration?

I'll send you the config in a separate email.

Thanks,
Tom

> 
>>
>> Thanks,
>> Tom
>>
>>>
>>> Thanks a lot to Ard Biesheuvel & Kees Cook on their feedback on compiler
>>> changes, PIE support and KASLR in general. Thanks to Roland McGrath on his
>>> feedback for using -pie versus --emit-relocs and details on compiler code
>>> generation.
>>>
>>> The patches:
>>>    - 1-3, 5-1#, 17-18: Change in assembly code to be PIE compliant.
>>>    - 4: Add a new _ASM_GET_PTR macro to fetch a symbol address generically.
>>>    - 14: Adapt percpu design to work correctly when PIE is enabled.
>>>    - 15: Provide an option to default visibility to hidden except for key symbols.
>>>          It removes errors between compilation units.
>>>    - 16: Adapt relocation tool to handle PIE binary correctly.
>>>    - 19: Add support for global cookie.
>>>    - 20: Support ftrace with PIE (used on Ubuntu config).
>>>    - 21: Fix incorrect address marker on dump_pagetables.
>>>    - 22: Add option to move the module section just after the kernel.
>>>    - 23: Adapt module loading to support PIE with dynamic GOT.
>>>    - 24: Make the GOT read-only.
>>>    - 25: Add the CONFIG_X86_PIE option (off by default).
>>>    - 26: Adapt relocation tool to generate a 64-bit relocation table.
>>>    - 27: Add the CONFIG_RANDOMIZE_BASE_LARGE option to increase relocation range
>>>          from 1G to 3G (off by default).
>>>
>>> Performance/Size impact:
>>>
>>> Size of vmlinux (Default configuration):
>>>    File size:
>>>    - PIE disabled: +0.000031%
>>>    - PIE enabled: -3.210% (less relocations)
>>>    .text section:
>>>    - PIE disabled: +0.000644%
>>>    - PIE enabled: +0.837%
>>>
>>> Size of vmlinux (Ubuntu configuration):
>>>    File size:
>>>    - PIE disabled: -0.201%
>>>    - PIE enabled: -0.082%
>>>    .text section:
>>>    - PIE disabled: same
>>>    - PIE enabled: +1.319%
>>>
>>> Size of vmlinux (Default configuration + ORC):
>>>    File size:
>>>    - PIE enabled: -3.167%
>>>    .text section:
>>>    - PIE enabled: +0.814%
>>>
>>> Size of vmlinux (Ubuntu configuration + ORC):
>>>    File size:
>>>    - PIE enabled: -3.167%
>>>    .text section:
>>>    - PIE enabled: +1.26%
>>>
>>> The size increase is mainly due to not having access to the 32-bit signed
>>> relocation that can be used with mcmodel=kernel. A small part is due to reduced
>>> optimization for PIE code. This bug [1] was opened with gcc to provide a better
>>> code generation for kernel PIE.
>>>
>>> Hackbench (50% and 1600% on thread/process for pipe/sockets):
>>>    - PIE disabled: no significant change (avg +0.1% on latest test).
>>>    - PIE enabled: between -0.50% to +0.86% in average (default and Ubuntu config).
>>>
>>> slab_test (average of 10 runs):
>>>    - PIE disabled: no significant change (-2% on latest run, likely noise).
>>>    - PIE enabled: between -1% and +0.8% on latest runs.
>>>
>>> Kernbench (average of 10 Half and Optimal runs):
>>>    Elapsed Time:
>>>    - PIE disabled: no significant change (avg -0.239%)
>>>    - PIE enabled: average +0.07%
>>>    System Time:
>>>    - PIE disabled: no significant change (avg -0.277%)
>>>    - PIE enabled: average +0.7%
>>>
>>> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82303
>>>
>>> diffstat:
>>>    Documentation/x86/x86_64/mm.txt              |    3
>>>    arch/x86/Kconfig                             |   43 ++++++
>>>    arch/x86/Makefile                            |   40 +++++
>>>    arch/x86/boot/boot.h                         |    2
>>>    arch/x86/boot/compressed/Makefile            |    5
>>>    arch/x86/boot/compressed/misc.c              |   10 +
>>>    arch/x86/crypto/aes-x86_64-asm_64.S          |   45 ++++--
>>>    arch/x86/crypto/aesni-intel_asm.S            |   14 +-
>>>    arch/x86/crypto/aesni-intel_avx-x86_64.S     |    6
>>>    arch/x86/crypto/camellia-aesni-avx-asm_64.S  |   42 +++---
>>>    arch/x86/crypto/camellia-aesni-avx2-asm_64.S |   44 +++---
>>>    arch/x86/crypto/camellia-x86_64-asm_64.S     |    8 -
>>>    arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++---
>>>    arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |   44 +++---
>>>    arch/x86/crypto/des3_ede-asm_64.S            |   96 +++++++++-----
>>>    arch/x86/crypto/ghash-clmulni-intel_asm.S    |    4
>>>    arch/x86/crypto/glue_helper-asm-avx.S        |    4
>>>    arch/x86/crypto/glue_helper-asm-avx2.S       |    6
>>>    arch/x86/entry/entry_32.S                    |    3
>>>    arch/x86/entry/entry_64.S                    |   29 ++--
>>>    arch/x86/include/asm/asm.h                   |   13 +
>>>    arch/x86/include/asm/bug.h                   |    2
>>>    arch/x86/include/asm/ftrace.h                |    6
>>>    arch/x86/include/asm/jump_label.h            |    8 -
>>>    arch/x86/include/asm/kvm_host.h              |    6
>>>    arch/x86/include/asm/module.h                |   11 +
>>>    arch/x86/include/asm/page_64_types.h         |    9 +
>>>    arch/x86/include/asm/paravirt_types.h        |   12 +
>>>    arch/x86/include/asm/percpu.h                |   25 ++-
>>>    arch/x86/include/asm/pgtable_64_types.h      |    6
>>>    arch/x86/include/asm/pm-trace.h              |    2
>>>    arch/x86/include/asm/processor.h             |   12 +
>>>    arch/x86/include/asm/sections.h              |    8 +
>>>    arch/x86/include/asm/setup.h                 |    2
>>>    arch/x86/include/asm/stackprotector.h        |   19 ++
>>>    arch/x86/kernel/acpi/wakeup_64.S             |   31 ++--
>>>    arch/x86/kernel/asm-offsets.c                |    3
>>>    arch/x86/kernel/asm-offsets_32.c             |    3
>>>    arch/x86/kernel/asm-offsets_64.c             |    3
>>>    arch/x86/kernel/cpu/common.c                 |    7 -
>>>    arch/x86/kernel/cpu/microcode/core.c         |    4
>>>    arch/x86/kernel/ftrace.c                     |   42 +++++-
>>>    arch/x86/kernel/head64.c                     |   32 +++-
>>>    arch/x86/kernel/head_32.S                    |    3
>>>    arch/x86/kernel/head_64.S                    |   41 +++++-
>>>    arch/x86/kernel/kvm.c                        |    6
>>>    arch/x86/kernel/module.c                     |  182 ++++++++++++++++++++++++++-
>>>    arch/x86/kernel/module.lds                   |    3
>>>    arch/x86/kernel/process.c                    |    5
>>>    arch/x86/kernel/relocate_kernel_64.S         |    8 -
>>>    arch/x86/kernel/setup_percpu.c               |    2
>>>    arch/x86/kernel/vmlinux.lds.S                |   13 +
>>>    arch/x86/kvm/svm.c                           |    4
>>>    arch/x86/lib/cmpxchg16b_emu.S                |    8 -
>>>    arch/x86/mm/dump_pagetables.c                |   11 +
>>>    arch/x86/power/hibernate_asm_64.S            |    4
>>>    arch/x86/tools/relocs.c                      |  170 +++++++++++++++++++++++--
>>>    arch/x86/tools/relocs.h                      |    4
>>>    arch/x86/tools/relocs_common.c               |   15 +-
>>>    arch/x86/xen/xen-asm.S                       |   12 -
>>>    arch/x86/xen/xen-head.S                      |    9 -
>>>    arch/x86/xen/xen-pvh.S                       |   13 +
>>>    drivers/base/firmware_class.c                |    4
>>>    include/asm-generic/sections.h               |    6
>>>    include/asm-generic/vmlinux.lds.h            |   12 +
>>>    include/linux/compiler.h                     |    8 +
>>>    init/Kconfig                                 |    9 +
>>>    kernel/kallsyms.c                            |   16 +-
>>>    kernel/trace/trace.h                         |    4
>>>    lib/dynamic_debug.c                          |    4
>>>    70 files changed, 1032 insertions(+), 308 deletions(-)
>>>
> 
> 
> 
