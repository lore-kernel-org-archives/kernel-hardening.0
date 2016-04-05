Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Apr 2016 13:14:53 +0100
From: "Maciej W. Rozycki" <macro@imgtec.com>
In-Reply-To: <20160404233721.GB26295@linux-mips.org>
Message-ID: <alpine.DEB.2.00.1604051255150.21846@tp.orcam.me.uk>
References: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com> <CAGXu5jKMLcRmMkowF=fUEQdtccTJLR9FEWT4g_zeyZMW4BWQOg@mail.gmail.com> <20160404233721.GB26295@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Subject: Re: [kernel-hardening] [PATCH v2 00/11] MIPS relocatable kernel &
 KASLR
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Aaro Koskinen <aaro.koskinen@nokia.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexander Sverdlin <alexander.sverdlin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, David Daney <ddaney@caviumnetworks.com>, Jaedon Shin <jaedon.shin@gmail.com>, James Hogan <james.hogan@imgtec.com>, Jonas Gorski <jogo@openwrt.org>, Paul Burton <paul.burton@imgtec.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 5 Apr 2016, Ralf Baechle wrote:

> > > * Relocation is supported only by multiples of 64k bytes. This
> > >   eliminates the need to handle R_MIPS_LO16 relocations as the bottom
> > >   16bits will remain the same at the relocated address.
> > 
> > IIUC, that's actually better than x86, which needs to be 2MB aligned.
> 
> On MIPS a key concern was maintaining a reasonable size for the final
> kernel image.  The R_MIPS_LO16 relocatio records make a significant
> portion of the relocations in a relocatable .o file, so we wanted to
> get rid of them.  This results in a relocation granularity of 64kB.
> If we were truely, truely stingy we could come up with a relocation format
> to save a few more bits but I doubt that'd make any sense.

 Additionally, for historical reasons, with 32-bit (o32) ELF images the 
REL relocation format is used making borrow propagation from R_MIPS_LO16 
to its corresponding R_MIPS_HI16 relocation a pain to handle.  It is 
solvable as the static linker does handle it, in particular doing the 
reasonable thing for orphan relocations, but I think it's a complication 
worth avoiding if the cost is so little.

> > > * In 64 bit kernels, relocation is supported only within the same 4Gb
> > >   memory segment as the kernel link address (CONFIG_PHYSICAL_START).
> > >   This eliminates the need to handle R_MIPS_HIGHEST and R_MIPS_HIGHER
> > >   relocations as the top 32bits will remain the same at the relocated
> > >   address.
> > 
> > Interesting. Could the relocation code be updated in the future to
> > bump the high addresses too?
> 
> It could but yet again, the idea was to keep the size of the final
> generated file under control.  The R_MIPS_HIGHER and R_MIPS_HIGHEST
> relocations can be discarded if we constrain the addresses to be in
> a single 4GB segment.  Removing this constraint would make a kernel
> image much bigger so I suggested to add this restriction at least for
> this initial version.

 For the record, with 64-bit ELF images the RELA relocation format is 
used, so there's no such concern about borrows as with 32-bit ones, 
because the whole addend is always readily available and does not have to 
be calculated from parts coming from different relocations.  Consequently 
the handling of R_MIPS_HIGHER and R_MIPS_HIGHEST (and also R_MIPS_HI16 and 
R_MIPS_LO16) relocations in 64-bit ELF images is straightforward if we 
decided to include them.

 I suspect extending the handling to R_MIPS_HIGHER only will suffice all 
use cases for the foreseeable future as I don't expect MIPS systems with 
more than 256TiB of RAM to appear anytime soon.

 FWIW,

  Maciej
