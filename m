Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 24 Jan 2012 15:51:04 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20120124115104.GA5743@albatros>
References: <20120123212115.GA29641@www.outflux.net>
 <20120124110332.GA4770@albatros>
 <CACVxJT95OjBkqh01AGVLVXDEw3YNaEcCNptgM9kbb47AG5C7zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVxJT95OjBkqh01AGVLVXDEw3YNaEcCNptgM9kbb47AG5C7zg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3] sysctl: control functionality of /proc/pid/mem
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>, Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 24, 2012 at 13:12 +0200, Alexey Dobriyan wrote:
> On 1/24/12, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >> +		.procname	= "proc_pid_mem",
> >> +		.data		= &sysctl_proc_pid_mem,
> >> +		.maxlen		= sizeof(int),
> >> +		.mode		= 0644,
> >> +		.proc_handler	= proc_dointvec_minmax,
> >> +		.extra1		= &zero,
> >> +		.extra2		= &two,
> >> +	},
> 
> >E.g. moving all such stuff to some sysctl group, not bloating
> > kernel.*.
> 
> Ehh.
> How bloat is measured in this case?

Do we want to add such sort of sysctls "from time to time" when we
consider one or another feature as deprecated?  If yes, I'd group them
somehow, e.g. by introducing subdirectory inside of kernel.

Btw, kernel sysctl dir contains all sort of stuff which goes to "kernel"
as if it is "etc".  It already contains ftrace, perf, printk, scheduler,
ipc.  IMHO plain kernel hierarchy is not profitable in the long term.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
