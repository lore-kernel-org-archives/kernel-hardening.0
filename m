MIME-Version: 1.0
In-Reply-To: <6b1017c450d163539d2b974657baaaf697f0a138.camel@intel.com>
References: <20181019204723.3903-1-rick.p.edgecombe@intel.com>
 <CAKv+Gu_AgPv2o4=U0-7pnpgtSufEobnta8oKhhGfCdCxM82B5Q@mail.gmail.com> <6b1017c450d163539d2b974657baaaf697f0a138.camel@intel.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 23 Oct 2018 08:54:56 -0300
Message-ID: <CAKv+Gu-Rk-SQVOQ63L3DkF3=EVik3pHXzpNp5r5TrgDajTM_iQ@mail.gmail.com>
Subject: Re: [PATCH RFC v3 0/3] Rlimit for module space
Content-Type: text/plain; charset="UTF-8"
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, "keescook@chromium.org" <keescook@chromium.org>, "jeyu@kernel.org" <jeyu@kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, "arjan@linux.intel.com" <arjan@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "jannh@google.com" <jannh@google.com>, "x86@kernel.org" <x86@kernel.org>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "mingo@redhat.com" <mingo@redhat.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "bp@alien8.de" <bp@alien8.de>, "Hansen, Dave" <dave.hansen@intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "davem@davemloft.net" <davem@davemloft.net>, "arnd@arndb.de" <arnd@arndb.de>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 22 October 2018 at 20:06, Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> On Sat, 2018-10-20 at 19:20 +0200, Ard Biesheuvel wrote:
>> Hi Rick,
>>
>> On 19 October 2018 at 22:47, Rick Edgecombe <rick.p.edgecombe@intel.com>
>> wrote:
>> > If BPF JIT is on, there is no effective limit to prevent filling the entire
>> > module space with JITed e/BPF filters.
>>
>> Why do BPF filters use the module space, and does this reason apply to
>> all architectures?
>>
>> On arm64, we already support loading plain modules far away from the
>> core kernel (i.e. out of range for ordinary relative jump/calll
>> instructions), and so I'd expect BPF to be able to deal with this
>> already as well. So for arm64, I wonder why an ordinary vmalloc_exec()
>> wouldn't be more appropriate.
> AFAIK, it's like you said about relative instruction limits, but also because
> some predictors don't predict past a certain distance. So performance as well.
> Not sure the reasons for each arch, or if they all apply for BPF JIT. There seem
> to be 8 by my count, that have a dedicated module space for some reason.
>
>> So before refactoring the module alloc/free routines to accommodate
>> BPF, I'd like to take one step back and assess whether it wouldn't be
>> more appropriate to have a separate bpf_alloc/free API, which could be
>> totally separate from module alloc/free if the arch permits it.
>>
> I am not a BPF JIT expert unfortunately, hopefully someone more authoritative
> will chime in. I only ran into this because I was trying to increase
> randomization for the module space and wanted to find out how many allocations
> needed to be supported.
>
> I'd guess though, that BPF JIT is just assuming that there will be some arch
> specific constraints about where text can be placed optimally and they would
> already be taken into account in the module space allocator.
>
> If there are no constraints for some arch, I'd wonder why not just update its
> module_alloc to use the whole space available. What exactly are the constraints
> for arm64 for normal modules?
>

Relative branches and the interactions with KAsan.

We just fixed something similar in the kprobes code: it was using
RWX-mapped module memory to store kprobed instructions, and we
replaced that with a simple vmalloc_exec() [and code to remap it
read-only], which was possible given that relative branches are always
emulated by arm64 kprobes.

So it depends on whether BPF code needs to be in relative branching
range from the calling code, and whether the BPF code itself is
emitted using relative branches into other parts of the code.

> It seems fine to me for architectures to have the option of solving this a
> different way. If potentially the rlimit ends up being the best solution for
> some architectures though, do you think this refactor (pretty close to just a
> name change) is that intrusive?
>
> I guess it could be just a BPF JIT per user limit and not touch module space,
> but I thought the module space limit was a more general solution as that is the
> actual limited resource.
>

I think it is wrong to conflate the two things. Limiting the number of
BPF allocations and the limiting number of module allocations are two
separate things, and the fact that BPF reuses module_alloc() out of
convenience does not mean a single rlimit for both is appropriate.


