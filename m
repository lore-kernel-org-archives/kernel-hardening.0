Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 25 Jun 2011 21:35:01 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110625173430.GA3079@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] procfs io and taskstats infoleaks, proc/pid/* threats
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

(Bringing the subject to the list)

While implementing HARDEN_PROC and arguing with LKML folks about
usefullness of the feature, I've discovered /proc/pid/io and taskstats
interfaces can be used to gather rather sensitive information, like
password length:

http://www.openwall.com/lists/oss-security/2011/06/21/12

The suggested patches:

https://lkml.org/lkml/2011/6/24/88
https://lkml.org/lkml/2011/6/24/89
https://lkml.org/lkml/2011/6/24/91

taskstats patch is partial, it doesn't honor set{u,g}ids and processes
using caps.  For the full fix ptrace_task_may_access_current() is
needed, the patch adding it is pending:

https://lkml.org/lkml/2011/6/20/316
https://lkml.org/lkml/2011/6/20/317


I'd appreciate if somebody points me how information stored in
sched, schedstats, stat, and status files can be exploited.  I suspect
it can be used similar way.


Other thoughts:

Files mountinfo, mounts store information related to the process' fs
namespace.  I feel this information can be somewhat private, e.g. mount
points can reveal private file pathes in case of separate namespaces
where this information cannot be learned by reading /proc/self/mountinfo. 

Files limits and status store process related restrictions.  I dunno
whether this can be considered as a private information.

I'd appeciate any comment.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
