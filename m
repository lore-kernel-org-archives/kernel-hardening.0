Return-Path: <SRS0=GiFT=CQ=lists.openwall.com=kernel-hardening-return-19795-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DA5C43461
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Sep 2020 07:01:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1357D21775
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Sep 2020 07:01:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1357D21775
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codefail.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19795-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7576 invoked by uid 550); 7 Sep 2020 07:01:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3570 invoked from network); 7 Sep 2020 01:13:10 -0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc: <linuxppc-dev@lists.ozlabs.org>, "Kernel Hardening"
 <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 4/6] powerpc: Introduce temporary mm
From: "Christopher M. Riedl" <cmr@codefail.de>
To: "Jann Horn" <jannh@google.com>
Date: Sun, 06 Sep 2020 19:15:02 -0500
Message-Id: <C5GPCGQNRBQ2.8LRBQFQQ8QRK@geist>
In-Reply-To: <CAG48ez1W7FcDPAnqQ7TpSnKy--vaQm_f5prsZXRxcybzGg0tpg@mail.gmail.com>
X-Virus-Scanned: ClamAV using ClamSMTP
X-Originating-IP: 198.54.122.47
X-SpamExperts-Domain: o3.privateemail.com
X-SpamExperts-Username: out-03
Authentication-Results: registrar-servers.com; auth=pass (plain) smtp.auth=out-03@o3.privateemail.com
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.02)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0VKALJWqpbz84ezJUOplsTqpSDasLI4SayDByyq9LIhVViWPu4qwxrHG
 on7QCRBH60TNWdUk1Ol2OGx3IfrIJKyP9eGNFz9TW9u+Jt8z2T3K0kAEPCk9rIF2PFRPd9oD/+mU
 epBsntXvmzMKp70qHIVy06HjBCNevvMk3/tz3RhKppPDurF249hEi/hXuZV0Bfydg2dPJIOdvML0
 pmuMjL+sSRVE/Yi9caFO9s+hJUIag7Mr+LdmEPMuzjcDLgIpUp4KqOh03z3Jnl1IbrFC3WxWd62Q
 4tf7w1n56gL5R3iTitzRVjQKpyyasW/cnw+IYZ3P7SXZfF/PMa7BKaW4aUHy0JCEIEBpwRrTof3G
 nw4dOSMe/wvVcKjx/+UKUJ2dAQHXl4wgwTqJlTT/fetzilMGV02hzj+6Clu59u5sr7HikapUBPW9
 YV4SESdWyVtFdVGH7sydZvDt9c5R0PA8ODZs3zuom9668jgWRpPOjHntXKEKMgzNLgjKsVkPoQlW
 r+vjEfTaJe0WbjDSwI4VsDh/Ak5UMKR5Jabn4uqWeMpVV+j5NTNoBBmpJESzDIAZD+ijHBtexFH6
 /O9QemIWoIxJHU2xvEqMW59RROlnpVhs3WYdNxMU6g6rgAqTbJg65XJ7Wcw/vHrkNz0yR/nxmRhz
 HDeqqFz43py4SDhdaHkWfNr5H/lmx0CkCS1/c0I+vQBJgDK7W7IEgz6hLB4NE7r4xc7DI5pUcvgC
 2qkeP00Sk+1FWQ+vJ8qzoMDtBircbZyj4Vr2fJau/pSKTnHZpmzev7R5gLj25cxY39MfuDbvaQ11
 y3lWUHxy16UznfzqmjgtcanFiK6d7wZEdGX/n8cTMXL2ASzO2/x/FXAqsRfgwBXfs6ClNsb8ml4Z
 rgPQJkxUuqZsyTFf9tJdo1NX/ThvA3QEKTMFvUWB5kl7tpOKiZ05cqMnXxzdxIfkHhcHe2JzRhXU
 TdwrTzwY0h5CMWU4m+NxLqLodZwv2BZA26yO5xS/zVfrqzZpLvpYwP30rKEsmgNU80KTDQcWwe0S
 4mBBUkQTxmW44eWEf55rQAvvoiIOeoh24KMUdfqAzhfhkHj0OOJajA6cq8jxoXiPMC6r+737L3jx
 JfXzftJwbfbaqDNKToL2xQmqr15vNQO8SQ==
X-Report-Abuse-To: spam@se5.registrar-servers.com

