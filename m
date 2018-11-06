Date: Tue, 6 Nov 2018 22:04:03 +0000
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 1/2] arm64: mm: purge lazily unmapped vm regions
 before changing permissions
Message-ID: <20181106220359.GA32210@brain-police>
References: <20181106214404.2497-1-ard.biesheuvel@linaro.org>
 <20181106214404.2497-2-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106214404.2497-2-ard.biesheuvel@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, keescook@chromium.org, kernel-hardening@lists.openwall.com, labbott@redhat.com, jannh@google.com, mark.rutland@arm.com, james.morse@arm.com, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 06, 2018 at 10:44:03PM +0100, Ard Biesheuvel wrote:
> Call vm_unmap_aliases() every time we apply any changes to permission
> attributes of mappings in the vmalloc region. This avoids any potential
> issues resulting from lingering writable or executable aliases of
> mappings that should be read-only or non-executable, respectively.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/mm/pageattr.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index a56359373d8b..f8cf5bc1d1f8 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -93,6 +93,12 @@ static int change_memory_common(unsigned long addr, int numpages,
>  	if (!numpages)
>  		return 0;
>  
> +	/*
> +	 * Get rid of potentially aliasing lazily unmapped vm areas that may
> +	 * have permissions set that deviate from the ones we are setting here.
> +	 */
> +	vm_unmap_aliases();

So this might_sleep(), which I don't think is currently the case for our
set_memory_XX() functions. However, a quick look at the existing callsites
indicates that's ok and matches the x86 implementation, so:

Acked-by: Will Deacon <will.deacon@arm.com>

Will
