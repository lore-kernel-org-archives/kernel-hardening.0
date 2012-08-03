Reply-To: kernel-hardening@lists.openwall.com
Sender: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Fri, 3 Aug 2012 15:02:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
Message-ID: <20120803110247.GB11952@moon>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
 <20120323190855.GA27213@www.outflux.net>
 <CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw@mail.gmail.com>
 <87pq7935w2.fsf@xmission.com>
 <CAFLxGvz0reQS=zfWeTz4a4xZVFeeu80VnP-efy7zCiPZVWzH-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvz0reQS=zfWeTz4a4xZVFeeu80VnP-efy7zCiPZVWzH-g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: richard -rw- weinberger <richard.weinberger@gmail.com>, Pavel Emelyanov <xemul@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 03, 2012 at 12:17:43PM +0200, richard -rw- weinberger wrote:
> On Thu, Aug 2, 2012 at 1:11 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > richard -rw- weinberger <richard.weinberger@gmail.com> writes:
> >
> >> On Fri, Mar 23, 2012 at 8:08 PM, Kees Cook <keescook@chromium.org> wrote:
> >>> Notify get_robust_list users that the syscall is going away.
> >>>
> >>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> >>> Signed-off-by: Kees Cook <keescook@chromium.org>
> >>> ---
> >>
> >> I'm using this system call in an application and noticed that's marked
> >> as deprecated now.
> >> My application collects all kind of information from crashing programs.
> >> It's installed in /proc/sys/kernel/core_pattern.
> >>
> >> If program X is crashing it executes get_robust_list(X) to get the
> >> address of the robust list
> >> and reads the list from /proc/X/mem.
> >>
> >> Is there another way to get the robust list from another program (by it's pid)?
> >
> > The folks doing checkpoint/restart claim to not need this, so there
> > might be a way either that or they just haven't hit this problem yet.
> >
> > What you are doing sounds like a reasonable use of get_robust_list to me.
> >
> 
> CRIU folks, how do you deal with futex robust lists?

Well, I believe we were over-optimistic in claiming that we don't need this
syscall (to be fair I think we simply yet not faced the problem Eric points).
So we need some way to fetch this address and set it back. If get_robust_list
get deprecated maybe we could print it out in /proc/pid/stat or something?

	Cyrill
