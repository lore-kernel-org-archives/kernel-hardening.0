Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 26 Aug 2013 21:34:12 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130826203412.GA2414@dztty>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
 <871u5gqtw3.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871u5gqtw3.fsf@xmission.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 26, 2013 at 09:49:48AM -0700, Eric W. Biederman wrote:
> Djalal Harouni <tixxdz@opendz.org> writes:
> 
> > Avoid giving an fd on privileged files for free by switching these
> > files to 0400 mode.
> 
> This seems to be a revert of Al's patch in March of 2011 based on broken
> reasoning.
Yes it reverts some parts of it which are not correct.

Yes the patch closes the races *during* read() time, but why the
permissions were changed ?

Note: it does not close any suid exec between open(),read(),lseek()...


History:
This is the link of the original thread that added /proc/pid/stack
support
https://lkml.org/lkml/2008/11/7/109

Quoting Andrew "I guess the 0400 mode on that file will suffice..."


Here we do not have traceble checks at open() time, and the *only*
protection at open() which is the 0400 mode was also removed!

Please do check protections for /proc/*/mem

> Al Viro commited:
> > commit a9712bc12c40c172e393f85a9b2ba8db4bf59509
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date:   Wed Mar 23 15:52:50 2011 -0400
> > 
> >     deal with races in /proc/*/{syscall,stack,personality}
> >     
> >     All of those are rw-r--r-- and all are broken for suid - if you open
> >     a file before the target does suid-root exec, you'll be still able
> >     to access it.  For personality it's not a big deal, but for syscall
> >     and stack it's a real problem.
> >     
> >     Fix: check that task is tracable for you at the time of read().
> >     
> >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> How does changing the permissions to S_IRUSR prevent someone from
> opening the file before, and reading the file after a suid exec?
This will block opening files owned by other users, doing a suid will
not help since you do not have an fd on the file.


There is a big difference here:

Currently you can get an fd on /proc/1/stack or whatever root owned
process or files, later just do a suid exec to read from it.

But with this simple change you can't. You will be able to open and get
an fd only on the files owned by you (or the same user). Of course you
can do a suid exec but you will only read input from this suid exec.
You will not be able to read from arbitrary processes.


There is a reason that these files were made 0400. Al's commit
stated that currently all these files are "rw-r--r--" so add a check to
close a race, but these files were "r--------" before the commit and not
"r--r--r--" and it mistakenly changed them.

> > This patch restores the old mode which was 0400
> 
> Which seems to add no security whatsoever and obscure the fact that
> anyone who cares can read the file so what is the point?
Well, I guess there is a big difference between 0400 and 0444

-- 
Djalal Harouni
http://opendz.org
