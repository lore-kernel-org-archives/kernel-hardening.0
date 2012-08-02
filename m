Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120323190855.GA27213@www.outflux.net>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	<20120323190855.GA27213@www.outflux.net>
Date: Thu, 2 Aug 2012 12:35:57 +0200
Message-ID: <CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw@mail.gmail.com>
From: richard -rw- weinberger <richard.weinberger@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 23, 2012 at 8:08 PM, Kees Cook <keescook@chromium.org> wrote:
> Notify get_robust_list users that the syscall is going away.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

I'm using this system call in an application and noticed that's marked
as deprecated now.
My application collects all kind of information from crashing programs.
It's installed in /proc/sys/kernel/core_pattern.

If program X is crashing it executes get_robust_list(X) to get the
address of the robust list
and reads the list from /proc/X/mem.

Is there another way to get the robust list from another program (by it's pid)?

-- 
Thanks,
//richard
