MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8Zc7eQbG-Ww51GXUCEmhe2J03vbq5vVdyaKra-s13KrA@mail.gmail.com>
References: <20180530044806.18449-1-yaojun8558363@gmail.com>
 <20180530091457.GB2452@arm.com> <CAKv+Gu8Zc7eQbG-Ww51GXUCEmhe2J03vbq5vVdyaKra-s13KrA@mail.gmail.com>
From: =?UTF-8?B?5aea5L+K?= <yaojun8558363@gmail.com>
Date: Wed, 30 May 2018 18:20:51 +0800
Message-ID: <CAP=LAmLa+BMXae_hfGB33RLwa+-gM9TWak23WdsDz9EKB6zYMA@mail.gmail.com>
Subject: Re: [PATCH] arm64: mm: mark tramp_pg_dir read-only
Content-Type: multipart/alternative; boundary="0000000000008e6e43056d69b4d6"
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--0000000000008e6e43056d69b4d6
Content-Type: text/plain; charset="UTF-8"

>We'd need to create a separate segment for it initially so the mapping
>is already at the right granularity.

I think that I should to it like your patch, right?

 Subject:    [RFC PATCH 2/6] arm64/mm: create dedicated segment for pgdir
mappings
 From:       Ard Biesheuvel <ard.biesheuvel () linaro ! org>
 Date:       2018-03-19 11:19:54
 Message-ID: 20180319111958.4171-3-ard.biesheuvel () linaro ! org

+       . = ALIGN(SEGMENT_ALIGN);
+       __pgdir_segment_start = .;
#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
         tramp_pg_dir = .;
         . += PAGE_SIZE;
@@ -229,6 +231,7 @@ SECTIONS
         . += RESERVED_TTBR0_SIZE;
#endif
         swapper_pg_dir = .;
 +       __pgdir_segment_end = . + PAGE_SIZE;
         . += SWAPPER_DIR_SIZE;
         swapper_pg_end = .;

Thanks.

Jun


2018-05-30 17:53 GMT+08:00 Ard Biesheuvel <ard.biesheuvel@linaro.org>:

> On 30 May 2018 at 11:14, Will Deacon <will.deacon@arm.com> wrote:
> > On Wed, May 30, 2018 at 12:48:06PM +0800, YaoJun wrote:
> >> To protect against KSMA(Kernel Space Mirroring Attack), make
> >> tramp_pg_dir read-only. The principle of KSMA is to insert a
> >> carefully constructed PGD entry into the translation table.
> >> The type of this entry is block, which maps the kernel text
> >> and its access permissions bits are 01. The user process can
> >> then modify kernel text directly through this mapping. In this
> >> way, an arbitrary write can be converted to multiple arbitrary
> >> writes.
> >>
> >> Signed-off-by: YaoJun <yaojun8558363@gmail.com>
> >> ---
> >>  arch/arm64/mm/mmu.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> >> index 2dbb2c9f1ec1..ac4b22c7e435 100644
> >> --- a/arch/arm64/mm/mmu.c
> >> +++ b/arch/arm64/mm/mmu.c
> >> @@ -551,6 +551,10 @@ static int __init map_entry_trampoline(void)
> >>       __create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
> PAGE_SIZE,
> >>                            prot, pgd_pgtable_alloc, 0);
> >>
> >> +     update_mapping_prot(__pa_symbol(tramp_pg_dir),
> >> +                             (unsigned long)tramp_pg_dir,
> >> +                             PGD_SIZE, PAGE_KERNEL_RO);
> >
> > Hmm, I like the idea but is there a risk that the page table has been
> mapped
> > as part of a block entry, which we can't safely split at this point (i.e.
> > we'll run into one of the BUG_ONs in the mapping code)?
> >
>
> We'd need to create a separate segment for it initially so the mapping
> is already at the right granularity.
>

--0000000000008e6e43056d69b4d6
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">&gt;<span style=3D"color:rgb(34,34,34);font-family:arial,s=
ans-serif;font-size:14px;font-style:normal;font-variant-ligatures:normal;fo=
nt-variant-caps:normal;font-weight:400;letter-spacing:normal;text-align:sta=
rt;text-indent:0px;text-transform:none;white-space:normal;word-spacing:0px;=
background-color:rgb(255,255,255);text-decoration-style:initial;text-decora=
tion-color:initial;float:none;display:inline">We&#39;d need to create a sep=
arate segment for it initially so the mapping</span><br style=3D"color:rgb(=
34,34,34);font-family:arial,sans-serif;font-size:14px;font-style:normal;fon=
t-variant-ligatures:normal;font-variant-caps:normal;font-weight:400;letter-=
spacing:normal;text-align:start;text-indent:0px;text-transform:none;white-s=
pace:normal;word-spacing:0px;background-color:rgb(255,255,255);text-decorat=
ion-style:initial;text-decoration-color:initial"><span style=3D"color:rgb(3=
4,34,34);font-family:arial,sans-serif;font-size:14px;font-style:normal;font=
-variant-ligatures:normal;font-variant-caps:normal;font-weight:400;letter-s=
pacing:normal;text-align:start;text-indent:0px;text-transform:none;white-sp=
ace:normal;word-spacing:0px;background-color:rgb(255,255,255);text-decorati=
on-style:initial;text-decoration-color:initial;float:none;display:inline">&=
gt;is already at the right granularity.</span><div><span style=3D"color:rgb=
(34,34,34);font-family:arial,sans-serif;font-size:14px;font-style:normal;fo=
nt-variant-ligatures:normal;font-variant-caps:normal;font-weight:400;letter=
-spacing:normal;text-align:start;text-indent:0px;text-transform:none;white-=
space:normal;word-spacing:0px;background-color:rgb(255,255,255);text-decora=
tion-style:initial;text-decoration-color:initial;float:none;display:inline"=
><br></span></div><div>I think that I should to it like your patch, right?<=
br></div><div><br></div><div><div>=C2=A0Subject:=C2=A0 =C2=A0 [RFC PATCH 2/=
6] arm64/mm: create dedicated segment for pgdir mappings</div><div>=C2=A0Fr=
om:=C2=A0 =C2=A0 =C2=A0 =C2=A0Ard Biesheuvel &lt;ard.biesheuvel () linaro !=
 org&gt;</div><div>=C2=A0Date:=C2=A0 =C2=A0 =C2=A0 =C2=A02018-03-19 11:19:5=
