Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1484671979.2886.12.camel@poochiereds.net>
From: Jeff Layton <jlayton@poochiereds.net>
Date: Tue, 17 Jan 2017 11:52:59 -0500
In-Reply-To: <20170117162627.GA9186@kroah.com>
References: <20170116164944.GA28984@kroah.com>
	 <20170116165044.GC29693@kroah.com>
	 <1484670023.2886.10.camel@poochiereds.net>
	 <20170117162627.GA9186@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH 3/3] Introduce STATIC_USERMODEHELPER to mediate
 call_usermodehelper()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Sailer <t.sailer@alumni.ethz.ch>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-01-17 at 17:26 +0100, Greg KH wrote:
> On Tue, Jan 17, 2017 at 11:20:23AM -0500, Jeff Layton wrote:
> > On Mon, 2017-01-16 at 17:50 +0100, Greg KH wrote:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > Some usermode helper applications are defined at kernel build time, while
> > > others can be changed at runtime.  To provide a sane way to filter these, add a
> > > new kernel option "STATIC_USERMODEHELPER".  This option routes all
> > > call_usermodehelper() calls through this binary, no matter what the caller
> > > wishes to have called.
> > > 
> > > The new binary (by default set to /sbin/usermode-helper, but can be changed
> > > through the STATIC_USERMODEHELPER_PATH option) can properly filter the
> > > requested programs to be run by the kernel by looking at the first argument
> > > that is passed to it.  All other options should then be passed onto the proper
> > > program if so desired.
> > > 
> > > To disable all call_usermodehelper() calls by the kernel, set
> > > STATIC_USERMODEHELPER_PATH to an empty string.
> > > 
> > > Thanks to Neil Brown for the idea of this feature.
> > > 
> > > Cc: NeilBrown <neilb@suse.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  kernel/kmod.c    | 14 ++++++++++++++
> > >  security/Kconfig | 35 +++++++++++++++++++++++++++++++++++
> > >  2 files changed, 49 insertions(+)
> > > 
> > > diff --git a/kernel/kmod.c b/kernel/kmod.c
> > > index 426a614e97fe..0c407f905ca4 100644
> > > --- a/kernel/kmod.c
> > > +++ b/kernel/kmod.c
> > > @@ -528,7 +528,12 @@ struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
> > >  		goto out;
> > >  
> > >  	INIT_WORK(&sub_info->work, call_usermodehelper_exec_work);
> > > +
> > > +#ifdef CONFIG_STATIC_USERMODEHELPER
> > > +	sub_info->path = CONFIG_STATIC_USERMODEHELPER_PATH;
> > > +#else
> > >  	sub_info->path = path;
> > > +#endif
> > >  	sub_info->argv = argv;
> > >  	sub_info->envp = envp;
> > >  
> > > @@ -566,6 +571,15 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
> > >  		retval = -EBUSY;
> > >  		goto out;
> > >  	}
> > > +
> > > +	/*
> > > +	 * If there is no binary for us to call, then just return and get out of
> > > +	 * here.  This allows us to set STATIC_USERMODEHELPER_PATH to "" and
> > > +	 * disable all call_usermodehelper() calls.
> > > +	 */
> > > +	if (strlen(sub_info->path) == 0)
> > > +		goto out;
> > > +
> > >  	/*
> > >  	 * Set the completion pointer only if there is a waiter.
> > >  	 * This makes it possible to use umh_complete to free
> > > diff --git a/security/Kconfig b/security/Kconfig
> > > index 118f4549404e..d900f47eaa68 100644
> > > --- a/security/Kconfig
> > > +++ b/security/Kconfig
> > > @@ -158,6 +158,41 @@ config HARDENED_USERCOPY_PAGESPAN
> > >  	  been removed. This config is intended to be used only while
> > >  	  trying to find such users.
> > >  
> > > +config STATIC_USERMODEHELPER
> > > +	bool "Force all usermode helper calls through a single binary"
> > > +	help
> > > +	  By default, the kernel can call many different userspace
> > > +	  binary programs through the "usermode helper" kernel
> > > +	  interface.  Some of these binaries are statically defined
> > > +	  either in the kernel code itself, or as a kernel configuration
> > > +	  option.  However, some of these are dynamically created at
> > > +	  runtime, or can be modified after the kernel has started up.
> > > +	  To provide an additional layer of security, route all of these
> > > +	  calls through a single executable that can not have its name
> > > +	  changed.
> > > +
> > > +	  Note, it is up to this single binary to then call the relevant
> > > +	  "real" usermode helper binary, based on the first argument
> > > +	  passed to it.  If desired, this program can filter and pick
> > > +	  and choose what real programs are called.
> > > +
> > > +	  If you wish for all usermode helper programs are to be
> > > +	  disabled, choose this option and then set
> > > +	  STATIC_USERMODEHELPER_PATH to an empty string.
> > > +
> > > +config STATIC_USERMODEHELPER_PATH
> > > +	string "Path to the static usermode helper binary"
> > > +	depends on STATIC_USERMODEHELPER
> > > +	default "/sbin/usermode-helper"
> > > +	help
> > > +	  The binary called by the kernel when any usermode helper
> > > +	  program is wish to be run.  The "real" application's name will
> > > +	  be in the first argument passed to this program on the command
> > > +	  line.
> > > +
> > > +	  If you wish for all usermode helper programs to be disabled,
> > > +	  specify an empty string here (i.e. "").
> > > +
> > >  source security/selinux/Kconfig
> > >  source security/smack/Kconfig
> > >  source security/tomoyo/Kconfig
> > 
> > I like the core of this idea (having a single dispatch binary) a lot. It
> > seems like a good way to limit the attack surface. We could even
> > consider signing this binary as well, etc...
> 
> Or use a read-only partition that is checked with dm-verity at boot so
> you know it's safe.  Lots of ways to protect this file.
> 

...and the binary could be even more helpful too -- drop capabilities or
change task creds before calling exec, for some binaries for instance. 

This may even provide a way to allow the upcalls to switch to the
appropriate namespaces maybe based  on info passed in env vars?

In any case, there are a lot of useful possibilities here.

> > I'm less excited though about using the binary pathnames in argv[0].
> > Would it be better to pass a non-path string of some sort that the
> > binary would have to turn into a path to the binary to exec?
> 
> What exactly do you mean by "non-path" string?  You can do whatever you
> want with the argv[0] value in your new binary, but rewriting all of the
> users of this interface in the kernel to pass in some other type of
> value instead of a full path, that doesn't make much sense (hint a path
> is just as good as anything else.)
> 
> 

I guess I'm thinking that this new binary is an opportunity to formalize
the usermode helper upcall stuff to be more of a real ABI. It's rather
haphazard now.

So yeah, the pathname strings would work fine as dispatch keys, but it
is a rather ugly interface. It might be nicer to pass in some set of
opaque string tokens so that the upcalls being requested have a real
meaning that's not defined by the legacy pathnames?

Hmm...I guess in that case we could pass this token along in the env
array as well. Fair enough, I think this is fine.

Acked-by: Jeff Layton <jlayton@poochiereds.net>
