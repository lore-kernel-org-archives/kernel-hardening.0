Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2011 14:04:47 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110812100447.GB6743@openwall.com>
References: <20110723162251.GA11485@openwall.com> <20110724084200.GB3659@albatros> <20110724142710.GB18345@openwall.com> <20110725192048.GA21675@albatros> <20110811083259.GA5429@albatros> <20110812035729.GB4964@openwall.com> <20110812042135.GA5149@openwall.com> <20110812082024.GA8785@albatros> <20110812092046.GB6400@openwall.com> <20110812095219.GA3012@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812095219.GA3012@albatros>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2011 at 01:52:19PM +0400, Vasiliy Kulikov wrote:
> There are 2 allocation logics, top down and bottom up:
> 
> http://lxr.free-electrons.com/source/mm/mmap.c#L1372
> 
> http://lxr.free-electrons.com/source/mm/mmap.c#L1444
> 
> If use top down logic (start from 0x01000000 as the end of the library)
> then some gap at 0x00110000 will be wasted.  With bottom up logic I'll
> simply have the last library partly being in ASCII-armor zone, the end
> of it will be located after 0x01000000, but no waste of vm space.
> 
> Or you mean anything else?

You're right.  I just didn't realize the words "bottom up" were used in
kernel source to mean that.

> OK.  However, I don't see much sense in sizes between 10 and 16.  If we
> want to use ASCII-armor or warried about vm-hungry apps, then use 10
> bits.

Why not use 14 in such cases, which still fits in the below-binary range
and thus does not reduce the maximum continuous allocation size?

> But if use distros with their default 12 bits in containers, it makes
> sense to protect them with a probabilistic measure, though.

I don't understand what you mean here.  The distros' default 12 bits -
are they patched into those distros' kernels?  If so, they do not apply
to use in containers (where only userlands are used).

Alexander
