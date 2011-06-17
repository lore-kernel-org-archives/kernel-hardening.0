Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Jun 2011 13:25:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110617092551.GA6959@albatros>
References: <20110617083651.GA5625@albatros>
 <20110617085951.GA7772@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110617085951.GA7772@openwall.com>
Subject: Re: [kernel-hardening] How to temporary change 'current' (task)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2011 at 12:59 +0400, Solar Designer wrote:
> On Fri, Jun 17, 2011 at 12:36:51PM +0400, Vasiliy Kulikov wrote:
> > I wonder whether there is a simple way to temporary switch 'current' to
> > another task and then switch it back with minimum side effects?
> 
> I strongly recommend that we don't.  Doing so would introduce security
> risks similar to what we saw with set_fs(USER_DS).  Even if you
> implement everything right and safely, you would set an extremely bad
> precedent, encouraging others to do risky things like that.  Under the
> security hardening project, we should be moving the kernel away from
> those things, not introducing more of them.

Yes, you might be right, but it looks like the most simple solution.  In
the netlink listeners case the task triggers a broadcast message (on
exec(), fork(), setuid(), etc.) and delivers the message to the
listeners.  The official way to filter these messages (actually, skbs)
is providing a filter function to netlink_broadcast_filter().  This
filter would do ptrace_may_access()-like check.  The check would be
processes in the context of the emmitter process (ptrace target).

Arbitrary filtering on the receivers' side looks technically rather
difficult and unreasonable to me and unlikely to be applied.


Much more simple, but dubious solution is disabling such netlink sockets
for unprivileged users.  This would deny harmless process tracking for
the same user without any actual need.


Thanks,

-- 
Vasiliy
