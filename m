Return-Path: <SRS0=7i9t=GZ=lists.openwall.com=kernel-hardening-return-20690-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2251EC433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Jan 2021 13:01:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 10F52230FC
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Jan 2021 13:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10F52230FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20690-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9296 invoked by uid 550); 22 Jan 2021 13:01:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9271 invoked from network); 22 Jan 2021 13:01:02 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	io-uring@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-mm@kvack.org
Cc: Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v4 0/7] Count rlimits in each user namespace
Date: Fri, 22 Jan 2021 14:00:09 +0100
Message-Id: <cover.1611320161.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 22 Jan 2021 13:00:51 +0000 (UTC)

Preface
-------
These patches are for binding the rlimit counters to a user in user namespace.
This patch set can be applied on top of:

git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v5.11-rc2

Problem
-------
The RLIMIT_NPROC, RLIMIT_MEMLOCK, RLIMIT_SIGPENDING, RLIMIT_MSGQUEUE rlimits
implementation places the counters in user_struct [1]. These limits are global
between processes and persists for the lifetime of the process, even if
processes are in different user namespaces.

To illustrate the impact of rlimits, let's say there is a program that does not
fork. Some service-A wants to run this program as user X in multiple containers.
Since the program never fork the service wants to set RLIMIT_NPROC=1.

service-A
 \- program (uid=1000, container1, rlimit_nproc=1)
 \- program (uid=1000, container2, rlimit_nproc=1)

The service-A sets RLIMIT_NPROC=1 and runs the program in container1. When the
service-A tries to run a program with RLIMIT_NPROC=1 in container2 it fails
since user X already has one running process.

The problem is not that the limit from container1 affects container2. The
problem is that limit is verified against the global counter that reflects
the number of processes in all containers.

This problem can be worked around by using different users for each container
but in this case we face a different problem of uid mapping when transferring
files from one container to another.

Eric W. Biederman mentioned this issue [2][3].

Introduced changes
------------------
To address the problem, we bind rlimit counters to user namespace. Each counter
reflects the number of processes in a given uid in a given user namespace. The
result is a tree of rlimit counters with the biggest value at the root (aka
init_user_ns). The limit is considered exceeded if it's exceeded up in the tree.

[1] https://lore.kernel.org/containers/87imd2incs.fsf@x220.int.ebiederm.org/
[2] https://lists.linuxfoundation.org/pipermail/containers/2020-August/042096.html
[3] https://lists.linuxfoundation.org/pipermail/containers/2020-October/042524.html

Changelog
---------
v4:
* Reverted the type change of ucounts.count to refcount_t.
* Fixed typo in the kernel/cred.c

v3:
* Added get_ucounts() function to increase the reference count. The existing
  get_counts() function renamed to __get_ucounts().
* The type of ucounts.count changed from atomic_t to refcount_t.
* Dropped 'const' from set_cred_ucounts() arguments.
* Fixed a bug with freeing the cred structure after calling cred_alloc_blank().
* Commit messages have been updated.
* Added selftest.

v2:
* RLIMIT_MEMLOCK, RLIMIT_SIGPENDING and RLIMIT_MSGQUEUE are migrated to ucounts.
* Added ucounts for pair uid and user namespace into cred.
* Added the ability to increase ucount by more than 1.

v1:
* After discussion with Eric W. Biederman, I increased the size of ucounts to
  atomic_long_t.
* Added ucount_max to avoid the fork bomb.

--

Alexey Gladkov (7):
  Add a reference to ucounts for each cred
  Move RLIMIT_NPROC counter to ucounts
  Move RLIMIT_MSGQUEUE counter to ucounts
  Move RLIMIT_SIGPENDING counter to ucounts
  Move RLIMIT_MEMLOCK counter to ucounts
  Move RLIMIT_NPROC check to the place where we increment the counter
  kselftests: Add test to check for rlimit changes in different user
    namespaces

 fs/exec.c                                     |   2 +-
 fs/hugetlbfs/inode.c                          |  17 +-
 fs/io-wq.c                                    |  22 ++-
 fs/io-wq.h                                    |   2 +-
 fs/io_uring.c                                 |   2 +-
 fs/proc/array.c                               |   2 +-
 include/linux/cred.h                          |   3 +
 include/linux/hugetlb.h                       |   3 +-
 include/linux/mm.h                            |   4 +-
 include/linux/sched/user.h                    |   6 -
 include/linux/shmem_fs.h                      |   2 +-
 include/linux/signal_types.h                  |   4 +-
 include/linux/user_namespace.h                |  23 ++-
 ipc/mqueue.c                                  |  29 ++--
 ipc/shm.c                                     |  31 ++--
 kernel/cred.c                                 |  46 ++++-
 kernel/exit.c                                 |   2 +-
 kernel/fork.c                                 |  12 +-
 kernel/signal.c                               |  53 +++---
 kernel/sys.c                                  |  13 --
 kernel/ucount.c                               | 109 ++++++++++--
 kernel/user.c                                 |   2 -
 kernel/user_namespace.c                       |   7 +-
 mm/memfd.c                                    |   4 +-
 mm/mlock.c                                    |  35 ++--
 mm/mmap.c                                     |   3 +-
 mm/shmem.c                                    |   8 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/rlimits/.gitignore    |   2 +
 tools/testing/selftests/rlimits/Makefile      |   6 +
 tools/testing/selftests/rlimits/config        |   1 +
 .../selftests/rlimits/rlimits-per-userns.c    | 161 ++++++++++++++++++
 32 files changed, 448 insertions(+), 169 deletions(-)
 create mode 100644 tools/testing/selftests/rlimits/.gitignore
 create mode 100644 tools/testing/selftests/rlimits/Makefile
 create mode 100644 tools/testing/selftests/rlimits/config
 create mode 100644 tools/testing/selftests/rlimits/rlimits-per-userns.c

-- 
2.29.2

