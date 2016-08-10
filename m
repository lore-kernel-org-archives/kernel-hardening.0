Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 10 Aug 2016 11:12:53 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20160810101253.GL1041@n2100.armlinux.org.uk>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org>
 <1464979224-2085-3-git-send-email-keescook@chromium.org>
 <20160810094339.GK1041@n2100.armlinux.org.uk>
 <2342289.4RWg0SWI3A@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2342289.4RWg0SWI3A@wuerfel>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 2/2] arm: apply more __ro_after_init
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 10, 2016 at 12:00:53PM +0200, Arnd Bergmann wrote:
> On Wednesday, August 10, 2016 10:43:39 AM CEST Russell King - ARM Linux wrote:
> > On Fri, Jun 03, 2016 at 11:40:24AM -0700, Kees Cook wrote:
> > > @@ -1309,16 +1309,11 @@ void __init arm_mm_memblock_reserve(void)
> > >   * Any other function or debugging method which may touch any device _will_
> > >   * crash the kernel.
> > >   */
> > > +static char vectors[PAGE_SIZE * 2] __ro_after_init __aligned(PAGE_SIZE);
> > >  static void __init devicemaps_init(const struct machine_desc *mdesc)
> > >  {
> > >       struct map_desc map;
> > >       unsigned long addr;
> > > -     void *vectors;
> > > -
> > > -     /*
> > > -      * Allocate the vector page early.
> > > -      */
> > > -     vectors = early_alloc(PAGE_SIZE * 2);
> > 
> > This one is not appropriate.  We _do_ write to these pages after init
> > for FIQ handler updates.  See set_fiq_handler().
> 
> Is that the only thing that modifies the page? If we think this is a
> valuable change, we could make it depend on the absence of FIQ
> support, as very few platforms (rpc, omap1, s3c24xx and possibly
> imx) seem to even use it.

There's the TLS emulation too, but that writes via the vectors mapping
at 0xffff0ff0.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
