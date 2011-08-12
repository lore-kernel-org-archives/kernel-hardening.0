Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2011 13:20:46 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110812092046.GB6400@openwall.com>
References: <20110723162251.GA11485@openwall.com> <20110724084200.GB3659@albatros> <20110724142710.GB18345@openwall.com> <20110725192048.GA21675@albatros> <20110811083259.GA5429@albatros> <20110812035729.GB4964@openwall.com> <20110812042135.GA5149@openwall.com> <20110812082024.GA8785@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812082024.GA8785@albatros>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2011 at 12:20:24PM +0400, Vasiliy Kulikov wrote:
> However, some upstream guys don't agree it should be configurable:
> 
> https://lkml.org/lkml/2006/5/19/219
> 
> https://lkml.org/lkml/2006/5/22/207:
> 
> "Because if it is configurable, someone _will_ configure it wrong, and
> then ask us why it does not work."

This is easily dealt with by limiting the allowable range to "correct"
values.  Say, instead of 0 to 19 use 9 to 18 or 10 to 16.  Then we'll
need to patch only the allowable range and not any code in Owl.

> Probably it worth trying to bring up the discussion of configurable ASLR
> entropy again - the code to configure it is simple anyway.

Yes, please - with a patch.

> However, I
> expect one nasty answer: "everybody should use x86-64 for good ASLR and
> other things, for x86-32 it is bad anyway, so don't bother to fix things
> broken by design."

You may simply reply that you disagree.  Maybe someone else will as well.

> So, to summarize:
> 
> For upstream we want to start mmap addresses allocation from 0x1100000,

You meant from 0x110000 (one zero less).

> bottom up.

Huh?  I don't think you used the right words here.

> Probably, make entropy configurable.

Yes.

> For Owl we want to make entropy size configurable.  Depending on the
> entropy, use ASCII-armor or fallback to the default allocator
> instantly.

Not exactly.  Both for upstream and for Owl, when the entropy size
exceeds what we can provide ASCII-armor for, we start at 0x110000
anyway, but we just happen to go to non-armored addresses if we get such
random numbers.  For example, if we're configured to use 12 bits and our
binary uses just one library of 3 MB in size, then there's an approx.
75% chance that on a given invocation of the binary we have ASCII armor
for the library anyway.  This is just not guaranteed.

Alexander
