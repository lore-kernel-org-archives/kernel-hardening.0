Return-Path: <SRS0=+at9=EI=lists.openwall.com=kernel-hardening-return-20319-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9449C388F9
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 17:55:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 997562222B
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Nov 2020 17:55:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 997562222B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ubuntu.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20319-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3244 invoked by uid 550); 2 Nov 2020 17:55:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3205 invoked from network); 2 Nov 2020 17:55:42 -0000
Date: Mon, 2 Nov 2020 18:55:26 +0100
From: Christian Brauner <christian.brauner@ubuntu.com>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Alexey Gladkov <legion@kernel.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [RFC PATCH v1 0/4] Per user namespace rlimits
Message-ID: <20201102175526.eu4npm4v2ggicvaf@wittgenstein>
References: <cover.1604335819.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1604335819.git.gladkov.alexey@gmail.com>

On Mon, Nov 02, 2020 at 05:50:29PM +0100, Alexey Gladkov wrote:
> Preface
> -------
> These patches are for binding the rlimits to a user in the user namespace.
> This patch set can be applied on top of:
> 
> git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v5.8-2-g43e210d68200
> 
> Problem
> -------
> Some rlimits are set per user: RLIMIT_NPROC, RLIMIT_MEMLOCK, RLIMIT_SIGPENDING,
> RLIMIT_MSGQUEUE. When several containers are created from one user then
> the processes inside the containers influence each other.
> 
> Eric W. Biederman mentioned this issue [1][2][3].
> 
> Introduced changes
> ------------------
> To fix this problem, you can bind the counter of the specified rlimits to the
> user within the user namespace. By default, to preserve backward compatibility,
> only the initial user namespace is used. This patch adds one more prctl
> parameter to change the binding to the user namespace.
> 
> This will not cause the user to take more resources than allowed in the parent
> user namespace because it only virtualizes the rlimit counter. Limits in all
> parent user namespaces are taken into account.
> 
> For example, this allows us to run multiple containers by the same user and
> set the RLIMIT_NPROC to 1 inside.

Thanks for picking this up and working on it. This would definitely fix
many issues for folks running unprivileged containers using a single id
map which is the default behavior for LXC/LXD and so very valuable to
us.

Christian

> 
> ToDo
> ----
> * RLIMIT_MEMLOCK, RLIMIT_SIGPENDING and RLIMIT_MSGQUEUE are not implemented.
> * No documentation.
> * No tests.
> 
> [1] https://lore.kernel.org/containers/87imd2incs.fsf@x220.int.ebiederm.org/
> [2] https://lists.linuxfoundation.org/pipermail/containers/2020-August/042096.html
> [3] https://lists.linuxfoundation.org/pipermail/containers/2020-October/042524.html
> 
> Changelog
> ---------
> v1:
> * After discussion with Eric W. Biederman, I increased the size of ucounts to
>   atomic_long_t.
> * Added ucount_max to avoid the fork bomb.
> 
> --
> 
> Alexey Gladkov (4):
>   Increase size of ucounts to atomic_long_t
>   Move the user's process counter to ucounts
>   Do not allow fork if RLIMIT_NPROC is exceeded in the user namespace
>     tree
>   Allow to change the user namespace in which user rlimits are counted
> 
>  fs/exec.c                      | 13 ++++++---
>  fs/io-wq.c                     | 25 +++++++++++++-----
>  fs/io-wq.h                     |  1 +
>  fs/io_uring.c                  |  1 +
>  include/linux/cred.h           |  8 ++++++
>  include/linux/sched.h          |  3 +++
>  include/linux/sched/user.h     |  1 -
>  include/linux/user_namespace.h | 12 +++++++--
>  include/uapi/linux/prctl.h     |  5 ++++
>  kernel/cred.c                  | 44 ++++++++++++++++++++++++-------
>  kernel/exit.c                  |  2 +-
>  kernel/fork.c                  | 13 ++++++---
>  kernel/sys.c                   | 26 ++++++++++++++++--
>  kernel/ucount.c                | 48 +++++++++++++++++++++++++++++-----
>  kernel/user.c                  |  3 ++-
>  kernel/user_namespace.c        |  3 +++
>  16 files changed, 171 insertions(+), 37 deletions(-)
> 
> -- 
> 2.25.4
> 
