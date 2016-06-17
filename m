Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160616060538.GA3923@osiris>
References: <cover.1466036668.git.luto@kernel.org> <20160616060538.GA3923@osiris>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Jun 2016 20:58:07 -0700
Message-ID: <CALCETrVD6aLzvgHxTji0mm5Fzkqq_h-bxWqF1bv+7z33UrgYgA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 11:05 PM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Wed, Jun 15, 2016 at 05:28:22PM -0700, Andy Lutomirski wrote:
>> Since the dawn of time, a kernel stack overflow has been a real PITA
>> to debug, has caused nondeterministic crashes some time after the
>> actual overflow, and has generally been easy to exploit for root.
>>
>> With this series, arches can enable HAVE_ARCH_VMAP_STACK.  Arches
>> that enable it (just x86 for now) get virtually mapped stacks with
>> guard pages.  This causes reliable faults when the stack overflows.
>>
>> If the arch implements it well, we get a nice OOPS on stack overflow
>> (as opposed to panicing directly or otherwise exploding badly).  On
>> x86, the OOPS is nice, has a usable call trace, and the overflowing
>> task is killed cleanly.
>
> Do you have numbers which reflect the performance impact of this change?
>

It seems to add ~1.5=C2=B5s per thread creation/join pair, which is around
15% overhead.  I *think* the major cost is that vmalloc calls
alloc_kmem_pages_node once per page rather than using a higher-order
block if available.

Anyway, if anyone wants this to become faster, I think the way to do
it would be to ask some friendly mm folks to see if they can speed up
vmalloc.  I don't really want to dig in to the guts of the page
allocator.  My instinct would be to add a new interface
(GFP_SMALLER_OK?) to ask the page allocator for a high-order
allocation such that, if a high-order block is not immediately
available (on the freelist) then it should fall back to a smaller
allocation rather than working hard to get a high-order allocation.
Then vmalloc could use this, and vfree could free pages in blocks
corresponding to whatever orders it got the pages in, thus avoiding
the need to merge all the pages back together.

There's another speedup available: actually reuse allocations.  We
could keep a very small freelist of vmap_areas with their associated
pages so we could reuse them.  (We can't efficiently reuse a vmap_area
without its backing pages because we need to flush the TLB in the
middle if we do that.)

--Andy
