Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 8 Jan 2016 12:40:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160108124055.GD3097@leverpostej>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-13-git-send-email-ard.biesheuvel@linaro.org>
 <20160108123614.GC3097@leverpostej>
 <CAKv+Gu9rp945-1cfn1iz01WBi+H5sWxTQPLGPduvG__wxVdK3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9rp945-1cfn1iz01WBi+H5sWxTQPLGPduvG__wxVdK3g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 12/13] arm64: add support for relocatable kernel
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 08, 2016 at 01:38:54PM +0100, Ard Biesheuvel wrote:
> On 8 January 2016 at 13:36, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Wed, Dec 30, 2015 at 04:26:11PM +0100, Ard Biesheuvel wrote:
> >> +
> >> +     /*
> >> +      * Iterate over each entry in the relocation table, and apply the
> >> +      * relocations in place.
> >> +      */
> >> +     adr_l   x8, __dynsym_start              // start of symbol table
> >> +     adr_l   x9, __reloc_start               // start of reloc table
> >> +     adr_l   x10, __reloc_end                // end of reloc table
> >> +
> >> +0:   cmp     x9, x10
> >> +     b.hs    2f
> >> +     ldp     x11, x12, [x9], #24
> >> +     ldr     x13, [x9, #-8]
> >> +     cmp     w12, #R_AARCH64_RELATIVE
> >> +     b.ne    1f
> >> +     add     x13, x13, x23                   // relocate
> >> +     str     x13, [x11, x23]
> >> +     b       0b
> >> +
> >> +1:   cmp     w12, #R_AARCH64_ABS64
> >> +     b.ne    0b
> >> +     add     x12, x12, x12, lsl #1           // symtab offset: 24x top word
> >> +     add     x12, x8, x12, lsr #(32 - 3)     // ... shifted into bottom word
> >> +     ldrsh   w14, [x12, #6]                  // Elf64_Sym::st_shndx
> >> +     ldr     x15, [x12, #8]                  // Elf64_Sym::st_value
> >> +     cmp     w14, #-0xf                      // SHN_ABS (0xfff1) ?
> >> +     add     x14, x15, x23                   // relocate
> >> +     csel    x15, x14, x15, ne
> >> +     add     x15, x13, x15
> >> +     str     x15, [x11, x23]
> >> +     b       0b
> >
> > We need to clean each of these relocated instructions to the PoU to be
> > visible for I-cache fetches.
> >
> > As this is normal-cacheable we can post the maintenance with a DC CVAU
> > immediately after the store (no barriers necessary), and rely on the DSB
> > at 2f to complete all of those.
> >
> 
> Dynamic relocations never apply to instructions, so i don't think that
> is necessary here.

Ah, yes. I was being thick. Sorry for the noise!

Thanks,
Mark.
