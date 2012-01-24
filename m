Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120124110332.GA4770@albatros>
References: <20120123212115.GA29641@www.outflux.net>
	<20120124110332.GA4770@albatros>
Date: Tue, 24 Jan 2012 13:12:36 +0200
Message-ID: <CACVxJT95OjBkqh01AGVLVXDEw3YNaEcCNptgM9kbb47AG5C7zg@mail.gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v3] sysctl: control functionality of /proc/pid/mem
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Randy Dunlap <rdunlap@xenotime.net>, Borislav Petkov <bp@alien8.de>, Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>, David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 1/24/12, Vasiliy Kulikov <segoon@openwall.com> wrote:
>> +		.procname	= "proc_pid_mem",
>> +		.data		= &sysctl_proc_pid_mem,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec_minmax,
>> +		.extra1		= &zero,
>> +		.extra2		= &two,
>> +	},

>E.g. moving all such stuff to some sysctl group, not bloating
> kernel.*.

Ehh.
How bloat is measured in this case?
