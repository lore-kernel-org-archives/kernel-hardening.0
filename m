Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <2869477.o6QceH2ItE@vostro.rjw.lan>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com>
 <2213000.eZV9GAcFWG@vostro.rjw.lan> <CAE9FiQW5tSXPZLKB_3xh4TNVgU=vHiMOeUmN9h+nzkg3VTqDXw@mail.gmail.com>
 <2869477.o6QceH2ItE@vostro.rjw.lan>
From: Yinghai Lu <yinghai@kernel.org>
Date: Mon, 8 Aug 2016 00:06:45 -0700
Message-ID: <CAE9FiQXMOc_df4V9SZjoy0BymG0hy8=KnsRetFP7Wi=jZXt8yg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] x86/power/64: Support unaligned addresses for
 temporary mapping
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Garnier <thgarnie@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Aug 7, 2016 at 4:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Saturday, August 06, 2016 09:53:50 PM Yinghai Lu wrote:
>> On Sat, Aug 6, 2016 at 6:03 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> > On Wednesday, August 03, 2016 11:28:48 PM Rafael J. Wysocki wrote:
>> >
>> > On a second thought, it seems to be better to follow your suggestion to simply
>> > provide a special version of kernel_ident_mapping_init() for hibernation,
>> > because it is sufficiently distinct from the other users of the code in
>> > ident_map.c.
>> >
>> > The patch below does just that (lightly tested).
>> >
>> >
>> > ---
>> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> > Subject: [PATCH] x86/power/64: Always create temporary identity mapping correctly
>> >
>> > The low-level resume-from-hibernation code on x86-64 uses
>> > kernel_ident_mapping_init() to create the temoprary identity mapping,
>> > but that function assumes that the offset between kernel virtual
>> > addresses and physical addresses is aligned on the PGD level.
>> >
>> > However, with a randomized identity mapping base, it may be aligned
>> > on the PUD level and if that happens, the temporary identity mapping
>> > created by set_up_temporary_mappings() will not reflect the actual
>> > kernel identity mapping and the image restoration will fail as a
>> > result (leading to a kernel panic most of the time).
>> >
>> > To fix this problem, provide simplified routines for creating the
>> > temporary identity mapping during resume from hibernation on x86-64
>> > that support unaligned offsets between KVA and PA up to the PMD
>> > level.
>> >
>> > Although kernel_ident_mapping_init() might be made work in that
>> > case too, using hibernation-specific code for that is way simpler.
>> >
>> > Reported-by: Thomas Garnier <thgarnie@google.com>
>> > Suggested-by: Yinghai Lu <yinghai@kernel.org>
>> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>> > ---
>> >  arch/x86/power/hibernate_64.c |   61 ++++++++++++++++++++++++++++++++++++------
>> >  1 file changed, 53 insertions(+), 8 deletions(-)
>> >
>> > Index: linux-pm/arch/x86/power/hibernate_64.c
>> > ===================================================================
>> > --- linux-pm.orig/arch/x86/power/hibernate_64.c
>> > +++ linux-pm/arch/x86/power/hibernate_64.c
>> > @@ -77,18 +77,63 @@ static int set_up_temporary_text_mapping
>> >         return 0;
>> >  }
>> >
>> > -static void *alloc_pgt_page(void *context)
>> > +static void ident_pmd_init(pmd_t *pmd, unsigned long addr, unsigned long end)
>> >  {
>> > -       return (void *)get_safe_page(GFP_ATOMIC);
>> > +       for (; addr < end; addr += PMD_SIZE)
>> > +               set_pmd(pmd + pmd_index(addr),
>> > +                       __pmd((addr - __PAGE_OFFSET) | __PAGE_KERNEL_LARGE_EXEC));
>> > +}
>> > +
>> > +static int ident_pud_init(pud_t *pud, unsigned long addr, unsigned long end)
>> > +{
>> > +       unsigned long next;
>> > +
>> > +       for (; addr < end; addr = next) {
>> > +               pmd_t *pmd;
>> > +
>> > +               pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
>> > +               if (!pmd)
>> > +                       return -ENOMEM;
>> > +
>> > +               next = (addr & PUD_MASK) + PUD_SIZE;
>> > +               if (next > end)
>> > +                       next = end;
>> > +
>> > +               ident_pmd_init(pmd, addr & PMD_MASK, next);
>> > +               set_pud(pud + pud_index(addr), __pud(__pa(pmd) | _KERNPG_TABLE));
>> > +       }
>> > +       return 0;
>> > +}
>> > +
>> > +static int ident_mapping_init(pgd_t *pgd, unsigned long mstart, unsigned long mend)
>> > +{
>> > +       unsigned long addr = mstart + __PAGE_OFFSET;
>> > +       unsigned long end = mend + __PAGE_OFFSET;
>> > +       unsigned long next;
>> > +
>> > +       for (; addr < end; addr = next) {
>> > +               pud_t *pud;
>> > +               int result;
>> > +
>> > +               pud = (pud_t *)get_safe_page(GFP_ATOMIC);
>> > +               if (!pud)
>> > +                       return -ENOMEM;
>> > +
>> > +               next = (addr & PGDIR_MASK) + PGDIR_SIZE;
>> > +               if (next > end)
>> > +                       next = end;
>> > +
>> > +               result = ident_pud_init(pud, addr, next);
>> > +               if (result)
>> > +                       return result;
>> > +
>> > +               set_pgd(pgd + pgd_index(addr), __pgd(__pa(pud) | _KERNPG_TABLE));
>> > +       }
>> > +       return 0;
>> >  }
>> >
>> >  static int set_up_temporary_mappings(void)
>> >  {
>> > -       struct x86_mapping_info info = {
>> > -               .alloc_pgt_page = alloc_pgt_page,
>> > -               .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
>> > -               .kernel_mapping = true,
>> > -       };
>> >         unsigned long mstart, mend;
>> >         pgd_t *pgd;
>> >         int result;
>> > @@ -108,7 +153,7 @@ static int set_up_temporary_mappings(voi
>> >                 mstart = pfn_mapped[i].start << PAGE_SHIFT;
>> >                 mend   = pfn_mapped[i].end << PAGE_SHIFT;
>> >
>> > -               result = kernel_ident_mapping_init(&info, pgd, mstart, mend);
>> > +               result = ident_mapping_init(pgd, mstart, mend);
>> >                 if (result)
>> >                         return result;
>> >         }
>> >
>>
>> Hi Rafael,
>>
>> Your version seems not considering different pfn_mapped range could
>> share same PGD (512G) or even PUD(1G), or even same PMD (2M) range.
>
> Good point!
>
>> so just keep on using kernel_ident_mapping_init() for that.
>
> But then playing with offsets in ident_pud_init() is not necessary,
> because that function works on virtual addresses only, so the appended patch
> should be sufficient to fix the problem, shouldn't it?

I agree.

>
>> At the same time, set_up_temporary_text_mapping could be replaced with
>> kernel_ident_mapping_init() too if restore_jump_address is KVA for
>> jump_address_phys.
>
> I see no reason to do that.
>
> First, it is not guaranteed that restore_jump_address will always be a KVA for
> jump_address_phys and second, it really is only necessary to map one PMD in
> there.

With your v2 version, you could pass difference between restore_jump_address and
jump_address_phys as info->off ?
With that, we can kill more lines if replace with
set_up_temporary_text_mapping with
kernel_ident_mapping_init() and make code more readable.

But just keep that in separated patch after your v2 patch.

> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: [PATCH v2] x86/power/64: Always create temporary identity mapping correctly
>
> The low-level resume-from-hibernation code on x86-64 uses
> kernel_ident_mapping_init() to create the temoprary identity mapping,
> but that function assumes that the offset between kernel virtual
> addresses and physical addresses is aligned on the PGD level.
>
> However, with a randomized identity mapping base, it may be aligned
> on the PUD level and if that happens, the temporary identity mapping
> created by set_up_temporary_mappings() will not reflect the actual
> kernel identity mapping and the image restoration will fail as a
> result (leading to a kernel panic most of the time).
>
> To fix this problem, rework kernel_ident_mapping_init() to support
> unaligned offsets between KVA and PA up to the PMD level and make
> set_up_temporary_mappings() use it as approprtiate.
>
> Reported-by: Thomas Garnier <thgarnie@google.com>
> Suggested-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

it should replace

[PATCH v2] x86/power/64: Support unaligned addresses for temporary mapping

Acked-by: Yinghai Lu <yinghai@kernel.org>

> ---
>  arch/x86/include/asm/init.h   |    4 ++--
>  arch/x86/mm/ident_map.c       |   19 +++++++++++--------
>  arch/x86/power/hibernate_64.c |    2 +-
>  3 files changed, 14 insertions(+), 11 deletions(-)
>
> Index: linux-pm/arch/x86/include/asm/init.h
> ===================================================================
> --- linux-pm.orig/arch/x86/include/asm/init.h
> +++ linux-pm/arch/x86/include/asm/init.h
> @@ -5,10 +5,10 @@ struct x86_mapping_info {
>         void *(*alloc_pgt_page)(void *); /* allocate buf for page table */
>         void *context;                   /* context for alloc_pgt_page */
>         unsigned long pmd_flag;          /* page flag for PMD entry */
> -       bool kernel_mapping;             /* kernel mapping or ident mapping */
> +       unsigned long offset;            /* ident mapping offset */
>  };
>
>  int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
> -                               unsigned long addr, unsigned long end);
> +                               unsigned long pstart, unsigned long pend);
>
>  #endif /* _ASM_X86_INIT_H */
> Index: linux-pm/arch/x86/mm/ident_map.c
> ===================================================================
> --- linux-pm.orig/arch/x86/mm/ident_map.c
> +++ linux-pm/arch/x86/mm/ident_map.c
> @@ -3,15 +3,17 @@
>   * included by both the compressed kernel and the regular kernel.
>   */
>
> -static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
> +static void ident_pmd_init(struct x86_mapping_info *info, pmd_t *pmd_page,
>                            unsigned long addr, unsigned long end)
>  {
>         addr &= PMD_MASK;
>         for (; addr < end; addr += PMD_SIZE) {
>                 pmd_t *pmd = pmd_page + pmd_index(addr);
>
> -               if (!pmd_present(*pmd))
> -                       set_pmd(pmd, __pmd(addr | pmd_flag));
> +               if (pmd_present(*pmd))
> +                       continue;
> +
> +               set_pmd(pmd, __pmd((addr - info->offset) | info->pmd_flag));
>         }
>  }
>
> @@ -30,13 +32,13 @@ static int ident_pud_init(struct x86_map
>
>                 if (pud_present(*pud)) {
>                         pmd = pmd_offset(pud, 0);
> -                       ident_pmd_init(info->pmd_flag, pmd, addr, next);
> +                       ident_pmd_init(info, pmd, addr, next);
>                         continue;
>                 }
>                 pmd = (pmd_t *)info->alloc_pgt_page(info->context);
>                 if (!pmd)
>                         return -ENOMEM;
> -               ident_pmd_init(info->pmd_flag, pmd, addr, next);
> +               ident_pmd_init(info, pmd, addr, next);
>                 set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
>         }
>
> @@ -44,14 +46,15 @@ static int ident_pud_init(struct x86_map
>  }
>
>  int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
> -                             unsigned long addr, unsigned long end)
> +                             unsigned long pstart, unsigned long pend)
>  {
> +       unsigned long addr = pstart + info->offset;
> +       unsigned long end = pend + info->offset;
>         unsigned long next;
>         int result;
> -       int off = info->kernel_mapping ? pgd_index(__PAGE_OFFSET) : 0;
>
>         for (; addr < end; addr = next) {
> -               pgd_t *pgd = pgd_page + pgd_index(addr) + off;
> +               pgd_t *pgd = pgd_page + pgd_index(addr);
>                 pud_t *pud;
>
>                 next = (addr & PGDIR_MASK) + PGDIR_SIZE;
> Index: linux-pm/arch/x86/power/hibernate_64.c
> ===================================================================
> --- linux-pm.orig/arch/x86/power/hibernate_64.c
> +++ linux-pm/arch/x86/power/hibernate_64.c
> @@ -87,7 +87,7 @@ static int set_up_temporary_mappings(voi
>         struct x86_mapping_info info = {
>                 .alloc_pgt_page = alloc_pgt_page,
>                 .pmd_flag       = __PAGE_KERNEL_LARGE_EXEC,
> -               .kernel_mapping = true,
> +               .offset         = __PAGE_OFFSET,
>         };
>         unsigned long mstart, mend;
>         pgd_t *pgd;
>
