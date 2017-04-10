MIME-Version: 1.0
In-Reply-To: <58EB619B.8144.6F924846@pageexec.freemail.hu>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <58EA2D58.17782.6ADE22BD@pageexec.freemail.hu> <CALCETrWvGLtObdk3V0k_Esa_L=EOf+Whe=6DpcJ7H_W8Z-5Btw@mail.gmail.com>
 <58EB619B.8144.6F924846@pageexec.freemail.hu>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 10 Apr 2017 09:01:21 -0700
Message-ID: <CALCETrXN2ocUWa_FNjYDXxjm_BTV86yAqq8yRpwYz1VbKvF4Uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v2][PATCH 04/11] x86: Implement __arch_rare_write_begin/unmap()
To: PaX Team <pageexec@freemail.hu>
Cc: Andy Lutomirski <luto@kernel.org>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 10, 2017 at 3:42 AM, PaX Team <pageexec@freemail.hu> wrote:
> On 9 Apr 2017 at 17:10, Andy Lutomirski wrote:
>
>> On Sun, Apr 9, 2017 at 5:47 AM, PaX Team <pageexec@freemail.hu> wrote:
>> > on x86 the cost of the pax_open/close_kernel primitives comes from the cr0
>> > writes and nothing else, use_mm suffers not only from the cr3 writes but
>> > also locking/atomic ops and cr4 writes on its path and the inevitable TLB
>> > entry costs. and if cpu vendors cared enough, they could make toggling cr0.wp
>> > a fast path in the microcode and reduce its overhead by an order of magnitude.
>> >
>>
>> If the CR4 writes happen in for this use case, that's a bug.
>
> that depends on how you plan to handle perf/rdpmc users and how many
> alternative mm structs you plan to manage (one global, one per cpu,
> one per mm struct, etc).
>

I was thinking one global unless more are needed for some reason.

>> > you'll be duplicating TLB entries in the alternative PCID for both code
>> > and data, where they will accumulate (=take room away from the normal PCID
>> > and expose unwanted memory for access) unless you also flush them when
>> > switching back (which then will cost even more cycles). also i'm not sure
>> > that processors implement all the 12 PCID bits so depending on how many PCIDs
>> > you plan to use, you could be causing even more unnecessary TLB replacements.
>> >
>>
>> Unless the CPU is rather dumber than I expect, the only duplicated
>> entries should be for the writable aliases of pages that are written.
>> The rest of the pages are global and should be shared for all PCIDs.
>
> well, 4.10.2.4 has language like this (4.10.3.2 implies similar):
>
>    A logical processor may use a global TLB entry to translate a linear
>    address, even if the TLB entry is associated with a PCID different
>    from the current PCID.

I read this as: the CPU still semantically tags global TLB entries
with a PCID, but the CPU will use (probably) use those TLB entries
even if the PCIDs don't match.  IIRC none of the TLB instructions have
any effect that makes the PCID associated with a global entry visible,
so the CPU could presumably omit the PCID tags entirely for global
entries.  E.g. I don't think there's any way to say "flush global
entries with a given PCID".

--Andy
