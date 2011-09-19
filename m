Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 19 Sep 2011 21:39:05 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110919173905.GA3804@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
 <20110630075716.GB3377@albatros>
 <BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
 <BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
 <BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
 <CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxXS9z=NwoYug+qGoYufqN-6dCo4fm5ggTsoDonsMi4Dw@mail.gmail.com>
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2011 at 09:40 -0700, Linus Torvalds wrote:
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index e19ce1454ee1..5874d4866b3c 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -457,6 +457,8 @@ static int cmd_attr_register_cpumask(struct genl_info *info)
>  	cpumask_var_t mask;
>  	int rc;
>  
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;

Shouldn't it simply protect taskstats_user_cmd()?  You may still poll
the counters with TASKSTATS_CMD_ATTR_PID/TASKSTATS_CMD_ATTR_TGID.

Or ptrace_may_access() in taskstats_user_cmd().

>  	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
>  		return -ENOMEM;
>  	rc = parse(info->attrs[TASKSTATS_CMD_ATTR_REGISTER_CPUMASK], mask);
> diff --git a/kernel/tsacct.c b/kernel/tsacct.c
> index 24dc60d9fa1f..110ca5a03bd6 100644
> --- a/kernel/tsacct.c
> +++ b/kernel/tsacct.c
> @@ -78,6 +78,7 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
>  
>  #define KB 1024
>  #define MB (1024*KB)
> +#define KB_MASK (~(KB-1))
>  /*
>   * fill in extended accounting fields
>   */
> @@ -100,9 +101,9 @@ void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
>  	stats->read_syscalls	= p->ioac.syscr;
>  	stats->write_syscalls	= p->ioac.syscw;
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
> -	stats->read_bytes	= p->ioac.read_bytes;
> -	stats->write_bytes	= p->ioac.write_bytes;
> -	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
> +	stats->read_bytes	= p->ioac.read_bytes & KB_MASK;
> +	stats->write_bytes	= p->ioac.write_bytes & KB_MASK;
> +	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes & KB_MASK;
>  #else
>  	stats->read_bytes	= 0;
>  	stats->write_bytes	= 0;


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
