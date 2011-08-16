Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 16 Aug 2011 17:55:16 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110816135515.GA17658@albatros>
References: <20110810161302.GA2548@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810161302.GA2548@albatros>
Subject: [kernel-hardening] Re: [RFC] proc: introduce pid_allowed mount option
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Arnd Bergmann <arnd@arndb.de>, "Serge E. Hallyn" <serge@hallyn.com>, Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Wed, Aug 10, 2011 at 20:13 +0400, Vasiliy Kulikov wrote:
> This patch adds support of pid_allowed=XX and attr_allowed=YY mount
> options for procfs.  When set, all /proc/PID/ files are restricted to
> the owner, except filenames passed via pid_allowed= argument.  E.g. with
> pid_allowed=sched sched file would be world readable and other files
> would be restricted to the task owner.  The same for /proc/PID/attr/
> files and attr_allowed=YY.
[...]
> Is the whole idea of high granularity, but static permissions worth it?
> The previous patch with relaxed/fully-restricted modes was criticized
> for being highly specific to one particular set of requirements:
> 
> http://www.openwall.com/lists/kernel-hardening/2011/06/21/3
> 
> On/off mechanism was used in server environments in times of Linux
> 2.0-2.4 as part of -ow patch and currently as part of -grsecurity patch.
> There were no complains about too limited application.  It serves a well
> defined needs (limiting processes' information to the owner, root, and a
> privileged "monitoring" group).

Any comments about the approach in general?

Different procfs patches were maintained out of tree for ~10 years,
all of them had/has the same goal - restrict processes/networking
information from unprivileged users.  All of them were not high
granularity, just on/off.

As to chmod/chown'able approach with inheritable permission across
fork() - I cannot imagine any case where it has any advantages over
static approach (which is implemented in this patch), but I see
disadvantages:

 * What to do on exec'ing setuid binary?  We have to re'chmod files to
   some sane defaults - first umask set.
 * For usermode helpers? - second umask set.
 * On privilege dropping (setuid(2))?  We can have umask
   set for all users, but it might not be convenient.  We can have umask
   set for each user.  Or we can use userspace for re-chmod'ing files
   like PAM, but what to do for apps that don't use PAM?..
 * Privilege restore? - a umask set again.


What is the goal of procfs high granularity permission model?  What
needs does it serve?  Every high granularity security model quickly
becomes hard to maintain/configure properly.  Given there were no out of
tree attempts to extend procfs in this direction (well, at least no
widespread attempts), I'm afraid such complication worth it.

I think on/off approach addresses the issue, which I've tried to
explain earlier, and it is "generic enough" for the existing needs.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
