Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 19 Jul 2011 13:27:07 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110719092707.GA23019@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] GSoC midterm accomplishments
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a summary what is done and what is to be done for upstream kernel
hardening during my GSoC participation.

[+] means success (applied or to be applied)
[-] means failure
[...] means "patch needs reworking" or additional patches are required
[F] means "didn't try, but will work on it"


HARDEN_VM86 [-]

Currently it lacks a proper configuration mechanism.  Given more generic
feature (slightly different, though), seccomp, was rejected, there is no
way it is applied in the current form.  New thoughts are needed.


HARDEN_PROC [...]

The first try was unsuccessful as it is not enough generic.  More
generic list of world-r/w files was suggested, I'll try implement this
variant.  In the future it can be extended by the feature suggested by
Andrew Morton, chmod'able and chown'able /proc/PID/* files inheritable
via fork (this specific feature seems unrelated to our goal).

Another interface of getting proc information, taskstats, should be
restricted too.  However, given procfs restriction is not yes/no
anymore, taskstats and procfs restrictions have to be separated.  Also
there is a little chance taskstats will be restricted by default
(recalling Linus' complains).

As to networking restrictions, NETLINK_INET_DIAG netlink socket should
be restricted too.  I don't know yet how to define these restrictions
consistent way, though (for procfs and netlink).

While stating the usefulness of the feature, 2 security bugs were fixed
- taskstats local DoS and taskstats/procfs io infoleak which could be
used to learn e.g. alien's password length.  (The taskstats fix is
pending, however.)

Also discussions on LKML generated some new thoughts in my mind, see
below.


HARDEN_SHM [+]

The code was accepted into -mm tree of Andrew Morton and even got some
feedback about optimizations.  I hope it will be accepted into Linux 3.1.


HARDEN_EXECVE [+]

This feature was accepted by Linus (surprise for me).  It is not yet
applied, pending...


HARDEN_STACK{,_SMART} [...]

I've posted the current issues with the feature as the separate thread.
The way kernel and glibc handle GNU_STACK it is not as simple as just say
"kernel, enforce NX stack".


GRKERNSEC_SYSFS_RESTRICT [-/...]

sysfs umask=/gid= mount options were rejected by GregKH as provided threats
are not impressive enough.  Probably we need to state the threats more
clearly or identify other threats like side channel attacks or learning
some information that might be used to adjust future attack's direction.

Also debugfs mount options introduction worth trying.  As GregKH states,
"there are no rules in debugfs", so breaking something via debugfs
restriction is probably not a big deal (unless it is perf :-).


GRKERNSEC_MODHARDEN [F]

I didn't try to push it yet.  To do so, I have to ping Dan to identify
what has blocked its appliance.


GRKERNSEC_SOCKET [F]

Didn't try it yet.  I'll try to implement it, but it is a low priority
task for me.


PAX_USERCOPY [...]

RFCv1 was NAK'ed by Linus as a crazy thing.  I wrongly thought that a
"release early" is a good strategy for the kernel :)  v2 got some
feedback, which I'll address soon.


PAX_MPROTECT [F]

This is really worth trying to push.


PAX_KERNEXEC [+/...]

I'll try to push some minor bits of it (I'll have no time for learning
this part of PaX, it is much more complicated than USERCOPY/MPROTECT) -
at least struct *ops constification parts.


PAX_REFCOUNT [F]

I'll try to push it.  At least it is a source of clarification what
atomic_t is for ;-)


printk() user supplied strings [+/F]

One solution of the issue was accepted by Linus - %s is for 7bit ASCII
strings only without control characters.  The fix needs identifying and
patching %s data with \n inside and UTF-8 strings (the latter needs
introducing new format string without filtering).

With the help of coccinelle I hope I'll finish it.


Solar recommended to create a wiki page to track accomplishment and
anchor links to LKML discussions, I'll create it soon.


Now about newly created tasks.  While thinking about arguments to
agitate to restrict world access to procfs files and taskstats, I've
identified some sources of possible infoleaks that could be used in side
channel attacks.  The files/interfaces are as follows:

/proc/PID/{limits,sched_*,stat,statm,status,wchan}
inotify_add_watch(2)
ustat(2)
*statfs(2)
*statvfs(2)
sysinfo(2)

I didn't precisely investigate in what situations these infoleaks might
be useful to an attacker, but I found some cases where inotify
disclosures somewhat private information.  I'll post about it in a few
days when I adjust my thoughts.

Thanks,

-- 
Vasiliy
