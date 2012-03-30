Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 30 Mar 2012 18:51:48 -0400
From: Gene Cooperman <gene@ccs.neu.edu>
Message-ID: <20120330225148.GC26814@mspacman.ccs.neu.edu>
References: <20120323190855.GA27213@www.outflux.net>
 <m1fwczvuph.fsf@fess.ebiederm.org>
 <20120330050544.GA32299@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330050544.GA32299@count0.beaverton.ibm.com>
Sender: Gene Cooperman <gene@ccs.neu.edu>
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, spender@grsecurity.net, Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-doc@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>, Darren Hart <dvhart@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Linux Containers <containers@lists.linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Cyrill Gorcunov <gorcunov@openvz.org>, Pavel Emelyanov <xemul@parallels.com>, Gene Cooperman <gene@ccs.neu.edu>
List-ID: <kernel-hardening.lists.openwall.com>

Thanks for including us in the cc, Matt.  
We don't need the system call for DMTCP either.

Also, in our DMTCP user base, we haven't had any requests to support
checkpointing of user code with get_robust_list().  If a user had needed
this or a similar system call, I suspect our new plugin architecture
would make it easy to eupport.  But it's a non-issue now.

Thanks,
- Gene

On Thu, Mar 29, 2012 at 10:05:44PM -0700, Matt Helsley wrote:
> On Fri, Mar 23, 2012 at 03:06:02PM -0700, Eric W. Biederman wrote:
> > Kees Cook <keescook@chromium.org> writes:
> > 
> > > Notify get_robust_list users that the syscall is going away.
> > 
> > Has anyone asked the question if the folks working on checkpoint/restart
> > are going to need this.
> > 
> > This seems like important information to know if you want to checkpoint
> > a process.
> 
> I have no idea if the CRIU and DMTCP folks care about this. I've added
> some folks related to those projects to the Cc list.
> 
> > 
> > Eric
> > 
> > > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > > v2:
> > >  - add note to feature-removal-schedule.txt.
> > > ---
> > >  Documentation/feature-removal-schedule.txt |   10 ++++++++++
> > >  kernel/futex.c                             |    2 ++
> > >  kernel/futex_compat.c                      |    2 ++
> > >  3 files changed, 14 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > > index 4bfd982..e3bf119 100644
> > > --- a/Documentation/feature-removal-schedule.txt
> > > +++ b/Documentation/feature-removal-schedule.txt
> > > @@ -543,3 +543,13 @@ When:	3.5
> > >  Why:	The old kmap_atomic() with two arguments is deprecated, we only
> > >  	keep it for backward compatibility for few cycles and then drop it.
> > >  Who:	Cong Wang <amwang@redhat.com>
> > > +
> > > +----------------------------
> > > +
> > > +What:	get_robust_list syscall
> > > +When:	2013
> > > +Why:	There appear to be no production users of the get_robust_list syscall,
> > > +	and it runs the risk of leaking address locations, allowing the bypass
> > > +	of ASLR. It was only ever intended for debugging, so it should be
> > > +	removed.
> 
> So I've looked in glibc, gdb, and DMTCP. The description of the intended
> use of get_robust_list() is accurate. However the benefit of ASLR is
> less clear when it comes to the robust list. In glibc the robust list is
> only used from NPTL. The robust list head is in struct pthread which can be
> obtained from pthread_self() anyway. Thus I think ASLR doesn't really help
> obfuscate the robust futex list unless the program is using robust futexes
> without the aid of glibc.
> 
> Cheers,
> 	-Matt Helsley
> 
