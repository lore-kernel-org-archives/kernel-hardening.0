MIME-Version: 1.0
References: <20190327145331.215360-1-joel@joelfernandes.org>
In-Reply-To: <20190327145331.215360-1-joel@joelfernandes.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 27 Mar 2019 17:06:04 -0700
Message-ID: <CAGXu5j+nhsL_s36R0k5APUfP6cNiH-BGEJu6mV6UcsP0i3gtyA@mail.gmail.com>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
Content-Type: text/plain; charset="UTF-8"
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, Oleg Nesterov <oleg@redhat.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 27, 2019 at 7:53 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> struct pid's count is an atomic_t field used as a refcount. Use
> refcount_t for it which is basically atomic_t but does additional
> checking to prevent use-after-free bugs. No change in behavior if
> CONFIG_REFCOUNT_FULL=n.
>
> Cc: keescook@chromium.org
> Cc: kernel-team@android.com
> Cc: kernel-hardening@lists.openwall.com
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> [...]
> diff --git a/kernel/pid.c b/kernel/pid.c
> index 20881598bdfa..2095c7da644d 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -37,7 +37,7 @@
>  #include <linux/init_task.h>
>  #include <linux/syscalls.h>
>  #include <linux/proc_ns.h>
> -#include <linux/proc_fs.h>
> +#include <linux/refcount.h>
>  #include <linux/sched/task.h>
>  #include <linux/idr.h>
>
> @@ -106,8 +106,8 @@ void put_pid(struct pid *pid)
>                 return;
>
>         ns = pid->numbers[pid->level].ns;
> -       if ((atomic_read(&pid->count) == 1) ||
> -            atomic_dec_and_test(&pid->count)) {
> +       if ((refcount_read(&pid->count) == 1) ||
> +            refcount_dec_and_test(&pid->count)) {

Why is this (and the original code) safe in the face of a race against
get_pid()? i.e. shouldn't this only use refcount_dec_and_test()? I
don't see this code pattern anywhere else in the kernel.

Beyond that, yes please. :)

-Kees


>                 kmem_cache_free(ns->pid_cachep, pid);
>                 put_pid_ns(ns);
>         }
> @@ -210,7 +210,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>         }
>
>         get_pid_ns(ns);
> -       atomic_set(&pid->count, 1);
> +       refcount_set(&pid->count, 1);
>         for (type = 0; type < PIDTYPE_MAX; ++type)
>                 INIT_HLIST_HEAD(&pid->tasks[type]);
>
> --
> 2.21.0.392.gf8f6787159e-goog
>


--
Kees Cook
