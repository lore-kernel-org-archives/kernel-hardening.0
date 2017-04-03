Content-Type: multipart/alternative;
	boundary=Apple-Mail-02FDA901-13ED-4DE8-9C15-FE640D933F4F
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CAKv+Gu_752QP5HGKopic=T3MA9=Vo0wHcRWXe4mN8+jTuxbB1A@mail.gmail.com>
Date: Mon, 3 Apr 2017 13:03:51 +0900
Content-Transfer-Encoding: 7bit
Message-Id: <B2E61980-E797-45EA-A24C-6BF2C01E1D60@gmail.com>
References: <1490884982-5066-1-git-send-email-hoeun.ryu@gmail.com> <CAKv+Gu_752QP5HGKopic=T3MA9=Vo0wHcRWXe4mN8+jTuxbB1A@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFCv2] arm64: support HAVE_ARCH_RARE_WRITE and HAVE_ARCH_RARE_WRITE_MEMCPY
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Laura Abbott <labbott@redhat.com>, Hugh Dickins <hughd@google.com>, Steve Capper <steve.capper@arm.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, James Morse <james.morse@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--Apple-Mail-02FDA901-13ED-4DE8-9C15-FE640D933F4F
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable


>> On Mar 31, 2017, at 6:25 PM, Ard Biesheuvel <ard.biesheuvel@linaro.org> w=
rote:
>>=20
>> On 30 March 2017 at 15:39, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>> This patch might be a part of Kees Cook's rare_write infrastructure serie=
s
>> for [1] for arm64 architecture.
>>=20
>> This implementation is based on Mark Rutland's suggestions [2], which is
>> that a special userspace mm that maps only __start/end_rodata as RW permi=
-
>> ssion is prepared during early boot time (paging_init) and __arch_rare_-
>> write_begin() switches to the mm [2].
>>=20
>> rare_write_mm address space is added for the special purpose and a page
>> global directory is also prepared for it. The mm remaps __start_rodata ~
>> __end_rodata to rodata_rw_alias_start which starts from TASK_SIZE_64 / 4
>> + kaslr_offset().
>>=20
>> It passes LKDTM's rare write test.
>>=20
>> [1] : http://www.openwall.com/lists/kernel-hardening/2017/02/27/5
>> [2] : https://lkml.org/lkml/2017/3/29/704
>>=20
>> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
>> ---
>> arch/arm64/Kconfig               |   2 +
>> arch/arm64/include/asm/pgtable.h |   4 ++
>> arch/arm64/mm/mmu.c              | 101 ++++++++++++++++++++++++++++++++++=
+++++
>> 3 files changed, 107 insertions(+)
>>=20
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index f2b0b52..6e2c592 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -102,6 +102,8 @@ config ARM64
>>       select HAVE_SYSCALL_TRACEPOINTS
>>       select HAVE_KPROBES
>>       select HAVE_KRETPROBES
>> +       select HAVE_ARCH_RARE_WRITE
>> +       select HAVE_ARCH_RARE_WRITE_MEMCPY
>>       select IOMMU_DMA if IOMMU_SUPPORT
>>       select IRQ_DOMAIN
>>       select IRQ_FORCED_THREADING
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
>> index c213fdbd0..1514933 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -741,6 +741,10 @@ static inline void update_mmu_cache(struct vm_area_s=
truct *vma,
>> #define kc_vaddr_to_offset(v)  ((v) & ~VA_START)
>> #define kc_offset_to_vaddr(o)  ((o) | VA_START)
>>=20
>> +unsigned long __arch_rare_write_begin(void);
>> +unsigned long __arch_rare_write_end(void);
>> +void __arch_rare_write_memcpy(void *dst, const void *src, __kernel_size_=
t len);
>> +
>=20
> If these hook into a generic framework, shouldn't these already be
> declared in a generic header file?

the generic header file doesn't declare arch-specific version of api.

>> #endif /* !__ASSEMBLY__ */
>>=20
>> #endif /* __ASM_PGTABLE_H */
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 91502e3..86b25c9 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -570,6 +570,105 @@ static void __init map_kernel(pgd_t *pgd)
>>       kasan_copy_shadow(pgd);
>> }
>>=20
>> +struct mm_struct rare_write_mm =3D {
>=20
> static please

OK, add static.=20

>=20
>> +       .mm_rb          =3D RB_ROOT,
>> +       .mm_users       =3D ATOMIC_INIT(2),
>> +       .mm_count       =3D ATOMIC_INIT(1),
>> +       .mmap_sem       =3D __RWSEM_INITIALIZER(rare_write_mm.mmap_sem),
>> +       .page_table_lock=3D __SPIN_LOCK_UNLOCKED(rare_write_mm.page_table=
_lock),
>> +       .mmlist         =3D LIST_HEAD_INIT(rare_write_mm.mmlist),
>> +};
>> +
>> +#ifdef CONFIG_ARM64_PTDUMP_DEBUGFS
>> +#include <asm/ptdump.h>
>> +
>> +static struct ptdump_info rare_write_ptdump_info =3D {
>> +       .mm             =3D &rare_write_mm,
>> +       .markers        =3D (struct addr_marker[]){
>> +               { 0,            "rare-write start" },
>> +               { TASK_SIZE_64, "rare-write end" }
>> +       },
>> +       .base_addr      =3D 0,
>> +};
>> +
>> +static int __init ptdump_init(void)
>> +{
>> +       return ptdump_debugfs_register(&rare_write_ptdump_info,
>> +                                      "rare_write_page_tables");
>> +}
>> +device_initcall(ptdump_init);
>> +
>> +#endif
>> +
>> +__always_inline unsigned long __arch_rare_write_begin(void)
>=20
> These functions are not called from the same compilation unit, so what
> do you think __always_inline buys you here?

