MIME-Version: 1.0
In-Reply-To: <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com> <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu, 20 Apr 2017 00:38:56 +0200
Message-ID: <CAEiveUdjiKg586M2GUTeOJMR5k5QtwDmHX9T8MZvkcAaR+_AOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 2/2] modules:capabilities: add a per-task modules
 autoload restriction
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, LSM List <linux-security-module@vger.kernel.org>
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, Zendyani <zendyani@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 20, 2017 at 12:20 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
[...]
> +/* Returns task's modules_autoload */
> +static inline void task_copy_modules_autoload(struct task_struct *dest,
> +                                             struct task_struct *src)
> +{
> +       dest->modules_autoload = src->modules_autoload;
> +}

Kees Cook just pointed out that this hook is not needed since we
already dup everything from parent to child.


[...]
>
> diff --git a/include/linux/security.h b/include/linux/security.h
> index e274bb11..9581cc5 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -866,7 +866,7 @@ static inline int security_task_create(unsigned long clone_flags)
>  static inline int security_task_alloc(struct task_struct *task,
>                                       unsigned long clone_flags)
>  {
> -       return 0;
> +       return cap_task_alloc(task, clone_flags);
>  }

Will remove it in next iteration.


>  static inline void security_task_free(struct task_struct *task)
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index a8d0759..0244264 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -197,4 +197,12 @@ struct prctl_mm_map {
>  # define PR_CAP_AMBIENT_LOWER          3
>  # define PR_CAP_AMBIENT_CLEAR_ALL      4
>
> +/*
> + * Control the per-task "modules_autoload" access.
> + *
> + * See Documentation/prctl/modules_autoload.txt for more details.
> + */
> +#define PR_SET_MODULES_AUTOLOAD                48
> +#define PR_GET_MODULES_AUTOLOAD                49
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 81347bd..141e06b 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1695,6 +1695,10 @@ static __latent_entropy struct task_struct *copy_process(
>         p->sequential_io_avg    = 0;
>  #endif
>
> +#ifdef CONFIG_MODULES
> +       p->modules_autoload     = 0;
> +#endif
> +
>         /* Perform scheduler related setup. Assign this task to a CPU. */
>         retval = sched_fork(clone_flags, p);
>         if (retval)
> diff --git a/kernel/module.c b/kernel/module.c
> index 54cb6e0..e1eca74 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -4313,19 +4313,24 @@ static int modules_autoload_privileged_access(const char *name)
>  }
>
>  /**
> - * modules_autoload_access - Determine whether a module auto-load is permitted
> + * modules_autoload_access - Determine whether the task is allowed to perform a
> + *                          module auto-load request
> + * @task: The task performing the request
>   * @kmod_name: The module name
>   *
> - * Determine whether a module should be automatically loaded or not. The check
> - * uses the sysctl "modules_autoload" value.
> + * Determine whether the task is allowed to perform a module auto-load request.
> + * This checks the per-task "modules_autoload" flag, if the access is not denied,
> + * then the global sysctl "modules_autoload" is evaluated.
>   *
>   * Returns 0 if the module request is allowed or -EPERM if not.
>   */
> -int modules_autoload_access(char *kmod_name)
> +int modules_autoload_access(struct task_struct *task, char *kmod_name)
>  {
> -       if (modules_autoload == MODULES_AUTOLOAD_ALLOWED)
> +       unsigned int autoload = max_t(unsigned int,
> +                                     modules_autoload, task->modules_autoload);
> +       if (autoload == MODULES_AUTOLOAD_ALLOWED)
>                 return 0;
> -       else if (modules_autoload == MODULES_AUTOLOAD_PRIVILEGED)
> +       else if (autoload == MODULES_AUTOLOAD_PRIVILEGED)
>                 return modules_autoload_privileged_access(kmod_name);
>
>         /* MODULES_AUTOLOAD_DISABLED */
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 67a6cfe..bcc1e09 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -886,6 +886,40 @@ static int cap_prctl_drop(unsigned long cap)
>         return commit_creds(new);
>  }
>
> +static int pr_set_mod_autoload(unsigned long arg2, unsigned long arg3,
> +                              unsigned long arg4, unsigned long arg5)
> +{
> +       if (arg3 || arg4 || arg5)
> +               return -EINVAL;
> +
> +       return task_set_modules_autoload(current, arg2);
> +}
> +
> +static inline int pr_get_mod_autoload(unsigned long arg2, unsigned long arg3,
> +                                     unsigned long arg4, unsigned long arg5)
> +{
> +       if (arg2 || arg3 || arg4 || arg5)
> +               return -EINVAL;
> +
> +       return task_modules_autoload(current);
> +}
> +
> +/**
> + * cap_task_alloc - Implement process context allocation for this security module
> + * @task: task being allocated
> + * @clone_flags: contains the clone flags indicating what should be shared.
> + *
> + * Allocate or initialize the task context for this security module.
> + *
> + * Returns 0.
> + */
> +int cap_task_alloc(struct task_struct *task, unsigned long clone_flags)
> +{
> +       task_copy_modules_autoload(task, current);
> +
> +       return 0;
> +}

All the calls to initialize task->modules_autoload or dup its value
using the task_alloc will be removed in next iteration as pointed out
by Kees.

Thanks!

-- 
tixxdz
