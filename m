Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 29 Jul 2011 13:00:53 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110729090053.GA7274@albatros>
References: <20110723162703.GA11631@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723162703.GA11631@openwall.com>
Subject: Re: [kernel-hardening] -ow features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jul 23, 2011 at 20:27 +0400, Solar Designer wrote:
> Can you please post a summary on the status of -ow patch features as it
> relates to mainline acceptance of their equivalents?

Sorry for the delay, I didn't somehow noticed this email.


HARDEN_STACK*

The code similar to -ow patch is ready, but it doesn't handle DSO cases
of stack usage.  I've described the problem here:

http://www.openwall.com/lists/kernel-hardening/2011/07/18/8


HARDEN_VM86

The code similar to -ow patch is ready, but I don't know how it should
be implemented relative to LSM/seccomp/etc.  It looks like a small
feature, which is not consistent with current upstream security
architecture.  I've described the problem here:

http://www.openwall.com/lists/kernel-hardening/2011/06/19/2

Without the major change of the configuration mechanism it's impossible
to get it applied.


HARDEN_PAGE0

It is a part of Linux for many years.  Distros may setup their own
mmap_min_addr limit and the default is 64K.  So, I don't see what can be
improved here.


HARDEN_LINK
HARDEN_FIFO

These are implemented in YAMA LSM.  Kees Cook's last attempt (AFAIK) is:

http://marc.info/?l=linux-security-module&m=130023775422255&w=2

James Morris' reaction:

http://marc.info/?l=linux-security-module&m=130032319219333&w=2

So, the issue is that LSM guys say that LSM is the place where only
enhanced access control schemes may be located, but VFS folks
say that all similar non-POSIX restrictions should go into LSM as a
configurable security feature (extern relative to VFS).  This
inconsistency is really nasty :(


HARDEN_PROC

The patch as in -ow received negative response from Andrew Morton as too
limited:

http://www.openwall.com/lists/kernel-hardening/2011/06/21/3

I'm working on it.  The demonstration is:

http://www.openwall.com/lists/kernel-hardening/2011/07/26/5


HARDEN_NLIMIT_NPROC

The discussion:

http://www.openwall.com/lists/kernel-hardening/2011/06/12/9

The latest patch:

http://www.openwall.com/lists/kernel-hardening/2011/07/29/3

(It has already got a Reviewed-by from James, which is very good.)


HARDEN_SHM

The patch:

http://www.openwall.com/lists/kernel-hardening/2011/06/22/4

It was applied first to -mm tree, now it is merged into Linus' linux-2.6
tree (it will be part of Linux 3.1).


Special handling of fd 0,1,2 (Linux 2.0/2.2) for set*id

It is handled in glibc now by opening /dev/{null,full}, however, I see
(minor) drawbacks:

1) It's possible to have a chroot without polluted /dev/, so setuid
inside of chroot might fail to reopen fds.

2) It's not handled in other libc implementations.

Other than that, it already works.


Privileged IP aliases (Linux 2.0)

I think it was fully obsoleted with network namespaces.


Thanks,

-- 
Vasiliy
