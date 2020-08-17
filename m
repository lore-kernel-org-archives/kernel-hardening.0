Return-Path: <SRS0=vFsl=B3=lists.openwall.com=kernel-hardening-return-19639-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56E1C433EA
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 03:05:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1FFC720885
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 03:05:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FFC720885
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19639-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9281 invoked by uid 550); 17 Aug 2020 03:05:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9247 invoked from network); 17 Aug 2020 03:05:15 -0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc: <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v2 2/5] powerpc/lib: Initialize a temporary mm for code
 patching
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: "Daniel Axtens" <dja@axtens.net>, <linuxppc-dev@lists.ozlabs.org>
Date: Sun, 16 Aug 2020 21:21:02 -0500
Message-Id: <C4YWVI0APTMX.XJ5Z6LWTLBO6@geist>
In-Reply-To: <87lfiso3rk.fsf@dja-thinkpad.axtens.net>
X-Virus-Scanned: ClamAV using ClamSMTP

On Thu Aug 6, 2020 at 8:24 AM CDT, Daniel Axtens wrote:
> "Christopher M. Riedl" <cmr@informatik.wtf> writes:
>
> > When code patching a STRICT_KERNEL_RWX kernel the page containing the
> > address to be patched is temporarily mapped with permissive memory
> > protections. Currently, a per-cpu vmalloc patch area is used for this
> > purpose. While the patch area is per-cpu, the temporary page mapping is
> > inserted into the kernel page tables for the duration of the patching.
> > The mapping is exposed to CPUs other than the patching CPU - this is
> > undesirable from a hardening perspective.
> >
> > Use the `poking_init` init hook to prepare a temporary mm and patching
> > address. Initialize the temporary mm by copying the init mm. Choose a
> > randomized patching address inside the temporary mm userspace address
> > portion. The next patch uses the temporary mm and patching address for
> > code patching.
> >
> > Based on x86 implementation:
> >
> > commit 4fc19708b165
> > ("x86/alternatives: Initialize temporary mm for patching")
> >
> > Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
> > ---
> >  arch/powerpc/lib/code-patching.c | 33 ++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> > diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-p=
atching.c
> > index 0a051dfeb177..8ae1a9e5fe6e 100644
> > --- a/arch/powerpc/lib/code-patching.c
> > +++ b/arch/powerpc/lib/code-patching.c
> > @@ -11,6 +11,8 @@
> >  #include <linux/cpuhotplug.h>
> >  #include <linux/slab.h>
> >  #include <linux/uaccess.h>
> > +#include <linux/sched/task.h>
> > +#include <linux/random.h>
> > =20
> >  #include <asm/tlbflush.h>
> >  #include <asm/page.h>
> > @@ -44,6 +46,37 @@ int raw_patch_instruction(struct ppc_inst *addr, str=
uct ppc_inst instr)
> >  }
> > =20
> >  #ifdef CONFIG_STRICT_KERNEL_RWX
> > +
> > +static struct mm_struct *patching_mm __ro_after_init;
> > +static unsigned long patching_addr __ro_after_init;
> > +
> > +void __init poking_init(void)
> > +{
> > +	spinlock_t *ptl; /* for protecting pte table */
> > +	pte_t *ptep;
> > +
> > +	/*
> > +	 * Some parts of the kernel (static keys for example) depend on
> > +	 * successful code patching. Code patching under STRICT_KERNEL_RWX
> > +	 * requires this setup - otherwise we cannot patch at all. We use
> > +	 * BUG_ON() here and later since an early failure is preferred to
> > +	 * buggy behavior and/or strange crashes later.
> > +	 */
> > +	patching_mm =3D copy_init_mm();
> > +	BUG_ON(!patching_mm);
> > +
> > +	/*
> > +	 * In hash we cannot go above DEFAULT_MAP_WINDOW easily.
> > +	 * XXX: Do we want additional bits of entropy for radix?
> > +	 */
> > +	patching_addr =3D (get_random_long() & PAGE_MASK) %
> > +		(DEFAULT_MAP_WINDOW - PAGE_SIZE);
>
> It took me a while to understand this calculation. I see that it's
> calculating a base address for a page in which to do patching. It does
> the following:

I will add a comment explaining the calulcation in the next spin.

>
> - get a random long
>
> - mask with PAGE_MASK so as to get a page aligned value
>
> - make sure that the base address is at least one PAGE_SIZE below
> DEFAULT_MAP_WINDOW so we have a clear page between the base and
> DEFAULT_MAP_WINDOW.
>
> On 64-bit Book3S with 64K pages, that works out to be
>
> PAGE_SIZE =3D 0x0000 0000 0001 0000
> PAGE_MASK =3D 0xFFFF FFFF FFFF 0000
>
> DEFAULT_MAP_WINDOW =3D DEFAULT_MAP_WINDOW_USER64 =3D TASK_SIZE_128TB
> =3D 0x0000_8000_0000_0000
>
> DEFAULT_MAP_WINDOW - PAGE_SIZE =3D 0x0000 7FFF FFFF 0000
>
> It took a while (and a conversation with my wife who studied pure
> maths!) but I am convinced that the modulo preserves the page-alignement
> of the patching address.

I am glad a proper mathematician agrees because my maths are decidedly
unpure :)

>
> One thing I did realise is that patching_addr can be zero at the end of
> this process. That seems dubious and slightly error-prone to me - is
> the patching process robust to that or should we exclude it?

Good catch! I will fix this in the next spin.

>
> Anyway, if I have the maths right, that there are 0x7fffffff or ~2
> billion possible locations for the patching page, which is just shy of
> 31 bits of entropy.
>
> I think this compares pretty favourably to most (K)ASLR implementations?

I will stress that I am not an expert here, but it looks like this does
compares favorably against other 64b ASLR [0].

[0]: https://www.cs.ucdavis.edu/~peisert/research/2017-SecDev-AnalysisASLR.=
pdf

>
> What's the range if built with 4k pages?

Using the formula from my series coverletter, we should expect 34 bits
of entropy since DEFAULT_MAP_WINDOW_USER64 is 64TB for 4K pages:

	bits of entropy =3D log2(DEFAULT_MAP_WINDOW_USER64 / PAGE_SIZE)

	PAGE_SIZE=3D4K, DEFAULT_MAP_WINDOW_USER64=3D64TB
	bits of entropy =3D log2(64TB / 4K)
	bits of entropy =3D 34

>
> Kind regards,
> Daniel
>
> > +
> > +	ptep =3D get_locked_pte(patching_mm, patching_addr, &ptl);
> > +	BUG_ON(!ptep);
> > +	pte_unmap_unlock(ptep, ptl);
> > +}
> > +
> >  static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);
> > =20
> >  static int text_area_cpu_up(unsigned int cpu)
> > --=20
> > 2.27.0

