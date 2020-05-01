Return-Path: <SRS0=ToVV=6P=lists.openwall.com=kernel-hardening-return-18702-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAD_ENC_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C2DC35280
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 May 2020 20:45:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D14E9208DB
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 May 2020 20:45:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D14E9208DB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18702-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7373 invoked by uid 550); 1 May 2020 20:45:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7338 invoked from network); 1 May 2020 20:45:09 -0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Originaldate: Wed Apr 29, 2020 at 7:48 AM
Originalfrom: "Christophe Leroy" <christophe.leroy@c-s.fr>
Original: =?utf-8?q?=0D=0A=0D=0ALe_29/04/2020_
 =C3=A0_04:05,_Christopher_M._Riedl_a_?= =?utf-8?q?=C3=A9crit=C2=A0:
 =0D=0A>_x86_supports_the_notion_of_a_temporary?=
 =?utf-8?q?_mm_which_restricts_access_to=0D=0A>_temporary_PTEs_to_a_single?=
 =?utf-8?q?_CPU._A_temporary_mm_is_useful_for_situations=0D=0A>_where_a_CP?=
 =?utf-8?q?U_needs_to_perform_sensitive_operations_(such_as_patching_a=0D?=
 =?utf-8?q?=0A>_STRICT=5FKERNEL=5FRWX_kernel)_requiring_temporary_mappings?=
 =?utf-8?q?_without_exposing=0D=0A>_said_mappings_to_other_CPUs._A_side_be?=
 =?utf-8?q?nefit_is_that_other_CPU_TLBs_do=0D=0A>_not_need_to_be_flushed_w?=
 =?utf-8?q?hen_the_temporary_mm_is_torn_down.=0D=0A>_=0D=0A>_Mappings_in_t?=
 =?utf-8?q?he_temporary_mm_can_be_set_in_the_userspace_portion_of_the=0D?=
 =?utf-8?q?=0A>_address-space.=0D=0A>_=0D=0A>_Interrupts_must_be_disabled_?=
 =?utf-8?q?while_the_temporary_mm_is_in_use._HW=0D=0A>_breakpoints,_which_?=
 =?utf-8?q?may_have_been_set_by_userspace_as_watchpoints_on=0D=0A>_address?=
 =?utf-8?q?es_now_within_the_temporary_mm,_are_saved_and_disabled_when=0D?=
 =?utf-8?q?=0A>_loading_the_temporary_mm._The_HW_breakpoints_are_restored_?=
 =?utf-8?q?when_unloading=0D=0A>_the_temporary_mm._All_HW_breakpoints_are_?=
 =?utf-8?q?indiscriminately_disabled_while=0D=0A>_the_temporary_mm_is_in_u?=
 =?utf-8?q?se.=0D=0A=0D=0AWhy_do_we_need_to_use_a_temporary_mm_all_the_tim?=
 =?utf-8?q?e_=3F=0D=0A=0D=0ADoesn't_each_CPU_have_its_own_mm_already_=3F_O?=
 =?utf-8?q?nly_the_upper_address_space_=0D=0Ais_shared_between_all_mm's_bu?=
 =?utf-8?q?t_each_mm_has_its_own_lower_address_space,_=0D=0Aat_least_when_?=
 =?utf-8?q?it_is_running_a_user_process._Why_not_just_use_that_mm_=3F_=0D?=
 =?utf-8?q?=0AAs_we_are_mapping_then_unmapping_with_interrupts_disabled,_t?=
 =?utf-8?q?here_is_no_=0D=0Arisk_at_all_that_the_user_starts_running_while?=
 =?utf-8?q?_the_patch_page_is_mapped,_=0D=0Aso_I'm_not_sure_why_switching_?=
 =?utf-8?q?to_a_temporary_mm_is_needed.=0D=0A=0D=0A=0D=0A>_=0D=0A>_Based_o?=
 =?utf-8?q?n_x86_implementation:=0D=0A>_=0D=0A>_commit_cefa929c034e=0D=0A>?=
 =?utf-8?q?_("x86/mm:_Introduce_temporary_mm_structs")=0D=0A>_=0D=0A>_Sign?=
 =?utf-8?q?ed-off-by:_Christopher_M._Riedl_<cmr@informatik.wtf>=0D=0A=0D?=
 =?utf-8?q?=0AChristophe=0D=0A?=
In-Reply-To: <d481ec66-8e14-614f-8e33-d381ce606bc5@c-s.fr>
Date: Fri, 01 May 2020 15:46:23 -0500
Subject: Re: [RFC PATCH v2 1/5] powerpc/mm: Introduce temporary mm
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: "Christophe Leroy" <christophe.leroy@c-s.fr>,
 <linuxppc-dev@lists.ozlabs.org>, <kernel-hardening@lists.openwall.com>
Message-Id: <C2FOQZG5ODV4.1I6MYZDG9N0ZE@geist>
X-Virus-Scanned: ClamAV using ClamSMTP

On Wed Apr 29, 2020 at 7:48 AM, Christophe Leroy wrote:
>
>=20
>
>=20
> Le 29/04/2020 =C3=A0 04:05, Christopher M. Riedl a =C3=A9crit :
> > x86 supports the notion of a temporary mm which restricts access to
> > temporary PTEs to a single CPU. A temporary mm is useful for situations
> > where a CPU needs to perform sensitive operations (such as patching a
> > STRICT_KERNEL_RWX kernel) requiring temporary mappings without exposing
> > said mappings to other CPUs. A side benefit is that other CPU TLBs do
> > not need to be flushed when the temporary mm is torn down.
> >=20
> > Mappings in the temporary mm can be set in the userspace portion of the
> > address-space.
> >=20
> > Interrupts must be disabled while the temporary mm is in use. HW
> > breakpoints, which may have been set by userspace as watchpoints on
> > addresses now within the temporary mm, are saved and disabled when
> > loading the temporary mm. The HW breakpoints are restored when unloadin=
g
> > the temporary mm. All HW breakpoints are indiscriminately disabled whil=
e
> > the temporary mm is in use.
>
>=20
> Why do we need to use a temporary mm all the time ?
>

Not sure I understand, the temporary mm is only in use for kernel
patching in this series. We could have other uses in the future maybe
where it's beneficial to keep mappings local.

>=20
> Doesn't each CPU have its own mm already ? Only the upper address space
> is shared between all mm's but each mm has its own lower address space,
> at least when it is running a user process. Why not just use that mm ?
> As we are mapping then unmapping with interrupts disabled, there is no
> risk at all that the user starts running while the patch page is mapped,
> so I'm not sure why switching to a temporary mm is needed.
>
>=20

I suppose that's an option, but then we have to save and restore the
mapping which we temporarily "steal" from userspace. I admit I didn't
consider that as an option when I started this series based on the x86
patches. I think it's cleaner to switch mm, but that's a rather weak
argument. Are you concerned about performance with the temporary mm?

>
>=20
> >=20
> > Based on x86 implementation:
> >=20
> > commit cefa929c034e
> > ("x86/mm: Introduce temporary mm structs")
> >=20
> > Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
>
>=20
> Christophe
>
>=20
>
>=20

