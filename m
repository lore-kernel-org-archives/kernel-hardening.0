Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
From: Hoeun Ryu <hoeun.ryu@gmail.com>
In-Reply-To: <CAGXu5jLFDGO5OfOGa7B9H6pw8ivnL9MUsPZ=fQns-fbA6R-Ljw@mail.gmail.com>
Date: Mon, 3 Apr 2017 12:19:38 +0900
Content-Transfer-Encoding: quoted-printable
Message-Id: <0A044FD1-41C0-4ABB-9BFF-17D21006EE2E@gmail.com>
References: <1490884982-5066-1-git-send-email-hoeun.ryu@gmail.com> <CAGXu5jLFDGO5OfOGa7B9H6pw8ivnL9MUsPZ=fQns-fbA6R-Ljw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFCv2] arm64: support HAVE_ARCH_RARE_WRITE and HAVE_ARCH_RARE_WRITE_MEMCPY
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Laura Abbott <labbott@redhat.com>, Hugh Dickins <hughd@google.com>, Steve Capper <steve.capper@arm.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, James Morse <james.morse@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On Mar 31, 2017, at 4:38 AM, Kees Cook <keescook@chromium.org> wrote:
>=20
>> On Thu, Mar 30, 2017 at 7:39 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
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
>=20
> Great work! I think this will need some further changes, though, since
> it doesn't look to me like this would pass LKDTM's tests if it was
> built as a module. (This is missing from my ARM attempt too... I
> haven't figured out how to set the domain on the kernel modules...)
>=20

ah.. I understand..
so we need to additional rw mappings for modules, right ?

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
>>        select HAVE_SYSCALL_TRACEPOINTS
>>        select HAVE_KPROBES
>>        select HAVE_KRETPROBES
>> +       select HAVE_ARCH_RARE_WRITE
>> +       select HAVE_ARCH_RARE_WRITE_MEMCPY
>>        select IOMMU_DMA if IOMMU_SUPPORT
>>        select IRQ_DOMAIN
>>        select IRQ_FORCED_THREADING
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
>> #endif /* !__ASSEMBLY__ */
>>=20
>> #endif /* __ASM_PGTABLE_H */
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 91502e3..86b25c9 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -570,6 +570,105 @@ static void __init map_kernel(pgd_t *pgd)
>>        kasan_copy_shadow(pgd);
>> }
>>=20
>> +struct mm_struct rare_write_mm =3D {
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
>> +{
>> +       struct mm_struct *mm =3D &rare_write_mm;
>> +
>> +       preempt_disable();
>> +
>> +       __switch_mm(mm);
>=20
> Can you include a BUG_ON check here that rare_write_mm is not already acti=
ve?
>=20

OK, I will find the way to do so.

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
>=20
> And same here (though the reverse test)?
>=20
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
>> +       BUG_ON(rodata_rw_alias_start + size > TASK_SIZE_64);
>> +
>> +       rare_write_mm.pgd =3D pgd;
>> +       init_new_context(NULL, &rare_write_mm);
>> +
>> +       __create_pgd_mapping(pgd,
>> +                            pa_start, rodata_rw_alias_start, size,
>> +                            __pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),
>> +                            early_pgtable_alloc, debug_pagealloc_enabled=
());
>> +}
>> +
>> /*
>>  * paging_init() sets up the page tables, initialises the zone memory
>>  * maps and sets up the zero page.
>> @@ -603,6 +702,8 @@ void __init paging_init(void)
>>         */
>>        memblock_free(__pa_symbol(swapper_pg_dir) + PAGE_SIZE,
>>                      SWAPPER_DIR_SIZE - PAGE_SIZE);
>> +
>> +       rare_write_init();
>> }
>>=20
>> /*
>> --
>> 2.7.4
>>=20
>=20

Thank you for the review !

> Thanks!
>=20
> -Kees
>=20
> --=20
> Kees Cook
> Pixel Security
