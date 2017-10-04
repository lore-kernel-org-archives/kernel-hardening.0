Date: Wed, 4 Oct 2017 21:42:40 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171004104240.GC16685@eros>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <1506816410-10230-3-git-send-email-me@tobin.cc>
 <20171002104205.GC3823@arm.com>
 <20171004085657.GC28247@kroah.com>
 <20171004085810.GA14022@arm.com>
 <20171004090255.GA29316@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004090255.GA29316@kroah.com>
Subject: Re: [kernel-hardening] [RFC V2 2/6] lib: vsprintf: whitelist stack
 traces
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Will Deacon <will.deacon@arm.com>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 04, 2017 at 11:02:55AM +0200, Greg KH wrote:
> On Wed, Oct 04, 2017 at 09:58:10AM +0100, Will Deacon wrote:
> > On Wed, Oct 04, 2017 at 10:56:57AM +0200, Greg KH wrote:
> > > On Mon, Oct 02, 2017 at 11:42:05AM +0100, Will Deacon wrote:
> > > > On Sun, Oct 01, 2017 at 11:06:46AM +1100, Tobin C. Harding wrote:
> > > > > Use the %pP functionality to explicitly allow kernel
> > > > > pointers to be logged for stack traces.
> > > > > 
> > > > > Signed-off-by: Tobin C. Harding <me@tobin.cc>
> > > > > ---
> > > > >  arch/arm64/kernel/traps.c | 4 ++--
> > > > >  kernel/printk/printk.c    | 2 +-
> > > > >  2 files changed, 3 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> > > > > index 5ea4b85..fe09660 100644
> > > > > --- a/arch/arm64/kernel/traps.c
> > > > > +++ b/arch/arm64/kernel/traps.c
> > > > > @@ -147,7 +147,7 @@ void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk)
> > > > >  	struct stackframe frame;
> > > > >  	int skip;
> > > > >  
> > > > > -	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
> > > > > +	pr_debug("%s(regs = %pP tsk = %pP)\n", __func__, regs, tsk);
> > > > 
> > > > Why do we care for pr_debug?
> > > 
> > > Because you really want the real value?  Seems to make sense to me...
> > 
> > Just seems like anybody debugging the kernel using pr_debug can probably
> > change /proc/sys/kernel/kptr_restrict...
> 
> Ok, fair enough :)

For what its worth I agree with Will.
