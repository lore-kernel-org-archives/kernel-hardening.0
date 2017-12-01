References: <20171201201000.GA44539@beast>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <653e978c-5930-723d-001d-019868af29fd@redhat.com>
Date: Fri, 1 Dec 2017 12:46:36 -0800
MIME-Version: 1.0
In-Reply-To: <20171201201000.GA44539@beast>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] Kconfig: Make STRICT_DEVMEM default-y on x86 and arm64
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 12/01/2017 12:10 PM, Kees Cook wrote:
> Distros have been shipping with CONFIG_STRICT_DEVMEM=y for years now. It
> is probably time to flip this default for x86 and arm64.
> 

With my Fedora hat on,

Acked-by: Laura Abbott <labbott@redhat.com

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   lib/Kconfig.debug | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 947d3e2ed5c2..39b123d04a36 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1985,7 +1985,7 @@ config STRICT_DEVMEM
>   	bool "Filter access to /dev/mem"
>   	depends on MMU && DEVMEM
>   	depends on ARCH_HAS_DEVMEM_IS_ALLOWED
> -	default y if TILE || PPC
> +	default y if TILE || PPC || X86 || ARM64
>   	---help---
>   	  If this option is disabled, you allow userspace (root) access to all
>   	  of memory, including kernel and userspace memory. Accidental
> 