4</div><div>=C2=A0Message-ID: 20180319111958.4171-3-ard.biesheuvel () linar=
o ! org</div></div><div><br></div><div><div>+=C2=A0 =C2=A0 =C2=A0 =C2=A0. =
=3D ALIGN(SEGMENT_ALIGN);</div><div>+=C2=A0 =C2=A0 =C2=A0 =C2=A0__pgdir_seg=
ment_start =3D .;</div><div>#ifdef CONFIG_UNMAP_KERNEL_AT_EL0</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tramp_pg_dir =3D .;</div><div>=C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0. +=3D PAGE_SIZE;</div><div>@@ -229,6 +231,7 @@ SECTION=
S</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0. +=3D RESERVED_TTBR0_SIZE;</=
div><div>#endif</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0swapper_pg_dir =
=3D .;</div><div>=C2=A0+=C2=A0 =C2=A0 =C2=A0 =C2=A0__pgdir_segment_end =3D =
. + PAGE_SIZE;</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0. +=3D SWAPPER_D=
IR_SIZE;</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0swapper_pg_end =3D .;<=
/div></div><div><br></div><div>Thanks.</div><div><br></div><div>Jun</div><d=
iv><br></div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote=
">2018-05-30 17:53 GMT+08:00 Ard Biesheuvel <span dir=3D"ltr">&lt;<a href=
=3D"mailto:ard.biesheuvel@linaro.org" target=3D"_blank">ard.biesheuvel@lina=
ro.org</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEn=
Zb"><div class=3D"h5">On 30 May 2018 at 11:14, Will Deacon &lt;<a href=3D"m=
ailto:will.deacon@arm.com">will.deacon@arm.com</a>&gt; wrote:<br>
&gt; On Wed, May 30, 2018 at 12:48:06PM +0800, YaoJun wrote:<br>
&gt;&gt; To protect against KSMA(Kernel Space Mirroring Attack), make<br>
&gt;&gt; tramp_pg_dir read-only. The principle of KSMA is to insert a<br>
&gt;&gt; carefully constructed PGD entry into the translation table.<br>
&gt;&gt; The type of this entry is block, which maps the kernel text<br>
&gt;&gt; and its access permissions bits are 01. The user process can<br>
&gt;&gt; then modify kernel text directly through this mapping. In this<br>
&gt;&gt; way, an arbitrary write can be converted to multiple arbitrary<br>
&gt;&gt; writes.<br>
&gt;&gt;<br>
&gt;&gt; Signed-off-by: YaoJun &lt;<a href=3D"mailto:yaojun8558363@gmail.co=
m">yaojun8558363@gmail.com</a>&gt;<br>
&gt;&gt; ---<br>
&gt;&gt;=C2=A0 arch/arm64/mm/mmu.c | 4 ++++<br>
&gt;&gt;=C2=A0 1 file changed, 4 insertions(+)<br>
&gt;&gt;<br>
&gt;&gt; diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c<br>
&gt;&gt; index 2dbb2c9f1ec1..ac4b22c7e435 100644<br>
&gt;&gt; --- a/arch/arm64/mm/mmu.c<br>
&gt;&gt; +++ b/arch/arm64/mm/mmu.c<br>
&gt;&gt; @@ -551,6 +551,10 @@ static int __init map_entry_trampoline(void)<=
br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0__create_pgd_mapping(tramp_pg_<wbr>dir, =
pa_start, TRAMP_VALIAS, PAGE_SIZE,<br>
&gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 prot, pgd_pgtable_alloc, 0);<br>
&gt;&gt;<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0update_mapping_prot(__pa_<wbr>symbol(tramp_pg=
_dir),<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(unsigned long)tramp_pg_dir,<br>
&gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PGD_SIZE, PAGE_KERNEL_RO);<br>
&gt;<br>
&gt; Hmm, I like the idea but is there a risk that the page table has been =
mapped<br>
&gt; as part of a block entry, which we can&#39;t safely split at this poin=
t (i.e.<br>
&gt; we&#39;ll run into one of the BUG_ONs in the mapping code)?<br>
&gt;<br>
<br>
</div></div>We&#39;d need to create a separate segment for it initially so =
the mapping<br>
is already at the right granularity.<br>
</blockquote></div><br></div>

--0000000000008e6e43056d69b4d6--
