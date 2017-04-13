From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1490730347-5165-1-git-send-email-bhsharma@redhat.com>
References: <1490730347-5165-1-git-send-email-bhsharma@redhat.com>
Date: Thu, 13 Apr 2017 12:06:27 +0530
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <87shlcq0es.fsf@skywalker.in.ibm.com>
Subject: [kernel-hardening] Re: [PATCH v3] powerpc: mm: support ARCH_MMAP_RND_BITS
To: Bhupesh Sharma <bhsharma@redhat.com>, linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: alistair@popple.id.au, agust@denx.de, keescook@chromium.org, dcashman@android.com, oss@buserror.net, paulus@samba.org, dcashman@google.com, bhupesh.linux@gmail.com, agraf@suse.com
List-ID: <kernel-hardening.lists.openwall.com>

Bhupesh Sharma <bhsharma@redhat.com> writes:

> powerpc arch_mmap_rnd() currently uses hard-coded values - (23-PAGE_SHIFT) for
> 32-bit and (30-PAGE_SHIFT) for 64-bit, to generate the random offset
> for the mmap base address for a ASLR ELF.
>
> This patch makes sure that powerpc mmap arch_mmap_rnd() implementation
> is similar to other ARCHs (like x86, arm64) and uses mmap_rnd_bits
> and helpers to generate the mmap address randomization.
>
> The maximum and minimum randomization range values represent
> a compromise between increased ASLR effectiveness and avoiding
> address-space fragmentation.
>
> Using the Kconfig option and suitable /proc tunable, platform
> developers may choose where to place this compromise.
>
> Also this patch keeps the default values as new minimums.
>
> Signed-off-by: Bhupesh Sharma <bhsharma@redhat.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
> * Changes since v2:
> v2 can be seen here (https://patchwork.kernel.org/patch/9551509/)
>     - Changed a few minimum and maximum randomization ranges as per Michael's suggestion.
>     - Corrected Kees's email address in the Reviewed-by line.
>     - Added further comments in kconfig to explain how the address ranges were worked out.
>
> * Changes since v1:
> v1 can be seen here (https://lists.ozlabs.org/pipermail/linuxppc-dev/2017-February/153594.html)
>     - No functional change in this patch.
>     - Dropped PATCH 2/2 from v1 as recommended by Kees Cook.
>
>  arch/powerpc/Kconfig   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  arch/powerpc/mm/mmap.c |  7 ++++---
>  2 files changed, 48 insertions(+), 3 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 97a8bc8..84aae67 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -22,6 +22,48 @@ config MMU
>  	bool
>  	default y
>  
> +# min bits determined by the following formula:
> +# VA_BITS - PAGE_SHIFT - CONSTANT
> +# where,
> +# 	VA_BITS = 46 bits for 64BIT and 4GB - 1 Page = 31 bits for 32BIT


Where did we derive that 46 bits from ? is that based on TASK_SIZE ?


> +# 	CONSTANT = 16 for 64BIT and 8 for 32BIT
> +config ARCH_MMAP_RND_BITS_MIN
> +       default 5 if PPC_256K_PAGES && 32BIT  # 31 - 18 - 8 = 5
> +       default 7 if PPC_64K_PAGES && 32BIT   # 31 - 16 - 8 = 7
> +       default 9 if PPC_16K_PAGES && 32BIT   # 31 - 14 - 8 = 9
> +       default 11 if PPC_4K_PAGES && 32BIT   # 31 - 12 - 8 = 11
> +       default 12 if PPC_256K_PAGES && 64BIT # 46 - 18 - 16 = 12
> +       default 14 if PPC_64K_PAGES && 64BIT  # 46 - 16 - 16 = 14
> +       default 16 if PPC_16K_PAGES && 64BIT  # 46 - 14 - 16 = 16
> +       default 18 if PPC_4K_PAGES && 64BIT   # 46 - 12 - 16 = 18
> +
> +# max bits determined by the following formula:


-aneesh
