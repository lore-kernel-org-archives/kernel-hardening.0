Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 10 Aug 2016 21:41:23 +0200
Message-ID: <2760702.46Rp2Juk5b@wuerfel>
In-Reply-To: <CAGXu5j+9saxwnKTK_vdnLCuXdbvUqQWXkbxOu8QrzB9SHmQGYA@mail.gmail.com>
References: <1464979224-2085-1-git-send-email-keescook@chromium.org> <20160810094339.GK1041@n2100.armlinux.org.uk> <CAGXu5j+9saxwnKTK_vdnLCuXdbvUqQWXkbxOu8QrzB9SHmQGYA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH 2/2] arm: apply more __ro_after_init
To: linux-arm-kernel@lists.infradead.org
Cc: Kees Cook <keescook@chromium.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Mathias Krause <minipli@googlemail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wednesday, August 10, 2016 11:32:07 AM CEST Kees Cook wrote:
> On Wed, Aug 10, 2016 at 2:43 AM, Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
> > On Fri, Jun 03, 2016 at 11:40:24AM -0700, Kees Cook wrote:
> >> @@ -1309,16 +1309,11 @@ void __init arm_mm_memblock_reserve(void)
> >>   * Any other function or debugging method which may touch any device _will_
> >>   * crash the kernel.
> >>   */
> >> +static char vectors[PAGE_SIZE * 2] __ro_after_init __aligned(PAGE_SIZE);
> >>  static void __init devicemaps_init(const struct machine_desc *mdesc)
> >>  {
> >>       struct map_desc map;
> >>       unsigned long addr;
> >> -     void *vectors;
> >> -
> >> -     /*
> >> -      * Allocate the vector page early.
> >> -      */
> >> -     vectors = early_alloc(PAGE_SIZE * 2);
> >
> > This one is not appropriate.  We _do_ write to these pages after init
> > for FIQ handler updates.  See set_fiq_handler().
> 
> Ah, interesting. I guess none of that hardware is being tested on
> linux-next.

Right. The OMAP1 Amstrad Delta is a somewhat obscure machine, and that
would be the most likely candidate to run into this.

RiscPC also has FIQ support, but I have not heard of anyone other
than Russell still using one with a modern kernel, and I doubt he
tests linux-next on it.

The s3c24xx and imx machines that could use FIQ probably don't
use it in practice, last time I checked, I didn't see any DTS file
or platform data definition in the kernel that activated that
code path.

> I'll drop that chunk and resubmit.

Good enough for now, but it may be worth revisiting this, as the
vector page might be a good target for an attack if you have a
way to overwrite a few bytes in the kernel.

Note that there are two mappings for the pages, and as Russell
mentioned, the TLS emulation writes to the other one that is
at a fixed virtual address.

It might be better to start by making the fixed mapping readonly,
as KASLR doesn't protect that one at all, and change the TLS
code accordingly.

	Arnd
