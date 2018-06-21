Date: Thu, 21 Jun 2018 20:24:36 +0800
From: Jun Yao <yaojun8558363@gmail.com>
Subject: Re: [PATCH 1/1] arm64/mm: move
 {idmap_pg_dir,tramp_pg_dir,swapper_pg_dir} to .rodata section
Message-ID: <20180621122436.GA19014@toy>
References: <20180620085755.20045-1-yaojun8558363@gmail.com>
 <20180620085755.20045-2-yaojun8558363@gmail.com>
 <CAKv+Gu8_=uTJFDXr0GpGMc=9WZ9tbz305CE6i=qbnqRB=suRVA@mail.gmail.com>
 <20180621025141.GB11276@toy>
 <CAKv+Gu_3Cfuq-qQuRHkYCB2uTPOK=KVeVh4OKmtu2MDYwfOtTA@mail.gmail.com>
 <70ebe6d7-0745-5606-ae89-8a7b2fb62008@arm.com>
 <CAKv+Gu-t5ErL89J=sxeVRYzDNrB1Ejdj+XOggAMWk-gY7ewsOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-t5ErL89J=sxeVRYzDNrB1Ejdj+XOggAMWk-gY7ewsOg@mail.gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 21, 2018 at 11:29:52AM +0200, Ard Biesheuvel wrote:
> On 21 June 2018 at 10:59, James Morse <james.morse@arm.com> wrote:
> > On 21/06/18 07:39, Ard Biesheuvel wrote:
> >> On 21 June 2018 at 04:51, Jun Yao <yaojun8558363@gmail.com> wrote:
> >>> On Wed, Jun 20, 2018 at 12:09:49PM +0200, Ard Biesheuvel wrote:
> >>>> On 20 June 2018 at 10:57, Jun Yao <yaojun8558363@gmail.com> wrote:
> >>>> As for swapper_pg_dir, it would indeed be nice if we could keep those
> >>>> mappings read-only most of the time, but I'm not sure how useful this
> >>>> is if we apply it to the root level only.
> >>>
> >>> The purpose of it is to make 'KSMA' harder, where an single arbitrary
> >>> write is used to add a block mapping to the page-tables, giving the
> >>> attacker full access to kernel memory. That's why we just apply it to
> >>> the root level only. If the attacker can arbitrary write multiple times,
> >>> I think it's hard to defend.
> >>>
> >>
> >> So the assumption is that the root level is more easy to find?
> >> Otherwise, I'm not sure I understand why being able to write a level 0
> >> entry is so harmful, given that we don't have block mappings at that
> >> level.
> >
> > I think this thing assumes 3-level page tables with 39bit VA.
> >
> 
> The attack, you mean? Because this code is unlikely to build with that
> configuration, given that __pgd_populate() BUILD_BUG()s in that case.

I think this configuration may be ok. I find that the kernel on Google
pixel 2 XL is built with 3-level page tables with 39-bit VA.
