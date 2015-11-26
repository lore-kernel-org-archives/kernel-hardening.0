Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 26 Nov 2015 18:17:06 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20151126171706.GB32190@chrystal.uk.oracle.com>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
 <20151125234542.GA10324@chrystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151125234542.GA10324@chrystal>
Subject: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 26, 2015 at 12:45:42AM +0100, Quentin Casasnovas wrote:
> On Tue, Nov 24, 2015 at 11:10:09AM -0800, Kees Cook wrote:
> > Hi,
> >
> 
> Hi Kees,
> 
> > I just wanted to check in and see how progress was going on the stack
> > overflow feature. Anything we can help with?
> >
> 
> Sorry for not following up on this, I've been busy and haven't had the time
> to finish it properly.  I've pushed an initial WIP break up of the
> KSTACK_OVERFLOW feature on my github:
> 
>   https://github.com/casasnovas/linux/tree/quentin-split-kstackoverflow
> 
> This is far from being complete though, and hasn't been cleaned at all.  I
> didn't share it earlier because I don't think I fully understand it and
> haven't tested it yet.  In "short", there's mention of guard pages in the
> Kconfig help:
> 
>   If you say Y here, the kernel's process stacks will be allocated with
>   vmalloc instead of the kernel's default allocator.  This introduces guard
>                                                                       ^^^^^
>   pages that in combination with the alloca checking of the STACKLEAK
>   ^^^^^
>   feature prevents all forms of kernel process stack overflow abuse.  Note
>   that this is different from kernel stack buffer overflows. """
> 
> And I couldn't find anything about it in the code.  Maybe it's just coming
> from a mis-interpretation of the above text, but I was expecting this to
> mean there would be a PROT_NONE guard page after the end of the stack, so
> that read/writes below it could be trapped.  It could also be that I missed
> some parts in my initial break-up or simply am missing something.
>

Alright, there's a guard page by default when using vmap() unless
VM_NO_GUARD is in the flags.  I had a feeling I was missing some bits.. ;)

Quentin
