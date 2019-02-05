Date: Tue, 5 Feb 2019 09:53:11 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 04/20] fork: provide a function for copying init_mm
Message-ID: <20190205085311.GH21801@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-5-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190129003422.9328-5-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 28, 2019 at 04:34:06PM -0800, Rick Edgecombe wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Provide a function for copying init_mm. This function will be later used
> for setting a temporary mm.
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
> Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  include/linux/sched/task.h |  1 +
>  kernel/fork.c              | 24 ++++++++++++++++++------
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
> index 44c6f15800ff..c5a00a7b3beb 100644
> --- a/include/linux/sched/task.h
> +++ b/include/linux/sched/task.h
> @@ -76,6 +76,7 @@ extern void exit_itimers(struct signal_struct *);
>  extern long _do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *, unsigned long);
>  extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
>  struct task_struct *fork_idle(int);
> +struct mm_struct *copy_init_mm(void);
>  extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
>  extern long kernel_wait4(pid_t, int __user *, int, struct rusage *);
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b69248e6f0e0..d7b156c49f29 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1299,13 +1299,20 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>  		complete_vfork_done(tsk);
>  }
>  
> -/*
> - * Allocate a new mm structure and copy contents from the
> - * mm structure of the passed in task structure.
> +/**
> + * dup_mm() - duplicates an existing mm structure
> + * @tsk: the task_struct with which the new mm will be associated.
> + * @oldmm: the mm to duplicate.
> + *
> + * Allocates a new mm structure and copy contents from the provided

s/copy/copies/

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
