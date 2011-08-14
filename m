Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 14 Aug 2011 16:16:17 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110814121616.GA3682@albatros>
References: <20110812120747.GA14598@albatros>
 <20110812122343.GA7859@openwall.com>
 <20110813151220.GA8388@albatros>
 <20110813151947.GA12495@openwall.com>
 <20110813165502.GA9328@albatros>
 <20110814095010.GA14443@openwall.com>
 <20110814101658.GA20509@albatros>
 <20110814112922.GA15012@openwall.com>
 <20110814115549.GA3423@albatros>
 <20110814120448.GA15372@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814120448.GA15372@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Chris Evans <scarybeasts@gmail.com>, djm@mindrot.org
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Aug 14, 2011 at 16:04 +0400, Solar Designer wrote:
> On Sun, Aug 14, 2011 at 03:55:50PM +0400, Vasiliy Kulikov wrote:
> > Btw, it can be even simplier.  If we use only one flag - lock to the
> > current bitness - then the code is greatly simplified.  The same
> > behaviour as with 3 flags can be achieved with binary helpers:
> 
> I dislike this.  Please implement extra flags instead.
> 
> > 1) vzctl wants to create CT 101 with specific bitness.  If it is 64, it
> > simply calls prctl(LOCK_BITNESS) and execve's init.  If it is 32, it
> > exec's small 32 bit helper binary that does the same job, but as 32
> > bits.  It is compiled from the same source files, so the helper creation
> > process is trivial.
> 
> I'd rather have a few extra lines of code in the kernel.
> 
> > 2) vzctl wants to create CT 101 with the bitness its /sbin/init is.
> > Then it just looks at /sbin/init and does (1) steps.
> 
> "Looking at" /sbin/init (checking the ELF header?) sounds risky to me.
> This depends on when vzctl does that, though (what privileges it still
> has at that point).

Then probably we don't need "lock to any bitness on exec" at all?  Only
explicit settings in vz config file.  Configs are anyway dependant on
the contained in the container distro.  The setup will happen only once
(at the container setup), but this way of handling removes some code
from the kernel critical pathes.

What's the global role of "lock to any bitness on exec"?  I can see only
one significant case - have one generic config for containers, which
doesn't depend on the bitness.  But then it is still needs some manual
changes because of the CT root compromize threat (unless we don't think
about CT root compromize, only CT daemons/users compromize).

Thanks,

-- 
Vasiliy
