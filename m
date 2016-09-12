Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Sep 2016 10:32:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160912093249.GA2492@e104818-lin.cambridge.arm.com>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <1472828533-28197-4-git-send-email-catalin.marinas@arm.com>
 <20160905172038.GC27305@leverpostej>
 <20160906102741.GF19605@e104818-lin.cambridge.arm.com>
 <20160906104514.GC1425@leverpostej>
 <CAKv+Gu8GMU=Lgh4awFLda-7K=orpg03D18kPDVVQEP6KzB5++g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8GMU=Lgh4awFLda-7K=orpg03D18kPDVVQEP6KzB5++g@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v2 3/7] arm64: Introduce
 uaccess_{disable, enable} functionality based on TTBR0_EL1
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Sep 11, 2016 at 02:55:12PM +0100, Ard Biesheuvel wrote:
> On 6 September 2016 at 11:45, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Tue, Sep 06, 2016 at 11:27:42AM +0100, Catalin Marinas wrote:
> >> On Mon, Sep 05, 2016 at 06:20:38PM +0100, Mark Rutland wrote:
> >> > On Fri, Sep 02, 2016 at 04:02:09PM +0100, Catalin Marinas wrote:
> >> > >    * tables again to remove any speculatively loaded cache lines.
> >> > >    */
> >> > >   mov     x0, x25
> >> > > - add     x1, x26, #SWAPPER_DIR_SIZE
> >> > > + add     x1, x26, #SWAPPER_DIR_SIZE + RESERVED_TTBR0_SIZE
> >> > >   dmb     sy
> >> > >   bl      __inval_cache_range
> >> > >
> >> > > diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> >> > > index 659963d40bb4..fe393ccf9352 100644
> >> > > --- a/arch/arm64/kernel/vmlinux.lds.S
> >> > > +++ b/arch/arm64/kernel/vmlinux.lds.S
> >> > > @@ -196,6 +196,11 @@ SECTIONS
> >> > >   swapper_pg_dir = .;
> >> > >   . += SWAPPER_DIR_SIZE;
> >> > >
> >> > > +#ifdef CONFIG_ARM64_TTBR0_PAN
> >> > > + reserved_ttbr0 = .;
> >> > > + . += PAGE_SIZE;
> >> > > +#endif
> >> >
> >> > Surely RESERVED_TTBR0_SIZE, as elsewhere?
> >>
> >> I'll try to move it somewhere where it can be included in vmlinux.lds.S
> >> (I can probably include cpufeature.h directly).
> 
> Do we really need another zero page? The ordinary zero page is already
> statically allocated these days, so we could simply move it between
> idmap_pg_dir[] and swapper_pg_dir[], and get all the changes in the
> early boot code for free (given that it covers the range between the
> start of idmap_pg_dir[] and the end of swapper_pg_dir[])
> 
> That way, we could refer to __pa(empty_zero_page) anywhere by reading
> ttbr1_el1 and subtracting PAGE_SIZE

That's fine by me. I'll cherry-pick your patch and rebase this series on
top.

-- 
Catalin
