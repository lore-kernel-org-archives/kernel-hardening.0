Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Dec 2011 15:20:29 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
In-Reply-To: <20111211182821.GA2853@albatros>
Message-ID: <alpine.LSU.2.00.1112111511290.2297@eggly>
References: <20111211182821.GA2853@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH -next] proc: fix task_struct infoleak
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 11 Dec 2011, Vasiliy Kulikov wrote:

> proc_pid_permission() doesn't put task_struct on every /proc/$pid/
> access.  A demo from Hugh Dickins:
> 
> while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Thank you, yes, that fixes it for me:
Tested-by: Hugh Dickins <hughd@google.com>
but hopefully akpm will just fold this into the original patch.

Hmm, tiny niggle, but I notice that has_pid_permissions() is
declared, reasonably, as bool; so wouldn't it be better for
has_perms to be declared as bool instead of int?  Hardly
worth bothering about, but if you've a mind to respin with
a corrected Subject as Al rightly suggests.

> ---
>  This is a patch against a hidepid patchset from -mm.
> 
>  fs/proc/base.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 8caf5cb..0e5c577 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -646,9 +646,14 @@ static bool has_pid_permissions(struct pid_namespace *pid,
>  static int proc_pid_permission(struct inode *inode, int mask)
>  {
>  	struct pid_namespace *pid = inode->i_sb->s_fs_info;
> -	struct task_struct *task = get_proc_task(inode);
> +	struct task_struct *task;
> +	int has_perms;
> +
> +	task = get_proc_task(inode);
> +	has_perms = has_pid_permissions(pid, task, 1);
> +	put_task_struct(task);
>  
> -	if (!has_pid_permissions(pid, task, 1)) {
> +	if (!has_perms) {
>  		if (pid->hide_pid == 2) {
>  			/*
>  			 * Let's make getdents(), stat(), and open()
> -- 
> 1.7.0.4
