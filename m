Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Tue,  1 Oct 2013 21:26:09 +0100
Message-Id: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with file->f_cred
To: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: tixxdz@gmail.com, Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

/proc/<pid>/* entries varies at runtime, appropriate permission checks
need to happen during each system call.

Currently some of these sensitive entries are protected by performing
the ptrace_may_access() check. However even with that the /proc file
descriptors can be passed to a more privileged process
(e.g. a suid-exec) which will pass the classic ptrace_may_access()
check. In general the ->open() call will be issued by an unprivileged
process while the ->read(),->write() calls by a more privileged one.

Example of these files are:
/proc/*/syscall, /proc/*/stack etc.

And any open(/proc/self/*) then suid-exec to read()/write() /proc/self/*


These files are protected during read() by the ptrace_may_access(),
however the file descriptor can be passed to a suid-exec which can be
used to read data and bypass ASLR. Of course this was discussed several
times on LKML.


Solution:
Here we propose a clean solution that uses available mechanisms. No
additions, nor new structs/memory allocation...

After a discussion about some /proc/<pid>/* file permissions [1],
Eric W. Biederman proposed to use the file->f_cred to check if current's
cred have changed [2], actually he said that Linus was looking
on using the file->f_cred to implement a similar thing! But run in
problems with Chromes sandbox ? a link please ?


So here are my experiments:
The idea is to track the cred of current. If the cred change between
->open() and read()/write() this means that current has lost or gained
some X privileges. If so, in addition to the classic ptrace_may_access()
check, perform a second check using the file's opener cred. This means,
if an unprivileged process that tries to use a privileged one
(e.g. suid-exec) to read privileged files will get caught. The original
process that opened the file does not have the appropriate permissions
to read()/write() the target /proc/<pid>/* entry.

This second check is done of course during read(),write()...


Advantages of the proposed solution:
* It uses available mechanisms: file->f_cred which is a const cred
  that reference the cred of the opener.

* The file->f_cred can be easily referenced

* It allows to pass file descriptors under certain conditions:
  (1) current at open time may have enough permissions
  (2) current does a suid-exec or change its ruid/euid (new cred)
  (3) current or suid-exec tries to read from the task /proc entry
     Allow the ->read() only if the file's opener cred at (1)
     have enough permissions on *this* task /proc entry during
     *this* ->read() moment. Otherwise fail.

  IOW allow it, if the opener does not need the help of a suid-exec to
  read/write data.


Disadvantage:
* Currently only /proc/*/{stack,syscall,stat,personality} are handled.
  If the solution is accepted I'll continue with other files, taking
  care to not break userspace. All the facilities are provided.
* Your feedback


[1] https://lkml.org/lkml/2013/8/26/354
[2] https://lkml.org/lkml/2013/8/31/209


Change log
----------
v1->v2:
 - Removed the file->f_cred member that was added to seq_file struct.
   Al Viro didn't like it, and Linus suggested to have a pointer on
   'file struct', so it's done by using seq_file->private

 - Added Acked-by: Kees Cook to
   [PATCH v2 4/9] procfs: make /proc/*/{stack,syscall} 0400

 - Added suggested-by: Eric W. Biederman  to
   [PATCH v2 1/9] procfs: add proc_same_open_cred() to check if the cred
   have changed
   [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's
   opener may access task
   [PATCH v2 3/9] procfs: Document the proposed solution to protect
   procfs entries

 - Patchset cleaned

Version 1 was discussed here:
https://lkml.org/lkml/2013/9/25/459


The following series tries to implement what I describe.


Djalal Harouni (9):
 procfs: add proc_same_open_cred() to check if the cred have changed
 procfs: add proc_allow_access() to check if file's opener may access task
 procfs: Document the proposed solution to protect procfs entries
 procfs: make /proc/*/{stack,syscall} 0400
 procfs: make /proc entries that use seq files able to access file->f_cred
 procfs: add permission checks on the file's opener of /proc/*/stat
 procfs: add permission checks on the file's opener of /proc/*/personality
 procfs: improve permission checks on /proc/*/stack
 procfs: improve permission checks on /proc/*/syscall

 fs/proc/array.c    |  16 ++++++-
 fs/proc/base.c     | 301 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 fs/proc/internal.h |   3 ++
 3 files changed, 292 insertions(+), 28 deletions(-)
