Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 22 Jan 2016 17:19:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160122171935.GF11645@leverpostej>
References: <1452518355-4606-1-git-send-email-ard.biesheuvel@linaro.org>
 <1452518355-4606-9-git-send-email-ard.biesheuvel@linaro.org>
 <20160122165517.GD11645@leverpostej>
 <CAKv+Gu-5uN9iZf00ABRmzgxW2QCM+rWkh12B981gP=mfhq8NGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-5uN9iZf00ABRmzgxW2QCM+rWkh12B981gP=mfhq8NGQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 08/21] arm64: add support for module PLTs
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 22, 2016 at 06:06:52PM +0100, Ard Biesheuvel wrote:
> On 22 January 2016 at 17:55, Mark Rutland <mark.rutland@arm.com> wrote:
> >> +static bool in_init(const struct module *mod, void *addr)
> >> +{
> >> +     return (u64)addr - (u64)mod->module_init < mod->init_size;
> >> +}
> >> +
> >> +u64 get_module_plt(struct module *mod, void *loc, u64 val)
> >> +{
> >> +     struct plt_entry entry = {
> >> +             cpu_to_le32(0x92800010 | (((~val      ) & 0xffff)) << 5),
> >> +             cpu_to_le32(0xf2a00010 | ((( val >> 16) & 0xffff)) << 5),
> >> +             cpu_to_le32(0xf2c00010 | ((( val >> 32) & 0xffff)) << 5),
> >> +             cpu_to_le32(0xd61f0200)
> >> +     }, *plt;
> >
> > It would be nice if we could un-magic this, though I see that reusing
> > the existing insn or reloc_insn code is painful here.
> >
> 
> Well, I could #define PLT0 PLT1 PLT2 etc, and document them a bit
> better, but having all the instruction machinery for emitting the
> exact same instructions each time seems a bit overkill imo.

Well, almost the same (the target address does change after all).

I agree that this looks more complicated using the insn machinery, based
on local experimentation. Oh well...
 
> >> +     int i, *count;
> >> +
> >> +     if (in_init(mod, loc)) {
> >> +             plt = (struct plt_entry *)mod->arch.init_plt->sh_addr;
> >> +             count = &mod->arch.init_plt_count;
> >> +     } else {
> >> +             plt = (struct plt_entry *)mod->arch.core_plt->sh_addr;
> >> +             count = &mod->arch.core_plt_count;
> >> +     }
> >> +
> >> +     /* Look for an existing entry pointing to 'val' */
> >> +     for (i = 0; i < *count; i++)
> >> +             if (plt[i].mov0 == entry.mov0 &&
> >> +                 plt[i].mov1 == entry.mov1 &&
> >> +                 plt[i].mov2 == entry.mov2)
> >> +                     return (u64)&plt[i];
> >
> > I think that at the cost of redundantly comparing the br x16, you could
> > simplify this by comparing the whole struct, e.g.
> >
> >         for (i = 0; i < *count; i++)
> >                 if (plt[i] == entry)
> 
> You can use struct types in assignments, but not in comparisons,
> strangely enough

Ah, sorry for the noise.

> >> +     for (s = sechdrs + 1; s < sechdrs_end; ++s) {
> >
> > Could we have a comment as to why we skip the first Shdr? I recall it's
> > in some way special, but I can't recall why/how.
> >
> 
> I don't remember exactly, and some of this code originated on ia64 IIRC.
> Probably better to simply start from [0]

Ok.

> >> +             const Elf64_Rela *rels = (void *)ehdr + s->sh_offset;
> >> +             int numrels = s->sh_size / sizeof(Elf64_Rela);
> >> +             Elf64_Shdr *dstsec = sechdrs + s->sh_info;
> >> +
> >> +             if (s->sh_type != SHT_RELA)
> >> +                     continue;
> >
> > We only have RELA, and no REL?
> >
> 
> Nope.
> 
> arch/arm64/Kconfig:86:  select MODULES_USE_ELF_RELA

Evidently I didn't do enough background reading.

> As I said, this code will look different in the next version, but I
> will make sure to take your review points.

Cheers! :)

Mark.
