Return-Path: <SRS0=R3+6=B3=lists.openwall.com=kernel-hardening-return-19640-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01655C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 05:39:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 31028206FA
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 05:39:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31028206FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19640-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12040 invoked by uid 550); 17 Aug 2020 05:39:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12007 invoked from network); 17 Aug 2020 05:39:14 -0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc: <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v2 1/5] powerpc/mm: Introduce temporary mm
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: "Daniel Axtens" <dja@axtens.net>, <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 17 Aug 2020 00:16:32 -0500
Message-Id: <C4Z0LVCFINQP.21DBP0ZHGZQJ6@geist>
In-Reply-To: <87o8noo96l.fsf@dja-thinkpad.axtens.net>
X-Virus-Scanned: ClamAV using ClamSMTP

On Thu Aug 6, 2020 at 6:27 AM CDT, Daniel Axtens wrote:
> Hi Chris,
>  =20
> >  void __set_breakpoint(int nr, struct arch_hw_breakpoint *brk);
> > +void __get_breakpoint(int nr, struct arch_hw_breakpoint *brk);
> >  bool ppc_breakpoint_available(void);
> >  #ifdef CONFIG_PPC_ADV_DEBUG_REGS
> >  extern void do_send_trap(struct pt_regs *regs, unsigned long address,
> > diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/incl=
ude/asm/mmu_context.h
> > index 1a474f6b1992..9269c7c7b04e 100644
> > --- a/arch/powerpc/include/asm/mmu_context.h
> > +++ b/arch/powerpc/include/asm/mmu_context.h
> > @@ -10,6 +10,7 @@
> >  #include <asm/mmu.h>=09
> >  #include <asm/cputable.h>
> >  #include <asm/cputhreads.h>
> > +#include <asm/debug.h>
> > =20
> >  /*
> >   * Most if the context management is out of line
> > @@ -300,5 +301,68 @@ static inline int arch_dup_mmap(struct mm_struct *=
oldmm,
> >  	return 0;
> >  }
> > =20
> > +struct temp_mm {
> > +	struct mm_struct *temp;
> > +	struct mm_struct *prev;
> > +	bool is_kernel_thread;
> > +	struct arch_hw_breakpoint brk[HBP_NUM_MAX];
> > +};
>
> This is on the nitpicky end, but I wonder if this should be named
> temp_mm, or should be labelled something else to capture its broader
> purpose as a context for code patching? I'm thinking that a store of
> breakpoints is perhaps unusual in a memory-managment structure?
>
> I don't have a better suggestion off the top of my head and I'm happy
> for you to leave it, I just wanted to flag it as a possible way we could
> be clearer.

First of all thank you for the review!

I had actually planned to move all this code into lib/code-patching.c
directly (and it turns out that's what x86 ended up doing as well).

>
> > +
> > +static inline void init_temp_mm(struct temp_mm *temp_mm, struct mm_str=
uct *mm)
> > +{
> > +	temp_mm->temp =3D mm;
> > +	temp_mm->prev =3D NULL;
> > +	temp_mm->is_kernel_thread =3D false;
> > +	memset(&temp_mm->brk, 0, sizeof(temp_mm->brk));
> > +}
> > +
> > +static inline void use_temporary_mm(struct temp_mm *temp_mm)
> > +{
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	temp_mm->is_kernel_thread =3D current->mm =3D=3D NULL;
> > +	if (temp_mm->is_kernel_thread)
> > +		temp_mm->prev =3D current->active_mm;
>
> You don't seem to restore active_mm below. I don't know what active_mm
> does, so I don't know if this is a problem.

For kernel threads 'current->mm' is NULL since a kthread does not need
a userspace mm; however they still need a mm so they "borrow" one which
is indicated by 'current->active_mm'.

'current->mm' needs to be restored because Hash requires a non-NULL
value when handling a page fault and so 'current->mm' gets set to the
temp_mm. This is a special case for kernel threads and Hash translation.

>
> > +	else
> > +		temp_mm->prev =3D current->mm;
> > +
> > +	/*
> > +	 * Hash requires a non-NULL current->mm to allocate a userspace addre=
ss
> > +	 * when handling a page fault. Does not appear to hurt in Radix eithe=
r.
> > +	 */
> > +	current->mm =3D temp_mm->temp;
> > +	switch_mm_irqs_off(NULL, temp_mm->temp, current);
> > +
> > +	if (ppc_breakpoint_available()) {
>
> I wondered if this could be changed during a text-patching operation.
> AIUI, it potentially can on a P9 via "dawr_enable_dangerous" in debugfs.
>
> I don't know if that's a problem. My concern is that you could turn off
> breakpoints, call 'use_temporary_mm', then turn them back on again
> before 'unuse_temporary_mm' and get a breakpoint while that can access
> the temporary mm. Is there something else that makes that safe?
> disabling IRQs maybe?

Hmm, I will have to investigate this more. I'm not sure if there is a
better way to just completely disable breakpoints while the temporary mm
is in use.

>
> > +		struct arch_hw_breakpoint null_brk =3D {0};
> > +		int i =3D 0;
> > +
> > +		for (; i < nr_wp_slots(); ++i) {
>
> super nitpicky, and I'm not sure if this is actually documented, but I'd
> usually see this written as:
>
> for (i =3D 0; i < nr_wp_slots(); i++) {
>
> Not sure if there's any reason that it _shouldn't_ be written the way
> you've written it (and I do like initialising the variable when it's
> defined!), I'm just not used to it. (Likewise with the unuse function.)
>

I've found other places (even in arch/powerpc!) where this is done so I
think it's fine. I prefer using this style when the variable
declaration and initialization are "close" to the loop statement.

> > +			__get_breakpoint(i, &temp_mm->brk[i]);
> > +			if (temp_mm->brk[i].type !=3D 0)
> > +				__set_breakpoint(i, &null_brk);
> > +		}
> > +	}
> > +}
> > +
>
> Kind regards,
> Daniel
>
> > +static inline void unuse_temporary_mm(struct temp_mm *temp_mm)
> > +{
> > +	lockdep_assert_irqs_disabled();
> > +
> > +	if (temp_mm->is_kernel_thread)
> > +		current->mm =3D NULL;
> > +	else
> > +		current->mm =3D temp_mm->prev;
> > +	switch_mm_irqs_off(NULL, temp_mm->prev, current);
> > +
> > +	if (ppc_breakpoint_available()) {
> > +		int i =3D 0;
> > +
> > +		for (; i < nr_wp_slots(); ++i)
> > +			if (temp_mm->brk[i].type !=3D 0)
> > +				__set_breakpoint(i, &temp_mm->brk[i]);
> > +	}
> > +}
> > +
> >  #endif /* __KERNEL__ */
> >  #endif /* __ASM_POWERPC_MMU_CONTEXT_H */
> > diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/proces=
s.c
> > index 4650b9bb217f..b6c123bf5edd 100644
> > --- a/arch/powerpc/kernel/process.c
> > +++ b/arch/powerpc/kernel/process.c
> > @@ -824,6 +824,11 @@ static inline int set_breakpoint_8xx(struct arch_h=
w_breakpoint *brk)
> >  	return 0;
> >  }
> > =20
> > +void __get_breakpoint(int nr, struct arch_hw_breakpoint *brk)
> > +{
> > +	memcpy(brk, this_cpu_ptr(&current_brk[nr]), sizeof(*brk));
> > +}
> > +
> >  void __set_breakpoint(int nr, struct arch_hw_breakpoint *brk)
> >  {
> >  	memcpy(this_cpu_ptr(&current_brk[nr]), brk, sizeof(*brk));
> > --=20
> > 2.27.0

