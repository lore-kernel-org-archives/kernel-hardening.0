Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 20:02:43 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128190243.gp3ner27uhsnnjpb@gmail.com>
References: <cover.1517164461.git.luto@kernel.org>
 <03148bcc1b217100e6e8ecf6a5468c45cf4304b6.1517164461.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03148bcc1b217100e6e8ecf6a5468c45cf4304b6.1517164461.git.luto@kernel.org>
Subject: [kernel-hardening] Re: [PATCH 2/3] x86/asm: Move 'status' from thread_struct to
 thread_info
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@kernel.org> wrote:

> The TS_COMPAT bit is very hot and is accessed from code paths that
> mostly also touch thread_info::flags.  Move it into struct
> thread_info to improve cache locality.
> 
> The only reason it was in thread_struct is that there was a brief
> period during which we didn't allow arch-specific fields in struct
> thread_info.
> 
> Linus suggested further changing:
> 
>   ti->status &= ~(TS_COMPAT|TS_I386_REGS_POKED);
> 
> to:
> 
>   if (unlikely(ti->status & (TS_COMPAT|TS_I386_REGS_POKED)))
>           ti->status &= ~(TS_COMPAT|TS_I386_REGS_POKED);
> 
> on the theory that frequently dirtying the cacheline even in pure
> 64-bit code that never needs to modify status hurts performance.
> That could be a reasonable followup patch, but I suspect it matters
> less on top of this patch.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/entry/common.c            | 4 ++--
>  arch/x86/include/asm/processor.h   | 2 --
>  arch/x86/include/asm/syscall.h     | 6 +++---
>  arch/x86/include/asm/thread_info.h | 3 ++-
>  arch/x86/kernel/process_64.c       | 4 ++--
>  arch/x86/kernel/ptrace.c           | 2 +-
>  arch/x86/kernel/signal.c           | 2 +-
>  7 files changed, 11 insertions(+), 12 deletions(-)

Reviewed-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