>> > For classic BPF filters attached with
>> > setsockopt SO_ATTACH_FILTER, there is no memlock rlimit check to limit the
>> > number of insertions like there is for the bpf syscall.
>> >
>> > This patch adds a per user rlimit for module space, as well as a system wide
>> > limit for BPF JIT. In a previously reviewed patchset, Jann Horn pointed out
>> > the
>> > problem that in some cases a user can get access to 65536 UIDs, so the
>> > effective
>> > limit cannot be set low enough to stop an attacker and be useful for the
>> > general
>> > case. A discussed alternative solution was a system wide limit for BPF JIT
>> > filters. This much more simply resolves the problem of exhaustion and
>> > de-randomizing in the case of non-CONFIG_BPF_JIT_ALWAYS_ON. If
>> > CONFIG_BPF_JIT_ALWAYS_ON is on however, BPF insertions will fail if another
>> > user
>> > exhausts the BPF JIT limit. In this case a per user limit is still needed.
>> > If
>> > the subuid facility is disabled for normal users, this should still be ok
>> > because the higher limit will not be able to be worked aroThey might und
>> > that way.
>> >
>> > The new BPF JIT limit can be set like this:
>> > echo 5000000 > /proc/sys/net/core/bpf_jit_limit
>> >
>> > So I *think* this patchset should resolve that issue except for the
>> > configuration of CONFIG_BPF_JIT_ALWAYS_ON and subuid allowed for normal
>> > users.
>> > Better module space KASLR is another way to resolve the de-randomizing
>> > issue,
>> > and so then you would just be left with the BPF DOS in that configuration.
>> >
>> > Jann also pointed out how, with purposely fragmenting the module space, you
>> > could make the effective module space blockage area much larger. This is
>> > also
>> > somewhat un-resolved. The impact would depend on how big of a space you are
>> > trying to allocate. The limit has been lowered on x86_64 so that at least
>> > typical sized BPF filters cannot be blocked.
>> >
>> > If anyone with more experience with subuid/user namespaces has any
>> > suggestions
>> > I'd be glad to hear. On an Ubuntu machine it didn't seem like a un-
>> > privileged
>> > user could do this. I am going to keep working on this and see if I can find
>> > a
>> > better solution.
>> >
>> > Changes since v2:
>> >  - System wide BPF JIT limit (discussion with Jann Horn)
>> >  - Holding reference to user correctly (Jann)
>> >  - Having arch versions of modulde_alloc (Dave Hansen, Jessica Yu)
>> >  - Shrinking of default limits, to help prevent the limit being worked
>> > around
>> >    with fragmentation (Jann)
>> >
>> > Changes since v1:
>> >  - Plug in for non-x86
>> >  - Arch specific default values
>> >
>> >
>> > Rick Edgecombe (3):
>> >   modules: Create arch versions of module alloc/free
>> >   modules: Create rlimit for module space
>> >   bpf: Add system wide BPF JIT limit
>> >
>> >  arch/arm/kernel/module.c                |   2 +-
>> >  arch/arm64/kernel/module.c              |   2 +-
>> >  arch/mips/kernel/module.c               |   2 +-
>> >  arch/nds32/kernel/module.c              |   2 +-
>> >  arch/nios2/kernel/module.c              |   4 +-
>> >  arch/parisc/kernel/module.c             |   2 +-
>> >  arch/s390/kernel/module.c               |   2 +-
>> >  arch/sparc/kernel/module.c              |   2 +-
>> >  arch/unicore32/kernel/module.c          |   2 +-
>> >  arch/x86/include/asm/pgtable_32_types.h |   3 +
>> >  arch/x86/include/asm/pgtable_64_types.h |   2 +
>> >  arch/x86/kernel/module.c                |   2 +-
>> >  fs/proc/base.c                          |   1 +
>> >  include/asm-generic/resource.h          |   8 ++
>> >  include/linux/bpf.h                     |   7 ++
>> >  include/linux/filter.h                  |   1 +
>> >  include/linux/sched/user.h              |   4 +
>> >  include/uapi/asm-generic/resource.h     |   3 +-
>> >  kernel/bpf/core.c                       |  22 +++-
>> >  kernel/bpf/inode.c                      |  16 +++
>> >  kernel/module.c                         | 152 +++++++++++++++++++++++-
>> >  net/core/sysctl_net_core.c              |   7 ++
>> >  22 files changed, 233 insertions(+), 15 deletions(-)
>> >
>> > --
>> > 2.17.1
>> >
> branching predictors may not be able to predict past a certain distance. So
> performance as well.
