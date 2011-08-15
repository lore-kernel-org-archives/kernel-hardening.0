Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 16 Aug 2011 01:46:51 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110815214651.GC20895@openwall.com>
References: <20110812122343.GA7859@openwall.com> <20110813151220.GA8388@albatros> <20110813151947.GA12495@openwall.com> <20110813165502.GA9328@albatros> <20110814095010.GA14443@openwall.com> <20110814101658.GA20509@albatros> <20110814112922.GA15012@openwall.com> <20110814115549.GA3423@albatros> <20110814120448.GA15372@openwall.com> <20110815153836.GA6060@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815153836.GA6060@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Aug 15, 2011 at 07:38:36PM +0400, Vasiliy Kulikov wrote:
> Note the strage output of -e32 lock64, -e64 lock32, lock64 -e lock32.
> There is a major problem with lock on exec (ptrace output):
> 
>     execve("./lock32", ["./lock32", "-e64", "./lock32"], [/* 17 vars */]) = 0
>     ...
>     prctl(0x23 /* PR_??? */, 0x1, 0x40, 0, 0) = 0
>     execve("./lock32", ["./lock32"], [/* 28 vars */]) = -1 ENOEXEC (Exec format error)
>     execve("/bin/sh", ["/bin/sh", "./lock32"], [/* 28 vars */]) = 0
>     brk(0)                                  = 0x2447000
>     ...
> 
> So, library function tries to run /bin/sh if no kernel interpreter is
> found.  As the first execve(2) failed, the lock on exec is not forced
> anymore, but from the application point of view it is the only execve().
> For -e lock32 the expectation is not broken, but 32bit ELF is still tried to
> be passed to 64bit /bin/sh.

That's nasty.

> My point is still that we should keep the only flag - lock current
> process and implement simple re-exec of vzctl.

It's not so simple.  It means, for example, that Owl built for x86_64
should also contain a version of vzctl built for i686 - but it normally
lacks development tools and libraries for that (we don't currently do
multilib within a single build of Owl).

> But other ways like workaround of multiple execve() calls are welcome.

Given your discovery, maybe we should have execve() return an error code
like -EPERM, such that the library would not try the shell?

Thanks,

Alexander
