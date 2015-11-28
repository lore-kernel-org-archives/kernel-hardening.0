Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 28 Nov 2015 10:16:49 +0100
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Message-ID: <20151128091649.GF32190@chrystal.uk.oracle.com>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
 <20151125234542.GA10324@chrystal>
 <20151126171706.GB32190@chrystal.uk.oracle.com>
 <CAGXu5j+ttTK5w-i7wituvrrkSXexta-3VWktBi1t5GC82iBQFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+ttTK5w-i7wituvrrkSXexta-3VWktBi1t5GC82iBQFw@mail.gmail.com>
Subject: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: Kees Cook <keescook@chromium.org>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 27, 2015 at 12:18:55PM -0800, Kees Cook wrote:
> On Thu, Nov 26, 2015 at 9:17 AM, Quentin Casasnovas
> <quentin.casasnovas@oracle.com> wrote:
> >
> > Alright, there's a guard page by default when using vmap() unless
> > VM_NO_GUARD is in the flags.  I had a feeling I was missing some bits.. ;)
> 
> Is this documented anywhere in Documentation?
>

I couldn't find anything in Documentation/ but the flag is documented in
include/linux/vmalloc.h.  I found it by looking at the vmap() code
directly.

> 
> Reading the code quickly, I don't understand what actually makes this a
> guard page. It looks like the requested size is just grown. Is it
> actually set up in a way that'll trap if it that page gets touched?
> 

AFAIU (which might not be very far!), the size is grown in
get_vm_area_caller() but then only the *requested* size is mapped in
map_vm_area().

On x86-64, where we have the IST stack, that means as soon as we access
below the currently mapped stack, we'll get a page fault, which will be
handled by vmalloc_fault(), and since no PTE is present for that page, that
should cause an Oops.

On x86, I believe a page fault when accessing below the stack would cause a
double fault, as there won't be any stack switching since we're coming from
ring0 (and there isn't a stack switch on exception when there isn't a
privilege change), so the first page fault would cause a second fault when
the CPU tries to push the context on the same stack.

Quentin
