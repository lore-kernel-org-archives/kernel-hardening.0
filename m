Date: Mon, 14 Aug 2017 12:59:59 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20170814115958.dqg2xrobls4jcgx3@armageddon.cambridge.arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
 <1502130965-18710-6-git-send-email-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502130965-18710-6-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [PATCH 05/14] arm64: clean up THREAD_* definitions
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, kernel-hardening@lists.openwall.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, luto@amacapital.net, james.morse@arm.com, labbott@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 07, 2017 at 07:35:56PM +0100, Mark Rutland wrote:
> Currently we define THREAD_SIZE and THREAD_SIZE order separately, with

s/THREAD_SIZE order/THREAD_SIZE_ORDER/

> the latter dependent on particular CONFIG_ARM64_*K_PAGES definitions.
> This is somewhat opaque, and will get in the way of future modifications
> to THREAD_SIZE.
> 
> This patch cleans this up, defining both in terms of a common
> THREAD_SHIFT, and using PAGE_SHIFT to calculate THREAD_SIZE_ORDER,
> rather than using a number of definitions dependent on config symbols.
> Subsequent patches will make use of this to alter the stack size used in
> some configurations.
> 
> At the same time, these are moved into <asm/memory.h>, which will avoid
> circular include issues in subsequent patches. To ensure that existing
> code isn't adversely affected, <asm/thread_info.h> is updated to
> transitively include these definitions.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/memory.h      | 8 ++++++++
>  arch/arm64/include/asm/thread_info.h | 9 +--------
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index 77d55dc..8ab4774 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -102,6 +102,14 @@
>  #define KASAN_SHADOW_SIZE	(0)
>  #endif
>  
> +#define THREAD_SHIFT		14
> +
> +#if THREAD_SHIFT >= PAGE_SHIFT
> +#define THREAD_SIZE_ORDER	(THREAD_SHIFT - PAGE_SHIFT)
> +#endif
> +
> +#define THREAD_SIZE		(UL(1) << THREAD_SHIFT)

I haven't tried the series to this patch but it seems to me that
THREAD_SIZE_ORDER is undefined for a PAGE_SHIFT of 16. Without
VMAP_STACKS, it may fail to build.

-- 
Catalin
