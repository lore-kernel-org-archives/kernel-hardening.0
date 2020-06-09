Return-Path: <SRS0=24z3=7W=lists.openwall.com=kernel-hardening-return-18937-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAD_ENC_HEADER,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C718CC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 04:39:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 19F842078C
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 04:39:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19F842078C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=informatik.wtf
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18937-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20472 invoked by uid 550); 9 Jun 2020 04:39:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20437 invoked from network); 9 Jun 2020 04:39:01 -0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Originaldate: Wed Jun 3, 2020 at 9:14 AM
Originalfrom: "Christophe Leroy" <christophe.leroy@csgroup.eu>
Original: =?utf-8?q?=0D=0A=0D=0ALe_03/06/2020_
 =C3=A0_07:19,_Christopher_M._Riedl_a_?= =?utf-8?q?=C3=A9crit=C2=A0:
 =0D=0A>_When_live_patching_a_STRICT=5FRWX_kern?=
 =?utf-8?q?el,_a_mapping_is_installed_at_a=0D=0A>_"patching_address"_with_?=
 =?utf-8?q?temporary_write_permissions._Provide_a=0D=0A>_LKDTM-only_access?=
 =?utf-8?q?or_function_for_this_address_in_preparation_for_a_LKDTM=0D=0A>_?=
 =?utf-8?q?test_which_attempts_to_"hijack"_this_mapping_by_writing_to_it_f?=
 =?utf-8?q?rom=0D=0A>_another_CPU.=0D=0A>_=0D=0A>_Signed-off-by:_Christoph?=
 =?utf-8?q?er_M._Riedl_<cmr@informatik.wtf>=0D=0A>_---=0D=0A>___arch/power?=
 =?utf-8?q?pc/lib/code-patching.c_|_7_+++++++=0D=0A>___1_file_changed,_7_i?=
 =?utf-8?q?nsertions(+)=0D=0A>_=0D=0A>_diff_--git_a/arch/powerpc/lib/code-?=
 =?utf-8?q?patching.c_b/arch/powerpc/lib/code-patching.c=0D=0A>_index_df07?=
 =?utf-8?q?65845204..c23453049116_100644=0D=0A>_---_a/arch/powerpc/lib/cod?=
 =?utf-8?q?e-patching.c=0D=0A>_+++_b/arch/powerpc/lib/code-patching.c=0D?=
 =?utf-8?q?=0A>_@@_-52,6_+52,13_@@_int_raw=5Fpatch=5Finstruction(struct_pp?=
 =?utf-8?q?c=5Finst_*addr,_struct_ppc=5Finst_instr)=0D=0A>___static_struct?=
 =?utf-8?q?_mm=5Fstruct_*patching=5Fmm_=5F=5Fro=5Fafter=5Finit;=0D=0A>___s?=
 =?utf-8?q?tatic_unsigned_long_patching=5Faddr_=5F=5Fro=5Fafter=5Finit;=0D?=
 =?utf-8?q?=0A>___=0D=0A>_+#ifdef_CONFIG=5FLKDTM=0D=0A>_+unsigned_long_rea?=
 =?utf-8?q?d=5Fcpu=5Fpatching=5Faddr(unsigned_int_cpu)=0D=0A=0D=0AIf_this_?=
 =?utf-8?q?fonction_is_not_static,_it_means_it_is_intended_to_be_used_from?=
 =?utf-8?q?_=0D=0Asome_other_C_file,_so_it_should_be_declared_in_a_.h_too.?=
 =?utf-8?q?=0D=0A=0D=0AChristophe=0D=0A=0D=0A>_+{=0D=0A>_+=09return_patchi?=
 =?utf-8?q?ng=5Faddr;=0D=0A>_+}=0D=0A>_+#endif=0D=0A>_+=0D=0A>___void_=5F?=
 =?utf-8?q?=5Finit_poking=5Finit(void)=0D=0A>___{=0D=0A>___=09spinlock=5Ft?=
 =?utf-8?q?_*ptl;_/*_for_protecting_pte_table_*/=0D=0A>_=0D=0A?=
In-Reply-To: <a458667c-fb8d-a01f-130b-0fef733dd001@csgroup.eu>
Date: Mon, 08 Jun 2020 23:40:41 -0500
Subject: Re: [PATCH 4/5] powerpc/lib: Add LKDTM accessor for patching addr
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 <linuxppc-dev@lists.ozlabs.org>, <kernel-hardening@lists.openwall.com>
Message-Id: <C3CAMU7CT62Z.1A5IZ7HO4BF80@geist>
X-Virus-Scanned: ClamAV using ClamSMTP

On Wed Jun 3, 2020 at 9:14 AM, Christophe Leroy wrote:
>
>=20
>
>=20
> Le 03/06/2020 =C3=A0 07:19, Christopher M. Riedl a =C3=A9crit :
> > When live patching a STRICT_RWX kernel, a mapping is installed at a
> > "patching address" with temporary write permissions. Provide a
> > LKDTM-only accessor function for this address in preparation for a LKDT=
M
> > test which attempts to "hijack" this mapping by writing to it from
> > another CPU.
> >=20
> > Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
> > ---
> >   arch/powerpc/lib/code-patching.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >=20
> > diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-p=
atching.c
> > index df0765845204..c23453049116 100644
> > --- a/arch/powerpc/lib/code-patching.c
> > +++ b/arch/powerpc/lib/code-patching.c
> > @@ -52,6 +52,13 @@ int raw_patch_instruction(struct ppc_inst *addr, str=
uct ppc_inst instr)
> >   static struct mm_struct *patching_mm __ro_after_init;
> >   static unsigned long patching_addr __ro_after_init;
> >  =20
> > +#ifdef CONFIG_LKDTM
> > +unsigned long read_cpu_patching_addr(unsigned int cpu)
>
>=20
> If this fonction is not static, it means it is intended to be used from
> some other C file, so it should be declared in a .h too.
>
Yup agreed. This was left-over from the RFC to simplify using the LKDTM
test on a tree without this series. Will fix this in the next spin.
>=20
> Christophe
>
>=20
> > +{
> > +	return patching_addr;
> > +}
> > +#endif
> > +
> >   void __init poking_init(void)
> >   {
> >   	spinlock_t *ptl; /* for protecting pte table */
> >=20
>
>=20
>
>=20

