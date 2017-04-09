Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 9 Apr 2017 12:53:36 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170409105335.GA15772@gmail.com>
References: <CA+rthh95rW95woiWvyeCcoJT-qRM18KCDGHGtH=bDHZdExmVmg@mail.gmail.com>
 <alpine.DEB.2.20.1704071048360.1716@nanos>
 <CA+rthh9-EJBBO6nYYY6noP0ybcvk+xJ+S5h6BCNPtidjMCv8VQ@mail.gmail.com>
 <alpine.DEB.2.20.1704071426300.1716@nanos>
 <CA+rthh8TbqU-4tY4Y8trnyMDBe6dRLhVrAnk-COJCZCOyHqSog@mail.gmail.com>
 <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com>
 <CA+DvKQKc8uq=1O5d41GRU6u=GkOvuCJzkbPPBcp2ohHLU7A25g@mail.gmail.com>
 <CALCETrUk7k3SFKiu2kykwPM=AQ9q2rczetL4j5XyoOxX_gjCGw@mail.gmail.com>
 <CA+DvKQKQzMk==8Z4sF1pCeDDwE4+m_2Kgtztamaf2BWYm5ENUA@mail.gmail.com>
 <CALCETrXQaRcNz7EQW9DHF-LMr5SkooLq=1HKsdOfXH-kY4fcBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXQaRcNz7EQW9DHF-LMr5SkooLq=1HKsdOfXH-kY4fcBw@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement
 __arch_rare_write_begin/unmap()
To: Andy Lutomirski <luto@kernel.org>
Cc: Daniel Micay <danielmicay@gmail.com>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@kernel.org> wrote:

> On Sat, Apr 8, 2017 at 12:33 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> > The
> > submitted code is aimed at rare writes to globals, but this feature is
> > more than that and design decisions shouldn't be based on just the
> > short term.
> 
> Then, if you disagree with a proposed design, *explain why* in a
> standalone manner.  Say what future uses a different design would
> have.
> 
> > I actually care a lot more about 64-bit ARM support than I do x86, but
> > using a portable API for pax_open_kernel (for the simple uses at
> > least) is separate from choosing the underlying implementation. There
> > might not be a great way to do it on the architectures I care about
> > but that doesn't need to hinder x86. It's really not that much code...
> > A weaker/slower implementation for x86 also encourages the same
> > elsewhere.
> 
> No one has explained how CR0.WP is weaker or slower than my proposal.
> Here's what I'm proposing:
> 
> At boot, choose a random address A.  Create an mm_struct that has a
> single VMA starting at A that represents the kernel's rarely-written
> section.  Compute O = (A - VA of rarely-written section).  To do a
> rare write, use_mm() the mm, write to (VA + O), then unuse_mm().

BTW., note that this is basically a pagetable based protection key variant.

> It'll be considerably slower than CR0.WP on a current x86 kernel, but, with PCID 
> landed, it shouldn't be much slower.  It has the added benefit that writes to 
> non-rare-write data using the rare-write primitive will fail.

... which is a security advantage of the use_mm() based design you suggest.

Thanks,

	Ingo
