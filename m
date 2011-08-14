Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 14 Aug 2011 15:29:22 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110814112922.GA15012@openwall.com>
References: <20110810154059.GA31860@openwall.com> <20110810162101.GA2833@albatros> <20110810164225.GA32177@openwall.com> <20110812120747.GA14598@albatros> <20110812122343.GA7859@openwall.com> <20110813151220.GA8388@albatros> <20110813151947.GA12495@openwall.com> <20110813165502.GA9328@albatros> <20110814095010.GA14443@openwall.com> <20110814101658.GA20509@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814101658.GA20509@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Chris Evans <scarybeasts@gmail.com>, djm@mindrot.org
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Sun, Aug 14, 2011 at 02:16:58PM +0400, Vasiliy Kulikov wrote:
> My current non-posted-yet patch handles the current process rather than
> a namespace.  It sets a task-related flag(s), which is checked/dropped on
> execve().  On execve() an actual locking is handled.  A locked process
> may not drop the lock.

Sounds good.

> On Sun, Aug 14, 2011 at 13:50 +0400, Solar Designer wrote:
> > So maybe the restriction should apply to a process tree rather than to a
> > namespace?
> 
> A process tree is a horrible term.  What if some elements of fork chain
> died?

Then it's a torn tree. ;-)  OK, let's not use this term.

> > 5 - lock current process to current bitness, but execve() to 32-bit ELF
> > 6 - lock current process to current bitness, but execve() to 64-bit ELF
> > 7 - lock current process to current bitness, but next execve() to its actual bitness
> > 
> > 5 to 7 are probably not very useful, but are defined for consistency.
> 
> These are confusing and IMO meaningless modes.

I agree.

> I think a simple way to go is an addition of PR_BITNESS_LOCK prctl() option,
> which calls __task_bitness_lock(current, current_bitness()).

I am fine with this.  I don't know which approach the LKML folks will
like best.

> Also, I try to handle syscalls as if they are not setup, but there are
> trivial ways to do something more than just 32 bit task of 32 bit kernel
> or 64 bit task of 64 bit kernel with IA32_EMULATION=n.  The obvious way
> is using CS segment of another bitness.  I bet procfs has something
> similar.  64 bit locking is rather simple as grep CONFIG_IA32_EMULATION
> shows only tens of lines (so, it can be fixed), but emulated 32 bit task
> might significantly differ from usual 32 task on 32 bit kernel.

OK, you don't have to emulate the exact same behavior.  Maybe ENOSYS
like you implemented initially would be fine.

Alexander
