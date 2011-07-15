Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 15 Jul 2011 11:38:23 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110715073823.GA3821@albatros>
References: <20110713091408.0d456352@notabene.brown>
 <20110713063142.GA19976@openwall.com>
 <20110713170657.59dae548@notabene.brown>
 <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
 <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
 <20110714112751.1bfd998f@notabene.brown>
 <20110714150602.GA30019@openwall.com>
 <20110715133013.4fa38d19@notabene.brown>
 <20110715063113.GA3166@albatros>
 <20110715170650.585f1dad@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715170650.585f1dad@notabene.brown>
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: NeilBrown <neilb@suse.de>
Cc: kernel-hardening@lists.openwall.com, Solar Designer <solar@openwall.com>, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

Neil,

On Fri, Jul 15, 2011 at 17:06 +1000, NeilBrown wrote:
> How about this then?

AFAIU, with this patch:

1) setuid() doesn't fail in NPROC exceed case.
2) NPROC is forced on execve() after setuid().
3) execve() fails only if NPROC was exceeded during setuid() execution.
4) Other processes of the same user doesn't suffer from "occasional"
execve() failures.

If it is correct, then I like the patch :)  It does RLIMIT_NPROC
enforcement without mixing other execve() calls like -ow patch did.

See minor suggestions about the comments below.


> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Vasiliy Kulikov <segoon@openwall.com>

> diff --git a/fs/exec.c b/fs/exec.c
> index 6075a1e..dfe9c61 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1434,6 +1434,17 @@ static int do_execve_common(const char *filename,
>  	bool clear_in_exec;
>  	int retval;
>  
> +	if (current->flags & PF_NPROC_EXCEEDED) {
> +		/* setuid noticed that RLIMIT_NPROC was
> +		 * exceeded, but didn't fail as that easily
> +		 * leads to privileges leaking.

It doesn't lead to privileges leaking as is, it is a threat of buggy
programs not checking return code of syscalls dropping privileges (setuid here).

>  So fail
> +		 * here instead - we still limit the number of
> +		 * processes running the user's code.
> +		 */
> +		retval = -EAGAIN;
> +		goto out_ret;
> +	}
> +
>  	retval = unshare_files(&displaced);
>  	if (retval)
>  		goto out_ret;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 496770a..f024c63 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1759,6 +1759,7 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
>  #define PF_DUMPCORE	0x00000200	/* dumped core */
>  #define PF_SIGNALED	0x00000400	/* killed by a signal */
>  #define PF_MEMALLOC	0x00000800	/* Allocating memory */
> +#define PF_NPROC_EXCEEDED 0x00001000	/* set_user noticed that RLIMIT_NPROC was exceeded */
>  #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
>  #define PF_FREEZING	0x00004000	/* freeze in progress. do not account to load */
>  #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 174fa84..8ef31f5 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -508,10 +508,8 @@ int commit_creds(struct cred *new)
>  		key_fsgid_changed(task);
>  
>  	/* do it
> -	 * - What if a process setreuid()'s and this brings the
> -	 *   new uid over his NPROC rlimit?  We can check this now
> -	 *   cheaply with the new uid cache, so if it matters
> -	 *   we should be checking for it.  -DaveM
> +	 * RLIMIT_NPROC limits on user->processes have already been checked
> +	 * in set_user().
>  	 */
>  	alter_cred_subscribers(new, 2);
>  	if (new->user != old->user)
> diff --git a/kernel/sys.c b/kernel/sys.c
> index e4128b2..dd1fb9d 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -592,10 +592,9 @@ static int set_user(struct cred *new)
>  		return -EAGAIN;
>  
>  	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
> -			new_user != INIT_USER) {
> -		free_uid(new_user);
> -		return -EAGAIN;
> -	}
> +			new_user != INIT_USER)
> +		/* Cause any subsequent 'exec' to fail */

The comment about why all this bustle is needed is better to put here
because the check is logically belongs to set_user().

Specifically, I'd mention that (1) we don't want setuid() to fail while
having enough privileges and (2) RLIMIT_NPROC can be still harmlessly
checked for programs doing setuid()+execve() if the error code is
deferred to the execve stage.

> +		current->flags |= PF_NPROC_EXCEEDED;
>  
>  	free_uid(new->user);
>  	new->user = new_user;

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
