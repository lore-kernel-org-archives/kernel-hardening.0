MIME-Version: 1.0
References: <20190506102112.GA12668@openwall.com>
In-Reply-To: <20190506102112.GA12668@openwall.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 6 May 2019 12:45:14 +0200
Message-ID: <CAG48ez0MUSH5tJEm-6_rzj2RYTTrA=_W0K13g93Bak=QDb+bUg@mail.gmail.com>
Subject: Re: race-free process signaling
Content-Type: text/plain; charset="UTF-8"
To: Solar Designer <solar@openwall.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Christian Brauner <christian@brauner.io>
List-ID: <kernel-hardening.lists.openwall.com>

+cc Christian Brauner (author of pidfd code)

On Mon, May 6, 2019 at 12:22 PM Solar Designer <solar@openwall.com> wrote:
> I totally missed the recent work in this area (I'm not on LKML),

FWIW, you don't usually need to actually read LKML to see when major
developments happen - I read LWN, which seems to work pretty well for
that purpose.

> and am
> now wondering whether the solution that got in ("use /proc/<pid> fds as
> stable handles on struct pid"):
>
> https://lwn.net/Articles/773459/
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9dce6679d736cb3d612af39bab9f31f8db66f9b
>
> is better or worse than what I had proposed in 1999 and 2005 ("locking"
> of pids for the caller's own visibility only):
>
> https://marc.info/?l=linux-kernel&m=112784189115058
>
> [Subject starts with "PID reuse safety for userspace apps", in case MARC
> is ever gone and someone wants to look this up in another archive.

(The kernel people now have lore.kernel.org as an email archive, which
is much nicer to use IMO - it has search, it has a nice thread view,
and you can download raw mbox files if you want to reply to a mail:
<https://lore.kernel.org/lkml/20050927172048.GA3423@openwall.com/>)

> I proposed a lockpid syscall back then, but I'd use a mere prctl now.]
>
> I still like my proposal much better - no dependency on procfs, much
> simpler implementation - but perhaps I'm missing the context here.

Actually, there is ongoing development of pidfd stuff, including
procfs-less pidfds. You may want to look through
<https://lore.kernel.org/lkml/?q=f%3Abrauner>, or something like that.

The following series adds anon-inode-based pidfds that can be returned
from sys_clone():
"[PATCH v3 2/4] clone: add CLONE_PIDFD"
<https://lore.kernel.org/lkml/20190419120904.27502-2-christian@brauner.io/>
"[PATCH v3 3/4] signal: support CLONE_PIDFD with pidfd_send_signal"
<https://lore.kernel.org/lkml/20190419120904.27502-4-christian@brauner.io/>

This patch adds process exit notifications that can be received
through the normal file polling syscalls (epoll/poll/select/...):
"[PATCH v2 1/2] Add polling support to pidfd"
<https://lore.kernel.org/lkml/20190430162154.61314-1-joel@joelfernandes.org/>

> Maybe I should have sent a patch back then.  Oh well.
