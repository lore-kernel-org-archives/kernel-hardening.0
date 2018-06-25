Subject: Re: [PATCH v5 27/27] x86/kaslr: Add option to extend KASLR range from
 1GB to 3GB
References: <20180625224014.134829-1-thgarnie@google.com>
 <20180625224014.134829-28-thgarnie@google.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <38e10823-8916-66d0-7fe9-1fe465a9c5e0@infradead.org>
Date: Mon, 25 Jun 2018 16:41:09 -0700
MIME-Version: 1.0
In-Reply-To: <20180625224014.134829-28-thgarnie@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Thomas Garnier <thgarnie@google.com>, kernel-hardening@lists.openwall.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Matthias Kaehlcke <mka@chromium.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tom Lendacky <thomas.lendacky@amd.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, Kees Cook <keescook@chromium.org>, Baoquan He <bhe@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>, "=?UTF-8?Q?Jan_H._Sch=c3=b6nherr?=" <jschoenh@amazon.de>, Kate Stewart <kstewart@linuxfoundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@suse.de>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 06/25/18 15:39, Thomas Garnier wrote:
> Add a new CONFIG_RANDOMIZE_BASE_LARGE option to benefit from PIE
> support. It increases the KASLR range from 1GB to 3GB. The new range
> stars at 0xffffffff00000000 just above the EFI memory region. This
> option is off by default.
> 
> The boot code is adapted to create the appropriate page table spanning
> three PUD pages.
> 
> The relocation table uses 64-bit integers generated with the updated
> relocation tool with the large-reloc option.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/Kconfig                     | 21 +++++++++++++++++++++
>  arch/x86/boot/compressed/Makefile    |  5 +++++
>  arch/x86/boot/compressed/misc.c      | 10 +++++++++-
>  arch/x86/include/asm/page_64_types.h |  9 +++++++++
>  arch/x86/kernel/head64.c             | 15 ++++++++++++---
>  arch/x86/kernel/head_64.S            | 11 ++++++++++-
>  6 files changed, 66 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 42f77aff5df1..f6cb20a66e8a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2236,6 +2236,27 @@ config X86_PIE
>  	select DYNAMIC_MODULE_BASE
>  	select MODULE_REL_CRCS if MODVERSIONS
>  
> +config RANDOMIZE_BASE_LARGE
> +	bool "Increase the randomization range of the kernel image"
> +	depends on X86_64 && RANDOMIZE_BASE
> +	select X86_PIE
> +	select X86_MODULE_PLTS if MODULES
> +	default n
> +	---help---
> +	  Build the kernel as a Position Independent Executable (PIE) and
> +	  increase the available randomization range from 1GB to 3GB.
> +
> +	  This option impacts performance on kernel CPU intensive workloads up
> +	  to 10% due to PIE generated code. Impact on user-mode processes and
> +	  typical usage would be significantly less (0.50% when you build the

how about:
	                                            (0.5% during a kernel build).

> +	  kernel).
> +
> +	  The kernel and modules will generate slightly more assembly (1 to 2%
> +	  increase on the .text sections). The vmlinux binary will be
> +	  significantly smaller due to less relocations.

preferably s/less/fewer/

> +
> +	  If unsure say N
> +
>  config HOTPLUG_CPU
>  	bool "Support for hot-pluggable CPUs"
>  	depends on SMP


-- 
~Randy
