Date: Fri, 22 Jun 2018 16:15:11 +0800
From: Jun Yao <yaojun8558363@gmail.com>
Subject: Re: [PATCH 1/1] arm64/mm: move
 {idmap_pg_dir,tramp_pg_dir,swapper_pg_dir} to .rodata section
Message-ID: <20180622081511.GA11076@toy>
References: <20180620085755.20045-1-yaojun8558363@gmail.com>
 <20180620085755.20045-2-yaojun8558363@gmail.com>
 <CAKv+Gu8_=uTJFDXr0GpGMc=9WZ9tbz305CE6i=qbnqRB=suRVA@mail.gmail.com>
 <20180621025141.GB11276@toy>
 <CAKv+Gu_3Cfuq-qQuRHkYCB2uTPOK=KVeVh4OKmtu2MDYwfOtTA@mail.gmail.com>
 <70ebe6d7-0745-5606-ae89-8a7b2fb62008@arm.com>
 <CAKv+Gu-t5ErL89J=sxeVRYzDNrB1Ejdj+XOggAMWk-gY7ewsOg@mail.gmail.com>
 <67a238a8-e4db-6bf1-6da5-62ca9536191f@arm.com>
 <CAKv+Gu8=jxY0qfMk53L8p5+x8HoE1DRy7W_p42ji9omGBc6QSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8=jxY0qfMk53L8p5+x8HoE1DRy7W_p42ji9omGBc6QSA@mail.gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Ard,

On Thu, Jun 21, 2018 at 07:27:01PM +0200, Ard Biesheuvel wrote:
> On 21 June 2018 at 19:04, James Morse <james.morse@arm.com> wrote:
> > On 21/06/18 10:29, Ard Biesheuvel wrote:
> >> On 21 June 2018 at 10:59, James Morse <james.morse@arm.com> wrote:
> >>> On 21/06/18 07:39, Ard Biesheuvel wrote:
> >>>> On 21 June 2018 at 04:51, Jun Yao <yaojun8558363@gmail.com> wrote:
> >>>>> On Wed, Jun 20, 2018 at 12:09:49PM +0200, Ard Biesheuvel wrote:
> >>>>>> As for swapper_pg_dir, it would indeed be nice if we could keep those
> >>>>>> mappings read-only most of the time, but I'm not sure how useful this
> >>>>>> is if we apply it to the root level only.
> >>>>>
> >>>>> The purpose of it is to make 'KSMA' harder, where an single arbitrary
> >>>>> write is used to add a block mapping to the page-tables, giving the
> >>>>> attacker full access to kernel memory. That's why we just apply it to
> >>>>> the root level only. If the attacker can arbitrary write multiple times,
> >>>>> I think it's hard to defend.
> >>>>
> >>>> So the assumption is that the root level is more easy to find?
> >>>> Otherwise, I'm not sure I understand why being able to write a level 0
> >>>> entry is so harmful, given that we don't have block mappings at that
> >>>> level.
> >>>
> >>> I think this thing assumes 3-level page tables with 39bit VA.
> >
> >> The attack, you mean? Because this code is unlikely to build with that
> >> configuration, given that __pgd_populate() BUILD_BUG()s in that case.
> >
> > Yes, the attack. (I struggle to think of it as an 'attack' because you already
> > have arbitrary write...)
> >
> 
> OK, so in that case, you can abuse your single arbitrary write to map
> an entire 1 GB block of memory with arbitrary permissions, allowing
> userland to take control of the contents, right? And if you know the
> virtual and physical addresses of swapper_pg_dir, you can make sure
> this block covers the entire kernel, allowing the attacker to
> manipulate all core kernel code and statically allocated data
> structures.
> 
> What I don't understand about this patch is how it is sufficient to
> only remap swapper_pg_dir r/w for updates on kernels that use 4 level
> paging.
> 

Sorry, It's my mistake.

To my best knowledge, to defend 'KSMA', we need to handle these
configurations:

1. ARM64_4K_PAGES && ARM64_VA_BITS_39 (PGTABLE_LEVELS = 3, 1GB block)
2. ARM64_16K_PAGES && ARM64_VA_BITS_36 (PGTABLE_LEVELS = 2, 32MB block)
3. ARM64_64K_PAGES && ARM64_VA_BITS_42 (PGTABLE_LEVELS = 2, 512MB block)

If these configurations are selected, we move {idmap_pg_dir,
tramp_pg_dir, reserved_ttbr0, swapper_pg_dir} to .rodata section(avoid
modifying tramp_(un)map_kernel), and remap swapper_pg_dir r/w for updates.
If these configurations are not selected, we just keep them as they are.

Do you think this is okay?
