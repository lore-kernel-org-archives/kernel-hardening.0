Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 15 Jun 2011 18:38:44 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110615143844.GB32753@openwall.com>
References: <20110614083559.GB7973@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614083559.GB7973@albatros>
Subject: Re: [kernel-hardening] HARDEN_VM86
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Tue, Jun 14, 2011 at 12:35:59PM +0400, Vasiliy Kulikov wrote:
> While actual implementation of CONFIG_HARDEN_VM86 is trivial, the most
> important part of pushing the feature into upstream is clarifying to
> what security domain vm86(2)/vm86old(2) should be restricted.  In -ow
> and -grsecurity it is restricted to CAP_SYS_RAWIO.
> 
> I see 3 possibilities:
> 
> 1) Restrict it to CAP_SYS_RAWIO and make it configurable via sysctl
> kernel.vm86_restricted.  0 means current behaviour, 1 means
> CAP_SYS_RAWIO-only.
> 
> 2) The same as (1), but CAP_SYS_ADMIN.

CAP_SYS_RAWIO makes more sense to me.  This is relatively low level
access to hardware, similar in spirit to what e.g. X servers do/did.
There's little sysadmin'ish in running dosemu.

> 3) Restrict it to some group or CAP_SYS_ADMIN, configurable via
> kernel.vm86_group_allowed.  As vm86 is a rarely used thing, group range
> makes little sense for me.  0 means root only, -1 means current
> behaviour, X>0 means group X.

This would definitely be more usable than a capability, because both
CAP_SYS_RAWIO and CAP_SYS_ADMIN grant way too much (actually "root").

If upstream is fine with sysctl's setting gids, and this appears to be
the case, then let's go for this.

A group range would make some sense to me, but a single group is also
fine.  With just a single number to specify, you reserve two values for
special meaning, but that's OK.  Just make sure you don't grant anything
to group root by default, because gid 0 is sometimes leaked to a user
inadvertently.

BTW, a related syscall is modify_ldt(2).  You could want to research
what programs use it, and consider restricting it as well.  Perhaps with
a separate sysctl?

Thanks,

Alexander
