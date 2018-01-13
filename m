From: ebiederm@xmission.com (Eric W. Biederman)
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
	<151586748981.5820.14559543798744763404.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CA+55aFzoAR+MYX+ub0xZ32OsT7WtD5Kru2t6LhwB1buLWPResQ@mail.gmail.com>
	<CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
Date: Sat, 13 Jan 2018 14:22:17 -0600
In-Reply-To: <CA+55aFxsg5+u7bCHj1N8xyyVf7-RMm-5ACNp=ENNrKL78omaow@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 13 Jan 2018 11:33:50 -0800")
Message-ID: <87inc5zeyu.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH v3 8/9] x86: use __uaccess_begin_nospec and ASM_IFENCE in get_user paths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Linus Torvalds <torvalds@linux-foundation.org> writes:

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

As an educated observer it seems like the cmpq/sbb/and sequence is an
improvement because it moves the dependency from one end of the cpu
pipeline to another.  If any cpu does data speculation on anything other
than branch targets that sequence could still be susceptible to
speculation.

>From the AMD patches it appears that lfence is becoming a serializing
instruction which in principal is much more expensive.

Also do we have alternatives for these sequences so if we run on an
in-order atom (or 386 or 486) where speculation does not occur we can
avoid the cost?

Eric