The first patch of Kee's series ([PATCH 01/11] Introduce rare_write() infras=
tructure) [1] says some requirements and one of these is the arch-specific h=
elpers should be inline to avoid making them ROP targets.

So I'd make sure the helpers are inline.

[1] : http://www.openwall.com/lists/kernel-hardening/2017/03/29/16

>=20
>> +{
>> +       struct mm_struct *mm =3D &rare_write_mm;
>> +
>> +       preempt_disable();
>> +
>> +       __switch_mm(mm);
>> +
>> +       if (system_uses_ttbr0_pan()) {
>> +               update_saved_ttbr0(current, mm);
>> +               cpu_switch_mm(mm->pgd, mm);
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +__always_inline unsigned long __arch_rare_write_end(void)
>> +{
>> +       struct mm_struct *mm =3D current->active_mm;
>> +
>> +       __switch_mm(mm);
>> +
>> +       if (system_uses_ttbr0_pan()) {
>> +               cpu_set_reserved_ttbr0();
>> +               if (mm !=3D &init_mm)
>> +                       update_saved_ttbr0(current, mm);
>> +       }
>> +
>> +       preempt_enable_no_resched();
>> +
>> +       return 0;
>> +}
>> +
>> +static unsigned long rodata_rw_alias_start __ro_after_init =3D TASK_SIZE=
_64 / 4;
>> +
>> +__always_inline void __arch_rare_write_memcpy(void *dst, const void *src=
,
>> +                                             __kernel_size_t len)
>> +{
>> +       unsigned long __dst =3D (unsigned long)dst;
>> +
>> +       __dst -=3D (unsigned long)__start_rodata;
>> +       __dst +=3D rodata_rw_alias_start;
>> +
>> +       memcpy((void *)__dst, src, len);
>> +}
>> +
>> +void __init rare_write_init(void)
>=20
> static please

OK, add static.=20

>=20
>> +{
>> +       phys_addr_t pgd_phys =3D early_pgtable_alloc();
>> +       pgd_t *pgd =3D (pgd_t *)__phys_to_virt(pgd_phys);
>> +       phys_addr_t pa_start =3D __pa_symbol(__start_rodata);
>> +       unsigned long size =3D __end_rodata - __start_rodata;
>> +
>> +       BUG_ON(!PAGE_ALIGNED(pa_start));
>> +       BUG_ON(!PAGE_ALIGNED(size));
>> +
>> +       rodata_rw_alias_start +=3D kaslr_offset();
>> +
>=20
> This places the rodata alias at a fixed offset from the original,
> right, even under KASLR? Given that they are completely independent, I
> think you can use a random offset here rather than the same offset we
> use for vmlinux.

What I did here is just to randomize the base of rw alias mapping when kaslr=
 is enabled.
You're right it's completely independent though from kaslr, I would like to a=
dd randomization for rw alias base address by using simple solution in early=
 boot stage.

I' ll think again to achieve randomization or just remove it.

>=20
>=20
>> +       BUG_ON(rodata_rw_alias_start + size > TASK_SIZE_64);
>> +
>> +       rare_write_mm.pgd =3D pgd;
>=20
> For correctness, you should add a call to mm_init_cpumask() here,
> although it doesn't matter in practice on arm64.

OK, I'll fix this.=20

>=20
>> +       init_new_context(NULL, &rare_write_mm);
>> +
>> +       __create_pgd_mapping(pgd,
>> +                            pa_start, rodata_rw_alias_start, size,
>> +                            __pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),
>> +                            early_pgtable_alloc, debug_pagealloc_enabled=
());
>=20
> This needs to be updated after the changes that are now queued in the
> arm64 tree for v4.12
>=20
> BTW you can allow page/cont mappings in all cases, no need for the
> debug_pagealloc_enabled() check

I will rebase this onto the version you mentioned later.

>> +}
>> +
>> /*
>> * paging_init() sets up the page tables, initialises the zone memory
>> * maps and sets up the zero page.
>> @@ -603,6 +702,8 @@ void __init paging_init(void)
>>        */
>>       memblock_free(__pa_symbol(swapper_pg_dir) + PAGE_SIZE,
>>                     SWAPPER_DIR_SIZE - PAGE_SIZE);
>> +
>> +       rare_write_init();
>> }
>>=20
>> /*
>> --
>> 2.7.4

Thank you very much for the review=

--Apple-Mail-02FDA901-13ED-4DE8-9C15-FE640D933F4F
Content-Type: text/html;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; charset=3D=
utf-8"></head><body dir=3D"auto"><div><span></span></div><div><span></span><=
br><div></div><blockquote type=3D"cite"><span>On Mar 31, 2017, at 6:25 PM, A=
rd Biesheuvel &lt;<a href=3D"mailto:ard.biesheuvel@linaro.org">ard.biesheuve=
l@linaro.org</a>&gt; wrote:</span><br></blockquote><blockquote type=3D"cite"=
><span></span><br></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>On 30 March 2017 at 15:39, Hoeun Ryu &lt;<a href=3D"mailto:hoeu=
n.ryu@gmail.com">hoeun.ryu@gmail.com</a>&gt; wrote:</span><br></blockquote><=
/blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>This p=
atch might be a part of Kees Cook's rare_write infrastructure series</span><=
br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"c=
ite"><span>for [1] for arm64 architecture.</span><br></blockquote></blockquo=
te><blockquote type=3D"cite"><blockquote type=3D"cite"><span></span><br></bl=
ockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><s=
pan>This implementation is based on Mark Rutland's suggestions [2], which is=
</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote t=
ype=3D"cite"><span>that a special userspace mm that maps only __start/end_ro=
data as RW permi-</span><br></blockquote></blockquote><blockquote type=3D"ci=
te"><blockquote type=3D"cite"><span>ssion is prepared during early boot time=
 (paging_init) and __arch_rare_-</span><br></blockquote></blockquote><blockq=
uote type=3D"cite"><blockquote type=3D"cite"><span>write_begin() switches to=
 the mm [2].</span><br></blockquote></blockquote><blockquote type=3D"cite"><=
blockquote type=3D"cite"><span></span><br></blockquote></blockquote><blockqu=
ote type=3D"cite"><blockquote type=3D"cite"><span>rare_write_mm address spac=
e is added for the special purpose and a page</span><br></blockquote></block=
quote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>global direc=
tory is also prepared for it. The mm remaps __start_rodata ~</span><br></blo=
ckquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><sp=
an>__end_rodata to rodata_rw_alias_start which starts from TASK_SIZE_64 / 4<=
/span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote ty=
pe=3D"cite"><span>+ kaslr_offset().</span><br></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><span></span><br></blockquot=
e></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>It p=
asses LKDTM's rare write test.</span><br></blockquote></blockquote><blockquo=
te type=3D"cite"><blockquote type=3D"cite"><span></span><br></blockquote></b=
lockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>[1] : <a=
 href=3D"http://www.openwall.com/lists/kernel-hardening/2017/02/27/5">http:/=
/www.openwall.com/lists/kernel-hardening/2017/02/27/5</a></span><br></blockq=
uote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>=
[2] : <a href=3D"https://lkml.org/lkml/2017/3/29/704">https://lkml.org/lkml/=
2017/3/29/704</a></span><br></blockquote></blockquote><blockquote type=3D"ci=
te"><blockquote type=3D"cite"><span></span><br></blockquote></blockquote><bl=
ockquote type=3D"cite"><blockquote type=3D"cite"><span>Signed-off-by: Hoeun R=
yu &lt;<a href=3D"mailto:hoeun.ryu@gmail.com">hoeun.ryu@gmail.com</a>&gt;</s=
pan><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=
=3D"cite"><span>---</span><br></blockquote></blockquote><blockquote type=3D"=
cite"><blockquote type=3D"cite"><span>arch/arm64/Kconfig &nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| &nbsp;&nb=
sp;2 +</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockq=
uote type=3D"cite"><span>arch/arm64/include/asm/pgtable.h | &nbsp;&nbsp;4 ++=
</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote t=
ype=3D"cite"><span>arch/arm64/mm/mmu.c &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 101 +++++++++++++++++++++++++++++=
++++++++++</span><br></blockquote></blockquote><blockquote type=3D"cite"><bl=
ockquote type=3D"cite"><span>3 files changed, 107 insertions(+)</span><br></=
blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite">=
<span></span><br></blockquote></blockquote><blockquote type=3D"cite"><blockq=
uote type=3D"cite"><span>diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfi=
g</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote t=
ype=3D"cite"><span>index f2b0b52..6e2c592 100644</span><br></blockquote></bl=
ockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>--- a/arc=
h/arm64/Kconfig</span><br></blockquote></blockquote><blockquote type=3D"cite=
"><blockquote type=3D"cite"><span>+++ b/arch/arm64/Kconfig</span><br></block=
quote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span=
>@@ -102,6 +102,8 @@ config ARM64</span><br></blockquote></blockquote><block=
quote type=3D"cite"><blockquote type=3D"cite"><span> &nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;select HAVE_SYSCALL_TRACEPOINTS</span><br></blockquote></blockq=
uote><blockquote type=3D"cite"><blockquote type=3D"cite"><span> &nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;select HAVE_KPROBES</span><br></blockquote></blockqu=
ote><blockquote type=3D"cite"><blockquote type=3D"cite"><span> &nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;select HAVE_KRETPROBES</span><br></blockquote></block=
quote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;select HAVE_ARCH_RARE_WRITE</span><br></blockquote=
></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;select HAVE_ARCH_RARE_WRITE_MEMCPY</span><=
br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"c=
ite"><span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;select IOMMU_DMA if IOMMU_SU=
PPORT</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockqu=
ote type=3D"cite"><span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;select IRQ_DOMA=
IN</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote=
 type=3D"cite"><span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;select IRQ_FORCED_=
THREADING</span><br></blockquote></blockquote><blockquote type=3D"cite"><blo=
ckquote type=3D"cite"><span>diff --git a/arch/arm64/include/asm/pgtable.h b/=
arch/arm64/include/asm/pgtable.h</span><br></blockquote></blockquote><blockq=
uote type=3D"cite"><blockquote type=3D"cite"><span>index c213fdbd0..1514933 1=
00644</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockqu=
ote type=3D"cite"><span>--- a/arch/arm64/include/asm/pgtable.h</span><br></b=
lockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><=
span>+++ b/arch/arm64/include/asm/pgtable.h</span><br></blockquote></blockqu=
ote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>@@ -741,6 +741=
,10 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,</span=
><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>#define kc_vaddr_to_offset(v) &nbsp;((v) &amp; ~VA_START)</span=
><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>#define kc_offset_to_vaddr(o) &nbsp;((o) | VA_START)</span><br>=
</blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite=
"><span></span><br></blockquote></blockquote><blockquote type=3D"cite"><bloc=
kquote type=3D"cite"><span>+unsigned long __arch_rare_write_begin(void);</sp=
an><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>+unsigned long __arch_rare_write_end(void);</span><br></blockqu=
ote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+=
void __arch_rare_write_memcpy(void *dst, const void *src, __kernel_size_t le=
n);</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquot=
e type=3D"cite"><span>+</span><br></blockquote></blockquote><blockquote type=
=3D"cite"><span></span><br></blockquote><blockquote type=3D"cite"><span>If t=
hese hook into a generic framework, shouldn't these already be</span><br></b=
lockquote><blockquote type=3D"cite"><span>declared in a generic header file?=
</span><br></blockquote><blockquote type=3D"cite"><span></span><br></blockqu=
ote><span></span><br><span>the generic header file doesn't declare arch-spec=
ific version of api.</span><br><span></span><br><blockquote type=3D"cite"><b=
lockquote type=3D"cite"><span>#endif /* !__ASSEMBLY__ */</span><br></blockqu=
ote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span><=
/span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote ty=
pe=3D"cite"><span>#endif /* __ASM_PGTABLE_H */</span><br></blockquote></bloc=
kquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>diff --git a=
/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c</span><br></blockquote></blockquo=
te><blockquote type=3D"cite"><blockquote type=3D"cite"><span>index 91502e3..=
86b25c9 100644</span><br></blockquote></blockquote><blockquote type=3D"cite"=
><blockquote type=3D"cite"><span>--- a/arch/arm64/mm/mmu.c</span><br></block=
quote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span=
>+++ b/arch/arm64/mm/mmu.c</span><br></blockquote></blockquote><blockquote t=
ype=3D"cite"><blockquote type=3D"cite"><span>@@ -570,6 +570,105 @@ static vo=
id __init map_kernel(pgd_t *pgd)</span><br></blockquote></blockquote><blockq=
uote type=3D"cite"><blockquote type=3D"cite"><span> &nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;kasan_copy_shadow(pgd);</span><br></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><span>}</span><br></blockquo=
te></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span></=
span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote typ=
e=3D"cite"><span>+struct mm_struct rare_write_mm =3D {</span><br></blockquot=
e></blockquote><blockquote type=3D"cite"><span></span><br></blockquote><bloc=
kquote type=3D"cite"><span>static please</span><br></blockquote><div><br></d=
iv><span style=3D"background-color: rgba(255, 255, 255, 0);">OK, add static.=
&nbsp;</span></div><div><br><blockquote type=3D"cite"><span></span><br></blo=
ckquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;.mm_rb &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;=3D RB_ROOT,</span><br></blockquote></blockquote><blockquote ty=
pe=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;.mm_users &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D ATOMIC_INIT(2),</spa=
n><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.mm_count &nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=3D ATOMIC_INIT(1),</span><br></blockquote></blockquote=
><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;.mmap_sem &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D __RWS=
EM_INITIALIZER(rare_write_mm.mmap_sem),</span><br></blockquote></blockquote>=
<blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;.page_table_lock=3D __SPIN_LOCK_UNLOCKED(rare_write_mm.p=
age_table_lock),</span><br></blockquote></blockquote><blockquote type=3D"cit=
e"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.mm=
list &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D LIST_HEAD_INIT(rare=
_write_mm.mmlist),</span><br></blockquote></blockquote><blockquote type=3D"c=
ite"><blockquote type=3D"cite"><span>+};</span><br></blockquote></blockquote=
><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+</span><br></blo=
ckquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><sp=
an>+#ifdef CONFIG_ARM64_PTDUMP_DEBUGFS</span><br></blockquote></blockquote><=
blockquote type=3D"cite"><blockquote type=3D"cite"><span>+#include &lt;asm/p=
tdump.h&gt;</span><br></blockquote></blockquote><blockquote type=3D"cite"><b=
lockquote type=3D"cite"><span>+</span><br></blockquote></blockquote><blockqu=
ote type=3D"cite"><blockquote type=3D"cite"><span>+static struct ptdump_info=
 rare_write_ptdump_info =3D {</span><br></blockquote></blockquote><blockquot=
e type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;.mm &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;=3D &amp;rare_write_mm,</span><br></blockquote></blockquote><block=
quote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;.markers &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D (struct=
 addr_marker[]){</span><br></blockquote></blockquote><blockquote type=3D"cit=
e"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{ 0, &nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"rare-write start" },</span><br></bl=
ockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><s=
pan>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;{ TASK_SIZE_64, "rare-write end" }</span><br></blockquote></bl=
ockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;},</span><br></blockquote></blockquote><blockqu=
ote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;.base_addr &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D 0,</span><br></bloc=
kquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><spa=
n>+};</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockqu=
ote type=3D"cite"><span>+</span><br></blockquote></blockquote><blockquote ty=
pe=3D"cite"><blockquote type=3D"cite"><span>+static int __init ptdump_init(v=
oid)</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquo=
te type=3D"cite"><span>+{</span><br></blockquote></blockquote><blockquote ty=
pe=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;return ptdump_debugfs_register(&amp;rare_write_ptdump_info,</span><br>=
</blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite=
"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;"rare_write_page_tables");</span><br></blockquote></blockquote><blockquo=
te type=3D"cite"><blockquote type=3D"cite"><span>+}</span><br></blockquote><=
/blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+devic=
e_initcall(ptdump_init);</span><br></blockquote></blockquote><blockquote typ=
e=3D"cite"><blockquote type=3D"cite"><span>+</span><br></blockquote></blockq=
uote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+#endif</span=
><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>+</span><br></blockquote></blockquote><blockquote type=3D"cite"=
><blockquote type=3D"cite"><span>+__always_inline unsigned long __arch_rare_=
write_begin(void)</span><br></blockquote></blockquote><blockquote type=3D"ci=
te"><span></span><br></blockquote><blockquote type=3D"cite"><span>These func=
tions are not called from the same compilation unit, so what</span><br></blo=
ckquote><blockquote type=3D"cite"><span>do you think __always_inline buys yo=
u here?</span><br></blockquote><div><br></div><div><span style=3D"background=
-color: rgba(255, 255, 255, 0);">The first patch of Kee's series ([PATCH 01/=
11] Introduce rare_write() infrastructure) [1] says some requirements and on=
e of these is the arch-specific helpers should be inline to avoid making the=
m ROP targets.</span></div><div><span style=3D"background-color: rgba(255, 2=
55, 255, 0);"><br></span></div><div><span style=3D"background-color: rgba(25=
5, 255, 255, 0);">So I'd make sure the helpers are inline.</span></div><div>=
<span style=3D"background-color: rgba(255, 255, 255, 0);"><br></span></div><=
div>[1] :&nbsp;<a href=3D"http://www.openwall.com/lists/kernel-hardening/201=
7/03/29/16">http://www.openwall.com/lists/kernel-hardening/2017/03/29/16</a>=
</div><br><blockquote type=3D"cite"><span></span><br></blockquote><blockquot=
e type=3D"cite"><blockquote type=3D"cite"><span>+{</span><br></blockquote></=
blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct mm_struct *mm =3D &amp;rare_write_mm;<=
/span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote ty=
pe=3D"cite"><span>+</span><br></blockquote></blockquote><blockquote type=3D"=
cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
preempt_disable();</span><br></blockquote></blockquote><blockquote type=3D"c=
ite"><blockquote type=3D"cite"><span>+</span><br></blockquote></blockquote><=
blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;__switch_mm(mm);</span><br></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><span>+</span><br></blockquo=
te></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (system_uses_ttbr0_pan()) {</span><br>=
</blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite=
"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;update_saved_ttbr0(current, mm);</span><br></blockquote></=
blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;cpu_switch_mm(mm-&gt;pgd, mm);</span><br></blockquote></blockquote><block=
quote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;}</span><br></blockquote></blockquote><blockquote type=3D"cite=
"><blockquote type=3D"cite"><span>+</span><br></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;return 0;</span><br></blockquote></blockquote><blockquote ty=
pe=3D"cite"><blockquote type=3D"cite"><span>+}</span><br></blockquote></bloc=
kquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+</span><br=
></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cit=
e"><span>+__always_inline unsigned long __arch_rare_write_end(void)</span><b=
r></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"ci=
te"><span>+{</span><br></blockquote></blockquote><blockquote type=3D"cite"><=
blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct m=
m_struct *mm =3D current-&gt;active_mm;</span><br></blockquote></blockquote>=
<blockquote type=3D"cite"><blockquote type=3D"cite"><span>+</span><br></bloc=
kquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><spa=
n>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__switch_mm(mm);</span><br></blockqu=
ote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+=
</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote t=
ype=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if (system_uses_ttb=
r0_pan()) {</span><br></blockquote></blockquote><blockquote type=3D"cite"><b=
lockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;cpu_set_reserved_ttbr0();</span><br>=
</blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite=
"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;if (mm !=3D &amp;init_mm)</span><br></blockquote></blockqu=
ote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;update_saved_ttbr0(current, mm);=
</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote t=
ype=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}</span><br></block=
quote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span=
>+</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote=
 type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;preempt_enable_no=
