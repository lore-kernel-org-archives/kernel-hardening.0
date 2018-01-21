MIME-Version: 1.0
In-Reply-To: <20180121104019.GS17719@n2100.armlinux.org.uk>
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151648236968.34747.390507912161115784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180121104019.GS17719@n2100.armlinux.org.uk>
From: Jann Horn <jannh@google.com>
Date: Sun, 21 Jan 2018 21:15:38 +0100
Message-ID: <CAG48ez2C1QAf_RrUz=xOunkvmEFrXh8dqUqsRCTaYomPJLto4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v4.1 02/10] asm/nospec, array_ptr:
 sanitize speculative array de-references
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, the arch/x86 maintainers <x86@kernel.org>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

[whoops, resending as non-HTML mail]

On Sun, Jan 21, 2018 at 11:40 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Sat, Jan 20, 2018 at 01:06:09PM -0800, Dan Williams wrote:
>> +/*
>> + * If idx is negative or if idx > size then bit 63 is set in the mask,
>> + * and the value of ~(-1L) is zero. When the mask is zero, bounds check
>> + * failed, array_ptr will return NULL.
>
> The more times I see this the more times I'm unhappy with this comment:
>
> 1. does this really mean "idx > size" or "idx >= size" ?  The code
>    implements the latter not the former.

Copying the code here for context:
return ~(long)(idx | (sz - 1 - idx)) >> (BITS_PER_LONG - 1);

That part of the condition (ignoring the overflow edgecases) is
equivalent to "!(idx > sz - 1)", which is equivalent to "idx <= sz -
1", which is (ignoring overflow edgecases) equivalent to "idx < sz".

Handling of edgecases:
idx>=2^(BITS_PER_LONG-1) will cause a NULL return through the first
part of the condition.
Hmm... a problematic case might be "sz==0 &&
idx==2^(BITS_PER_LONG-1)-1". The first part of the expression wouldn't
trigger, the second part would be
"2^(BITS_PER_LONG)-1-(2^(BITS_PER_LONG-1)-1) ==
2^(BITS_PER_LONG)-2^(BITS_PER_LONG-1) == 2^(BITS_PER_LONG-1)", which
also wouldn't trigger, I think?
