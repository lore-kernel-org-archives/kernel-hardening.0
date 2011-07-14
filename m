Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 14 Jul 2011 19:55:22 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110714155521.GA5024@albatros>
References: <20110714152233.GA30181@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714152233.GA30181@openwall.com>
Subject: Re: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Thu, Jul 14, 2011 at 19:22 +0400, Solar Designer wrote:
> On Tue, Jul 12, 2011 at 05:27:23PM +0400, Vasiliy Kulikov wrote:
> > +	const struct cred *cred = current_cred();
> > +
> > +	/*
> > +	 * We check for RLIMIT_NPROC in execve() instead of set_user() because
> > +	 * too many poorly written programs don't check setuid() return code.
> > +	 * The check in execve() does the same thing for programs doing
> > +	 * setuid()+execve(), but without similar security issues.
> > +	 */
> > +	if (atomic_read(&cred->user->processes) > rlimit(RLIMIT_NPROC) &&
> > +	    cred->user != INIT_USER) {
> > +		retval = -EAGAIN;
> > +		goto out_ret;
> > +	}
> 
> Is cred->user == NULL impossible here?  Somehow I had a check for NULL
> here in -ow patches (for older kernels), maybe out of paranoia or maybe
> for specific reasons (I don't recall).

It is not checked in copy_process(), which is the same kind of syscalls,
I don't see how it can be NULL here.

> > +++ b/kernel/sys.c
> > @@ -591,12 +591,6 @@ static int set_user(struct cred *new)
> >  	if (!new_user)
> >  		return -EAGAIN;
> >  
> > -	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
> > -			new_user != INIT_USER) {
> > -		free_uid(new_user);
> > -		return -EAGAIN;
> > -	}
> 
> So you're moving the check almost literally.  However, I think a similar
> check on fork() also checked "!capable(CAP_SYS_ADMIN) &&
> !capable(CAP_SYS_RESOURCE)", and I had this additional check/bypass
> included in -ow patches' execve().

Oh, right.  I also noted these cap checks while observing -ow and
-grsecurity patches, but somehow missed them now.  As you see, there
already was such inconsistency in setuid() case.  I don't know what is a
right way - either copy setuid's blind way or immitate fork's pedantic
checks.

However, I really don't see any need in CAP_SYS_ADMIN check - if it is
to be sure some core system process has not suffocated then it simply
should reset RLIMIT_NPROC and that's all.


Thanks,

-- 
Vasiliy