_resched();</span><br></blockquote></blockquote><blockquote type=3D"cite"><b=
lockquote type=3D"cite"><span>+</span><br></blockquote></blockquote><blockqu=
ote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;return 0;</span><br></blockquote></blockquote><blockquote type=3D=
"cite"><blockquote type=3D"cite"><span>+}</span><br></blockquote></blockquot=
e><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+</span><br></bl=
ockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><s=
pan>+static unsigned long rodata_rw_alias_start __ro_after_init =3D TASK_SIZ=
E_64 / 4;</span><br></blockquote></blockquote><blockquote type=3D"cite"><blo=
ckquote type=3D"cite"><span>+</span><br></blockquote></blockquote><blockquot=
e type=3D"cite"><blockquote type=3D"cite"><span>+__always_inline void __arch=
_rare_write_memcpy(void *dst, const void *src,</span><br></blockquote></bloc=
kquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;__kernel_size_t len)</span><br></blockquote></blo=
ckquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+{</span><=
br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"c=
ite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;unsigned long __dst =3D (un=
signed long)dst;</span><br></blockquote></blockquote><blockquote type=3D"cit=
e"><blockquote type=3D"cite"><span>+</span><br></blockquote></blockquote><bl=
ockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;__dst -=3D (unsigned long)__start_rodata;</span><br></block=
quote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span=
>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__dst +=3D rodata_rw_alias_start;</sp=
an><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>+</span><br></blockquote></blockquote><blockquote type=3D"cite"=
><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;memcp=
y((void *)__dst, src, len);</span><br></blockquote></blockquote><blockquote t=
ype=3D"cite"><blockquote type=3D"cite"><span>+}</span><br></blockquote></blo=
ckquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+</span><b=
r></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"ci=
te"><span>+void __init rare_write_init(void)</span><br></blockquote></blockq=
uote><blockquote type=3D"cite"><span></span><br></blockquote><blockquote typ=
e=3D"cite"><span>static please</span></blockquote><div><br></div><span style=
=3D"background-color: rgba(255, 255, 255, 0);">OK, add static.&nbsp;</span><=
/div><div><br><blockquote type=3D"cite"><span></span><br></blockquote><block=
quote type=3D"cite"><blockquote type=3D"cite"><span>+{</span><br></blockquot=
e></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;phys_addr_t pgd_phys =3D early_pgtable_al=
loc();</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockq=
uote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pgd_t *pgd =3D=
 (pgd_t *)__phys_to_virt(pgd_phys);</span><br></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;phys_addr_t pa_start =3D __pa_symbol(__start_rodata);</span>=
<br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"=
cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;unsigned long size =3D __e=
nd_rodata - __start_rodata;</span><br></blockquote></blockquote><blockquote t=
ype=3D"cite"><blockquote type=3D"cite"><span>+</span><br></blockquote></bloc=
kquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;BUG_ON(!PAGE_ALIGNED(pa_start));</span><br></bloc=
kquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><spa=
n>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BUG_ON(!PAGE_ALIGNED(size));</span><=
br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"c=
ite"><span>+</span><br></blockquote></blockquote><blockquote type=3D"cite"><=
blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rodata_=
rw_alias_start +=3D kaslr_offset();</span><br></blockquote></blockquote><blo=
ckquote type=3D"cite"><blockquote type=3D"cite"><span>+</span><br></blockquo=
te></blockquote><blockquote type=3D"cite"><span></span><br></blockquote><blo=
ckquote type=3D"cite"><span>This places the rodata alias at a fixed offset f=
rom the original,</span><br></blockquote><blockquote type=3D"cite"><span>rig=
ht, even under KASLR? Given that they are completely independent, I</span><b=
r></blockquote><blockquote type=3D"cite"><span>think you can use a random of=
fset here rather than the same offset we</span><br></blockquote><blockquote t=
ype=3D"cite"><span>use for vmlinux.</span><br></blockquote><span></span><br>=
<span>What I did here is just to randomize the base of rw alias mapping when=
 kaslr is enabled.</span><br><span>You're right it's completely independent t=
hough from kaslr, I would like to add randomization for rw alias base addres=
s by using simple solution in early boot stage.</span><br><span></span><br><=
span>I' ll think again to achieve randomization or just remove it.</span><br=
><span></span><br><blockquote type=3D"cite"><span></span><br></blockquote><b=
lockquote type=3D"cite"><span></span><br></blockquote><blockquote type=3D"ci=
te"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BU=
G_ON(rodata_rw_alias_start + size &gt; TASK_SIZE_64);</span><br></blockquote=
></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+</s=
pan><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=
=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;rare_write_mm.pgd =3D p=
gd;</span><br></blockquote></blockquote><blockquote type=3D"cite"><span></sp=
an><br></blockquote><blockquote type=3D"cite"><span>For correctness, you sho=
uld add a call to mm_init_cpumask() here,</span><br></blockquote><blockquote=
 type=3D"cite"><span>although it doesn't matter in practice on arm64.</span>=
<br></blockquote><span></span><br><span>OK, I'll fix this. </span><br><span>=
</span><br><blockquote type=3D"cite"><span></span><br></blockquote><blockquo=
te type=3D"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;init_new_context(NULL, &amp;rare_write_mm);</span><br></blockquot=
e></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>+</=
span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote typ=
e=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__create_pgd_mapping(=
pgd,</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquo=
te type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pa_start, rodata_rw_alias_start, size,</s=
pan><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=
=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;__pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),</spa=
n><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;early_pgtable_alloc, debug_pagealloc_enabled());</s=
pan><br></blockquote></blockquote><blockquote type=3D"cite"><span></span><br=
></blockquote><blockquote type=3D"cite"><span>This needs to be updated after=
 the changes that are now queued in the</span><br></blockquote><blockquote t=
