Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 5 Jun 2011 01:03:15 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110604210315.GA6051@openwall.com>
References: <20110518150601.GA2921@albatros> <20110524023409.GC12486@openwall.com> <20110524151246.GA3401@albatros> <4DE139FE.8050808@gmail.com> <20110604181911.GC5034@openwall.com> <20110604202018.GA8019@shinshilla>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110604202018.GA8019@shinshilla>
Subject: Re: [kernel-hardening] /proc/PID directory hiding (was: [owl-dev] segoon's status report - #1 of 15)
To: kernel-hardening@lists.openwall.com
Cc: Pavel Labushev <p.labushev@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 05, 2011 at 12:20:47AM +0400, Vasiliy Kulikov wrote:
> On Sat, Jun 04, 2011 at 22:19 +0400, Solar Designer wrote:
> > As to probing for PIDs with syscalls such as kill(2), we may deal with
> > that as well
> 
> I'd not do this.  There are too many paths using pids, I don't think
> there is some universal way (read: a bottleneck) to filter all accesses.

Something like this is done for containers, but I agree with you.

> And the award is not too high to bother.

Yes, perhaps, and it'd be difficult to avoid timing leaks.

Anyhow, this would be a separate task.  Let's deal with the filesystems
first, and then proceed with other hardening measures already
implemented in patches and needing proper submission upstream.

Alexander
