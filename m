Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Apr 2016 01:37:21 +0200
From: Ralf Baechle <ralf@linux-mips.org>
Message-ID: <20160404233721.GB26295@linux-mips.org>
References: <1459415142-3412-1-git-send-email-matt.redfearn@imgtec.com>
 <CAGXu5jKMLcRmMkowF=fUEQdtccTJLR9FEWT4g_zeyZMW4BWQOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKMLcRmMkowF=fUEQdtccTJLR9FEWT4g_zeyZMW4BWQOg@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v2 00/11] MIPS relocatable kernel &
 KASLR
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux MIPS Mailing List <linux-mips@linux-mips.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Aaro Koskinen <aaro.koskinen@nokia.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexander Sverdlin <alexander.sverdlin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, David Daney <ddaney@caviumnetworks.com>, Jaedon Shin <jaedon.shin@gmail.com>, James Hogan <james.hogan@imgtec.com>, Jonas Gorski <jogo@openwrt.org>, Paul Burton <paul.burton@imgtec.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 04, 2016 at 12:46:29PM -0700, Kees Cook wrote:

> This is great! Thanks for working on this! :)
> 
> Without actually reading the code yet, I wonder if the x86 and MIPS
> relocs tool could be merged at all? Sounds like it might be more
> difficult though -- the relocation output is different and its storage
> location is different...
> 
> > Restrictions:
> > * The new kernel is not allowed to overlap the old kernel, such that
> >   the original kernel can still be booted if relocation fails.
> 
> This sounds like physical-only relocation then? Is the virtual offset
> randomized as well (like arm64) or just physical (like x86 currently
> -- though there is a series to fix this).

On MIPS we normally place the kernel in KSEG0 or XKPHYS which address
segments which are not mapped through the TLB so the difference is
kinda moot.

> > * Relocation is supported only by multiples of 64k bytes. This
> >   eliminates the need to handle R_MIPS_LO16 relocations as the bottom
> >   16bits will remain the same at the relocated address.
> 
> IIUC, that's actually better than x86, which needs to be 2MB aligned.

On MIPS a key concern was maintaining a reasonable size for the final
kernel image.  The R_MIPS_LO16 relocatio records make a significant
portion of the relocations in a relocatable .o file, so we wanted to
get rid of them.  This results in a relocation granularity of 64kB.
If we were truely, truely stingy we could come up with a relocation format
to save a few more bits but I doubt that'd make any sense.

> > * In 64 bit kernels, relocation is supported only within the same 4Gb
> >   memory segment as the kernel link address (CONFIG_PHYSICAL_START).
> >   This eliminates the need to handle R_MIPS_HIGHEST and R_MIPS_HIGHER
> >   relocations as the top 32bits will remain the same at the relocated
> >   address.
> 
> Interesting. Could the relocation code be updated in the future to
> bump the high addresses too?

It could but yet again, the idea was to keep the size of the final
generated file under control.  The R_MIPS_HIGHER and R_MIPS_HIGHEST
relocations can be discarded if we constrain the addresses to be in
a single 4GB segment.  Removing this constraint would make a kernel
image much bigger so I suggested to add this restriction at least for
this initial version.

  Ralf
