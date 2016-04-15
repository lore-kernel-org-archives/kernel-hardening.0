Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160415080715.GD30715@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
	<1460672954-32567-4-git-send-email-keescook@chromium.org>
	<20160415080715.GD30715@gmail.com>
Date: Fri, 15 Apr 2016 12:12:56 -0700
Message-ID: <CAGXu5jKXP0i28gbZ9Yu=fgrJ8G6kcs5oWem_1av2bezj72KK2Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 03/21] x86, KASLR: Drop CONFIG_RANDOMIZE_BASE_MAX_OFFSET
To: Ingo Molnar <mingo@kernel.org>
Cc: Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 15, 2016 at 1:07 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Kees Cook <keescook@chromium.org> wrote:
>
>> From: Baoquan He <bhe@redhat.com>
>>
>> Currently CONFIG_RANDOMIZE_BASE_MAX_OFFSET is used to limit the maximum
>> offset for kernel randomization. This limit doesn't need to be a CONFIG
>> since it is tied completely to KERNEL_IMAGE_SIZE, and will make no sense
>> once physical and virtual offsets are randomized separately. This patch
>> removes CONFIG_RANDOMIZE_BASE_MAX_OFFSET and consolidates the Kconfig
>> help text.
>>
>> Signed-off-by: Baoquan He <bhe@redhat.com>
>> [kees: rewrote changelog, dropped KERNEL_IMAGE_SIZE_DEFAULT, moved earlier]
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/x86/Kconfig                     | 57 +++++++++++++-----------------------
>>  arch/x86/boot/compressed/aslr.c      | 12 ++++----
>>  arch/x86/include/asm/page_64_types.h |  8 ++---
>>  arch/x86/mm/init_32.c                |  3 --
>>  4 files changed, 29 insertions(+), 51 deletions(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 2dc18605831f..fd9ac711ada8 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1936,51 +1936,36 @@ config RANDOMIZE_BASE
>>       depends on RELOCATABLE
>>       default n
>>       ---help---
>> -        Randomizes the physical and virtual address at which the
>> -        kernel image is decompressed, as a security feature that
>> -        deters exploit attempts relying on knowledge of the location
>> -        of kernel internals.
>> +        Randomizes the physical address at which the kernel image
>> +        is decompressed and the virtual address where the kernel
>> +        image is mapped, as a secrurity feature that deters exploit
>
> Guys, please _read_ what you write: s/secrurity/security

Gah, sorry. I was reading these, but things slip by. I'll fix it. (And
add these to the common misspellings that checkpatch.pl looks for.)

>
>> +        attempts relying on knowledge of the location of kernel
>> +        internals.
>> +
>> +        The kernel physical address can be randomized from 16M to
>> +        64T at most.)
>
> The 64TB value sure reads weird if you are configuring a 32-bit system ...
>
> A much better approach would be to split the help text into 32-bit and 64-bit
> portions:
>
>   On 64-bit systems the kernel physical address will be randomized from 16M to the
>   top of available physical memory. (With a maximum of 64TB.)
>
>   On 32-bit systems the kernel physical address will be randomized from 16MB to
>   1GB.

Yup, good idea.

> Also note the assertive tone: if this Kconfig feature is eanbled, we say that the
> kernel address _will_ be randomized, and we should make sure it is. (If for some
> weird reason randomization fails we should warn prominently during bootup.)

This will need some thought... is it better to fail to boot or to boot
without entropy? As-is, it's possible to randomly position the kernel
base address at exactly the location it was going to boot without
KASLR too, yet this is still considered random...

>
>
>>                           The kernel virtual address will be offset
>> +        by up to KERNEL_IMAGE_SIZE. On 32-bit KERNEL_IMAGE_SIZE is
>> +        512MiB. while on 64-bit this is limited by how the kernel
>> +        fixmap page table is positioned, so this cannot be larger
>> +        than 1GiB currently. Without RANDOMIZE_BASE there is a 512MiB
>> +        to 1.5GiB split between kernel and modules. When RANDOMIZE_BASE
>> +        is enabled, the modules area will shrink to compensate, up
>> +        to a 1GiB to 1GiB split, KERNEL_IMAGE_SIZE changes from 512MiB
>> +        to 1GiB.
>
> Beyond the broken capitalization, I'll show you what 99.999% of users who are not
> kernel hackers will understand from this paragraph, approximately:
>
>                              To dream: ay, and them? To bear to sling afterprises
>             coil, and scover'd cowards of resolence dream: ay, the us for no mome
>             wish'd. Thus and sweary life, or nobles cast and makes, whips and that
>             is sicklied of resolence of so long afterprises us more; for whips
>             all; and name whething after bear to sleep; to beart-ache shocks the
>             undiscover'd consummative have, but that pith a sleep of somethe under
>             'tis the spurns of troud makes off thance doth make whose bourns of
>             dispriz'd consient and arms more.
>
> So this is really deep kernel internals, I get a headache trying to interpret it,
> and it's my job to interpret this! Please try to formulate key pieces of
> information in Kconfig help texts in a more ... approachable fashion, and move the
> jargon to .c source code files.

Trying to capture the effect of reducing the kernel/module split
without detailing the actual numbers may sound evasive, but I'll see
what I can do.

>
>>          Entropy is generated using the RDRAND instruction if it is
>>          supported. If RDTSC is supported, it is used as well. If
>>          neither RDRAND nor RDTSC are supported, then randomness is
>>          read from the i8254 timer.
>
> Also, instead of 'used as well' I'd say "is mixed into the entropy pool as well"
> or so, to make sure it's clear that we don't exclusively rely on RDRAND or RDTSC.
>
> Also, could we always mix the i8254 timer into this as well, not just when RDTSC
> is unavailable?

IIRC, hpa explicitly did not want to do this when he was making
suggestions on this area. I would need to dig out the thread -- I
can't find it now. I'd prefer to leave this as-is, since changing it
would add yet another variable to the behavioral changes of this
series.

>> -        The kernel will be offset by up to RANDOMIZE_BASE_MAX_OFFSET,
>> -        and aligned according to PHYSICAL_ALIGN. Since the kernel is
>> -        built using 2GiB addressing, and PHYSICAL_ALGIN must be at a
>> -        minimum of 2MiB, only 10 bits of entropy is theoretically
>> -        possible. At best, due to page table layouts, 64-bit can use
>> -        9 bits of entropy and 32-bit uses 8 bits.
>> +        Since the kernel is built using 2GiB addressing, and
>> +        PHYSICAL_ALGIN must be at a minimum of 2MiB, only 10 bits of
>> +        entropy is theoretically possible. At best, due to page table
>> +        layouts, 64-bit can use 9 bits of entropy and 32-bit uses 8
>> +        bits.
>
> Please read what you write, there's a typo in this section.

Gah, I need to teach my spell checker about #defines. ;) I read this
multiple times after you called it out and still couldn't see it
(http://www.mrc-cbu.cam.ac.uk/people/matt.davis/cmabridge/). Finally
dropped the _ and the spell checker flagged it. ;)

> Another request: please stop the MiB/GiB nonsense and call it MB/GB. This isn't
> storage code that has to fight marketing lies. Only the KASLR section in
> arch/x86/Kconfig* is using MiB/GiB, everything else uses MB/GB naming, we should
> stick with that.

Totally fine by me. I prefer MB/GB. I wonder if it is worth
documenting this preference somewhere in the style guide? It's
certainly rare in the kernel, but it's present (and there are even
#defines for it *sob*).

$ git grep '[KMGTP]iB' | wc -l
1239
$ git grep '[KMGTP]B' | wc -l
192251

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
