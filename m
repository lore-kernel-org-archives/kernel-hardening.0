MIME-Version: 1.0
In-Reply-To: <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com> <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 16 Jan 2018 14:23:08 -0800
Message-ID: <CAPcyv4hfUx8gLScuNewY3+BWi4YBS_Z9dhvYf1D+WEWDDCShXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in
 get_user paths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 13, 2018 at 11:33 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Jan 13, 2018 at 11:05 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I _know_ that lfence is expensive as hell on P4, for example.
>>
>> Yes, yes, "sbb" is often more expensive than most ALU instructions,
>> and Agner Fog says it has a 10-cycle latency on Prescott (which is
>> outrageous, but being one or two cycles more due to the flags
>> generation is normal). So the sbb/and may certainly add a few cycles
>> to the critical path, but on Prescott "lfence" is *50* cycles
>> according to those same tables by Agner Fog.
>
> Side note: I don't think P4 is really relevant for a performance
> discussion, I was just giving it as an example where we do know actual
> cycles.
>
> I'm much more interested in modern Intel big-core CPU's, and just
> wondering whether somebody could ask an architect.
>
> Because I _suspect_ the answer from a CPU architect would be: "Christ,
> the sbb/and sequence is much better because it doesn't have any extra
> serialization", but maybe I'm wrong, and people feel that lfence is
> particularly easy to do right without any real downside.
>

>From the last paragraph of this guidance:

https://software.intel.com/sites/default/files/managed/c5/63/336996-Speculative-Execution-Side-Channel-Mitigations.pdf

...I read that as Linux can constrain speculation with 'and; sbb'
instead of 'lfence', and any future changes will be handled like any
new cpu enabling.

To your specific question of the relative costs, sbb is
architecturally cheaper, so let's go with that approach.

For this '__uaccess_begin_nospec' patch set, at a minimum the kernel
needs a helper that can be easily grep'd when/if it needs changing in
a future kernel. It also indicates that the command line approach to
dynamically switch the mitigation mechanism is over-engineering.

That said, for get_user specifically, can we do something even
cheaper. Dave H. reminds me that any valid user pointer that gets past
the address limit check will have the high bit clear. So instead of
calculating a mask, just unconditionally clear the high bit. It seems
worse case userspace can speculatively leak something that's already
in its address space.

I'll respin this set along those lines, and drop the ifence bits.
