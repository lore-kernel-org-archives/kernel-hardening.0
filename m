Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 5 Jan 2016 15:58:42 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
Message-ID: <20160105145842.GB3234@cbox>
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>
 <1451489172-17420-3-git-send-email-ard.biesheuvel@linaro.org>
 <20160105143634.GD28354@cbox>
 <20160105144649.GD24664@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160105144649.GD24664@leverpostej>
Subject: [kernel-hardening] Re: [PATCH v2 02/13] arm64: introduce KIMAGE_VADDR as the virtual
 base of the kernel region
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, stuart.yoder@freescale.com, bhupesh.sharma@freescale.com, arnd@arndb.de, marc.zyngier@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 05, 2016 at 02:46:50PM +0000, Mark Rutland wrote:
> On Tue, Jan 05, 2016 at 03:36:34PM +0100, Christoffer Dall wrote:
> > On Wed, Dec 30, 2015 at 04:26:01PM +0100, Ard Biesheuvel wrote:
> > > This introduces the preprocessor symbol KIMAGE_VADDR which will serve as
> > > the symbolic virtual base of the kernel region, i.e., the kernel's virtual
> > > offset will be KIMAGE_VADDR + TEXT_OFFSET. For now, we define it as being
> > > equal to PAGE_OFFSET, but in the future, it will be moved below it once
> > > we move the kernel virtual mapping out of the linear mapping.
> > > 
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > >  arch/arm64/include/asm/memory.h | 10 ++++++++--
> > >  arch/arm64/kernel/head.S        |  2 +-
> > >  arch/arm64/kernel/vmlinux.lds.S |  4 ++--
> > >  3 files changed, 11 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > > index 853953cd1f08..bea9631b34a8 100644
> > > --- a/arch/arm64/include/asm/memory.h
> > > +++ b/arch/arm64/include/asm/memory.h
> > > @@ -51,7 +51,8 @@
> > >  #define VA_BITS			(CONFIG_ARM64_VA_BITS)
> > >  #define VA_START		(UL(0xffffffffffffffff) << VA_BITS)
> > >  #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
> > > -#define MODULES_END		(PAGE_OFFSET)
> > > +#define KIMAGE_VADDR		(PAGE_OFFSET)
> > > +#define MODULES_END		(KIMAGE_VADDR)
> > >  #define MODULES_VADDR		(MODULES_END - SZ_64M)
> > >  #define PCI_IO_END		(MODULES_VADDR - SZ_2M)
> > >  #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
> > > @@ -75,8 +76,13 @@
> > >   * private definitions which should NOT be used outside memory.h
> > >   * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
> > >   */
> > > -#define __virt_to_phys(x)	(((phys_addr_t)(x) - PAGE_OFFSET + PHYS_OFFSET))
> > > +#define __virt_to_phys(x) ({						\
> > > +	phys_addr_t __x = (phys_addr_t)(x);				\
> > > +	__x >= PAGE_OFFSET ? (__x - PAGE_OFFSET + PHYS_OFFSET) :	\
> > > +			     (__x - KIMAGE_VADDR + PHYS_OFFSET); })
> > 
> > so __virt_to_phys will now work with a subset of the non-linear namely
> > all except vmalloced and ioremapped ones?
> 
> It will work for linear mapped memory and for the kernel image, which is
> what it used to do. It's just that the relationship between the image
> and the linear map is broken.
> 
> The same rules apply to x86, where their virt_to_phys eventually boils down to:
> 
> static inline unsigned long __phys_addr_nodebug(unsigned long x)
> {
>         unsigned long y = x - __START_KERNEL_map;
> 
>         /* use the carry flag to determine if x was < __START_KERNEL_map */
>         x = y + ((x > y) ? phys_base : (__START_KERNEL_map - PAGE_OFFSET));
> 
>         return x;
> }
> 
ok, thanks for the snippet :)

-Christoffer
