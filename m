Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 24 Feb 2012 04:56:13 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120224005613.GA32733@openwall.com>
References: <20120210020658.GA17709@dztty> <20120210143616.GA6100@albatros> <20120221145653.GA22597@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120221145653.GA22597@openwall.com>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

Brad, all -

On Tue, Feb 21, 2012 at 06:56:53PM +0400, Solar Designer wrote:
> On Fri, Feb 10, 2012 at 06:36:17PM +0400, Vasiliy Kulikov wrote:
> > [1] http://grsecurity.net/~spender/dev_patches/distros_should_sponsor_me_for_doing_their_jobs.patch
...
> Are there any other known issues with this patch (or approach)?
> 
> A newer revision of it maybe (e.g. what's merged in grsecurity patch)?
> I am just guessing.

I've just reviewed revisions of this patch as included in
grsecurity-2.2.2-2.6.32.57-201202200919.patch and
grsecurity-2.2.2-3.2.7-201202202005.patch.  Here are a few observations:

1. The grsecurity patch for 2.6.32.x appears to need the counter
increment introduced into fs/compat.c: compat_do_execve().  It is
currently missing that, so I guess the protection is bypassable on
64-bit kernels with 32-bit syscall wrappers present (only if the system
also has a suitable 32-bit SUID/SGID/fscaps-enabled binary).

2. /proc/<pid>/mem appears to be excluded from this protection - any
special reason why?  I expected it to be one of the primary targets of
this protection.

3. These grsecurity patch revisions actually include a newer revision of
distros_should_sponsor_me_for_doing_their_jobs.patch.  Notably, copying
of exec_id has been added to kernel/fork.c: copy_process().  I wonder
why such explicit copying was needed and whether it is possibly a no-op
given that this same function does:

	p = dup_task_struct(current);

which appears to boil down to:

int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
                                               struct task_struct *src)
{
	*dst = *src;
	return 0;
}

OK, that's a weak alias, so perhaps some archs override it and somehow
don't copy that added field?  This doesn't appear to be the case in
2.6.32.57 (the alias is only overridden for x86, and it does full
copying like above), but maybe it might differ in other versions,
although it'd sound weird if arch_dup_task_struct() didn't copy the
entire struct.

Is this just a better safe than sorry type of thing?  I'm OK with that
if so.

Another change is "long long" to "u64" for the exec_id fields.  I suppose
it's not atomic64_t in order to avoid unnecessarily bringing in volatile.
Looks OK to me.

4. In grsecurity-2.2.2-3.2.7-201202202005.patch, it may be cleaner to
declare global_exec_counter static.  (In the patch for 2.6.32.x, the
counter will also need to be accessed from fs/compat.c, I think.)

As I think is normal for code reviews, I fully expect some or all of the
questions/suggestions above to be dumb. ;-)

I'd appreciate any comments.

Thanks,

Alexander
