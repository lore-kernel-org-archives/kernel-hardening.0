MIME-Version: 1.0
In-Reply-To: <20180828201421.157735-1-jannh@google.com>
References: <20180828201421.157735-1-jannh@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Aug 2018 14:51:51 -0700
Message-ID: <CAGXu5jLHRzMMbpUmcFP3hqXamUsWkCAwnoQgEp3xaZ-_R9yzXQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] x86: BUG() on #GP / kernel #PF in uaccess
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Masami Hiramatsu <mhiramat@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Alexander Viro <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 28, 2018 at 1:14 PM, Jann Horn <jannh@google.com> wrote:
> This is the third version of "[RFC PATCH 1/2] x86: WARN() when uaccess
> helpers fault on kernel addresses".
>
> Changes since v2:
>  - patch 1: avoid unnecessary branch on return value and split up the
>    checks (Borislav Petkov)
>  - patch 5: really plumb the error code through to the handlers (Andy)
>  - patch 6: whitelist exact_copy_from_user(), at least for now - the
>    alternative would be a somewhat complicated refactor (Kees Cook)
>
> Expanding on the change in patch 6:
> I believe that for now, whitelisting exact_copy_from_user() is
> acceptable, since there aren't many places that call ksys_mount() under
> KERNEL_DS.
> I very much dislike copy_mount_options()/exact_copy_from_user() and want
> to do something about that code at some point - in particular because it
> currently silently truncates mount options, which seems like a bad idea
> security-wise
> (https://github.com/libfuse/libfuse/commit/34c62ee90c69) -, but I don't
> want to block this series on that.
>
> I hope that exact_copy_from_user() was the only place that does this
> kind of thing under KERNEL_DS - if there might be more places like this,
> it may be necessary for now to change the "return true;" in
> bogus_uaccess() to "WARN(1, ...); return false;" for now, and make it a
> "return true" later. Does anyone have opinions on this?
>
> This time I've actually also boot-tested a build with vmapped stack, not
> just a KASAN build. (It's annoying that those are mutually exclusive...)
> Kees, I hope you can cleanly boot with this series applied now?
>
>
> See patch 6/7 ("x86: BUG() when uaccess helpers fault on kernel
> addresses") for a description of the motivation for this series.
>
> Patches 1 and 2 are cleanups that I did while working on this
> series, but the series doesn't depend on them. (I first thought these
> cleanups were necessary for the rest of the series, then noticed that
> they actually aren't, but decided to keep them since cleanups are good
> anyway.)
>
> Patches 3, 4 and 5 are prep work; 4 and 5 are loosely based on code
> from the v1 patch. They've changed quite a bit though.
>
> Patch 6 is the main semantic change.
>
> Patch 7 is a small testcase for verifying that patch 6 works.
>
> Jann Horn (7):
>   x86: refactor kprobes_fault() like kprobe_exceptions_notify()
>   x86: inline kprobe_exceptions_notify() into do_general_protection()
>   x86: stop calling fixup_exception() from kprobe_fault_handler()
>   x86: introduce _ASM_EXTABLE_UA for uaccess fixups
>   x86: plumb error code and fault address through to fault handlers
>   x86: BUG() when uaccess helpers fault on kernel addresses
>   lkdtm: test copy_to_user() on bad kernel pointer under KERNEL_DS

I've done boot tests and tried probing it the earlier waitid() flaw
with the fix reverted and it correctly Oops when touching unmapped
kernel memory. Please consider the series:

Tested-by: Kees Cook <keescook@chromium.org>

-Kees

>
>  arch/x86/include/asm/asm.h          |  10 ++-
>  arch/x86/include/asm/extable.h      |   3 +-
>  arch/x86/include/asm/fpu/internal.h |   2 +-
>  arch/x86/include/asm/futex.h        |   6 +-
>  arch/x86/include/asm/ptrace.h       |   2 +
>  arch/x86/include/asm/uaccess.h      |  22 ++---
>  arch/x86/kernel/cpu/mcheck/mce.c    |   2 +-
>  arch/x86/kernel/kprobes/core.c      |  38 +--------
>  arch/x86/kernel/traps.c             |  16 +++-
>  arch/x86/lib/checksum_32.S          |   4 +-
>  arch/x86/lib/copy_user_64.S         |  90 ++++++++++----------
>  arch/x86/lib/csum-copy_64.S         |   8 +-
>  arch/x86/lib/getuser.S              |  12 +--
>  arch/x86/lib/putuser.S              |  10 +--
>  arch/x86/lib/usercopy_32.c          | 126 ++++++++++++++--------------
>  arch/x86/lib/usercopy_64.c          |   4 +-
>  arch/x86/mm/extable.c               | 114 +++++++++++++++++++++----
>  arch/x86/mm/fault.c                 |  26 +++---
>  drivers/misc/lkdtm/core.c           |   1 +
>  drivers/misc/lkdtm/lkdtm.h          |   1 +
>  drivers/misc/lkdtm/usercopy.c       |  13 +++
>  fs/namespace.c                      |   2 +
>  include/linux/sched.h               |   6 ++
>  mm/maccess.c                        |   6 ++
>  24 files changed, 314 insertions(+), 210 deletions(-)
>
> --
> 2.19.0.rc0.228.g281dcd1b4d0-goog
>



-- 
Kees Cook
Pixel Security
