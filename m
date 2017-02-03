MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170203222822.GG27312@n2100.armlinux.org.uk>
References: <1486144343-24998-1-git-send-email-labbott@redhat.com>
 <1486144343-24998-2-git-send-email-labbott@redhat.com> <CAGXu5jK6_y=dWHUDBto7ykN_sSOQ6Gx+sZs_gQ1Hoh5DjP-fTw@mail.gmail.com>
 <20170203202919.GE27312@n2100.armlinux.org.uk> <CAGXu5j+HOTHRrFJFMsMaAvqcTAUoEBuphzrYAr7VAjJQU9_RYA@mail.gmail.com>
 <20170203222822.GG27312@n2100.armlinux.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Feb 2017 15:07:02 -0800
Message-ID: <CAGXu5j+_hxry0nSkz77WCDHX5SzjXyr6YK9THeBOBH6x87145w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2 1/2] arch: Move CONFIG_DEBUG_RODATA and
 CONFIG_SET_MODULE_RONX to be common
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Laura Abbott <labbott@redhat.com>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-parisc <linux-parisc@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 3, 2017 at 2:28 PM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Fri, Feb 03, 2017 at 01:08:40PM -0800, Kees Cook wrote:
>> On Fri, Feb 3, 2017 at 12:29 PM, Russell King - ARM Linux
>> <linux@armlinux.org.uk> wrote:
>> > On Fri, Feb 03, 2017 at 11:45:56AM -0800, Kees Cook wrote:
>> >> On Fri, Feb 3, 2017 at 9:52 AM, Laura Abbott <labbott@redhat.com> wrote:
>> >> > diff --git a/arch/Kconfig b/arch/Kconfig
>> >> > index 99839c2..22ee01e 100644
>> >> > --- a/arch/Kconfig
>> >> > +++ b/arch/Kconfig
>> >> > @@ -781,4 +781,32 @@ config VMAP_STACK
>> >> >           the stack to map directly to the KASAN shadow map using a formula
>> >> >           that is incorrect if the stack is in vmalloc space.
>> >> >
>> >> > +config ARCH_NO_STRICT_RWX_DEFAULTS
>> >> > +       def_bool n
>> >> > +
>> >> > +config ARCH_HAS_STRICT_KERNEL_RWX
>> >> > +       def_bool n
>> >> > +
>> >> > +config DEBUG_RODATA
>> >> > +       def_bool y if !ARCH_NO_STRICT_RWX_DEFAULTS
>> >> > +       prompt "Make kernel text and rodata read-only" if ARCH_NO_STRICT_RWX_DEFAULTS
>> >>
>> >> Ah! Yes, perfect. I totally forgot about using conditional "prompt"
>> >> lines. Nice!
>> >
>> > It's no different from the more usual:
>> >
>> >         bool "Make kernel text and rodata read-only" if ARCH_NO_STRICT_RWX_DEFAULTS
>> >         default y if !ARCH_NO_STRICT_RWX_DEFAULTS
>> >         depends on ARCH_HAS_STRICT_KERNEL_RWX
>> >
>> > But... I really don't like this - way too many negations and negatives
>> > which make it difficult to figure out what's going on here.
>> >
>> > The situation we have today is:
>> >
>> > -config DEBUG_RODATA
>> > -       bool "Make kernel text and rodata read-only"
>> > -       depends on MMU && !XIP_KERNEL
>> > -       default y if CPU_V7
>> >
>> > which is "allow the user to select DEBUG_RODATA if building a MMU non-XIP
>> > kernel", suggesting that the user turns it on for ARMv7 CPUs.
>> >
>> > That changes with this and the above:
>> >
>> > +       select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
>> > +       select ARCH_HAS_STRICT_MODULE_RWX if MMU
>> > +       select ARCH_NO_STRICT_RWX_DEFAULTS if !CPU_V7
>> >
>> > This means that ARCH_HAS_STRICT_KERNEL_RWX is set for a MMU non-XIP
>> > kernel, which carries the same pre-condition for DEBUG_RODATA - no
>> > problem there.
>> >
>> > However, ARCH_NO_STRICT_RWX_DEFAULTS is set for non-ARMv7 CPUs, which
>> > means the "Make kernel text and rodata read-only" prompt _is_ provided
>> > for those.  However, for all ARMv7 systems, we go from "suggesting that
>> > the user enables the option" to "you don't have a choice, you get this
>> > whether you want it or not."
>> >
>> > I'd prefer to keep it off for my development systems, where I don't
>> > care about kernel security.  If we don't wish to do that as a general
>> > rule, can we make it dependent on EMBEDDED?
>> >
>> > Given that on ARM it can add up to 4MB to the kernel image - there
>> > _will_ be about 1MB before the .text section, the padding on between
>> > __modver and __ex_table which for me is around 626k, the padding
>> > between .notes and the init sections start with .vectors (the space
>> > between __ex_table and end of .notes is only 4124, which gets padded
>> > up to 1MB) and lastly the padding between the .init section and the
>> > data section (for me around 593k).  This all adds up to an increase
>> > in kernel image size of 3.2MB on 14.2MB - an increase of 22%.
>> >
>> > So no, I'm really not happy with that.
>>
>> Ah yeah, good point. We have three cases: unsupported, mandatory,
>> optional, but we have the case of setting the default for the optional
>> case. Maybe something like this?
>>
>> config STRICT_KERNEL_RWX
>>   bool "Make kernel text and rodata read-only" if ARCH_OPTIONAL_KERNEL_RWX
>>   depends on ARCH_HAS_STRICT_KERNEL_RWX
>>   default ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
>>
>> unsupported:
>> !ARCH_HAS_STRICT_KERNEL_RWX
>>
>> mandatory:
>> ARCH_HAS_STRICT_KERNEL_RWX
>> !ARCH_OPTIONAL_KERNEL_RWX
>>
>> optional:
>> ARCH_HAS_STRICT_KERNEL_RWX
>> ARCH_OPTIONAL_KERNEL_RWX
>> with default controlled by ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
>>
>> Then arm is:
>>   select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
>>   select ARCH_HAS_STRICT_MODULE_RWX if MMU
>>   select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
>>   select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT if CPU_V7
>>
>> x86 and arm64 are:
>>   select ARCH_HAS_STRICT_KERNEL_RWX
>>   select ARCH_HAS_STRICT_MODULE_RWX
>
> Looks to me like it will do the job.
>
> In passing, I noticed that, on ARM:
>
>   3 .rodata       002212b4  c0703000  c0703000  00703000  2**6
>                   CONTENTS, ALLOC, LOAD, DATA
>
> a lack of READONLY there - which suggests something in this lot isn't
> actually read-only data:
>
>         .rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {           \
>                 VMLINUX_SYMBOL(__start_rodata) = .;                     \
>                 *(.rodata) *(.rodata.*)                                 \
>                 RO_AFTER_INIT_DATA      /* Read only after init */      \
>                 KEEP(*(__vermagic))     /* Kernel version magic */      \
>                 . = ALIGN(8);                                           \
>                 VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;         \
>                 KEEP(*(__tracepoints_ptrs)) /* Tracepoints: pointer array */ \
>                 VMLINUX_SYMBOL(__stop___tracepoints_ptrs) = .;          \
>                 *(__tracepoints_strings)/* Tracepoints: strings */      \
>         }                                                               \
>
> I suspect it's the RO_AFTER_INIT_DATA section - maybe this should be
> placed into its own separate output section?  I don't think it's doing
> any harm, it's just odd that the .rodata section is marked as a normal
> data section.

Yeah, I think the linker drops the RO flag when it see the
RO_AFTER_INIT_DATA flags. Since the kernel does the permissions
settings, this has been fine. If we can force the linker flags on it,
I'm all for it, but every time I've tried, it has defeated me. :)

-Kees

-- 
Kees Cook
Pixel Security
