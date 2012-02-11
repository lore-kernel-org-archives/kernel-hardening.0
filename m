Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 11 Feb 2012 14:21:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20120211102105.GA18464@albatros>
References: <20120210020658.GA17709@dztty>
 <20120210143616.GA6100@albatros>
 <20120211092050.GA18669@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120211092050.GA18669@openwall.com>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 11, 2012 at 13:20 +0400, Solar Designer wrote:
> On Fri, Feb 10, 2012 at 06:36:17PM +0400, Vasiliy Kulikov wrote:
> > On Fri, Feb 10, 2012 at 03:06 +0100, Djalal Harouni wrote:
> > > 2) DAC permissions and suid/guid/privileged programs (userspace):
> > >    This is a list of files that are supposed to be protected:
> > >    /proc/<pid>/maps
> ...
> > I cannot find any solution of (2) except actually add ptrace check at
> > open() time...  Looks like we have to check what specific action glibc 
> > does with /proc/$pid/maps and whitelist these idiotic actions.  I hope
> > it is not arbitrary reads :-)
> 
> I did not look into this closely, but my current understanding is that
> apparently glibc reads the process' own proc files only, and restricting
> their perms to 0400 breaks this if the process changes euid/fsuid during
> its runtime.  Right?

Yes, AFAICS, it looks whether a specific memory area is RW.  But looking
at "grep -r /proc/self/ glibc-sources/" output I can say /proc/self/maps
is not the only file usage which might be broken by open() restricting.


> How about including a DAC bypass (perhaps limited to certain files only)
> if the calling process' PID matches the PID in the pathname?

You mean s/PID/task_struct/ as PID is not a system global id in case of
pid namespaces.


>  This feels
> very dirty, but it might work.  I mention this possibility primarily
> such that maybe we can arrive at something cleaner based on this thought.
> 
> Oh, here's a slightly cleaner alternative: instead of basing this on a
> PID match, base it on unique exec_id match.

More clean way - leave 0444 POSIX perms, but add a check at open():

if (current != task && !ptrace_may_access(task, PTRACE_MODE_READ))
	return -EPERM;

We should not limit processes to POSIX security domains, but to any
defined Linux domains including LSMs.  In general, POSIX permissions in
/proc/$PID/* are obscure exactly because of such non-POSIX security models.


>  I am referring to those
> from Spender's patch:
> 
> > [1] http://grsecurity.net/~spender/dev_patches/distros_should_sponsor_me_for_doing_their_jobs.patch
> 
> BTW, I like this approach.

It is very similar to ->self_exec_id, which was used before, but with
really unique ids ;)

-- 
Vasiliy
