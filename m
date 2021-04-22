Return-Path: <SRS0=xs4I=JT=lists.openwall.com=kernel-hardening-return-21194-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07BFFC433ED
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Apr 2021 12:28:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ECB4761463
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Apr 2021 12:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECB4761463
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21194-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32051 invoked by uid 550); 22 Apr 2021 12:27:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32000 invoked from network); 22 Apr 2021 12:27:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1619094452;
	bh=e7/3muMWug4jMpmXy/cCbRoOU1BGJcQC4qQ+ljj6AA4=;
	h=From:To:Cc:Subject:Date:From;
	b=uNvvXXBTmAPHbqKCeJPztXYrEgkBTBA+yaOjUW4dGF662aU1x3KcK/5asGa36hi3t
	 fAbf4rYkJOVMmlsICssW1vOHsR5xSMuQErgzd/d/WCzREIqkOimd5sXtVkGxiRUeL/
	 e3bdge73FeG8CVvGHMU2UvXV2vqJwKqf4bISAbgTZMA0dwNJUGhGvkhYGGuJ2t35Wj
	 RGMVo9YIuV5tBAw5oHHNe3wSExAH4JQmoFPFlCo+xgzKyvCv58IIVIejZOchKTbpYU
	 XVNoREmaz9bYJ7H3VDW9pX7+q05lx5GEWmKVgidRoNCakajFrqXYVBTv42nSssa9gZ
	 vX90+BLs5r3Aw==
From: legion@kernel.org
To: LKML <linux-kernel@vger.kernel.org>,
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
Subject: [PATCH v11 0/9] Count rlimits in each user namespace
Date: Thu, 22 Apr 2021 14:27:07 +0200
Message-Id: <cover.1619094428.git.legion@kernel.org>
X-Mailer: git-send-email 2.29.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Gladkov <legion@kernel.org>

Preface
-------
These patches are for binding the rlimit counters to a user in user namespace.
This patch set can be applied on top of:

git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v5.12-rc4

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

[1]: https://lore.kernel.org/containers/87imd2incs.fsf@x220.int.ebiederm.org/
[2]: https://lists.linuxfoundation.org/pipermail/containers/2020-August/042096.html
[3]: https://lists.linuxfoundation.org/pipermail/containers/2020-October/042524.html

Changelog
---------
v11:
* Revert most of changes in signal.c to fix performance issues and remove
  unnecessary memory allocations.
* Fixed issue found by lkp robot (again).

v10:
* Fixed memory leak in __sigqueue_alloc.
* Handled an unlikely situation when all consumers will return ucounts at once.
* Addressed other review comments from Eric W. Biederman.

v9:
* Used a negative value to check that the ucounts->count is close to overflow.
* Rebased onto v5.12-rc4.

v8:
* Used atomic_t for ucounts reference counting. Also added counter overflow
  check (thanks to Linus Torvalds for the idea).
* Fixed other issues found by lkp-tests project in the patch that Reimplements
  RLIMIT_MEMLOCK on top of ucounts.

v7:
* Fixed issues found by lkp-tests project in the patch that Reimplements
  RLIMIT_MEMLOCK on top of ucounts.

v6:
* Fixed issues found by lkp-tests project.
* Rebased onto v5.11.

v5:
* Split the first commit into two commits: change ucounts.count type to atomic_long_t
  and add ucounts to cred. These commits were merged by mistake during the rebase.
* The __get_ucounts() renamed to alloc_ucounts().
* The cred.ucounts update has been moved from commit_creds() as it did not allow
  to handle errors.
* Added error handling of set_cred_ucounts().

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

Alexey Gladkov (9):
  Increase size of ucounts to atomic_long_t
  Add a reference to ucounts for each cred
  Use atomic_t for ucounts reference counting
  Reimplement RLIMIT_NPROC on top of ucounts
  Reimplement RLIMIT_MSGQUEUE on top of ucounts
  Reimplement RLIMIT_SIGPENDING on top of ucounts
  Reimplement RLIMIT_MEMLOCK on top of ucounts
  kselftests: Add test to check for rlimit changes in different user
    namespaces
  ucounts: Set ucount_max to the largest positive value the type can
    hold

 fs/exec.c                                     |   6 +-
 fs/hugetlbfs/inode.c                          |  16 +-
 fs/proc/array.c                               |   2 +-
 include/linux/cred.h                          |   4 +
 include/linux/hugetlb.h                       |   4 +-
 include/linux/mm.h                            |   4 +-
 include/linux/sched/user.h                    |   7 -
 include/linux/shmem_fs.h                      |   2 +-
 include/linux/signal_types.h                  |   4 +-
 include/linux/user_namespace.h                |  31 +++-
 ipc/mqueue.c                                  |  40 ++---
 ipc/shm.c                                     |  26 +--
 kernel/cred.c                                 |  50 +++++-
 kernel/exit.c                                 |   2 +-
 kernel/fork.c                                 |  18 +-
 kernel/signal.c                               |  25 +--
 kernel/sys.c                                  |  14 +-
 kernel/ucount.c                               | 116 ++++++++++---
 kernel/user.c                                 |   3 -
 kernel/user_namespace.c                       |   9 +-
 mm/memfd.c                                    |   4 +-
 mm/mlock.c                                    |  22 ++-
 mm/mmap.c                                     |   4 +-
 mm/shmem.c                                    |  10 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/rlimits/.gitignore    |   2 +
 tools/testing/selftests/rlimits/Makefile      |   6 +
 tools/testing/selftests/rlimits/config        |   1 +
 .../selftests/rlimits/rlimits-per-userns.c    | 161 ++++++++++++++++++
 29 files changed, 467 insertions(+), 127 deletions(-)
 create mode 100644 tools/testing/selftests/rlimits/.gitignore
 create mode 100644 tools/testing/selftests/rlimits/Makefile
 create mode 100644 tools/testing/selftests/rlimits/config
 create mode 100644 tools/testing/selftests/rlimits/rlimits-per-userns.c

-- 
2.29.3

