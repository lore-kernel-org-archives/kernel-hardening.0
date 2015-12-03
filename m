Reply-To: kernel-hardening@lists.openwall.com
References: <20151202202725.GA794@www.outflux.net>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <565F8732.5050402@redhat.com>
Date: Wed, 2 Dec 2015 16:05:06 -0800
MIME-Version: 1.0
In-Reply-To: <20151202202725.GA794@www.outflux.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] ARM: mm: flip priority of CONFIG_DEBUG_RODATA
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Nicolas Pitre <nico@linaro.org>, Arnd Bergmann <arnd@arndb.de>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 12/02/2015 12:27 PM, Kees Cook wrote:
> The use of CONFIG_DEBUG_RODATA is generally seen as an essential part of
> kernel self-protection:
> http://www.openwall.com/lists/kernel-hardening/2015/11/30/13
> Additionally, its name has grown to mean things beyond just rodata. To
> get ARM closer to this, we ought to rearrange the names of the configs
> that control how the kernel protects its memory. What was called
> CONFIG_ARM_KERNMEM_PERMS is really doing the work that other architectures
> call CONFIG_DEBUG_RODATA.
>
> This redefines CONFIG_DEBUG_RODATA to actually do the bulk of the
> ROing (and NXing). In the place of the old CONFIG_DEBUG_RODATA, use
> CONFIG_DEBUG_ALIGN_RODATA, since that's what the option does: adds
> section alignment for making rodata explicitly NX, as arm does not split
> the page tables like arm64 does without _ALIGN_RODATA.
>
> Also adds human readable names to the sections so I could more easily
> debug my typos, and makes CONFIG_DEBUG_RODATA default "y" for CPU_V7.
>
> Results in /sys/kernel/debug/kernel_page_tables for each config state:
>
>   # CONFIG_DEBUG_RODATA is not set
>   # CONFIG_DEBUG_ALIGN_RODATA is not set
>
> ---[ Kernel Mapping ]---
> 0x80000000-0x80900000           9M     RW x  SHD
> 0x80900000-0xa0000000         503M     RW NX SHD
>
>   CONFIG_DEBUG_RODATA=y
>   CONFIG_DEBUG_ALIGN_RODATA=y
>
> ---[ Kernel Mapping ]---
> 0x80000000-0x80100000           1M     RW NX SHD
> 0x80100000-0x80700000           6M     ro x  SHD
> 0x80700000-0x80a00000           3M     ro NX SHD
> 0x80a00000-0xa0000000         502M     RW NX SHD
>
>   CONFIG_DEBUG_RODATA=y
>   # CONFIG_DEBUG_ALIGN_RODATA is not set
>
> ---[ Kernel Mapping ]---
> 0x80000000-0x80100000           1M     RW NX SHD
> 0x80100000-0x80a00000           9M     ro x  SHD
> 0x80a00000-0xa0000000         502M     RW NX SHD
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Reviewed-by: Laura Abbott <labbott@fedoraproject.org>
