Date: Fri, 30 Jun 2017 16:55:14 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
Message-ID: <20170630155513.GA4902@n2100.armlinux.org.uk>
References: <20170630153502.3327030-1-arnd@arndb.de>
 <9291740E-3BD1-454C-A3EB-46E35F073D0E@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9291740E-3BD1-454C-A3EB-46E35F073D0E@linaro.org>
Sender: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [kernel-hardening] Re: [PATCH] ARM: fix randomized task_struct
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 30, 2017 at 03:49:41PM +0000, Ard Biesheuvel wrote:
> 
> 
> > On 30 Jun 2017, at 15:34, Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > With the new task struct randomization, we can run into a build
> > failure for certain random seeds:
> > 
> > arch/arm/kernel/entry-armv.S: Assembler messages:
> > arch/arm/kernel/entry-armv.S:803: Error: bad immediate value for offset (4096)
> > 
> > Only two constants in asm-offset.h are affected, and I'm changing
> > both of them here to work correctly in all configurations.
> > 
> > One more macro has the problem, but is currently unused, so this
> > removes it instead of adding complexity.
> > 
> > Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Fixes: c33d8b12fbbd ("task_struct: Allow randomized layout")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> > arch/arm/kernel/entry-armv.S |  5 ++++-
> > arch/arm/mm/proc-macros.S    | 10 ++++------
> > 2 files changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> > index 9f157e7c51e7..db6d22b23bd8 100644
> > --- a/arch/arm/kernel/entry-armv.S
> > +++ b/arch/arm/kernel/entry-armv.S
> > @@ -797,7 +797,10 @@ ENTRY(__switch_to)
> > #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
> >    ldr    r7, [r2, #TI_TASK]
> >    ldr    r8, =__stack_chk_guard
> > -    ldr    r7, [r7, #TSK_STACK_CANARY]
> > +    .if (TSK_STACK_CANARY > PAGE_MASK)
> 
> Shouldn't this be ~PAGE_MASK?
> 
> I think 
> 
> .if (TSK_STACK_CANARY & PAGE_MASK) != 0
> 
> is better and clearer as well

It's not really that much clearer - what has any of this got to do with
the size of a page?  Just because a definition appears to be numerically
the same, it doesn't mean it should be used!

The LDR instruction takes a maximum of a 12-bit constant.  This 12-bit
constant has nothing to do with the page size; it's been that way since
the early ARMs that knew nothing about page tables.

Please instead create a LDR_IMM12_MASK or similar definition for this.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
