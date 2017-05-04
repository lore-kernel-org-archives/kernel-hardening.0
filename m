Message-ID: <1493924614.1596.6.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 04 May 2017 15:03:34 -0400
In-Reply-To: <20170504180917.GB19929@leverpostej>
References: <20170504142435.10175-1-danielmicay@gmail.com>
	 <20170504154850.GE20461@leverpostej> <1493920184.1596.4.camel@gmail.com>
	 <20170504180917.GB19929@leverpostej>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk
List-ID: <kernel-hardening.lists.openwall.com>

> > https://github.com/thestinger/linux-
> > hardened/commit/6efe84cdb88f73e8b8c59b59a8ea46fa4b1bdab1.patch
> > https://github.com/thestinger/linux-hardened/commit/d342da362c5f852c
> > 1666dce461bc82521b6711e4.patch
> > 
> > Unfortunately, ksize means alloc_size on kmalloc is not 100% correct
> > since the extra space from size class rounding falls outside of what
> > it
> > will claim to be the size of the allocation. C standard libraries
> > with
> > _FORTIFY_SOURCE seem to ignore this problem for malloc_usable_size.
> > It
> > doesn't have many uses though.
> 
> Perhaps I've misunderstood, but does that matter?
> 
> If a caller is relying on accessing padding, I'd say that's a bug.

I think it's gross, but it's essentially what ksize provides: exposing
how much usable padding is available. If the size class rounding padding
is being used by slab debugging red zones, etc. ksize doesn't expose it
as part of the size. It's definitely not widely used. I think the main
use case is for dynamic arrays, to take advantage of the space added to
round to the next size class. There are also likely some users of it
that are not tracking sizes themselves but rather relying on ksize, and
then might end up using that extra space.

I think the glibc authors decided to start considering it a bug to make
real use of malloc_usable_size, and the man page discourages it but
doesn't explicitly document that:

NOTES
       The  value  returned  by malloc_usable_size() may be greater than the requested size of the
       allocation because of alignment and minimum size constraints.  Although  the  excess  bytes
       can  be  overwritten  by  the application without ill effects, this is not good programming
       practice: the number of excess bytes in an allocation depends on the underlying implementa‐
       tion.

       The main use of this function is for debugging and introspection.

It's mostly safe to use alloc_size like glibc... but not entirely if
using ksize to make use of extra padding is permitted, and it seems like
it is. I don't think it's particularly useful even for dynamic arrays,
but unfortunately it exists / is used.
