Date: Fri, 19 Jan 2018 03:27:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20180119032719.GG13338@ZenIV.linux.org.uk>
References: <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
 <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
 <CA+55aFxAFG5czVmCyhYMyHmXLNJ7pcXxWzusjZvLRh_qTGHj6Q@mail.gmail.com>
 <CA+55aFxB01XEEpdPynwYmzQMfTJdJnUrN+ZLqSV_UdnKLBgAZw@mail.gmail.com>
 <1516198646.4184.13.camel@linux.intel.com>
 <20180117185232.GW13338@ZenIV.linux.org.uk>
 <20180118030634.GY13338@ZenIV.linux.org.uk>
 <CA+55aFzKPed+89wz=ajWNpsQ8Kh+AQWx61hwVqqDh7_=h4tecg@mail.gmail.com>
 <20180118044302.GZ13338@ZenIV.linux.org.uk>
 <20180118193156.GC13338@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180118193156.GC13338@ZenIV.linux.org.uk>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: [RFC][PATCH] get rid of the use of set_fs() (by way of
 kernel_recvmsg()) in sunrpc
To: Network Development <netdev@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, David Miller <davem@davemloft.net>, Linus Torvalds <torvalds@linux-foundation.org>, Ralf Baechle <ralf@linux-mips.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 18, 2018 at 07:31:56PM +0000, Al Viro wrote:

> * SIOCADDRT/SIOCDELRT in compat ioctls

To bring back a question I'd asked back in October - what do
we do about SIOC...RT compat?

To recap:
	* AF_INET sockets expect struct rtentry; it differs
between 32bit and 64bit, so routing_ioctl() in net/socket.c
is called from compat_sock_ioctl_trans() and does the right
thing.  All proto_ops instances with .family = PF_INET (and
only they) have inet_ioctl() as ->ioctl(), and end up with
ip_rt_ioctl() called for native ones.  Three of those have
->compat_ioctl() set to inet_compat_ioctl(), the rest have
it NULL.  In any case, inet_compat_ioctl() ignores those,
leaving them to compat_sock_ioctl_trans() to pick up.
	* for AF_INET6 the situation is similar, except that
they use struct in6_rtmsg.  Compat is also dealt with in
routing_ioctl().  inet6_ioctl() for all such proto_ops
(and only those), ipv6_route_ioctl() is what ends up
handling the native ones.  No ->compat_ioctl() in any
of those.
	* AF_PACKET sockets expect struct rt_entry and
actually bounce the native calls to inet_ioctl().  No
->compat_ioctl() there, but routing_ioctl() in net/socket.c
does the right thing.
	* AF_APPLETALK sockets expect struct rt_entry.
Native handled in atrtr_ioctl(); there is ->compat_ioctl(),
but it ignores those ioctls, so we go through the conversion
in net/socket.c.  Also happens to work correctly.

	* ax25, ipx, netrom, rose and x25 use structures
of their own, and those structures have identical layouts on
32bit and 64bit.  x25 has ->compat_ioctl() that does the
right thing (bounces to native), the rest either have
->compat_ioctl() ignoring those ioctls (ipx) or do not
have ->compat_ioctl() at all.  That ends up with generic
code picking those and buggering them up - routing_ioctl()
assumes that we want either in6_rtmsg (ipv6) or rtentry
(everything else).  Unfortunately, in case of these
protocols we should just leave the suckers alone.
	Back then Ralf has verified that the bug exists
and said he'd put together a fix.  Looks like that fix
has fallen through the cracks, though.

	* all other protocols fail those; usually with
ENOTTY, except for AF_QIPCRTR that fails with EINVAL.
Either way, compat is not an issue.

	Note that handling of SIOCADDRT on e.g. raw ipv4
sockets from 32bit process is convoluted as hell.  The
call chain is
	compat_sys_ioctl()
		compat_sock_ioctl()
			inet_compat_ioctl()
				compat_raw_ioctl()
					=> -ENOIOCTLCMD, possibly
					    by way of ipmr_compat_ioctl()
			compat_sock_ioctl_trans()
				routing_ioctl() [conversion done here]
					sock_do_ioctl()
						inet_ioctl()
							ip_rt_ioctl()
A lot of those are method calls, BTW, and the overhead on those has
just grown...

Does anybody have objections against the following?

1) Somewhere in net/core (or net/compat.c, for that matter) add
int compat_get_rtentry(struct rtentry *r, struct rtentry32 __user *p);

2) In inet_compat_ioctl() recognize SIOC{ADD,DEL}RT and do
		err = compat_get_rtentry(&r, (void __user *)arg);
		if (!err)
			err = ip_rt_ioctl(...)
		return err;

3) Add inet_compat_ioctl() as ->compat_ioctl in all PF_INET proto_ops.

4) Lift copyin from atrtr_ioctl() to atalk_ioctl(), teach
atalk_compat_ioctl() about these ioctls (using compat_get_rtentry()
and atrtr_ioctl(), that is).

5) Add ->compat_ioctl() to AF_PACKET, let it just call inet_compat_ioctl()
for those two.

6) Lift copyin from ipv6_route_ioctl() to inet6_ioctl().  
Add inet6_compat_ioctl() that would recognize those two, do compat copyin
and call ipv6_route_ioctl().  Make it ->compat_ioctl for all PF_INET6
proto_ops.

7) Tell compat_sock_ioctl_trans() to move these two into the "just call
sock_do_ioctl()" group of cases.  Or, with Ralf's fix, just remove these
two cases from compat_sock_ioctl_trans() completely.  Either way,
routing_ioctl() becomes dead code and can be removed.
