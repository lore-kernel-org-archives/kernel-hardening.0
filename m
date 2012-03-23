Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <20120323190855.GA27213@www.outflux.net>
Date: Fri, 23 Mar 2012 15:06:02 -0700
In-Reply-To: <20120323190855.GA27213@www.outflux.net> (Kees Cook's message of
	"Fri, 23 Mar 2012 12:08:55 -0700")
Message-ID: <m1fwczvuph.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, spender@grsecurity.net, Linux Containers <containers@lists.linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> Notify get_robust_list users that the syscall is going away.

Has anyone asked the question if the folks working on checkpoint/restart
are going to need this.

This seems like important information to know if you want to checkpoint
a process.

Eric

> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - add note to feature-removal-schedule.txt.
> ---
>  Documentation/feature-removal-schedule.txt |   10 ++++++++++
>  kernel/futex.c                             |    2 ++
>  kernel/futex_compat.c                      |    2 ++
>  3 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 4bfd982..e3bf119 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -543,3 +543,13 @@ When:	3.5
>  Why:	The old kmap_atomic() with two arguments is deprecated, we only
>  	keep it for backward compatibility for few cycles and then drop it.
>  Who:	Cong Wang <amwang@redhat.com>
> +
> +----------------------------
> +
> +What:	get_robust_list syscall
> +When:	2013
> +Why:	There appear to be no production users of the get_robust_list syscall,
> +	and it runs the risk of leaking address locations, allowing the bypass
> +	of ASLR. It was only ever intended for debugging, so it should be
> +	removed.
> +Who:	Kees Cook <keescook@chromium.org>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index d701be5..e2b0fb9 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2449,6 +2449,8 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
>  	if (!futex_cmpxchg_enabled)
>  		return -ENOSYS;
>  
> +	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
> +
>  	rcu_read_lock();
>  
>  	ret = -ESRCH;
> diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
> index a9642d5..83e368b 100644
> --- a/kernel/futex_compat.c
> +++ b/kernel/futex_compat.c
> @@ -142,6 +142,8 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
>  	if (!futex_cmpxchg_enabled)
>  		return -ENOSYS;
>  
> +	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
> +
>  	rcu_read_lock();
>  
>  	ret = -ESRCH;