ype=3D"cite"><span>arm64 tree for v4.12</span><br></blockquote><blockquote t=
ype=3D"cite"><span></span><br></blockquote><blockquote type=3D"cite"><span>B=
TW you can allow page/cont mappings in all cases, no need for the</span><br>=
</blockquote><blockquote type=3D"cite"><span>debug_pagealloc_enabled() check=
</span><br></blockquote><blockquote type=3D"cite"><span></span><br></blockqu=
ote><span></span><br><span>I will rebase this onto the version you mentioned=
 later.</span><br><span></span><br><blockquote type=3D"cite"><blockquote typ=
e=3D"cite"><span>+}</span><br></blockquote></blockquote><blockquote type=3D"=
cite"><blockquote type=3D"cite"><span>+</span><br></blockquote></blockquote>=
<blockquote type=3D"cite"><blockquote type=3D"cite"><span>/*</span><br></blo=
ckquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><sp=
an> * paging_init() sets up the page tables, initialises the zone memory</sp=
an><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote type=3D=
"cite"><span> * maps and sets up the zero page.</span><br></blockquote></blo=
ckquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span>@@ -603,6 +=
702,8 @@ void __init paging_init(void)</span><br></blockquote></blockquote><=
blockquote type=3D"cite"><blockquote type=3D"cite"><span> &nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;*/</span><br></blockquote></blockquote><blockquote t=
ype=3D"cite"><blockquote type=3D"cite"><span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;memblock_free(__pa_symbol(swapper_pg_dir) + PAGE_SIZE,</span><br></blo=
ckquote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><sp=
an> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SWAPPER_DIR_SIZE - PAGE_SIZE=
);</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquote=
 type=3D"cite"><span>+</span><br></blockquote></blockquote><blockquote type=3D=
"cite"><blockquote type=3D"cite"><span>+ &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;rare_write_init();</span><br></blockquote></blockquote><blockquote type=3D"=
cite"><blockquote type=3D"cite"><span>}</span><br></blockquote></blockquote>=
<blockquote type=3D"cite"><blockquote type=3D"cite"><span></span><br></block=
quote></blockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span=
>/*</span><br></blockquote></blockquote><blockquote type=3D"cite"><blockquot=
e type=3D"cite"><span>--</span><br></blockquote></blockquote><blockquote typ=
e=3D"cite"><blockquote type=3D"cite"><span>2.7.4</span><br></blockquote></bl=
ockquote><blockquote type=3D"cite"><blockquote type=3D"cite"><span></span><b=
r></blockquote></blockquote><span></span><br><span>Thank you very much for t=
he review</span></div></body></html>=

--Apple-Mail-02FDA901-13ED-4DE8-9C15-FE640D933F4F--
