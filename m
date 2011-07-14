Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Jul 2011 19:22:33 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110714152233.GA30181@openwall.com>
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros> <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com> <20110706185932.GB3299@albatros> <20110707075610.GA3411@albatros> <20110707081930.GA4393@albatros> <20110712132723.GA3193@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712132723.GA3193@albatros>
Subject: Re: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Tue, Jul 12, 2011 at 05:27:23PM +0400, Vasiliy Kulikov wrote:
> +	const struct cred *cred = current_cred();
> +
> +	/*
> +	 * We check for RLIMIT_NPROC in execve() instead of set_user() because
> +	 * too many poorly written programs don't check setuid() return code.
> +	 * The check in execve() does the same thing for programs doing
> +	 * setuid()+execve(), but without similar security issues.
> +	 */
> +	if (atomic_read(&cred->user->processes) > rlimit(RLIMIT_NPROC) &&
> +	    cred->user != INIT_USER) {
> +		retval = -EAGAIN;
> +		goto out_ret;
> +	}

Is cred->user == NULL impossible here?  Somehow I had a check for NULL
here in -ow patches (for older kernels), maybe out of paranoia or maybe
for specific reasons (I don't recall).

> +++ b/kernel/sys.c
> @@ -591,12 +591,6 @@ static int set_user(struct cred *new)
>  	if (!new_user)
>  		return -EAGAIN;
>  
> -	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
> -			new_user != INIT_USER) {
> -		free_uid(new_user);
> -		return -EAGAIN;
> -	}

So you're moving the check almost literally.  However, I think a similar
check on fork() also checked "!capable(CAP_SYS_ADMIN) &&
!capable(CAP_SYS_RESOURCE)", and I had this additional check/bypass
included in -ow patches' execve().  This discrepancy between the two
checks (one allows capable processes to bypass it, the other does not)
is seen in Neil's commit you referenced:

http://lkml.org/lkml/2003/7/13/226

So maybe it was intentional, or maybe it was overlooked.  I don't care
about this much, but I thought I'd point it out.

Thanks,

Alexander
