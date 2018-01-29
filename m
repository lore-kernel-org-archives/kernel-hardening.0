MIME-Version: 1.0
In-Reply-To: <20180128183309.j7zkoyqblich4zhq@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703972396.26578.7326612698912543866.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180128085500.djlm5rlbhjlpfj4i@gmail.com> <CAPcyv4jTaskPT1qXhdCO2mWVkcaMDMBq12vUJ_hSfjOU49qvgQ@mail.gmail.com>
 <20180128183309.j7zkoyqblich4zhq@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 08:45:38 -0800
Message-ID: <CAPcyv4i__O1VjkcSOKTsbX28VFrC8GJH-sd4TAxYECqOhoDs+g@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] array_idx: sanitize speculative array de-references
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Cyril Novikov <cnovikov@lynx.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, X86 ML <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, Ingo Molnar <mingo@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 10:33 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Thomas, Peter, and Alexei wanted s/nospec_barrier/ifence/ and
>
> I just checked past discussions, and I cannot find that part, got any links or
> message-IDs?
>
> PeterZ's feedback on Jan 8 was:
>
>> On Sun, Jan 07, 2018 at 06:24:11PM -0800, Alexei Starovoitov wrote:
>> > How about:
>> > CONFIG_SPECTRE1_WORKAROUND_INDEX_MASK
>> > CONFIG_SPECTRE1_WORKAROUND_LOAD_FENCE
>>
>> INSTRUCTION_FENCE if anything. LFENCE for Intel (and now also for AMD as
>> per 0592b0bce169) is a misnomer, IFENCE would be a better name for it.
>
> Which in that context clearly talked about the config space and how to name the
> instruction semantics in light of the confusion of LFENCE and MFENCE opcodes on
> Intel and AMD CPUs...
>
> Also, those early reviews were fundamentally low level feedback related to the
> actual functionality of the barriers and their mapping to the hardware.
>
> But the fact is, the current series introduces an inconsistent barrier namespace
> extension of:
>
>         barrier()
>         barrier_data()
>         mb()
>         rmb()
>         wmb()
>         store_mb()
>         read_barrier_depends()
>         ...
> +       ifence()
> +       array_idx()
> +       array_idx_mask()
>
> This isn't bikeshed painting: _ALL_ existing barrier API names have 'barrier' or
> its abbreviation 'mb' (memory barrier) somewhere in their names, which makes it
> pretty easy to recognize them at a glance.
>
> I'm giving you high level API naming feedback because we are now growing the size
> of the barrier API.
>
> array_idx() on the other hand is pretty much close to a 'worst possible' name:
>
>  - it's named in an overly generic, opaque fashion
>  - doesn't indicate it at all that it's a barrier for something
>
> ... and since we want all kernel developers to use these facilities correctly, we
> want the names to be good and suggestive as well.
>
> I'd accept pretty much anything else that adds 'barrier' or 'nospec' to the name:
> array_idx_barrier() or array_idx_nospec(). (I'm slightly leaning towards 'nospec'
> because it's more indicative of what is being done, and it also is what we do for
> get uaccess APIs.)
>
> ifence() is a similar departure from existing barrier naming nomenclature, and I'd
> accept pretty much any other variant:
>
>         barrier_nospec()
>         ifence_nospec()
>
> The kernel namespace cleanliness rules are clear and consistent, and there's
> nothing new about them:
>
>  - the name of the API should unambiguously refer back to the API category. For
>    barriers this common reference is 'barrier' or 'mb'.
>
>  - use postfixes or prefixes consistently: pick one and don't mix them. If we go
>    with a _nospec() variant for the uaccess API names then we should use a similar
>    naming for array_idx() and for the new barrier as well - no mixing.

This is the feedback I can take action with, thank you.

>
>> You can always follow on with a patch to fix up the names and placements to your
>> liking. While they'll pick on my name choices, they won't pick on yours, because
>> I simply can't be bothered to care about a bikeshed color at this point after
>> being bounced around for 5 revisions of this patch set.
>
> Sorry, this kind of dismissive and condescending attitude won't cut it.

I reacted to your "for heaven's sake", I'll send a v6.
