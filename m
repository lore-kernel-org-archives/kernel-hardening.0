Reply-To: kernel-hardening@lists.openwall.com
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201308031715.FCH73469.OVOHQStOFMLJFF@I-love.SAKURA.ne.jp>
	<20130807143151.GA4560@cachalot>
In-Reply-To: <20130807143151.GA4560@cachalot>
Message-Id: <201308081950.HDC18500.OFSFMHOtFLJQVO@I-love.SAKURA.ne.jp>
Date: Thu, 8 Aug 2013 19:50:33 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [RFC] KPortReserve : kernel version of portreserve utility
To: segoon@openwall.com
Cc: twaugh@redhat.com, amwang@redhat.com, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasily Kulikov wrote:
> Wait, it restrict the port to a *program*, not a user/group/security
> domain?  It means *any* user may run this program and obtain the port.
> Is it intentional behaviour?

Yes, it is intentional behaviour. Below is the background of proposing this
functionality.

I sometimes hear of troubles caused by local port reservation conflicts.
For example, active/standby high-availability services failed to failover
because the migrating application failed to bind() to port number which the
application uses was already used by other applications (e.g. portmap ,
vsftpd ) when failover occurred.
For another example, some enterprise application failed to start because
the application failed to bind() to port numbers which the application uses
was already used by other applications when the application starts.

Regarding autobind cases, /proc/sys/net/ipv4/ip_local_reserved_ports can
prevent troubles shown above. But regarding non-autobind cases,
/proc/sys/net/ipv4/ip_local_reserved_ports cannot.

While portreserve utility is provided for managing non-autobind cases, it is
not available in RHEL4/5. While it is available in RHEL6, it is not race-free.

Thus, I decided to write a trivial, race-free kernel module which restricts
local ports to the programs.

The applications which I care are likely running as root user. Thus, I'm not
feeling that this module needs to restrict the port to a user/group/security
domain.

> I guess it would be MUCH more useful to
> allow some port to this specific user, NOT a program.  For most daemons
> we have separate user accounts (SELinux contexts in some distros,
> whatever), so it makes sense to limit the port to a UID/GID (or LSM's
> security context).

I know. Skilled users can use more complicated implementations which restrict
the port to a user/group/security domain. The goal of this module is to allow
unskilled users to use this module as simple/easy as
/proc/sys/net/ipv4/ip_local_reserved_ports .



> d_absolute_path() may fail in case of not only ENOMEM, but also EINVAL.

Indeed. I truncated too much.

Well, if the system entered into a situation where d_absolute_path() returns
EINVAL, program's pathname can never be calculated and we would need to choose
one from

  any program which got EINVAL cannot bind() the reserved port

and

  any program which got EINVAL can bind() the reserved port

if answer to Question 5 is "no".



(Question 5) Do we want to distinguish interpreter/busybox programs?

I worry that the use of /proc/self/exe is too coarse in some systems.
Say, there are four programs.

  (1) /sbin/prog1 starts with "#! /usr/bin/perl" and calls bind() with port
      50000 and the EADDRINUSE error is fatal.

  (2) /bin/prog2 starts with "#! /usr/bin/perl" and calls bind() with randomly
      chosen non-0 port numbers but the EADDRINUSE error is not fatal.

  (3) /bin/prog3 is a symlink to a multicall-binary and calls bind() with port
      60000 and the EADDRINUSE error is fatal.

  (4) /bin/prog4 is a symlink to a multicall-binary and calls bind() with
      randomly chosen non-0 port numbers but the EADDRINUSE error is not fatal.

The content of /proc/self/exe cannot distinguish (1) and (2) because they are
both /usr/bin/perl . But users might expect this module to return 0 for (1)
and return EADDRINUSE for (2).

The content of /proc/self/exe cannot distinguish (3) and (4) if they are
symlinks to the same multicall-binary. But users might expect this module
to return 0 for (3) and return EADDRINUSE for (4).

To distinguish such cases, I need to use the pathname passed to do_execve()
rather than the content of /proc/self/exe .
