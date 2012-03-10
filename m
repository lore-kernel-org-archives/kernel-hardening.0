Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 11 Mar 2012 00:25:10 +0100
Message-Id: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

Procfs files and other important objects may contain sensitive information
which must not be seen, inherited or processed across execve.
The commit e268337dfe26dfc7efd422a804dbb27977a3cccc tries to fix the same
problem, but that leaves all the other sensitive /proc/<pid>/* files which
includes the {maps,smaps,numa_maps} files that can be used to bypass ASLR
(there is a PoC to demonstrate it). We should also note that currently the
/proc/<pid>/mem fix will pin mm_structs.

The following series tries to take another path to solve the same problem
by using a global execve counter and each task will have its own exec ID,
this way we can know if the processed files are attached to the reader or
the target tasks. With this solution we do not pin mm_structs of dead
processes and we can track special objects at each syscall.


There is a new proc_file_private struct which can be used to hold internal
data related to opened /proc/<pid>/* files, we also use it to store the
exec_id of the reader or the target tasks, it depends on the files being
processed. This struct offers a consistent and unified way to protect
all these sensitive files even the other /proc/* files.
There are also some new helper functions.


Currently we perform the protection in two different ways:

1) Use the target exec_id to bind files to their exec_id task:

For the REG files /proc/<pid>/{environ,pagemap,mem} we set the exec_id
of the proc_file_private to the target task, and we continue with
permission checks at open time, later on each read/write call the
permission checks are done + check the target exec_id if it equals the
exec_id of the proc_file_private that was set at open time, in other words
we bind the file to its task's exec_id, this way new exec programs can not
operate on the passed fd.


2) Use the reader exec_id to track reader behaviour (aggressive checks):

For the /proc/<pid>/{maps,smaps,numa_maps} we set the exec_id of the
proc_file_private to the current (reader) exec_id, and the permission
checks are only performed at read time + the exec_id check against reader,
this way we are sure that we are still dealing with the same reader. We do
this since currently it is not clear if the permission checks at open time
will work with glibc FORTIFY_SOURCE protection and without permission
checks at each syscall using the target exec_id will not work.

Hopefully it seems that perhaps we can work-around this, if the exec_id
design is accepted then I will split /proc/<pid>/{maps,smaps,numa_maps}
internal functions and implement proper permission checks so we can bind
all these files to their task's exec_id (track target instead of reader).


For the ONE and INF files /proc/<pid>/{stack,syscall,io,auxv,...} we also
use the reader exec_id since these sensitive files share their internal
logic with the other less important files, and performing permission
checks at open time will just break things.


Notes:
The exec_id idea was taken from the recent grsecurity patches, but I have
made some design changes so if there are bugs they are mine.


This was also discussed in this kernel-hardening thread:
http://www.openwall.com/lists/kernel-hardening/2012/02/10/1

This thread also includes other procfs files problems which currently I am
working on, I will try to continue with an other patch series as soon as
possible. Thanks to Vasiliy Kulikov and Solar Designer for their comments.


Finally I will just add Alan's thread that also explain the problem with
some historical discussions:
http://lkml.org/lkml/2012/1/29/35


Hope to get feedback to avoid new problems. Thanks.


Djalal Harouni (9):
  exec: add a global execve counter
  proc: add proc_file_private struct to store private information
  proc: new proc_exec_id_ok() helper function
  proc: protect /proc/<pid>/* INF files from reader across execve
  proc: add protection support for /proc/<pid>/* ONE files
  proc: protect /proc/<pid>/* ONE files from reader across execve
  proc: protect /proc/<pid>/{maps,smaps,numa_maps}
  proc: protect /proc/<pid>/{environ,pagemap} across execve
  proc: improve and clean up /proc/<pid>/mem protection
 
 fs/exec.c             |   11 ++
 fs/proc/array.c       |    4 +
 fs/proc/base.c        |  303 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/proc/internal.h    |   31 +++++-
 fs/proc/task_mmu.c    |  106 +++++++++++++++--
 include/linux/sched.h |   32 +++++
 6 files changed, 431 insertions(+), 56 deletions(-)
