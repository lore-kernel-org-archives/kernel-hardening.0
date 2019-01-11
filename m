MIME-Version: 1.0
References: <cover.1547153058.git.khalid.aziz@oracle.com> <CAGXu5jKS8XSw7nByaeXqgPbmRRw01E_zUYxLCk7zFepAVSw_aQ@mail.gmail.com>
In-Reply-To: <CAGXu5jKS8XSw7nByaeXqgPbmRRw01E_zUYxLCk7zFepAVSw_aQ@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 10 Jan 2019 16:44:36 -0800
Message-ID: <CALCETrVWjdo6C53eFz8Gc99q4HFsGpwf4kDXR5OG8E96t-gSLw@mail.gmail.com>
Subject: Re: [RFC PATCH v7 00/16] Add support for eXclusive Page Frame Ownership
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>, Juerg Haefliger <juergh@gmail.com>, Tycho Andersen <tycho@tycho.ws>, jsteckli@amazon.de, Andi Kleen <ak@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, liran.alon@oracle.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, deepa.srinivasan@oracle.com, chris hyser <chris.hyser@oracle.com>, Tyler Hicks <tyhicks@canonical.com>, "Woodhouse, David" <dwmw@amazon.co.uk>, Andrew Cooper <andrew.cooper3@citrix.com>, Jon Masters <jcm@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, kanth.ghatraju@oracle.com, Joao Martins <joao.m.martins@oracle.com>, Jim Mattson <jmattson@google.com>, pradeep.vincent@oracle.com, John Haxby <john.haxby@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Christoph Hellwig <hch@lst.de>, steven.sistare@oracle.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 10, 2019 at 3:07 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Jan 10, 2019 at 1:10 PM Khalid Aziz <khalid.aziz@oracle.com> wrote:
> > I implemented a solution to reduce performance penalty and
> > that has had large impact. When XPFO code flushes stale TLB entries,
> > it does so for all CPUs on the system which may include CPUs that
> > may not have any matching TLB entries or may never be scheduled to
> > run the userspace task causing TLB flush. Problem is made worse by
> > the fact that if number of entries being flushed exceeds
> > tlb_single_page_flush_ceiling, it results in a full TLB flush on
> > every CPU. A rogue process can launch a ret2dir attack only from a
> > CPU that has dual mapping for its pages in physmap in its TLB. We
> > can hence defer TLB flush on a CPU until a process that would have
> > caused a TLB flush is scheduled on that CPU. I have added a cpumask
> > to task_struct which is then used to post pending TLB flush on CPUs
> > other than the one a process is running on. This cpumask is checked
> > when a process migrates to a new CPU and TLB is flushed at that
> > time. I measured system time for parallel make with unmodified 4.20
> > kernel, 4.20 with XPFO patches before this optimization and then
> > again after applying this optimization. Here are the results:

I wasn't cc'd on the patch, so I don't know the exact details.

I'm assuming that "ret2dir" means that you corrupt the kernel into
using a direct-map page as its stack.  If so, then I don't see why the
task in whose context the attack is launched needs to be the same
process as the one that has the page mapped for user access.

My advice would be to attempt an entirely different optimization: try
to avoid putting pages *back* into the direct map when they're freed
until there is an actual need to use them for kernel purposes.

How are you handing page cache?  Presumably MAP_SHARED PROT_WRITE
pages are still in the direct map so that IO works.
