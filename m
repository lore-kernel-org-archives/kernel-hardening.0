Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 5 Jan 2012 17:18:17 -0500
From: Nick Bowler <nbowler@elliptictech.com>
Message-ID: <20120105221817.GA4498@elliptictech.com>
References: <20120104201800.GA2587@www.outflux.net>
 <20120105143008.GA31728@elliptictech.com>
 <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com>
 <20120105200810.GA3826@elliptictech.com>
 <CAGXu5jKe_qpQ9yG4f0J_94WNKYy_qdDNdVW4v74ZivwO4Xy0Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jKe_qpQ9yG4f0J_94WNKYy_qdDNdVW4v74ZivwO4Xy0Rg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2012-01-05 12:55 -0800, Kees Cook wrote:
> On Thu, Jan 5, 2012 at 12:08 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> > On 2012-01-05 11:34 -0800, Kees Cook wrote:
> >> On Thu, Jan 5, 2012 at 6:30 AM, Nick Bowler <nbowler@elliptictech.com> wrote:
> >> > On 2012-01-04 12:18 -0800, Kees Cook wrote:
> >> >> diff --git a/fs/Kconfig b/fs/Kconfig
> >> >> index 5f4c45d..26ede24 100644
> >> >> --- a/fs/Kconfig
> >> >> +++ b/fs/Kconfig
> >> >> @@ -278,3 +278,19 @@ source "fs/nls/Kconfig"
> >> >>  source "fs/dlm/Kconfig"
> >> >>
> >> >>  endmenu
> >> >> +
> >> >> +config PROTECTED_STICKY_SYMLINKS
> >> >> +     bool "Protect symlink following in sticky world-writable directories"
> >> >> +     default y
> >> > [...]
> >> >
> >> > Why do we need a config option for this?  What's wrong with just using
> >> > the sysctl?
> >>
> >> This way the sysctl can configured directly without needing to have a
> >> distro add a new item to sysctl.conf.
> >
> > This seems totally pointless to me.  There are tons of sysctls that
> > don't have Kconfig options: what makes this one special?
> 
> Most are system tuning; this is directly related to vulnerability
> mitigation. Besides, I like having CONFIGs for sysctls because then I
> can build my kernel the way I want it without having to worry about
> tweaking my userspace sysctl.conf file, or run newer kernels on older
> userspaces, etc etc.

I agree that having kconfig knobs for sysctls may be convenient for some
users.  But every kconfig option we add requires the user to make a
decision before building their kernel.  In this case, this decision is
a waste of time because the option doesn't really affect the kernel in a
meaningful way: either choice can be easily changed from userspace after
booting.  A similar argument could be applied to almost any sysctl, and
we could add hundreds of new Kconfig options to control their default
values.  The result would be untenable.

Perhaps what we need instead is a way to set arbitrary sysctls from the
kernel command line.  This could easily be done by an initramfs, and not
require any changes to the kernel at all.

> >> > Why have you made this option "default y", when enabling it clearly
> >> > makes user-visible changes to kernel behaviour?
> >>
> >> Ingo specifically asked me to make it "default y".
> >
> > But this is a brand new feature that changes longstanding behaviour of
> > various syscalls.  Making it default to enabled is rather mean to users
> > (since it will tend to get enabled by "oldconfig") and seems almost
> > guaranteed to cause regressions.
> 
> I couldn't disagree more. There has been zero evidence of this change
> causing anything but regressions in _attacks_.

We have absolutely no idea what applications people are running that
will be affected by this change.  Of course there's no evidence of
breakage, because affected users (if any) have not had a single chance
to try this new feature out: it's not in the kernel yet.

> If anything, I think there should be no CONFIG and no sysctl, and it
> should be entirely non-optional. But since this patch needs consensus,
> I have provided knobs to control it. This is the way of security
> features. For example, years back I added a knob for /proc/$pid/maps
> protection being optional (and defaulted it to insecure because of
> people's fear of regression), and eventually it changed to
> secure-by-default, and then the knob went away completely because it
> didn't actually cause problems.

The process you describe above for /proc/$pid/maps is the right way to
change kernel behaviour while mitigating the risk of regressions.  With
this patch, you've skipped all those important steps!

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
