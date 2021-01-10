Return-Path: <SRS0=bSjA=GN=lists.openwall.com=kernel-hardening-return-20625-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138D4C433DB
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Jan 2021 17:35:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1D153221E5
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 Jan 2021 17:35:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D153221E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20625-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11343 invoked by uid 550); 10 Jan 2021 17:35:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11284 invoked from network); 10 Jan 2021 17:35:02 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Alexey Gladkov <legion@kernel.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC PATCH v2 0/8] Count rlimits in each user namespace
Date: Sun, 10 Jan 2021 18:33:39 +0100
Message-Id: <cover.1610299857.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Sun, 10 Jan 2021 17:34:51 +0000 (UTC)

Preface
-------
These patches are for binding the rlimit counters to a user in user namespace.
This patch set can be applied on top of:

git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v5.11-rc2

Problem
-------
Some rlimits are set per user: RLIMIT_NPROC, RLIMIT_MEMLOCK, RLIMIT_SIGPENDING,
RLIMIT_MSGQUEUE. When several containers are created from one user then
the processes inside the containers influence each other.

Eric W. Biederman mentioned this issue [1][2][3].

For example, there are two containers (A and B) created by one user. The
container A sets RLIMIT_NPROC=1 and starts one process. Everything is fine, but
when container B tries to do the same it will fail because the number of
processes is counted globally for each user and user has one process already.

On the other hand, we cannot simply calculate the rlimits for each container
separately. This will lead to the fact that the user creating a new user
namespace can create a fork bomb.

Introduced changes
------------------
To address the problem, we bind rlimit counters to each user namespace. The
result is a tree of rlimit counters with the biggest value at the root (aka
init_user_ns). The rlimit counter increment/decrement occurs in the current and
all parent user namespaces.

ToDo
----
* No documentation.
* No tests.

[1] https://lore.kernel.org/containers/87imd2incs.fsf@x220.int.ebiederm.org/
[2] https://lists.linuxfoundation.org/pipermail/containers/2020-August/042096.html
[3] https://lists.linuxfoundation.org/pipermail/containers/2020-October/042524.html

Changelog
---------
v2:
* RLIMIT_MEMLOCK, RLIMIT_SIGPENDING and RLIMIT_MSGQUEUE are migrated to ucounts.
* Added ucounts for pair uid and user namespace into cred.
* Added the ability to increase ucount by more than 1.

v1:
* After discussion with Eric W. Biederman, I increased the size of ucounts to
  atomic_long_t.
* Added ucount_max to avoid the fork bomb.

--

Alexey Gladkov (8):
  Use atomic type for ucounts reference counting
  Add a reference to ucounts for each user
  Increase size of ucounts to atomic_long_t
  Move RLIMIT_NPROC counter to ucounts
  Move RLIMIT_MSGQUEUE counter to ucounts
  Move RLIMIT_SIGPENDING counter to ucounts
  Move RLIMIT_MEMLOCK counter to ucounts
  Move RLIMIT_NPROC check to the place where we increment the counter

 fs/exec.c                      |  2 +-
 fs/hugetlbfs/inode.c           | 17 +++---
 fs/io-wq.c                     | 22 ++++----
 fs/io-wq.h                     |  2 +-
 fs/io_uring.c                  |  2 +-
 fs/proc/array.c                |  2 +-
 include/linux/cred.h           |  3 ++
 include/linux/hugetlb.h        |  3 +-
 include/linux/mm.h             |  4 +-
 include/linux/sched/user.h     |  6 ---
 include/linux/shmem_fs.h       |  2 +-
 include/linux/signal_types.h   |  4 +-
 include/linux/user_namespace.h | 31 +++++++++--
 ipc/mqueue.c                   | 29 +++++-----
 ipc/shm.c                      | 31 ++++++-----
 kernel/cred.c                  | 43 +++++++++++----
 kernel/exit.c                  |  2 +-
 kernel/fork.c                  | 12 +++--
 kernel/signal.c                | 53 ++++++++----------
 kernel/sys.c                   | 13 -----
 kernel/ucount.c                | 99 +++++++++++++++++++++++++++++-----
 kernel/user.c                  |  2 -
 kernel/user_namespace.c        |  7 ++-
 mm/memfd.c                     |  4 +-
 mm/mlock.c                     | 35 +++++-------
 mm/mmap.c                      |  3 +-
 mm/shmem.c                     |  8 +--
 27 files changed, 268 insertions(+), 173 deletions(-)

-- 
2.29.2

