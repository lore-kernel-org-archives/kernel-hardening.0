MIME-Version: 1.0
In-Reply-To: <1487498660-16600-7-git-send-email-hoeun.ryu@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com> <1487498660-16600-7-git-send-email-hoeun.ryu@gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun, 19 Feb 2017 11:35:51 +0000
Message-ID: <CAKv+Gu9umycZm_UP99ZUifLUBb8MuOZHXgU9nB6XioVMa4eeVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC 7/7] arm64: map seperately rodata sections for
 __ro_mostly_after_init section
To: Hoeun Ryu <hoeun.ryu@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jeremy Linton <jeremy.linton@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 19 February 2017 at 10:04, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> Map rodata sections seperately for the new __ro_mostly_after_init section.
> Attribute of memory for __ro_mostly_after_init section can be changed later
> so we need a dedicated vmalloced region for set_memory_rw/ro api.
>
> Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
> ---
>  arch/arm64/mm/mmu.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 91271b1..4a89a2e 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -434,8 +434,22 @@ void mark_rodata_ro(void)
>          * mark .rodata as read only. Use __init_begin rather than __end_rodata
>          * to cover NOTES and EXCEPTION_TABLE.
>          */
> -       section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
> -       create_mapping_late(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
> +       section_size = (unsigned long)__start_data_ro_mostly_after_init -
> +               (unsigned long)__start_rodata;
> +       create_mapping_late(__pa_symbol(__start_rodata),
> +                           (unsigned long)__start_rodata,
> +                           section_size, PAGE_KERNEL_RO);
> +
> +       section_size = (unsigned long)__end_data_ro_mostly_after_init -
> +               (unsigned long)__start_data_ro_mostly_after_init;
> +       create_mapping_late(__pa_symbol(__start_data_ro_mostly_after_init),
> +                           (unsigned long)__start_data_ro_mostly_after_init,
> +                           section_size, PAGE_KERNEL_RO);
> +
> +       section_size = (unsigned long)__init_begin -
> +               (unsigned long)__end_data_ro_mostly_after_init;
> +       create_mapping_late(__pa_symbol(__end_data_ro_mostly_after_init),
> +                           (unsigned long)__end_data_ro_mostly_after_init,
>                             section_size, PAGE_KERNEL_RO);
>
>         /* flush the TLBs after updating live kernel mappings */
> @@ -478,10 +492,18 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
>   */
>  static void __init map_kernel(pgd_t *pgd)
>  {
> -       static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
> +       static struct vm_struct vmlinux_text, vmlinux_rodata1, vmlinux_rodata2, vmlinux_ro_mostly_after_init, vmlinux_init, vmlinux_data;
>
>         map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_EXEC, &vmlinux_text);
> -       map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
> +       map_kernel_segment(pgd, __start_rodata, __start_data_ro_mostly_after_init, PAGE_KERNEL, &vmlinux_rodata1);
> +       __map_kernel_segment(pgd,
> +                            __start_data_ro_mostly_after_init,
> +                            __end_data_ro_mostly_after_init,
> +                            PAGE_KERNEL,
> +                            &vmlinux_ro_mostly_after_init,
> +                            VM_MAP | VM_ALLOC);
> +       map_kernel_segment(pgd, __end_data_ro_mostly_after_init, __init_begin, PAGE_KERNEL, &vmlinux_rodata2);
> +
>         map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
>                            &vmlinux_init);
>         map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
> --
> 2.7.4
>

While it is correct that you are splitting this into three separate
segments (otherwise we would not be able to change the permissions
later without risking splitting to occur), I think this leads to
unnecessary fragmentation.

If there is demand for this feature (but you still need to make the
argument for that), I wonder if it wouldn't be sufficient, and much
more straightforward, to redefine the __ro_after_init semantics to
include the kind of subsystem registration and module init context you
are targeting, and implement some hooks to temporarily lift the
__ro_after_init r/o permission restrictions in a controlled manner.

Kees: any thoughts?
