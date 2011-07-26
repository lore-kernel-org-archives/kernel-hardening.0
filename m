Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jul 2011 10:47:13 +1000
From: NeilBrown <neilb@suse.de>
Message-ID: <20110726104713.37273143@notabene.brown>
In-Reply-To: <20110725234013.GB24110@openwall.com>
References: <20110715170650.585f1dad@notabene.brown>
	<20110715073823.GA3821@albatros>
	<1310738313.30257.27.camel@moss-pluto>
	<20110715152641.GA6286@albatros>
	<1310759683.30257.123.camel@moss-pluto>
	<20110721140936.632d2c8b@notabene.brown>
	<20110721124830.GA1325@openwall.com>
	<CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
	<20110721193939.GA3914@openwall.com>
	<20110725171423.GA3739@albatros>
	<20110725234013.GB24110@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: Solar Designer <solar@openwall.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Smalley <sds@tycho.nsa.gov>, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 26 Jul 2011 03:40:13 +0400 Solar Designer <solar@openwall.com> wrote:

> Vasiliy,
> 
> On Mon, Jul 25, 2011 at 09:14:23PM +0400, Vasiliy Kulikov wrote:
> > @@ -1433,6 +1433,19 @@ static int do_execve_common(const char *filename,
> >  	struct files_struct *displaced;
> >  	bool clear_in_exec;
> >  	int retval;
> > +	const struct cred *cred = current_cred();
> > +
> > +	/*
> > +	 * We move the actual failure in case of RLIMIT_NPROC excess from
> > +	 * set*uid() to execve() because too many poorly written programs
> > +	 * don't check setuid() return code.  Here we additionally recheck
> > +	 * whether NPROC limit is still exceeded.
> > +	 */
> > +	if ((current->flags & PF_NPROC_EXCEEDED) &&
> > +	    atomic_read(&cred->user->processes) > rlimit(RLIMIT_NPROC)) {
> > +		retval = -EAGAIN;
> > +		goto out_ret;
> > +	}
> 
> Do you possibly need:
> 
> 	current->flags &= ~PF_NPROC_EXCEEDED;
> 
> somewhere after this point?
> 
> I think it's weird to have past set_user() failure affect other than the
> very next execve().

So we are hoping that no program uses execvp() or similar...  Maybe that is
reasonable but "in for a penny, in for a pound" - I'd fail them all.

I think the flag should only be cleared once we notice that the limit is no
longer exceeded.  So clearing the flag can appear *after* the code you quote
above, but not in the middle of it.

> 
> Perhaps also reset the flag on fork() because we have an RLIMIT_NPROC
> check on fork() anyway.

I agree it should be cleared here too.

> 
> Thanks,
> 
> Alexander


But there is still the issue of 'zygot' like services....

Let me try another suggestion.  Instead of catching the error in
do_execve_common, how about we catch it in do_mmap_pgoff.
i.e. if the flag is set and an attempt it made to create an executable
mapping, we check the user->processes against the limit then - either failing
or clearing the flag and succeeding.

This will stop an execve, and an attempt to load a shared library and call it.

In the case of 'exec' the process will get a SIGKILL as well, which is
probably a good thing.

Thoughts?

NeilBrown
