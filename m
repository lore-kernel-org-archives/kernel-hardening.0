Message-ID: <1536681662.3382.7.camel@linux.intel.com>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
From: Kristen C Accardi <kristen@linux.intel.com>
Date: Tue, 11 Sep 2018 09:01:02 -0700
In-Reply-To: <20180911084148.GA23570@kroah.com>
References: <20180910191002.350195-1-kristen@linux.intel.com>
	 <20180911084148.GA23570@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2018-09-11 at 10:41 +0200, Greg KH wrote:
> On Mon, Sep 10, 2018 at 12:10:02PM -0700, Kristen Carlson Accardi
> wrote:
> > This patch aims to make it harder to perform cache timing attacks
> > on data
> > left behind by system calls. If we have an error returned from a
> > syscall,
> > flush the L1 cache.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > ---
> >  arch/x86/Kconfig        |  8 ++++++++
> >  arch/x86/entry/common.c | 20 ++++++++++++++++++++
> >  2 files changed, 28 insertions(+)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index c5ff296bc5d1..8a67642ff9fe 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -445,6 +445,14 @@ config RETPOLINE
> >  	  code are eliminated. Since this includes the syscall
> > entry path,
> >  	  it is not entirely pointless.
> >  
> > +config SYSCALL_FLUSH
> > +	bool "Clear L1 Cache on syscall errors"
> > +	default y
> 
> "y" normally is only for "your machine will not boot without this
> option", and I don't think that's the case here :)

true. :). I wish there was a way to indicate that this option provided
enhanced security so that people could just select all of these
features at once and I could make it select based on that option.

> 
> > +	help
> > +	  Select to allow the L1 cache to be cleared upon return
> > of
> > +	  an error code from a syscall. This will reduce the
> > likelyhood of
> > +	  speculative execution style attacks on syscalls.
> 
> Shouldn't this help text refer to the fact that this needs CPU
> support
> for this type of functionality?

OK, I will change it.

> 
> I like the idea, as a "gadget" normally only is used when an
> out-of-bands check happens, which implies someone could be trying to
> do
> something "bad", nice job.
> 
> thanks,
> 
> greg k-h

Thanks!
