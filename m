Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 5 Jan 2012 10:17:04 +0100
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20120105091704.GB3249@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104201800.GA2587@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> @@ -1495,6 +1496,15 @@ static struct ctl_table fs_table[] = {
>  #endif
>  #endif
>  	{
> +		.procname	= "protected_sticky_symlinks",
> +		.data		= &protected_sticky_symlinks,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},

Small detail:

Might make sense to change the .mode to 0600, to make it harder 
for unprivileged attack code to guess whether this protection 
(and the resulting audit warning to the administrator) is 
enabled on a system or not.

It can be probed, but only at the cost of generating a warning.

Likewise, distros should set /etc/sysctl.conf to 0600 as well, 
for similar reasons.

Thanks,

	Ingo
