Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 12 Aug 2011 13:52:19 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110812095219.GA3012@albatros>
References: <20110723162251.GA11485@openwall.com>
 <20110724084200.GB3659@albatros>
 <20110724142710.GB18345@openwall.com>
 <20110725192048.GA21675@albatros>
 <20110811083259.GA5429@albatros>
 <20110812035729.GB4964@openwall.com>
 <20110812042135.GA5149@openwall.com>
 <20110812082024.GA8785@albatros>
 <20110812092046.GB6400@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812092046.GB6400@openwall.com>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2011 at 13:20 +0400, Solar Designer wrote:
> > bottom up.
> 
> Huh?  I don't think you used the right words here.

There are 2 allocation logics, top down and bottom up:

http://lxr.free-electrons.com/source/mm/mmap.c#L1372

http://lxr.free-electrons.com/source/mm/mmap.c#L1444

If use top down logic (start from 0x01000000 as the end of the library)
then some gap at 0x00110000 will be wasted.  With bottom up logic I'll
simply have the last library partly being in ASCII-armor zone, the end
of it will be located after 0x01000000, but no waste of vm space.

Or you mean anything else?


> > For Owl we want to make entropy size configurable.  Depending on the
> > entropy, use ASCII-armor or fallback to the default allocator
> > instantly.
> 
> Not exactly.  Both for upstream and for Owl, when the entropy size
> exceeds what we can provide ASCII-armor for, we start at 0x110000
> anyway, but we just happen to go to non-armored addresses if we get such
> random numbers.  For example, if we're configured to use 12 bits and our
> binary uses just one library of 3 MB in size, then there's an approx.
> 75% chance that on a given invocation of the binary we have ASCII armor
> for the library anyway.  This is just not guaranteed.

OK.  However, I don't see much sense in sizes between 10 and 16.  If we
want to use ASCII-armor or warried about vm-hungry apps, then use 10
bits.  If not, use all power of ASLR.

But if use distros with their default 12 bits in containers, it makes
sense to protect them with a probabilistic measure, though.


Thanks,

-- 
Vasiliy
