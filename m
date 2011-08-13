Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 13 Aug 2011 19:19:47 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110813151947.GA12495@openwall.com>
References: <20110810130333.GA31122@openwall.com> <20110810132715.GA8993@albatros> <20110810142609.GA31434@openwall.com> <20110810150257.GA12198@albatros> <20110810154059.GA31860@openwall.com> <20110810162101.GA2833@albatros> <20110810164225.GA32177@openwall.com> <20110812120747.GA14598@albatros> <20110812122343.GA7859@openwall.com> <20110813151220.GA8388@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813151220.GA8388@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Sat, Aug 13, 2011 at 07:12:20PM +0400, Vasiliy Kulikov wrote:
> Re: slowdown - my assumptions are:
> 
> 1) we don't want any slowdown for legitimate tasks - 64 bit tasks for 64
> bit containers and 32 bit tasks for 32 bit containers.
> 
> 2) slowdown of malicious (or broken) tasks is not important.

Right.

> /* work to do in syscall_trace_enter() */
> #define _TIF_WORK_SYSCALL_ENTRY	\
> 	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
> 	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)
> 
> 
> So, there is a mask, which is used to identify whether a syscall needs
> additional pre/post processing.  If divide syscall_trace_enter() into 3
> functions, we'll get what we want.  This will result in zero impact on
> the legitimate code (relavite to current behaviour).
> 
> One drawback - *tracesys clobbers EAX/RAX, so I still have to patch asm.

I haven't looked into the detail of this, but in general I like the
approach of reusing a check that is already in the code.  Please proceed
with this.

Thanks,

Alexander
