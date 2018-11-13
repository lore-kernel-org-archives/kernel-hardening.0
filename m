MIME-Version: 1.0
In-Reply-To: <1542056928-10917-1-git-send-email-alex.popov@linux.com>
References: <1542056928-10917-1-git-send-email-alex.popov@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 13 Nov 2018 14:06:53 -0600
Message-ID: <CAGXu5jK-sQ4tAs0k-SST0NCoW8RgTmq9KHo97eGdN+57at5qQg@mail.gmail.com>
Subject: Re: [PATCH 1/1] stackleak: Disable function tracing and kprobes for stackleak_erase()
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Masami Hiramatsu <mhiramat@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 12, 2018 at 3:08 PM, Alexander Popov <alex.popov@linux.com> wrote:
> The stackleak_erase() function is called on the trampoline stack at the end
> of syscall. This stack is not big enough for ftrace and kprobes operations,
> e.g. it can be exhausted if we use kprobe_events for stackleak_erase().
>
> So let's disable function tracing and kprobes for stackleak_erase().
>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

Thanks! I'll get this into my tree.

-Kees

> ---
>  kernel/stackleak.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/stackleak.c b/kernel/stackleak.c
> index e428929..08cb57e 100644
> --- a/kernel/stackleak.c
> +++ b/kernel/stackleak.c
> @@ -11,6 +11,7 @@
>   */
>
>  #include <linux/stackleak.h>
> +#include <linux/kprobes.h>
>
>  #ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
>  #include <linux/jump_label.h>
> @@ -47,7 +48,7 @@ int stack_erasing_sysctl(struct ctl_table *table, int write,
>  #define skip_erasing() false
>  #endif /* CONFIG_STACKLEAK_RUNTIME_DISABLE */
>
> -asmlinkage void stackleak_erase(void)
> +asmlinkage void notrace stackleak_erase(void)
>  {
>         /* It would be nice not to have 'kstack_ptr' and 'boundary' on stack */
>         unsigned long kstack_ptr = current->lowest_stack;
> @@ -101,6 +102,7 @@ asmlinkage void stackleak_erase(void)
>         /* Reset the 'lowest_stack' value for the next syscall */
>         current->lowest_stack = current_top_of_stack() - THREAD_SIZE/64;
>  }
> +NOKPROBE_SYMBOL(stackleak_erase);
>
>  void __used stackleak_track_stack(void)
>  {
> --
> 2.7.4
>



-- 
Kees Cook
