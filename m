MIME-Version: 1.0
In-Reply-To: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
References: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sat, 20 Oct 2018 19:20:03 +0200
Message-ID: <CAKv+Gu_AgPv2o4=U0-7pnpgtSufEobnta8oKhhGfCdCxM82B5Q@mail.gmail.com>
Subject: Re: [PATCH RFC v3 0/3] Rlimit for module space
Content-Type: text/plain; charset="UTF-8"
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Daniel Borkmann <daniel@iogearbox.net>, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, the arch/x86 maintainers <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jessica Yu <jeyu@kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mips <linux-mips@linux-mips.org>, linux-s390 <linux-s390@vger.kernel.org>, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, Jann Horn <jannh@google.com>, kristen@linux.intel.com, Dave Hansen <dave.hansen@intel.com>, arjan@linux.intel.com, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Rick,

On 19 October 2018 at 22:47, Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:
> If BPF JIT is on, there is no effective limit to prevent filling the entire
> module space with JITed e/BPF filters.

Why do BPF filters use the module space, and does this reason apply to
all architectures?

On arm64, we already support loading plain modules far away from the
core kernel (i.e. out of range for ordinary relative jump/calll
instructions), and so I'd expect BPF to be able to deal with this
already as well. So for arm64, I wonder why an ordinary vmalloc_exec()
wouldn't be more appropriate.

So before refactoring the module alloc/free routines to accommodate
BPF, I'd like to take one step back and assess whether it wouldn't be
more appropriate to have a separate bpf_alloc/free API, which could be
totally separate from module alloc/free if the arch permits it.


> For classic BPF filters attached with
> setsockopt SO_ATTACH_FILTER, there is no memlock rlimit check to limit the
> number of insertions like there is for the bpf syscall.
>
> This patch adds a per user rlimit for module space, as well as a system wide
> limit for BPF JIT. In a previously reviewed patchset, Jann Horn pointed out the
> problem that in some cases a user can get access to 65536 UIDs, so the effective
> limit cannot be set low enough to stop an attacker and be useful for the general
> case. A discussed alternative solution was a system wide limit for BPF JIT
> filters. This much more simply resolves the problem of exhaustion and
> de-randomizing in the case of non-CONFIG_BPF_JIT_ALWAYS_ON. If
> CONFIG_BPF_JIT_ALWAYS_ON is on however, BPF insertions will fail if another user
> exhausts the BPF JIT limit. In this case a per user limit is still needed. If
> the subuid facility is disabled for normal users, this should still be ok
> because the higher limit will not be able to be worked around that way.
>
> The new BPF JIT limit can be set like this:
> echo 5000000 > /proc/sys/net/core/bpf_jit_limit
>
> So I *think* this patchset should resolve that issue except for the
> configuration of CONFIG_BPF_JIT_ALWAYS_ON and subuid allowed for normal users.
> Better module space KASLR is another way to resolve the de-randomizing issue,
> and so then you would just be left with the BPF DOS in that configuration.
>
> Jann also pointed out how, with purposely fragmenting the module space, you
> could make the effective module space blockage area much larger. This is also
> somewhat un-resolved. The impact would depend on how big of a space you are
> trying to allocate. The limit has been lowered on x86_64 so that at least
> typical sized BPF filters cannot be blocked.
>
> If anyone with more experience with subuid/user namespaces has any suggestions
> I'd be glad to hear. On an Ubuntu machine it didn't seem like a un-privileged
> user could do this. I am going to keep working on this and see if I can find a
> better solution.
>
> Changes since v2:
>  - System wide BPF JIT limit (discussion with Jann Horn)
>  - Holding reference to user correctly (Jann)
>  - Having arch versions of modulde_alloc (Dave Hansen, Jessica Yu)
>  - Shrinking of default limits, to help prevent the limit being worked around
>    with fragmentation (Jann)
>
> Changes since v1:
>  - Plug in for non-x86
>  - Arch specific default values
>
>
> Rick Edgecombe (3):
>   modules: Create arch versions of module alloc/free
>   modules: Create rlimit for module space
>   bpf: Add system wide BPF JIT limit
>
>  arch/arm/kernel/module.c                |   2 +-
>  arch/arm64/kernel/module.c              |   2 +-
>  arch/mips/kernel/module.c               |   2 +-
>  arch/nds32/kernel/module.c              |   2 +-
>  arch/nios2/kernel/module.c              |   4 +-
>  arch/parisc/kernel/module.c             |   2 +-
>  arch/s390/kernel/module.c               |   2 +-
>  arch/sparc/kernel/module.c              |   2 +-
>  arch/unicore32/kernel/module.c          |   2 +-
>  arch/x86/include/asm/pgtable_32_types.h |   3 +
>  arch/x86/include/asm/pgtable_64_types.h |   2 +
>  arch/x86/kernel/module.c                |   2 +-
>  fs/proc/base.c                          |   1 +
>  include/asm-generic/resource.h          |   8 ++
>  include/linux/bpf.h                     |   7 ++
>  include/linux/filter.h                  |   1 +
>  include/linux/sched/user.h              |   4 +
>  include/uapi/asm-generic/resource.h     |   3 +-
>  kernel/bpf/core.c                       |  22 +++-
>  kernel/bpf/inode.c                      |  16 +++
>  kernel/module.c                         | 152 +++++++++++++++++++++++-
>  net/core/sysctl_net_core.c              |   7 ++
>  22 files changed, 233 insertions(+), 15 deletions(-)
>
> --
> 2.17.1
>
