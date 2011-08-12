Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2011 07:57:29 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110812035729.GB4964@openwall.com>
References: <20110723162251.GA11485@openwall.com> <20110724084200.GB3659@albatros> <20110724142710.GB18345@openwall.com> <20110725192048.GA21675@albatros> <20110811083259.GA5429@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811083259.GA5429@albatros>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

Thank you for conducting and summarizing this research.  It helps.  Most
of the things I was aware of, but a few I was not (specific entropy
sizes of different kernels).

On Thu, Aug 11, 2011 at 12:32:59PM +0400, Vasiliy Kulikov wrote:
> The problem with ASCII-armor is that it contradicts good ALSR entropy.
> E.g. with 12 bits of entropy the maximum library size to fit in low 16
> MB is zero bytes.

Yes, so we have to choose between 10 and 11.

> PaX has 16 bits of entropy, so ASCII-armor would only hurt entropy.

Yes, there's a tradeoff here.

> It makes sense to have e.g. 10 bits of entropy for 32-bit environments,
> but it would help only for tiny programs (hopefully, most of Owl
> programs).  It would not work for any python/GUI/Java, Apache with many
> modules, TomCat, etc.

For programs with many/large libs, we would not get ASCII-armor for some
of the libs, but we would still have our 10 bits of ASLR.  So we'd lose
at the tradeoff - having sold some entropy, but having received only
partial ASCII-armor - but we would not completely leave those programs
unprotected.

Arguably, in those large-app cases mostly remote attacks are relevant, and
for them 10 bits is already somewhat difficult.  It is not obvious
whether there's a lot of difference between 10 and 16 bits for them or not.
If they're crashing from the first attempt or otherwise make the attack
easy to notice, then 10 bits may be enough.  If they don't crash and
don't show any misbehavior, nor logging, then 16 may not be enough.

Also, 16 bits means that libs are scattered over a 256 MB range, which
reduces the maximum continuous allocation size accordingly.  I think many
(upstream, RHEL) would find this cost prohibitive and would go for less
entropy anyway.

Arguably, ASCII-armor is more effective than entropy against some local
attacks.  16 bits is easy to search locally anyway (well, not exactly
"search 16 bits" - rather, you have a 63% chance of success in 65536
tries, but it's good enough for our discussion).  However, if you have
no read access to the program binary (say, mode 4711), but you do to the
libraries (say, mode 755), then ret2libc may be the most reliable attack
to use.

> pipacs' position is that exploitation of C-string buffer overflows is
> rather rare nowadays, and heap overflows, buffer overflows, math
> miscalculation, etc. are much more often => C-string buffer overflow is
> not something which worth specific protection.

I do feel that overflows via C strings became relatively less common,
yet they're still of some relevance.

Blocking further attempts to run a program binary after SIGSEGV or not
doing it is also part of the tradeoff.  With this in place, local
attacks on ASLR may become ineffective - however, 10 bits would likely
be enough then.

> IMO it makes sense for Owl to have e.g. 10 bits of entropy for libs and
> use ASCII-armor.  But it makes very little sense for upstream.

I think it makes sense for upstream because we have little chance to get
upstream to accept higher entropy (lowering the maximum continuous
allocation size).

> Or even use 16 bits as PaX does and don't use ASCII-armor at all.

I think it'd be great to have this as an option.  In fact, the code
could simply try to do ASCII-armor, but also allow one to configure more
than 11 bits of entropy, in which case the ASCII-armor would be usually
ineffective.  That is, start at max(0x00110000, mmap_min_addr), but add
to this a random page-aligned offset in a configurable range
(configurable as number of entropy bits).  When the setting is 11 or
less (and mmap_min_addr is not set unusually high), ASCII-armor is
guaranteed for libs not exceeding a certain size.  When the setting is
12 to 14, ASCII-armor is not guaranteed in any case (but may happen in
some cases nevertheless).  For 15+, you have to use a different starting
address or use two ranges (if the random number has no "1" bits beyond
bits 0-13, then use the low range, otherwise use a high range).

What specific address range(s) does PaX use?

> ASCII-armor
> has rather limited usage - prevention of ret2libc via exploitation of
> C-string buffer overflows.

Yes.

> But it is already included in ASLR, which does much more.

Is it?  Not exactly.  Just invoke the binary thousands of time, and you
have a good chance to hit the right libc code.

> Probably we should concentrate on more generic things, like ASLR?

I'd like us to support both.  Sounds easy enough to do.

Thanks again,

Alexander
