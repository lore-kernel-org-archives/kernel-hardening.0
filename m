Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 16 Aug 2011 10:25:15 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110816062515.GB3733@albatros>
References: <20110813151220.GA8388@albatros>
 <20110813151947.GA12495@openwall.com>
 <20110813165502.GA9328@albatros>
 <20110814095010.GA14443@openwall.com>
 <20110814101658.GA20509@albatros>
 <20110814112922.GA15012@openwall.com>
 <20110814115549.GA3423@albatros>
 <20110814120448.GA15372@openwall.com>
 <20110815153836.GA6060@albatros>
 <20110815214651.GC20895@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815214651.GC20895@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 16, 2011 at 01:46 +0400, Solar Designer wrote:
> > My point is still that we should keep the only flag - lock current
> > process and implement simple re-exec of vzctl.
> 
> It's not so simple.  It means, for example, that Owl built for x86_64
> should also contain a version of vzctl built for i686 - but it normally
> lacks development tools and libraries for that (we don't currently do
> multilib within a single build of Owl).
> 
> > But other ways like workaround of multiple execve() calls are welcome.
> 
> Given your discovery, maybe we should have execve() return an error code
> like -EPERM, such that the library would not try the shell?

Other way - do syscall(__NR_execve, ...) instead of execve(...).  It is
a bit ugly, but given it will be used in only one place (and explicitly
by programs, whithout any wrapper) IMO it's acceptable.

-- 
Vasiliy
