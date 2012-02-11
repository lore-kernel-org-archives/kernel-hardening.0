Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 11 Feb 2012 13:20:50 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120211092050.GA18669@openwall.com>
References: <20120210020658.GA17709@dztty> <20120210143616.GA6100@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210143616.GA6100@albatros>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2012 at 06:36:17PM +0400, Vasiliy Kulikov wrote:
> On Fri, Feb 10, 2012 at 03:06 +0100, Djalal Harouni wrote:
> > 2) DAC permissions and suid/guid/privileged programs (userspace):
> >    This is a list of files that are supposed to be protected:
> >    /proc/<pid>/maps
...
> I cannot find any solution of (2) except actually add ptrace check at
> open() time...  Looks like we have to check what specific action glibc 
> does with /proc/$pid/maps and whitelist these idiotic actions.  I hope
> it is not arbitrary reads :-)

I did not look into this closely, but my current understanding is that
apparently glibc reads the process' own proc files only, and restricting
their perms to 0400 breaks this if the process changes euid/fsuid during
its runtime.  Right?

How about including a DAC bypass (perhaps limited to certain files only)
if the calling process' PID matches the PID in the pathname?  This feels
very dirty, but it might work.  I mention this possibility primarily
such that maybe we can arrive at something cleaner based on this thought.

Oh, here's a slightly cleaner alternative: instead of basing this on a
PID match, base it on unique exec_id match.  I am referring to those
from Spender's patch:

> [1] http://grsecurity.net/~spender/dev_patches/distros_should_sponsor_me_for_doing_their_jobs.patch

BTW, I like this approach.

So maybe we can use it not only as an extra requirement, but also as a
way to bypass DAC... which still feels dirty, though. %-)

Alexander
