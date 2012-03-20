Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 20 Mar 2012 08:31:41 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
Message-ID: <20120320133141.GC2918@peqn>
References: <20120319231253.GA20893@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319231253.GA20893@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH] futex: do not leak robust list to unprivileged process
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Darren Hart <dvhart@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net, mingo@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Kees Cook (keescook@chromium.org):
> It was possible to extract the robust list head address from a setuid
> process if it had used set_robust_list(), allowing an ASLR info leak. This
> changes the permission checks to be the same as those used for similar
> info that comes out of /proc.
> 
> Running a setuid program that uses robust futexes would have had:
>   cred->euid != pcred->euid
>   cred->euid == pcred->uid
> so the old permissions check would allow it. I'm not aware of any setuid
> programs that use robust futexes, so this is just a preventative measure.
> 
> (This patch is based on changes from grsecurity.)
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

I like the change.  Much cleaner.  I'm not 100% sure though that
there are no legitimate cases of robust futexes use which would now
be forbidden.  (Explicitly cc:ing Ingo)

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/futex.c        |   36 +++++++++++++-----------------------
>  kernel/futex_compat.c |   36 +++++++++++++-----------------------
>  2 files changed, 26 insertions(+), 46 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 1614be2..439440d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -59,6 +59,7 @@
>  #include <linux/magic.h>
>  #include <linux/pid.h>
>  #include <linux/nsproxy.h>
> +#include <linux/ptrace.h>
>  
>  #include <asm/futex.h>
>  
> @@ -2443,40 +2444,29 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
>  {
>  	struct robust_list_head __user *head;
>  	unsigned long ret;
> -	const struct cred *cred = current_cred(), *pcred;
> +	struct task_struct *p;
>  
>  	if (!futex_cmpxchg_enabled)
>  		return -ENOSYS;
>  
> +	rcu_read_lock();
> +
> +	ret = -ESRCH;
>  	if (!pid)
> -		head = current->robust_list;
> +		p = current;
>  	else {
> -		struct task_struct *p;
> -
> -		ret = -ESRCH;
> -		rcu_read_lock();
>  		p = find_task_by_vpid(pid);
>  		if (!p)
>  			goto err_unlock;
> -		ret = -EPERM;
> -		pcred = __task_cred(p);
> -		/* If victim is in different user_ns, then uids are not
> -		   comparable, so we must have CAP_SYS_PTRACE */
> -		if (cred->user->user_ns != pcred->user->user_ns) {
> -			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
> -				goto err_unlock;
> -			goto ok;
> -		}
> -		/* If victim is in same user_ns, then uids are comparable */
> -		if (cred->euid != pcred->euid &&
> -		    cred->euid != pcred->uid &&
> -		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
> -			goto err_unlock;
> -ok:
> -		head = p->robust_list;
> -		rcu_read_unlock();
>  	}
>  
> +	ret = -EPERM;
> +	if (!ptrace_may_access(p, PTRACE_MODE_READ))
> +		goto err_unlock;
> +
> +	head = p->robust_list;
> +	rcu_read_unlock();
> +
>  	if (put_user(sizeof(*head), len_ptr))
>  		return -EFAULT;
>  	return put_user(head, head_ptr);
> diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
> index 5f9e689..a9642d5 100644
> --- a/kernel/futex_compat.c
> +++ b/kernel/futex_compat.c
> @@ -10,6 +10,7 @@
>  #include <linux/compat.h>
>  #include <linux/nsproxy.h>
>  #include <linux/futex.h>
> +#include <linux/ptrace.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -136,40 +137,29 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
>  {
>  	struct compat_robust_list_head __user *head;
>  	unsigned long ret;
> -	const struct cred *cred = current_cred(), *pcred;
> +	struct task_struct *p;
>  
>  	if (!futex_cmpxchg_enabled)
>  		return -ENOSYS;
>  
> +	rcu_read_lock();
> +
> +	ret = -ESRCH;
>  	if (!pid)
> -		head = current->compat_robust_list;
> +		p = current;
>  	else {
> -		struct task_struct *p;
> -
> -		ret = -ESRCH;
> -		rcu_read_lock();
>  		p = find_task_by_vpid(pid);
>  		if (!p)
>  			goto err_unlock;
> -		ret = -EPERM;
> -		pcred = __task_cred(p);
> -		/* If victim is in different user_ns, then uids are not
> -		   comparable, so we must have CAP_SYS_PTRACE */
> -		if (cred->user->user_ns != pcred->user->user_ns) {
> -			if (!ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
> -				goto err_unlock;
> -			goto ok;
> -		}
> -		/* If victim is in same user_ns, then uids are comparable */
> -		if (cred->euid != pcred->euid &&
> -		    cred->euid != pcred->uid &&
> -		    !ns_capable(pcred->user->user_ns, CAP_SYS_PTRACE))
> -			goto err_unlock;
> -ok:
> -		head = p->compat_robust_list;
> -		rcu_read_unlock();
>  	}
>  
> +	ret = -EPERM;
> +	if (!ptrace_may_access(p, PTRACE_MODE_READ))
> +		goto err_unlock;
> +
> +	head = p->compat_robust_list;
> +	rcu_read_unlock();
> +
>  	if (put_user(sizeof(*head), len_ptr))
>  		return -EFAULT;
>  	return put_user(ptr_to_compat(head), head_ptr);
> -- 
> 1.7.0.4
> 
