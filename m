Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Jan 2012 08:10:37 +0100
From: Ingo Molnar <mingo@elte.hu>
Message-ID: <20120106071037.GA14188@elte.hu>
References: <20120104201800.GA2587@www.outflux.net>
 <20120105143008.GA31728@elliptictech.com>
 <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com>
 <20120105200810.GA3826@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120105200810.GA3826@elliptictech.com>
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


* Nick Bowler <nbowler@elliptictech.com> wrote:

> > >> +config PROTECTED_STICKY_SYMLINKS
> > >> +     bool "Protect symlink following in sticky world-writable directories"
> > >> +     default y
> > > [...]
> > >
> > > Why do we need a config option for this?  What's wrong 
> > > with just using the sysctl?
> > 
> > This way the sysctl can configured directly without needing 
> > to have a distro add a new item to sysctl.conf.
> 
> This seems totally pointless to me. [...]

It's how we add new features typically. From a distro's POV 
.config's are a lot more durable than system specific 
sysctl.conf's.

User can of course still override via the sysctl.conf, but the 
kernel (and the distro) wants to provide a sane default that 
does not depend on userspace settings.

Also, there are people who test new kernels but don't want to 
change the underlying distro. Twiddling such .config values is 
quite straightforward for them.

> [...]  There are tons of sysctls that don't have Kconfig 
> options: what makes this one special?

Those are old mistakes we want to forget about.

> > > Why have you made this option "default y", when enabling 
> > > it clearly makes user-visible changes to kernel behaviour?
> > 
> > Ingo specifically asked me to make it "default y".
> 
> But this is a brand new feature that changes longstanding 
> behaviour of various syscalls.  Making it default to enabled 
> is rather mean to users (since it will tend to get enabled by 
> "oldconfig") and seems almost guaranteed to cause regressions.

The changelog of the feature (which feature has been in use for 
years in various [admittedly smaller] distros) says that it does 
not break apps.

Worth a try: it will be very easy to flip it back if it causes a 
regression - but we'd like it to have at least *some* testing in 
the merge window to see whether there *is* some broken (or not 
so broken) app that relies on the current semantics.

Thanks,

	Ingo
