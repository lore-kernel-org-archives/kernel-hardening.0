Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 19 Jun 2011 17:34:35 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110619133435.GA2670@albatros>
References: <20110609141745.GA11957@albatros>
 <20110612022833.GB14976@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612022833.GB14976@openwall.com>
Subject: Re: [kernel-hardening] rlimit_nproc check
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 12, 2011 at 06:28 +0400, Solar Designer wrote:
> Right.  Dealing with setuid() failing to drop privs yet returning, which
> many apps don't expect, is definitely something we (you) need to do
> under this project.  In Linux 2.4.x-ow, I simply do:
> 
> --- linux-2.4.37.9.orig/kernel/sys.c	2010-02-01 21:04:46 +0000
> +++ linux-2.4.37.9/kernel/sys.c	2010-02-18 14:04:42 +0000
> @@ -514,8 +514,10 @@ static int set_user(uid_t new_ruid, int 
>  	struct user_struct *new_user;
>  
>  	new_user = alloc_uid(new_ruid);
> -	if (!new_user)
> +	if (!new_user) {
> +		force_sig(SIGSEGV, current);
>  		return -EAGAIN;
> +	}
>  	switch_uid(new_user);
>  
>  	if(dumpclear)
> 
> As an option, you could propose to revert that 8-year old change and
> introduce the check on execve().  Unrealistic?

I have slightly another idea.  Introduce mechanism (e.g. sysctl
variable) to make all capabilities dropping function cause SIGSEGV if
actual dropping process fails for any of several reasons.

The initial list should look like this:

    set*{u,g}id
    {set,init}groups
    unshare
    prctl(PR_CAPBSET_DROP, ...)
    prctl(PR_SET_SECCOMP, ...)
    capset

But any such list looks a bit not complete because there are many
different functions that might drop some capabilities in some
situations, like close(), *chdir(), rlimit(), nice(), fcntl(), ioctl(),
chroot(), which are, well, might fail in very common situations without
any actual secuity risk.

So, IMO this solution might not be enough consistent for upstream
inclusion.


Thanks,

-- 
Vasiliy
