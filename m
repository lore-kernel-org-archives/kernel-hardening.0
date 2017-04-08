MIME-Version: 1.0
In-Reply-To: <58E7EF70.30766.621C4F44@pageexec.freemail.hu>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <CA+rthh8TbqU-4tY4Y8trnyMDBe6dRLhVrAnk-COJCZCOyHqSog@mail.gmail.com>
 <CALCETrWuZPDjAuE1jnhJNKiZOOEdbus-O6GY8++0UO56Q84PZw@mail.gmail.com> <58E7EF70.30766.621C4F44@pageexec.freemail.hu>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 7 Apr 2017 21:58:46 -0700
Message-ID: <CALCETrXd9MgAk2p72UMbOOoL2W1fP0UT_pc2bfG8r0t=qJotwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: PaX Team <pageexec@freemail.hu>
Cc: Mathias Krause <minipli@googlemail.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 7, 2017 at 12:58 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 7 Apr 2017 at 9:14, Andy Lutomirski wrote:
>
>> On Fri, Apr 7, 2017 at 6:30 AM, Mathias Krause <minipli@googlemail.com> wrote:
>> > On 7 April 2017 at 15:14, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >> On Fri, 7 Apr 2017, Mathias Krause wrote:
>> > Fair enough. However, placing a BUG_ON(!(read_cr0() & X86_CR0_WP))
>> > somewhere sensible should make those "leaks" visible fast -- and their
>> > exploitation impossible, i.e. fail hard.
>>
>> The leaks surely exist and now we'll just add an exploitable BUG.
>
> can you please share those leaks that 'surely exist' and CC oss-security
> while at it?

I meant in the patchset here, not in grsecurity.  grsecurity (on very,
very brief inspection) seems to read cr0 and fix it up in
pax_enter_kernel.

>>
>> Then someone who cares about performance can benchmark the CR0.WP
>> approach against it and try to argue that it's a good idea.  This
>> benchmark should wait until I'm done with my PCID work, because PCID
>> is going to make use_mm() a whole heck of a lot faster.
>
> in my measurements switching PCID is hovers around 230 cycles for snb-ivb
> and 200-220 for hsw-skl whereas cr0 writes are around 230-240 cycles. there's
> of course a whole lot more impact for switching address spaces so it'll never
> be fast enough to beat cr0.wp.
>

If I'm reading this right, you're saying that a non-flushing CR3 write
is about the same cost as a CR0.WP write.  If so, then why should CR0
be preferred over the (arch-neutral) CR3 approach?  And why would
switching address spaces obviously be much slower?  There'll be a very
small number of TLB fills needed for the actual protected access.

--Andy
