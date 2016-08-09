Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1470681607-36883-1-git-send-email-thgarnie@google.com>
References: <1470681607-36883-1-git-send-email-thgarnie@google.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 9 Aug 2016 09:00:04 -0700
Message-ID: <CAJcbSZFOMJkXNJX-eMCgyesp71+j+MZTteuS9gBUjpHL=u_sZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/2] x86/KASLR: Fix physical memory calculation on
 KASLR memory randomization
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Thomas Garnier <thgarnie@google.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 8, 2016 at 11:40 AM, Thomas Garnier <thgarnie@google.com> wrote:
> Initialize KASLR memory randomization after max_pfn is initialized. Also
> ensure the size is rounded up. Could have create problems on machines
> with more than 1Tb of memory on certain random addresses.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

I will send a new version of this PATCH soon. The test bot found
places where virtual addresses were computed before PAGE_OFFSET was
set. I will investigate that.

> ---
> Based on next-20160805
> ---
>  arch/x86/kernel/setup.c | 4 ++--
>  arch/x86/mm/kaslr.c     | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index bcabb88..8dda0ce 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -936,8 +936,6 @@ void __init setup_arch(char **cmdline_p)
>
>         x86_init.oem.arch_setup();
>
> -       kernel_randomize_memory();
> -
>         iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
>         setup_memory_map();
>         parse_setup_data();
> @@ -1071,6 +1069,8 @@ void __init setup_arch(char **cmdline_p)
>         high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
>  #endif
>
> +       kernel_randomize_memory();
> +
>         /*
>          * Find and reserve possible boot-time SMP configuration:
>          */
> diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
> index 26dccd6..ec8654f 100644
> --- a/arch/x86/mm/kaslr.c
> +++ b/arch/x86/mm/kaslr.c
> @@ -97,7 +97,7 @@ void __init kernel_randomize_memory(void)
>          * add padding if needed (especially for memory hotplug support).
>          */
>         BUG_ON(kaslr_regions[0].base != &page_offset_base);
> -       memory_tb = ((max_pfn << PAGE_SHIFT) >> TB_SHIFT) +
> +       memory_tb = DIV_ROUND_UP(max_pfn << PAGE_SHIFT, 1UL << TB_SHIFT) +
>                 CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
>
>         /* Adapt phyiscal memory region size based on available memory */
> --
> 2.8.0.rc3.226.g39d4020
>
