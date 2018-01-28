Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 10:36:38 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128093638.74bzvmmue77spqbb@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703975686.26578.8851773106290279966.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151703975686.26578.8851773106290279966.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 08/12] x86: sanitize sycall table de-references under
 speculation
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>


* Dan Williams <dan.j.williams@intel.com> wrote:

> The syscall table base is a user controlled function pointer in kernel
> space. Use 'array_idx' to prevent any out of bounds speculation. While
> retpoline prevents speculating into a userspace directed target it does
> not stop the pointer de-reference, the concern is leaking memory
> relative to the syscall table base, by observing instruction cache
> behavior.

(The style problems/inconsistencies of the previous patches are repeated here too, 
please fix.)
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/entry/common.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
> index 03505ffbe1b6..f78bf8bfdfae 100644
> --- a/arch/x86/entry/common.c
> +++ b/arch/x86/entry/common.c
> @@ -21,6 +21,7 @@
>  #include <linux/export.h>
>  #include <linux/context_tracking.h>
>  #include <linux/user-return-notifier.h>
> +#include <linux/nospec.h>
>  #include <linux/uprobes.h>
>  #include <linux/livepatch.h>
>  #include <linux/syscalls.h>
> @@ -284,6 +285,7 @@ __visible void do_syscall_64(struct pt_regs *regs)
>  	 * regs->orig_ax, which changes the behavior of some syscalls.
>  	 */
>  	if (likely((nr & __SYSCALL_MASK) < NR_syscalls)) {
> +		nr = array_idx(nr & __SYSCALL_MASK, NR_syscalls);
>  		regs->ax = sys_call_table[nr & __SYSCALL_MASK](
>  			regs->di, regs->si, regs->dx,
>  			regs->r10, regs->r8, regs->r9);

Btw., in the future we could optimize the 64-bit fastpath here, by doing something 
like:

	if (unlikely(nr >= NR_syscalls)) {
		nr = array_idx(nr, NR_syscalls);
		...
	} else {
		if ((nr & __SYSCALL_MASK) < NR_syscalls) {
			... X32 ABI ...
		} else {
			... error ...
		}
	}

This would remove 2-3 instructions from the 64-bit syscall fast-path I believe, by 
pushing the x32 details to a slow-path.

But obviously that should not be part of the Spectre series.

Thanks,

	Ingo
