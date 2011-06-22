Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 22 Jun 2011 09:03:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Message-Id: <20110622090331.fd6a3cc7.rdunlap@xenotime.net>
In-Reply-To: <20110622152514.GA9521@albatros>
References: <20110622152514.GA9521@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] ipc: introduce shm_rmid_forced sysctl
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 22 Jun 2011 19:25:14 +0400 Vasiliy Kulikov wrote:

> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
> 
>  Documentation/sysctl/kernel.txt |   22 ++++++++++
>  include/linux/ipc_namespace.h   |    3 +
>  include/linux/shm.h             |    5 ++
>  ipc/ipc_sysctl.c                |   33 +++++++++++++++
>  ipc/shm.c                       |   87 +++++++++++++++++++++++++++++++++++++--
>  kernel/exit.c                   |    1 +
>  6 files changed, 147 insertions(+), 4 deletions(-)
> 
> ---
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 5e7cb39..7a0ecfd 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -62,6 +62,7 @@ show up in /proc/sys/kernel:
>  - shmall
>  - shmmax                      [ sysv ipc ]
>  - shmmni
> +- shm_rmid_forced
>  - stop-a                      [ SPARC only ]
>  - sysrq                       ==> Documentation/sysrq.txt
>  - tainted
> @@ -475,6 +476,27 @@ kernel.  This value defaults to SHMMAX.
>  
>  ==============================================================
>  
> +shm_rmid_forced:
> +
> +Linux lets you set resource limits, including on how much memory one

                                       including how much memory one

> +process can consume, via setrlimit(2).  Unfortunately, shared memory
> +segments are allowed to exist without association with any process, and
> +thus might not be counted against any resource limits.  If enabled,
> +shared memory segments are automatically destroyed when their attach
> +count becomes zero after a detach or a process termination.  It will
> +also destroy segments that were created, but never attached to, on exit
> +from the process.  The only use left for IPC_RMID is to immediately
> +destroy an unattached segment.  Of course, this breaks the way things are
> +defined, so some applications might stop working.  Note that this
> +feature will do you no good unless you also configure your resource
> +limits (in particular, RLIMIT_AS and RLIMIT_NPROC).  Most systems don't
> +need this.
> +
> +Note that if you change this from 0 to 1, already created segments
> +without users and with a dead originative process will be destroyed.

                                 originating (?)

> +
> +==============================================================
> +
>  softlockup_thresh:
>  
>  This value can be used to lower the softlockup tolerance threshold.  The



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
