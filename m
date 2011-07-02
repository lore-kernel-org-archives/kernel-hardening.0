Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 2 Jul 2011 21:21:59 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110702172159.GE26232@openwall.com>
References: <20110626183321.GA3867@albatros> <20110629182505.GC14873@openwall.com> <20110629183728.GA8163@albatros> <20110629194339.GA15379@openwall.com> <20110630160345.GA15258@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110630160345.GA15258@albatros>
Subject: Re: [kernel-hardening] overview of PaX features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 30, 2011 at 08:03:45PM +0400, Vasiliy Kulikov wrote:
> I've looked over -ow and PaX' implementations of trampolines emulation.
> Two notes:
> 
> 1) Are trampolines the only widespread user of executable stack?
> (widespread among executable stack needings ;)

Apps/libs relying on executable stack are very uncommon these days, even
more so than they were in 1990s when I started playing with this.  Of
those few that do exist, I am not sure which are "less uncommon".  There
was a time when glibc's localedef program had a nested function and thus
required either executable stack or gcc trampoline emulation.  Moreover,
there was a time when glibc's dynamic linker required executable stack.
But it was a decade ago (IIRC, glibc 2.1 and glibc 2.0, respectively).
Since then, I am not aware of widespread users of executable stack,
because of trampolines or otherwise.

Oh, of course the kernel itself also put a signal handler return
trampoline on the stack.  However, glibc started installing its own code
for that, not on the stack.  Also, -ow patch included a fault-based
signal return mechanism, which worked even with libc5.  I don't recall
what happened to it in exec-shield.

> 2) In -ow patch the trampolines emulation is very tolerant: it supports
> up to 8 movs and then one of 2 jmps.  PaX' version distinguishes only 2
> specific trampolines implementations and alerts if the code doesn't fit
> into these strict patterns.  Taking into consideration how long PaX
> patch exists, I suppose the restricted version cover all (or almost all)
> realworld trampolines implementations.   The -ow variant would relax the
> stack too much.

I recall fixing limitations and bugs in -ow's trampoline emulation in
response to actual problem reports with different versions of gcc, so I
think there are/were more than two kinds of gcc trampolines in
existence.  Maybe there are only two or even only one widespread version
of the trampoline code, though.

You may want to check the code in linux-2.2.12-ow6.diff.  It turned out
to be insufficient to cover some newer gcc versions, so it was enhanced
in later 2.2.x-ow versions.

http://download.openwall.net/pub/patches/linux/v2.2/historical/

That said, I don't have strong feelings one way or the other.  Feel free
to use the stricter code from PaX if you like.  You can also ask for PaX
Team's advice on this.

> Btw, there is a tool to change executable stack settings per binary,
> written by Jakub Jelinek (Red Hat):
> 
> http://linux.die.net/man/8/execstack

I think it makes sense for us to get it into Owl.

Thanks,

Alexander
