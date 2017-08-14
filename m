MIME-Version: 1.0
In-Reply-To: <20170814153213.GU6321@e103592.cambridge.arm.com>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
 <20170814125411.22604-3-ard.biesheuvel@linaro.org> <20170814153213.GU6321@e103592.cambridge.arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 16:40:55 +0100
Message-ID: <CAKv+Gu83nTRAqqT_AzQZubPVCt69tUdHy1oK7bPaYvHFmnihkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 02/30] ARM: assembler: introduce adr_l, ldr_l and str_l macros
To: Dave Martin <Dave.Martin@arm.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Russell King <linux@armlinux.org.uk>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Garnier <thgarnie@google.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 14 August 2017 at 16:32, Dave Martin <Dave.Martin@arm.com> wrote:
> On Mon, Aug 14, 2017 at 01:53:43PM +0100, Ard Biesheuvel wrote:
>> Like arm64, ARM supports position independent code sequences that
>> produce symbol references with a greater reach than the ordinary
>> adr/ldr instructions.
>>
>> Currently, we use open coded instruction sequences involving literals
>> and arithmetic operations. Instead, we can use movw/movt pairs on v7
>> CPUs, circumventing the D-cache entirely. For older CPUs, we can emit
>> the literal into a subsection, allowing it to be emitted out of line
>> while retaining the ability to perform arithmetic on label offsets.
>>
>> E.g., on pre-v7 CPUs, we can emit a PC-relative reference as follows:
>>
>>        ldr          <reg>, 222f
>>   111: add          <reg>, <reg>, pc
>>        .subsection  1
>>   222: .long        <sym> - (111b + 8)
>>        .previous
>>
>> This is allowed by the assembler because, unlike ordinary sections,
>> subsections are combined into a single section into the object file,
>> and so the label references are not true cross-section references that
>> are visible as relocations. Note that we could even do something like
>>
>>        add          <reg>, pc, #(222f - 111f) & ~0xfff
>>        ldr          <reg>, [<reg>, #(222f - 111f) & 0xfff]
>>   111: add          <reg>, <reg>, pc
>>        .subsection  1
>>   222: .long        <sym> - (111b + 8)
>>        .previous
>>
>> if it turns out that the 4 KB range of the ldr instruction is insufficient
>> to reach the literal in the subsection, although this is currently not a
>> problem (of the 98 objects built from .S files in a multi_v7_defconfig
>> build, only 11 have .text sections that are over 1 KB, and the largest one
>> [entry-armv.o] is 3308 bytes)
>>
>> Subsections have been available in binutils since 2004 at least, so
>> they should not cause any issues with older toolchains.
>>
>> So use the above to implement the macros mov_l, adr_l, adrm_l (using ldm
>
> I don't see adrm_l in this patch.
>

Oops (2)

Nico already mentioned that, and I failed to fix the commit log. I
added it at some point, but it wasn't really useful

>> to load multiple literals at once), ldr_l and str_l, all of which will
>> use movw/movt pairs on v7 and later CPUs, and use PC-relative literals
>> otherwise.
>
> Also...
>
> By default, I'd assume that we should port _all_ uses of :upper16:/
> :lower16: to use these.  Does this series consciously do that?  Are
> there any exceptions?
>

There aren't that many. Anything that refers to absolute symbols will
break under CONFIG_RELOCATABLE and I haven't noticed any issues (I
tested extensively with Thumb2)

I don't mind open coded movw/movt for relative references in code that
is tightly coupled to a platform that guarantees v7+ so I didn't do a
full sweep. Also, I started with 50+ patches and tried to remove the
ones that are mostly orthogonal to the KASLR stuff.
