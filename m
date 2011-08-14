Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 14 Aug 2011 16:04:48 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110814120448.GA15372@openwall.com>
References: <20110810164225.GA32177@openwall.com> <20110812120747.GA14598@albatros> <20110812122343.GA7859@openwall.com> <20110813151220.GA8388@albatros> <20110813151947.GA12495@openwall.com> <20110813165502.GA9328@albatros> <20110814095010.GA14443@openwall.com> <20110814101658.GA20509@albatros> <20110814112922.GA15012@openwall.com> <20110814115549.GA3423@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814115549.GA3423@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Chris Evans <scarybeasts@gmail.com>, djm@mindrot.org
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Sun, Aug 14, 2011 at 03:55:50PM +0400, Vasiliy Kulikov wrote:
> Btw, it can be even simplier.  If we use only one flag - lock to the
> current bitness - then the code is greatly simplified.  The same
> behaviour as with 3 flags can be achieved with binary helpers:

I dislike this.  Please implement extra flags instead.

> 1) vzctl wants to create CT 101 with specific bitness.  If it is 64, it
> simply calls prctl(LOCK_BITNESS) and execve's init.  If it is 32, it
> exec's small 32 bit helper binary that does the same job, but as 32
> bits.  It is compiled from the same source files, so the helper creation
> process is trivial.

I'd rather have a few extra lines of code in the kernel.

> 2) vzctl wants to create CT 101 with the bitness its /sbin/init is.
> Then it just looks at /sbin/init and does (1) steps.

"Looking at" /sbin/init (checking the ELF header?) sounds risky to me.
This depends on when vzctl does that, though (what privileges it still
has at that point).

> > OK, you don't have to emulate the exact same behavior.  Maybe ENOSYS
> > like you implemented initially would be fine.
> 
> Hmm, so you say such emulation is not needed?

I was hoping it'd be simpler, but if it turns out to be non-trivial,
then you can drop it.

And I agree that SIGKILL would be slightly better than -ENOSYS.

Alexander
