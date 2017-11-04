Date: Sat, 4 Nov 2017 00:44:51 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20171104004451.GP21978@ZenIV.linux.org.uk>
References: <20171103230426.19114-1-labbott@redhat.com>
 <20171103230426.19114-2-labbott@redhat.com>
 <CAGXu5jJconGeCQbRX9XOpPo__dgDY5zdRtb5G6ce7Wih7SHyiQ@mail.gmail.com>
 <20171104002430.GN21978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171104002430.GN21978@ZenIV.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [RFC PATCH 2/2] x86: Allow paranoid __{get,put}_user
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 04, 2017 at 12:24:30AM +0000, Al Viro wrote:
> On Fri, Nov 03, 2017 at 05:14:05PM -0700, Kees Cook wrote:
> > > x86 turns out to be easier since the safe and unsafe paths are mostly
> > > disjoint so we don't have to worry about gcc optimizing out access_ok.
> > > I tweaked the Kconfig to someting a bit more generic.
> > >
> > > The size increase was ~8K in text with a config I tested.
> > 
> > Specifically, this feature would have caught the waitid() bug in 4.13
> > immediately.
> 
> You mean, as soon as waitid() was given a kernel address.  At which point
> you'd get a shiny way to generate a BUG(), and if something like that
> happened under a mutex - it's even more fun...
> 
> > > +config PARANOID_UACCESS
> > > +       bool "Use paranoid uaccess primitives"
> > > +       depends on ARCH_HAS_PARANOID_UACCESS
> > > +       help
> > > +         Forces access_ok() checks in __get_user(), __put_user(), and other
> > > +         low-level uaccess primitives which usually do not have checks. This
> > > +         can limit the effect of missing access_ok() checks in higher-level
> > > +         primitives, with a runtime performance overhead in some cases and a
> > > +         small code size overhead.
> 
> IMO that's the wrong way to go - what we need is to reduce the amount of
> __get_user()/__put_user(), rather than "instrumenting" them that way.

FWIW, unsafe variants ought to be encapsulated in as few places as possible.
And that includes both unsafe_... and __... stuff.  waitid() had been a dumb
fuckup (by me) and it should've been done as

static int waitid_put_siginfo(struct siginfo __user *si, struct waitid_info *info,
				int signo)
{
	if (!si)
		return 0;
	if (!access_ok(VERIFY_WRITE, si, sizeof(struct siginfo)))
		return -EFAULT;
        user_access_begin();
        unsafe_put_user(signo, &si->si_signo, Efault);
        unsafe_put_user(0, &si->si_errno, Efault);
        unsafe_put_user(info->cause, &si->si_code, Efault);
        unsafe_put_user(info->pid, &si->si_pid, Efault);
        unsafe_put_user(info->uid, &si->si_uid, Efault);
        unsafe_put_user(info->status, &si->si_status, Efault);
        user_access_end();
        return 0;
Efault:
        user_access_end();
        return -EFAULT;
}

instead, rather than mixing it with the rest.  Basically, any unsafe... or __...
should be
	* used as little as possible
	* accompanied by access_ok() in the same function
	* not mixed with other stuff within the same function

We are obviously not there yet, but __get_user()/__put_user() *are* getting killed
off.
