Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Mon, 08 Aug 2016 15:16:41 +0200
Message-ID: <86530854.uEH6qIGyWZ@vostro.rjw.lan>
In-Reply-To: <CAE9FiQXMJB4rxAanWxAFtXKYUG6WhDbDq+VHQ7eeEuUuy6oD3w@mail.gmail.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com> <CAE9FiQXMOc_df4V9SZjoy0BymG0hy8=KnsRetFP7Wi=jZXt8yg@mail.gmail.com> <CAE9FiQXMJB4rxAanWxAFtXKYUG6WhDbDq+VHQ7eeEuUuy6oD3w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [PATCH v2] x86/power/64: Support unaligned addresses for temporary mapping
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Monday, August 08, 2016 12:23:33 AM Yinghai Lu wrote:
> On Mon, Aug 8, 2016 at 12:06 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >>> At the same time, set_up_temporary_text_mapping could be replaced with
> >>> kernel_ident_mapping_init() too if restore_jump_address is KVA for
> >>> jump_address_phys.
> >>
> >> I see no reason to do that.
> >>
> >> First, it is not guaranteed that restore_jump_address will always be a KVA for
> >> jump_address_phys and second, it really is only necessary to map one PMD in
> >> there.
> >
> > With your v2 version, you could pass difference between restore_jump_address and
> > jump_address_phys as info->off ?
> > With that, we can kill more lines if replace with
> > set_up_temporary_text_mapping with
> > kernel_ident_mapping_init() and make code more readable.
> >
> > But just keep that in separated patch after your v2 patch.
> 
> like:
> 
> ---
>  arch/x86/power/hibernate_64.c |   55 ++++++++++++------------------------------
>  1 file changed, 17 insertions(+), 38 deletions(-)
> 
> Index: linux-2.6/arch/x86/power/hibernate_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/power/hibernate_64.c
> +++ linux-2.6/arch/x86/power/hibernate_64.c
> @@ -41,42 +41,6 @@ unsigned long temp_level4_pgt __visible;
> 
>  unsigned long relocated_restore_code __visible;
> 
> -static int set_up_temporary_text_mapping(pgd_t *pgd)
> -{
> -    pmd_t *pmd;
> -    pud_t *pud;
> -
> -    /*
> -     * The new mapping only has to cover the page containing the image
> -     * kernel's entry point (jump_address_phys), because the switch over to
> -     * it is carried out by relocated code running from a page allocated
> -     * specifically for this purpose and covered by the identity mapping, so
> -     * the temporary kernel text mapping is only needed for the final jump.
> -     * Moreover, in that mapping the virtual address of the image kernel's
> -     * entry point must be the same as its virtual address in the image
> -     * kernel (restore_jump_address), so the image kernel's
> -     * restore_registers() code doesn't find itself in a different area of
> -     * the virtual address space after switching over to the original page
> -     * tables used by the image kernel.
> -     */
> -    pud = (pud_t *)get_safe_page(GFP_ATOMIC);
> -    if (!pud)
> -        return -ENOMEM;
> -
> -    pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
> -    if (!pmd)
> -        return -ENOMEM;
> -
> -    set_pmd(pmd + pmd_index(restore_jump_address),
> -        __pmd((jump_address_phys & PMD_MASK) | __PAGE_KERNEL_LARGE_EXEC));
> -    set_pud(pud + pud_index(restore_jump_address),
> -        __pud(__pa(pmd) | _KERNPG_TABLE));
> -    set_pgd(pgd + pgd_index(restore_jump_address),
> -        __pgd(__pa(pud) | _KERNPG_TABLE));
> -
> -    return 0;
> -}
> -
>  static void *alloc_pgt_page(void *context)
>  {
>      return (void *)get_safe_page(GFP_ATOMIC);
> @@ -87,7 +51,6 @@ static int set_up_temporary_mappings(voi
>      struct x86_mapping_info info = {
>          .alloc_pgt_page    = alloc_pgt_page,
>          .pmd_flag    = __PAGE_KERNEL_LARGE_EXEC,
> -        .offset        = __PAGE_OFFSET,
>      };
>      unsigned long mstart, mend;
>      pgd_t *pgd;
> @@ -99,11 +62,27 @@ static int set_up_temporary_mappings(voi
>          return -ENOMEM;
> 
>      /* Prepare a temporary mapping for the kernel text */
> -    result = set_up_temporary_text_mapping(pgd);
> +    /*
> +     * The new mapping only has to cover the page containing the image
> +     * kernel's entry point (jump_address_phys), because the switch over to
> +     * it is carried out by relocated code running from a page allocated
> +     * specifically for this purpose and covered by the identity mapping, so
> +     * the temporary kernel text mapping is only needed for the final jump.
> +     * Moreover, in that mapping the virtual address of the image kernel's
> +     * entry point must be the same as its virtual address in the image
> +     * kernel (restore_jump_address), so the image kernel's
> +     * restore_registers() code doesn't find itself in a different area of
> +     * the virtual address space after switching over to the original page
> +     * tables used by the image kernel.
> +     */
> +    info.offset = restore_jump_address - jump_address_phys;
> +    result = kernel_ident_mapping_init(&info, pgd, jump_address_phys,
> +                       jump_address_phys + PMD_SIZE);
>      if (result)
>          return result;
> 
>      /* Set up the direct mapping from scratch */
> +    info.offset = __PAGE_OFFSET;
>      for (i = 0; i < nr_pfn_mapped; i++) {
>          mstart = pfn_mapped[i].start << PAGE_SHIFT;
>          mend   = pfn_mapped[i].end << PAGE_SHIFT;

OK, I see what you mean.

Looks like a good idea to me.

Thanks,
Rafael
