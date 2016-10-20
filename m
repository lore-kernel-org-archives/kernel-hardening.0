Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476952250.2339.2.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Thu, 20 Oct 2016 10:30:50 +0200
In-Reply-To: <20161020055856.GS19531@linaro.org>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
	 <1476802761-24340-3-git-send-email-colin@cvidal.org>
	 <CAGXu5jJXRxCvO6YiBWt4-mWMO_pbrurViWcFODbN2NtjJ3PSmQ@mail.gmail.com>
	 <1476866702.21069.8.camel@cvidal.org>
	 <CAGXu5j+AT4rnD5Zo6qdr76aJZLnvuknx-=UE57CTD1+WxmX=1A@mail.gmail.com>
	 <20161020055856.GS19531@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [RFC 2/2] arm: implementation for
 HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, David Windsor <dave@progbits.org>, Hans Liljestrand <ishkamiel@gmail.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2016-10-20 at 14:58 +0900, AKASHI Takahiro wrote:
> On Wed, Oct 19, 2016 at 01:11:46PM -0700, Kees Cook wrote:
> > 
> > On Wed, Oct 19, 2016 at 1:45 AM, Colin Vidal <colin@cvidal.org> wrote:
> > > 
> > > Hi Kees,
> > > 
> > > > 
> > > > > 
> > > > > This adds arm-specific code in order to support HARDENED_ATOMIC
> > > > > feature. When overflow is detected in atomic_t, atomic64_t or
> > > > > atomic_long_t, an exception is raised and call
> > > > > hardened_atomic_overflow.
> > > > 
> > > > Can you include some notes that this was originally in PaX/grsecurity,
> > > > and detail what is different from their implemention?
> > > 
> > > Of course. I add it in the next version.
> > > 
> > > > 
> > > > > 
> > > > > Signed-off-by: Colin Vidal <colin@cvidal.org>
> > > > > ---
> > > > >  arch/arm/Kconfig              |   1 +
> > > > >  arch/arm/include/asm/atomic.h | 434 +++++++++++++++++++++++++++++-------------
> > > > >  arch/arm/mm/fault.c           |  15 ++
> > > > >  3 files changed, 320 insertions(+), 130 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > > > > index b5d529f..fcf4a64 100644
> > > > > --- a/arch/arm/Kconfig
> > > > > +++ b/arch/arm/Kconfig
> > > > > @@ -36,6 +36,7 @@ config ARM
> > > > >         select HAVE_ARCH_AUDITSYSCALL if (AEABI && !OABI_COMPAT)
> > > > >         select HAVE_ARCH_BITREVERSE if (CPU_32v7M || CPU_32v7) && !CPU_32v6
> > > > >         select HAVE_ARCH_HARDENED_USERCOPY
> > > > > +       select HAVE_ARCH_HARDENED_ATOMIC
> > > > >         select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL && !CPU_ENDIAN_BE32 && MMU
> > > > >         select HAVE_ARCH_KGDB if !CPU_ENDIAN_BE32 && MMU
> > > > >         select HAVE_ARCH_MMAP_RND_BITS if MMU
> > > > > diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> > > > > index 66d0e21..fdaee17 100644
> > > > > --- a/arch/arm/include/asm/atomic.h
> > > > > +++ b/arch/arm/include/asm/atomic.h
> > > > > @@ -17,18 +17,52 @@
> > > > >  #include <linux/irqflags.h>
> > > > >  #include <asm/barrier.h>
> > > > >  #include <asm/cmpxchg.h>
> > > > > +#include <linux/bug.h>
> > > > > 
> > > > >  #define ATOMIC_INIT(i) { (i) }
> > > > > 
> > > > >  #ifdef __KERNEL__
> > > > > 
> > > > > +#ifdef CONFIG_HARDENED_ATOMIC
> > > > > +#define HARDENED_ATOMIC_INSN "bkpt 0xf103"
> > > > 
> > > > In PaX, I see a check for THUMB2 config:
> > > > 
> > > > #ifdef CONFIG_THUMB2_KERNEL
> > > > #define REFCOUNT_TRAP_INSN "bkpt        0xf1"
> > > > #else
> > > > #define REFCOUNT_TRAP_INSN "bkpt        0xf103"
> > > > #endif
> > > > 
> > > > That should probably stay unless I'm misunderstanding something. Also,
> > > > for your new ISNS define name, I'd leave "TRAP" in the name, since
> > > > that describes more clearly what it does.
> > > 
> > > Oh yeah. I will add it. Actually I does not add it at first since I
> > > does not really understand why there is a special case for Thumbs2 (as
> > > far I understand, instructions size can also be 4 bytes). If ARM
> > > experts are around, I would appreciate pointers about it :-)
> > 
> > Cool. Perhaps Takahiro or Mark (now on CC) can comment on it.
> 
> "bkpt" is a 16-bit instruction with an 8-bit immediate value in thumb2.

Ok, I better understand why PaX uses this guard now.

Thanks!

Colin
