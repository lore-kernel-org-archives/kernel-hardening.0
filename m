Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 10 Aug 2016 21:31:05 +0200
Message-ID: <2096112.OBiRuggdEi@wuerfel>
In-Reply-To: <20160810101253.GL1041@n2100.armlinux.org.uk>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org> <2342289.4RWg0SWI3A@wuerfel> <20160810101253.GL1041@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH 2/2] arm: apply more __ro_after_init
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, linux-arch@vger.kernel.org, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wednesday, August 10, 2016 11:12:53 AM CEST Russell King - ARM Linux wrote:
> On Wed, Aug 10, 2016 at 12:00:53PM +0200, Arnd Bergmann wrote:
> > On Wednesday, August 10, 2016 10:43:39 AM CEST Russell King - ARM Linux wrote:
> > > On Fri, Jun 03, 2016 at 11:40:24AM -0700, Kees Cook wrote:
> > > > @@ -1309,16 +1309,11 @@ void __init arm_mm_memblock_reserve(void)
> > > >   * Any other function or debugging method which may touch any device _will_
> > > >   * crash the kernel.
> > > >   */
> > > > +static char vectors[PAGE_SIZE * 2] __ro_after_init __aligned(PAGE_SIZE);
> > > >  static void __init devicemaps_init(const struct machine_desc *mdesc)
> > > >  {
> > > >       struct map_desc map;
> > > >       unsigned long addr;
> > > > -     void *vectors;
> > > > -
> > > > -     /*
> > > > -      * Allocate the vector page early.
> > > > -      */
> > > > -     vectors = early_alloc(PAGE_SIZE * 2);
> > > 
> > > This one is not appropriate.  We _do_ write to these pages after init
> > > for FIQ handler updates.  See set_fiq_handler().
> > 
> > Is that the only thing that modifies the page? If we think this is a
> > valuable change, we could make it depend on the absence of FIQ
> > support, as very few platforms (rpc, omap1, s3c24xx and possibly
> > imx) seem to even use it.
> 
> There's the TLS emulation too, but that writes via the vectors mapping
> at 0xffff0ff0.

Ok, so that should be safe. Can we change the fiq code to also use the
high mapping and then take the __ro_after_init patch on top?

	Arnd