On Thu Aug 27, 2020 at 11:15 AM CDT, Jann Horn wrote:
> On Thu, Aug 27, 2020 at 7:24 AM Christopher M. Riedl <cmr@codefail.de>
> wrote:
> > x86 supports the notion of a temporary mm which restricts access to
> > temporary PTEs to a single CPU. A temporary mm is useful for situations
> > where a CPU needs to perform sensitive operations (such as patching a
> > STRICT_KERNEL_RWX kernel) requiring temporary mappings without exposing
> > said mappings to other CPUs. A side benefit is that other CPU TLBs do
> > not need to be flushed when the temporary mm is torn down.
> >
> > Mappings in the temporary mm can be set in the userspace portion of the
> > address-space.
> [...]
> > diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-p=
atching.c
> [...]
> > @@ -44,6 +45,70 @@ int raw_patch_instruction(struct ppc_inst *addr, str=
uct ppc_inst instr)
> >  }
> >
> >  #ifdef CONFIG_STRICT_KERNEL_RWX
> > +
> > +struct temp_mm {
> > +       struct mm_struct *temp;
> > +       struct mm_struct *prev;
> > +       bool is_kernel_thread;
> > +       struct arch_hw_breakpoint brk[HBP_NUM_MAX];
> > +};
> > +
> > +static inline void init_temp_mm(struct temp_mm *temp_mm, struct mm_str=
uct *mm)
> > +{
> > +       temp_mm->temp =3D mm;
> > +       temp_mm->prev =3D NULL;
> > +       temp_mm->is_kernel_thread =3D false;
> > +       memset(&temp_mm->brk, 0, sizeof(temp_mm->brk));
> > +}
> > +
> > +static inline void use_temporary_mm(struct temp_mm *temp_mm)
> > +{
> > +       lockdep_assert_irqs_disabled();
> > +
> > +       temp_mm->is_kernel_thread =3D current->mm =3D=3D NULL;
>
> (That's a somewhat misleading variable name - kernel threads can have
> a non-NULL ->mm, too.)
>

Oh I didn't know that, in that case yes this is not a good name. I am
considering some changes (based on your comments about current->mm
below) which would make this variable superfluous.

> > +       if (temp_mm->is_kernel_thread)
> > +               temp_mm->prev =3D current->active_mm;
> > +       else
> > +               temp_mm->prev =3D current->mm;
>
> Why the branch? Shouldn't current->active_mm work in both cases?
>
>

Yes you are correct.

> > +       /*
> > +        * Hash requires a non-NULL current->mm to allocate a userspace=
 address
> > +        * when handling a page fault. Does not appear to hurt in Radix=
 either.
> > +        */
> > +       current->mm =3D temp_mm->temp;
>
> This looks dangerous to me. There are various places that attempt to
> find all userspace tasks that use a given mm by iterating through all
> tasks on the system and comparing each task's ->mm pointer to
> current's. Things like current_is_single_threaded() as part of various
> security checks, mm_update_next_owner(), zap_threads(), and so on. So
> if this is reachable from userspace task context (which I think it
> is?), I don't think we're allowed to switch out the ->mm pointer here.
>
>

Thanks for pointing this out! I took a step back and looked at this
again in more detail. The only reason for reassigning the ->mm pointer
is that when patching we need to hash the page and allocate an SLB=20
entry w/ the hash MMU. That codepath includes a check to ensure that
->mm is not NULL. Overwriting ->mm temporarily and restoring it is
pretty crappy in retrospect. I _think_ a better approach is to just call
the hashing and allocate SLB functions from `map_patch` directly - this
both removes the need to overwrite ->mm (since the functions take an mm
parameter) and it avoids taking two exceptions when doing the actual
patching.

This works fine on Power9 and a Power8 at least but needs some testing
on PPC32 before I can send a v4.

> > +       switch_mm_irqs_off(NULL, temp_mm->temp, current);
>
> switch_mm_irqs_off() calls switch_mmu_context(), which in the nohash
> implementation increments next->context.active and decrements
> prev->context.active if prev is non-NULL, right? So this would
> increase temp_mm->temp->context.active...
>
> > +       if (ppc_breakpoint_available()) {
> > +               struct arch_hw_breakpoint null_brk =3D {0};
> > +               int i =3D 0;
> > +
> > +               for (; i < nr_wp_slots(); ++i) {
> > +                       __get_breakpoint(i, &temp_mm->brk[i]);
> > +                       if (temp_mm->brk[i].type !=3D 0)
> > +                               __set_breakpoint(i, &null_brk);
> > +               }
> > +       }
> > +}
> > +
> > +static inline void unuse_temporary_mm(struct temp_mm *temp_mm)
> > +{
> > +       lockdep_assert_irqs_disabled();
> > +
> > +       if (temp_mm->is_kernel_thread)
> > +               current->mm =3D NULL;
> > +       else
> > +               current->mm =3D temp_mm->prev;
> > +       switch_mm_irqs_off(NULL, temp_mm->prev, current);
>
> ... whereas this would increase temp_mm->prev->context.active. As far
> as I can tell, that'll mean that both the original mm and the patching
> mm will have their .active counts permanently too high after
> use_temporary_mm()+unuse_temporary_mm()?
>

Yes you are correct. Hmm, I can't immediately recall why prev=3DNULL here,
and I can't find anything in the various powerpc
switch_mm_irqs_off/switch_mmu_context implementations that would break
by setting prev=3Dactual previous mm here. I will fix this for v4. Thanks!

> > +       if (ppc_breakpoint_available()) {
> > +               int i =3D 0;
> > +
> > +               for (; i < nr_wp_slots(); ++i)
> > +                       if (temp_mm->brk[i].type !=3D 0)
> > +                               __set_breakpoint(i, &temp_mm->brk[i]);
> > +       }
> > +}

