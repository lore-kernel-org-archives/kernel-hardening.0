MIME-Version: 1.0
References: <cover.1547153058.git.khalid.aziz@oracle.com> <31fe7522-0a59-94c8-663e-049e9ad2bff6@intel.com>
 <7e3b2c4b-51ff-2027-3a53-8c798c2ca588@oracle.com> <8ffc77a9-6eae-7287-0ea3-56bfb61758cd@intel.com>
In-Reply-To: <8ffc77a9-6eae-7287-0ea3-56bfb61758cd@intel.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 11 Jan 2019 13:06:27 -0800
Message-ID: <CALCETrXqJJq1LMxfBA=LK=PYc5Q7hgeDQGap38h1AUAQuF2VHA@mail.gmail.com>
Subject: Re: [RFC PATCH v7 00/16] Add support for eXclusive Page Frame Ownership
Content-Type: text/plain; charset="UTF-8"
To: Dave Hansen <dave.hansen@intel.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Juerg Haefliger <juergh@gmail.com>, Tycho Andersen <tycho@tycho.ws>, jsteckli@amazon.de, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, liran.alon@oracle.com, Kees Cook <keescook@google.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, deepa.srinivasan@oracle.com, chris hyser <chris.hyser@oracle.com>, Tyler Hicks <tyhicks@canonical.com>, "Woodhouse, David" <dwmw@amazon.co.uk>, Andrew Cooper <andrew.cooper3@citrix.com>, Jon Masters <jcm@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, kanth.ghatraju@oracle.com, Joao Martins <joao.m.martins@oracle.com>, Jim Mattson <jmattson@google.com>, pradeep.vincent@oracle.com, John Haxby <john.haxby@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Christoph Hellwig <hch@lst.de>, steven.sistare@oracle.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 11, 2019 at 12:42 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> >> The second process could easily have the page's old TLB entry.  It could
> >> abuse that entry as long as that CPU doesn't context switch
> >> (switch_mm_irqs_off()) or otherwise flush the TLB entry.
> >
> > That is an interesting scenario. Working through this scenario, physmap
> > TLB entry for a page is flushed on the local processor when the page is
> > allocated to userspace, in xpfo_alloc_pages(). When the userspace passes
> > page back into kernel, that page is mapped into kernel space using a va
> > from kmap pool in xpfo_kmap() which can be different for each new
> > mapping of the same page. The physical page is unmapped from kernel on
> > the way back from kernel to userspace by xpfo_kunmap(). So two processes
> > on different CPUs sharing same physical page might not be seeing the
> > same virtual address for that page while they are in the kernel, as long
> > as it is an address from kmap pool. ret2dir attack relies upon being
> > able to craft a predictable virtual address in the kernel physmap for a
> > physical page and redirect execution to that address. Does that sound right?
>
> All processes share one set of kernel page tables.  Or, did your patches
> change that somehow that I missed?
>
> Since they share the page tables, they implicitly share kmap*()
> mappings.  kmap_atomic() is not *used* by more than one CPU, but the
> mapping is accessible and at least exists for all processors.
>
> I'm basically assuming that any entry mapped in a shared page table is
> exploitable on any CPU regardless of where we logically *want* it to be
> used.
>
>

We can, very easily, have kernel mappings that are private to a given
mm.  Maybe this is useful here.
