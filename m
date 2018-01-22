MIME-Version: 1.0
In-Reply-To: <CA+55aFyqAGRE4+QteYyvNyMzepFXHVVBn=A07Adj-yBs=tS_Ww@mail.gmail.com>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151648236968.34747.390507912161115784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180121104019.GS17719@n2100.armlinux.org.uk> <CAPcyv4iY9PWULZfGnKnTiD4tVxHSw4QfSwUBV4d=1KfnUjbgWw@mail.gmail.com>
 <CA+55aFyqAGRE4+QteYyvNyMzepFXHVVBn=A07Adj-yBs=tS_Ww@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Jan 2018 10:52:54 -0800
Message-ID: <CAPcyv4gjDrTnC_xeuVWjonvF7_L1Y-OOQndMRyVDdaLmcC7NMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4.1 02/10] asm/nospec, array_ptr: sanitize speculative
 array de-references
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 22, 2018 at 10:37 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 22, 2018 at 10:07 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Sun, Jan 21, 2018 at 2:40 AM, Russell King - ARM Linux
>> <linux@armlinux.org.uk> wrote:
>>>
>>> I'd suggest changing the description to something like:
>>>
>>>   * If 0 <= idx < size, return a mask of ~0UL, otherwise return zero.
>
> Yes. HOWEVER.
>
> We should make it clear that the signedness of the comparisons is
> undefined, and that 'size' should always be positive for the above to
> be well-specified.
>
> Why?
>
> Because one valid implementation of the above is:
>
>    idx U< size ? ~0UL : 0
>
> as a single unsigned comparison (I'm using "U<" as a "unsigned less than").
>
> But an equally valid implementation of it might be
>
>    idx S>= 0 && idx S< size ? ~0UL : 0
>
> which does two signed comparisons instead.
>
> And they are not exactly the same. They are the same _IFF_ 'size' is
> positive in 'long'. But if size is an unsigned value so big as to be
> negative in 'long', they give different results for 'idx'.
>
> In fact, the ALU-only version actually did a third version of the
> above that only uses "signed comparison against zero":
>
>    idx S> 0 && (size - idx - 1) S>= 0 ? ~0UL : 0
>
> which again is equivalent only when 'size' is positive in 'long'.
>
> Note that 'idx' itself can have any range (that's kind of the _point_,
> after all: checking that idx is in some range). But the logic only
> works for a positive array size.
>
> Which honestly is not really a limitation, but it's worth spelling out, I think.
>
> In particular, if you have a user pointer, and a 3G:1G split in
> user:kernel address space, you camn *not* do something like
>
>     uptr = array_ptr(NULL, userptr, TASK_SIZE);
>
> to get a sanitized user pointer, because TASK_SIZE is not positive in 'long'.
>
> Hmm?

We could at least have a BUILD_BUG_ON when 'size' is a
builtin_contstant and greater than LONG_MAX. Alternatively we could
require archs to provide the equivalent of the x86 array_ptr_mask()
that does not have the LONG_MAX limitation?
