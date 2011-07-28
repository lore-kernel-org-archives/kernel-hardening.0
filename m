Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 28 Jul 2011 14:41:35 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110728104134.GA4133@albatros>
References: <20110719092707.GA23019@albatros>
 <20110722144927.GA3176@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722144927.GA3176@albatros>
Subject: [kernel-hardening] Re: kernel infoleaks
To: kernel-hardening@lists.openwall.com
Cc: security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

(CC'ed security@kernel.org.  This is not a high severity and security@
might already know about it, but better safe than sorry.)

On Fri, Jul 22, 2011 at 18:49 +0400, Vasiliy Kulikov wrote:
> Hi,
> 
> On Tue, Jul 19, 2011 at 13:27 +0400, Vasiliy Kulikov wrote:
> > Now about newly created tasks.  While thinking about arguments to
> > agitate to restrict world access to procfs files and taskstats, I've
> > identified some sources of possible infoleaks that could be used in side
> > channel attacks.  The files/interfaces are as follows:
> > 
> > /proc/PID/{limits,sched_*,stat,statm,status,wchan}
> > inotify_add_watch(2)
> > ustat(2)
> > *statfs(2)
> > *statvfs(2)
> > sysinfo(2)
> > 
> > I didn't precisely investigate in what situations these infoleaks might
> > be useful to an attacker, but I found some cases where inotify
> > disclosures somewhat private information.  I'll post about it in a few
> > days when I adjust my thoughts.
> 
> This is a follow up of kernel possible infoleaks.  I've divided them
> into groups.
> 
> * procfs
> 
> Historically almost all /proc/PID/* files are readable by all users, IMO
> without actual need.
> 
> 
> - sched_* files might be used to simplify timing attacks.  "classical"
>   timing attack would measure the time delta, but such measurement might
>   be smashed by a scheduler.  Here the kernel grants already measured
>   numbers.
> 
> - status reveals memory usage.  It might reveal whether a mmap() is
>   done, how much stacks was used, how much memory is locked.  If
>   malloc() expands the heap, it is visible too.
> 
>   Also I think the knowledge of task's capabilities is something other
>   users should not care of (the same for limits).
> 
> - stat, statm reveal process' times and rss.
> 
> - mountinfo, mounts might reveal path information of private namespaces.
> 
> 
> * inotify_add_watch(2)
> 
> From the manpage: "The inotify API provides a mechanism for monitoring
> file system events.".  It allows users to monitor fs changes (e.g. for
> re-indexing) and accesses.  I see 2 issues here: 
> 
> 1) While fs changes are monitor'able via getdents(2)/*stat(2), it is a
> poll'able mechanism and it is exposured to races (unlike inotify
> delivery "for sure").  If it is *known* that some fs activity exposes
> some private information then inotify simplifies gathering this
> information.  Surely it depends on scheduler load, disk load, number of
> files in the directory, etc. etc.  But if the event is very rare (e.g.
> a daily/weekly cron job) even the 20x decrease of race win chance is
> good.
> 
> 2) Inotify exposes information not gather'able (AFAICS) via other means:
> file reads, file writes, the file descriptor associated with the file is
> closed (and closing of RO fd and RW fd are different events).
> 
> Some ways to (ab)use inotify:
> 
> - If there is a PAM module with "requisite" control field, the
>   following modules read some /etc/ files and the directories where
>   these files are located are readable by a user, he may learn that this
>   specific requisite module failed.  This might be a /etc/pam.d/
>   misconfiguration though.
> 
> - If there is a PAM module that checks user's authority against 2 files
>   sequentially, then watching for accesses of the second file reveals
>   information whether the first check failed (similar to requisite).
>   This might be a PAM module infoleak though, which is probably
>   identifiable via time measurement.
> 
> - Watching for /etc/passwd and /etc/.pwd.lock might reveal information
>   whether a user changes his password.  It is not inotify specific, the
>   same can be learned via stat'ing the lock file.  (Note: watching for
>   passwd process in /proc/ is not sufficient as a user is able to
>   terminate passwd without actual pass change.)
> 
> - Watching for /dev/null opening/closing may reveal whether significant
>   events happened (e.g. privilege dropping).  I couldn't find any such
>   event that is not visible via procfs (euid change).
> 
> - Watching for /lib/ reveals DSO usage.  It differs from $PATH
>   running binaries monitoring as the latter is identifiable via
>   /proc/PID/cmdline.  If DSO is used for handling specific file type (e.g.
>   media/compression format), the information that such file is opened is
>   revealed.
> 
> - Watching for / reveals root's "ls /root/".
> 
> - Watching for /var/run/screen/ can be used to monitor "screen -r"
>   events.  Poll variant is still procfs.
> 
> - Bash uses /etc/bash_completion.d/* to initialize completion engine at
>   the start time.  However, some db files can be used for actual
>   completion.  Watching for these db files reveals user's will to run
>   this command (compared to /proc/pid/cmdline it happens _before_ the
>   command is run and even if it is not run at all).
> 
> - Watching for /tmp/ may reveal private (not accessable by world)
>   /tmp/*/ directories activity.
> 
> 
> * ustat(2), statfs(2), statvfs(2).
> 
> It's possible to learn the precise free inodes number and free blocks
> number.  It's possible to call statvfs() in a loop and get somewhat
> precise information about other users' activity.  If there are 2 users
> logged in, one may learn other user created/removed files number and how
> much data (rounded to a block size) he did removed/added (the mistake is
> daemons' acitivity, but anyway).  On SMP it's possible to get every
> inode creation/deletion event information.
> 
> * sysinfo(2).
> 
> The same as *stat*, but now with free memory.  Also it is related to
> kernel activity, so if there is a correlation of a significant memory
> allocation and a private event, the event might be disclosured.
> 
> 
> Suggestions about what to do with these things or how they can be abused
> another way are welcomed.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
