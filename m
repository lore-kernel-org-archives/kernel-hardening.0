MIME-Version: 1.0
In-Reply-To: <1486603856-27642-1-git-send-email-kys@exchange.microsoft.com>
References: <1486603856-27642-1-git-send-email-kys@exchange.microsoft.com>
From: Kees Cook <keescook@google.com>
Date: Wed, 8 Feb 2017 20:44:59 -0800
Message-ID: <CAGXu5jLgeozusibh7fhckjjfbUXnrMGZ6q2ztajc8r-EcUp_dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 1/1] Ddrivers: hv: Turn off write permission on the
 hypercall page
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org, Olaf Hering <olaf@aepfle.de>, Andy Whitcroft <apw@canonical.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Jason Wang <jasowang@redhat.com>, Leann Ogasawara <leann.ogasawara@canonical.com>, Stephen Hemminger <stephen@networkplumber.org>, Stephen Smalley <sds@tycho.nsa.gov>, "x86@kernel.org" <x86@kernel.org>, Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 8, 2017 at 5:30 PM,  <kys@exchange.microsoft.com> wrote:
> From: K. Y. Srinivasan <kys@microsoft.com>
>
> The hypercall page only needs to be executable but currently it is setup to
> be writable as well. Fix the issue.
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/hyperv/hv_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
> index c224b7d..db64baf 100644
> --- a/arch/x86/hyperv/hv_init.c
> +++ b/arch/x86/hyperv/hv_init.c
> @@ -125,7 +125,7 @@ void hyperv_init(void)
>         guest_id = generate_guest_id(0, LINUX_VERSION_CODE, 0);
>         wrmsrl(HV_X64_MSR_GUEST_OS_ID, guest_id);
>
> -       hypercall_pg  = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_EXEC);
> +       hypercall_pg  = __vmalloc(PAGE_SIZE, GFP_KERNEL, PAGE_KERNEL_RX);
>         if (hypercall_pg == NULL) {
>                 wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
>                 return;
> --
> 1.7.1
>

Acked-by: Kees Cook <keescook@chromium.org>

This does beg the question: why is PAGE_KERNEL_EXEC defined at all?
The only permissions available should be _RO, _RW, or _RX... Current
users in arch/x86:

kernel/machine_kexec_32.c:      set_pte(pte, pfn_pte(paddr >>
PAGE_SHIFT, PAGE_KERNEL_EXEC));
kernel/machine_kexec_64.c:      set_pte(pte, pfn_pte(paddr >>
PAGE_SHIFT, PAGE_KERNEL_EXEC));
kernel/module.c:                                    PAGE_KERNEL_EXEC,
0, NUMA_NO_NODE,
kernel/tboot.c:         if (map_tboot_page(vaddr, start_pfn, PAGE_KERNEL_EXEC))
mm/init_32.c:                                   prot = PAGE_KERNEL_EXEC;
power/hibernate_32.c:                                   set_pte(pte,
pfn_pte(pfn, PAGE_KERNEL_EXEC));
xen/mmu.c:                      pte = pfn_pte(pfn, PAGE_KERNEL_EXEC);

and vmalloc_exec...

void *vmalloc_exec(unsigned long size)
{
        return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM,
PAGE_KERNEL_EXEC,
                              NUMA_NO_NODE, __builtin_return_address(0));
}

which is only ever used by module_alloc(), and the module code knows
how to make things RW, RO, and RX correctly. (Though on x86,
module_alloc() is overridden, but it still uses PAGE_KERNEL_EXEC.)

Seems like x86 should drop PAGE_KERNEL_EXEC, and vmalloc_exec should
use PAGE_KERNEL... ?

Or better yet, drop PAGE_KERNEL_EXEC globally and rename PAGE_KERNEL
to PAGE_KERNEL_RW.

-Kees

-- 
Kees Cook
Pixel Security
