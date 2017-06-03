Date: Sat, 3 Jun 2017 18:13:33 +0200
From: Solar Designer <solar@openwall.com>
Message-ID: <20170603161333.GA19418@openwall.com>
References: <20170603055351.16080-1-matt@nmatt.com> <20170603154707.GA19161@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170603154707.GA19161@openwall.com>
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as a stackable LSM
To: Matt Brown <matt@nmatt.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Matt,

On Sat, Jun 03, 2017 at 05:47:07PM +0200, Solar Designer wrote:
> On Sat, Jun 03, 2017 at 01:53:51AM -0400, Matt Brown wrote:
> > 2. Attacker on system replaces binary used by a privileged user with a
> >    malicious one
> > 
> > *  This situation arises when administrator of a system leaves a binary
> >    as world writable.
> > 
> > *  TPE is very effective against this threat model
> 
> This makes more sense to me.  It's known-bypassable policy enforcement
> by the sysadmin against one's own human error and such.  However, for
> this to be effective the exception "NOTE: root is never restricted by
> TPE" should be removed or made an option.
> 
> In a similar spirit, it'd also make sense to have a policy disallowing
> at least root to write into directories writable by other users without
> setting the O_EXCL flag.  I actually had this in a kernel module, which
> I used to find issues of this kind in Postfix in 2006 or so (Wietse
> promptly patched those), but I didn't try running this in production.

I misrecalled - that was in 2001, from Postfix's change log:

20011217
[...]
        Security: subtle hardening of the Postfix chroot jail,
        Postfix queue file permissions and access methods, in case
        someone compromises the postfix account.  Michael Tokarev,
        who received the insights from Solar Designer, who tested
        Postfix with a kernel module that is paranoid about open()
        calls.  Files:  master/master_wakeup.c, util/fifo_trigger.c,
        postfix-script.

2006 is when I finally met Wietse in real life, and then bothered to
forward-port the kernel module IIRC from 2.2 to 2.4 kernels and rerun it
on newer Postfix, which found no new issues (suggesting that no bugs of
this type were introduced into Postfix between 2001 and 2006, at least
for whatever coverage my little testing of it achieved).  This kind of
testing could be performed in userspace as well, such as with a revision
of strace or with a preloadable library, even if in an inherently racy
fashion (that's OK for non-production testing).

None of this is directly related to the TPE feature and patch indeed,
but it's something you may look into as well or refocus on.  This finds
real issues (errors in upstream software, distros, sysadmin practices),
and being bypassable is OK when it's not a policy against adversaries
but rather against unintentional errors.

> Summary: I see little value in TPE, but I don't intend to argue against
> it any further (and I deliberately dropped the CC list on this reply,
> not to hamper your efforts much).  If you choose to proceed with trying
> to upstream it anyway, I suggest the above changes to the description of
> the threat models and the tiny code change to allow for restricting root
> as well.

Alexander
