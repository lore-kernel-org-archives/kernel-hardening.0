Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 24 Jan 2012 15:03:32 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20120124110332.GA4770@albatros>
References: <20120123212115.GA29641@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123212115.GA29641@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH v3] sysctl: control functionality of /proc/pid/mem
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>, Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

(cc'ed kernel-hardening)

On Mon, Jan 23, 2012 at 13:21 -0800, Kees Cook wrote:
> 
> Add the "proc_pid_mem" sysctl to control whether or not /proc/pid/mem is
> allowed to work: 0: disabled, 1: read only, 2: read/write (default).
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
...
> index f487f25..6fd4bc0 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -103,6 +103,7 @@ extern int percpu_pagelist_fraction;
>  extern int compat_log;
>  extern int latencytop_enabled;
>  extern int sysctl_nr_open_min, sysctl_nr_open_max;
> +extern int sysctl_proc_pid_mem;
>  #ifndef CONFIG_MMU
>  extern int sysctl_nr_trim_pages;
>  #endif
> @@ -1004,6 +1005,15 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> +	{
> +		.procname	= "proc_pid_mem",
> +		.data		= &sysctl_proc_pid_mem,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &two,
> +	},

While I fully agree that we should step by step opt out all deprecated and
legacy features, which are not widely used nowadays and are probably
dangerous from the security POV, but we should define a standart way
of doing it.  E.g. moving all such stuff to some sysctl group, not bloating
kernel.*.  Probably sysctl dir kernel.legacy.*?  Then this sysctl would be
kernel.legacy.proc_pid_mem.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
