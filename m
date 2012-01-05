Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 5 Jan 2012 15:08:10 -0500
From: Nick Bowler <nbowler@elliptictech.com>
Message-ID: <20120105200810.GA3826@elliptictech.com>
References: <20120104201800.GA2587@www.outflux.net>
 <20120105143008.GA31728@elliptictech.com>
 <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2012-01-05 11:34 -0800, Kees Cook wrote:
> On Thu, Jan 5, 2012 at 6:30 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
> > On 2012-01-04 12:18 -0800, Kees Cook wrote:
> >> diff --git a/fs/Kconfig b/fs/Kconfig
> >> index 5f4c45d..26ede24 100644
> >> --- a/fs/Kconfig
> >> +++ b/fs/Kconfig
> >> @@ -278,3 +278,19 @@ source "fs/nls/Kconfig"
> >>  source "fs/dlm/Kconfig"
> >>
> >>  endmenu
> >> +
> >> +config PROTECTED_STICKY_SYMLINKS
> >> +     bool "Protect symlink following in sticky world-writable directories"
> >> +     default y
> > [...]
> >
> > Why do we need a config option for this?  What's wrong with just using
> > the sysctl?
> 
> This way the sysctl can configured directly without needing to have a
> distro add a new item to sysctl.conf.

This seems totally pointless to me.  There are tons of sysctls that
don't have Kconfig options: what makes this one special?

> > Why have you made this option "default y", when enabling it clearly
> > makes user-visible changes to kernel behaviour?
> 
> Ingo specifically asked me to make it "default y".

But this is a brand new feature that changes longstanding behaviour of
various syscalls.  Making it default to enabled is rather mean to users
(since it will tend to get enabled by "oldconfig") and seems almost
guaranteed to cause regressions.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
