Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <ec58e505925c46bd43f9c4275c78292d4483af16.1466974736.git.luto@kernel.org>
References: <cover.1466974736.git.luto@kernel.org> <ec58e505925c46bd43f9c4275c78292d4483af16.1466974736.git.luto@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 26 Jun 2016 19:35:11 -0700
Message-ID: <CALCETrVFC+X6uLe-ce7BePBTM5zCnAUn_vV73jyS-evTbmg6PA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 28/29] sched: Free the stack early if CONFIG_THREAD_INFO_IN_TASK
To: Andy Lutomirski <luto@kernel.org>
Cc: X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 2:55 PM, Andy Lutomirski <luto@kernel.org> wrote:
> We currently keep every task's stack around until the task_struct
> itself is freed.  This means that we keep the stack allocation alive
> for longer than necessary and that, under load, we free stacks in
> big batches whenever RCU drops the last task reference.  Neither of
> these is good for reuse of cache-hot memory, and freeing in batches
> prevents us from usefully caching small numbers of vmalloced stacks.
>
> On architectures that have thread_info on the stack, we can't easily
> change this, but on architectures that set THREAD_INFO_IN_TASK, we
> can free it as soon as the task is dead.

This is broken:

> -void free_task(struct task_struct *tsk)
> +void release_task_stack(struct task_struct *tsk)
>  {
>         account_kernel_stack(tsk, -1);
>         arch_release_thread_stack(tsk->stack);
>         free_thread_stack(tsk);
> +       tsk->stack = NULL;
> +#ifdef CONFIG_VMAP_STACK
> +       tsk->stack_vm_area = NULL;
> +#endif
> +}
> +
> +void free_task(struct task_struct *tsk)
> +{
> +#ifndef CONFIG_THREAD_INFO_IN_TASK
> +       /*
> +        * The task is finally done with both the stack and thread_info,
> +        * so free both.
> +        */
> +       release_task_stack(tsk);
> +#else
> +       /*
> +        * If the task had a separate stack allocation, it should be gone
> +        * by now.
> +        */
> +       WARN_ON_ONCE(tsk->stack);
> +#endif

We can get to free_task without first going through TASK_DEAD if we
fail to clone().  I'm inclined to make release_task_stack be safe to
call more than once and to call it unconditionally in free_task, since
doing it without branches (calling release_task_stack in the
copy_process failure path) will require more ifdeffery and sounds like
more trouble than it's worth.

--Andy
