Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 30 Nov 2015 22:20:32 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <565CF5E3.7000109@redhat.com>
Message-ID: <alpine.LFD.2.20.1511302219260.22569@knanqh.ubzr>
References: <20151130233819.GA18873@www.outflux.net> <565CF1E5.2070003@redhat.com> <CAGXu5jJUv3EKkFA3J43nVO+v=-K5kgwSqwrVA9hxJGeZ79CkAg@mail.gmail.com> <565CF5E3.7000109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] ARM: mm: flip priority of CONFIG_DEBUG_RODATA
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 30 Nov 2015, Laura Abbott wrote:

> On 11/30/2015 05:08 PM, Kees Cook wrote:
> > On Mon, Nov 30, 2015 at 5:03 PM, Laura Abbott <labbott@redhat.com> wrote:
> > > On 11/30/2015 03:38 PM, Kees Cook wrote:
> > > >
> > > > Given the choice between making things NX or making things RO, we want
> > > > RO first. As such, redefine CONFIG_DEBUG_RODATA to actually do the bulk
> > >
> > >
> > > Can you give a citation for why? The thread that inspired it might be
> > > a good link.
> >
> > This was inspired by my examining the existing architecture's
> > implementations of CONFIG_DEBUG_RODATA after Ingo suggested it be made
> > a common feature not a build-time config (or at least renamed):
> > http://www.openwall.com/lists/kernel-hardening/2015/11/30/13
> >
> 
> Thanks. I read the thread and I think it would be good to put a link
> in the commit message to make it clearer why this is going in.

A link is good, but a summary is even better. You may add both for best 
results.


> 
> > > > index 41218867a9a6..b617084e9520 100644
> > > > --- a/arch/arm/mm/Kconfig
> > > > +++ b/arch/arm/mm/Kconfig
> > > > @@ -1039,24 +1039,26 @@ config ARCH_SUPPORTS_BIG_ENDIAN
> > > >            This option specifies the architecture can support big endian
> > > >            operation.
> > > >
> > > > -config ARM_KERNMEM_PERMS
> > > > -       bool "Restrict kernel memory permissions"
> > > > +config DEBUG_RODATA
> > > > +       bool "Make kernel text and rodata read-only"
> > > >          depends on MMU
> > > > +       default y if CPU_V7
> > > >          help
> > > > -         If this is set, kernel memory other than kernel text (and
> > > > rodata)
> > > > -         will be made non-executable. The tradeoff is that each region
> > > > is
> > > > -         padded to section-size (1MiB) boundaries (because their
> > > > permissions
> > > > -         are different and splitting the 1M pages into 4K ones causes
> > > > TLB
> > > > -         performance problems), wasting memory.
> > > > +         If this is set, kernel memory (text, rodata, etc) will be made
> > > > +         read-only, and non-text kernel memory will be made
> > > > non-executable.
> > > > +         The tradeoff is that each region is padded to section-size
> > > > (1MiB)
> > > > +         boundaries (because their permissions are different and
> > > > splitting
> > > > +         the 1M pages into 4K ones causes TLB performance problems),
> > > > which
> > > > +         can waste memory.
> > > >
> > > > -config DEBUG_RODATA
> > > > -       bool "Make kernel text and rodata read-only"
> > > > -       depends on ARM_KERNMEM_PERMS
> > > > +config DEBUG_ALIGN_RODATA
> > > > +       bool "Make rodata strictly non-executable"
> > > > +       depends on DEBUG_RODATA
> > > >          default y
> > > >          help
> > > > -         If this is set, kernel text and rodata will be made read-only.
> > > > This
> > > > -         is to help catch accidental or malicious attempts to change
> > > > the
> > > > -         kernel's executable code. Additionally splits rodata from
> > > > kernel
> > > > -         text so it can be made explicitly non-executable. This creates
> > > > -         another section-size padded region, so it can waste more
> > > > memory
> > > > -         space while gaining the read-only protections.
> > > > +         If this is set, rodata will be made explicitly non-executable.
> > > > This
> > > > +         provides protection on the rare chance that attackers might
> > > > find
> > > > and
> > > > +         use ROP gadgets that exist in the rodata section. This adds an
> > > > +         additional section-aligned split of rodata from kernel text so
> > > > it
> > > > +         can be made explicitly non-executable. This padding may waste
> > > > memory
> > > > +         space to gain this additional protection.
> > >
> > >
> > > I get that you want to make this match arm64 but it's really not intuitive
> > > that
> > > something with ALIGN_RODATA in the name is actually for setting NX. The
> > > purpose
> > > of ALIGN_RODATA was also slightly different on arm64 since the RO/NX will
> > > still
> > > be there, the difference is if the sections are present versus broken down
> > > into
> > > pages.
> >
> > Well, it seems to have the same effect: without the alignment, a
> > portion of rodata may remain executable on arm64. Unless I
> > misunderstand?
> >
> 
> No, on arm64 everything should always be NX, the difference is part of the NX
> sections may be mapped as pages instead of sections so you take the TLB hit.
> It's a trade off of memory vs TLB pressure instead of just security vs TLB.
> 
> Thanks,
> Laura
> 
> 
