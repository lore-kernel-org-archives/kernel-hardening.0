Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 23 Dec 2015 16:45:16 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20151223212911.GR2793@atomide.com>
Message-ID: <alpine.LFD.2.20.1512231637110.3603@knanqh.ubzr>
References: <20151202202725.GA794@www.outflux.net> <20151223195129.GP2793@atomide.com> <567B04AB.6010906@redhat.com> <20151223212911.GR2793@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2] ARM: mm: flip priority of CONFIG_DEBUG_RODATA
To: Tony Lindgren <tony@atomide.com>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, Laura Abbott <labbott@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 23 Dec 2015, Tony Lindgren wrote:

> Hi,
> 
> * Laura Abbott <labbott@redhat.com> [151223 12:31]:
> > 
> > Looks like a case similar to Geert's
> > 
> >         adr     r7, kick_counter
> > wait_dll_lock_timed:
> >         ldr     r4, wait_dll_lock_counter
> >         add     r4, r4, #1
> >         str     r4, [r7, #wait_dll_lock_counter - kick_counter]
> >         ldr     r4, sdrc_dlla_status
> >         /* Wait 20uS for lock */
> >         mov     r6, #8
> > 
> > 
> > kick_counter and wait_dll_lock_counter are in the text section which is marked read only.
> > They need to be moved to the data section along with a few other variables from what I
> > can tell (maybe those are read only?).
> 
> Thanks for looking, yeah so it seem.
> 
> > I suspect this is going to be a common issue with suspend/resume code paths since those
> > are hand written assembly.
> 
> Yes I suspect we have quite a few cases like this.

We fixed a bunch of similar issues where code was located in the .data 
section for ease of use from assembly code.  See commit b4e61537 and 
d0776aff for example.


Nicolas
