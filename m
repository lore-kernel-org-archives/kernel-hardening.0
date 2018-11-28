Subject: Re: [PATCH 2/4] powerpc/64: Setup KUP before feature fixups
References: <20181122140416.3447-1-ruscur@russell.cc>
 <20181122140416.3447-3-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <d05cc770-8104-6920-9ccf-a3d146438f02@c-s.fr>
Date: Wed, 28 Nov 2018 09:38:39 +0000
MIME-Version: 1.0
In-Reply-To: <20181122140416.3447-3-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 11/22/2018 02:04 PM, Russell Currey wrote:
> The subsequent implementation of KUAP for radix makes use of a MMU
> feature in order to patch out assembly when KUAP is disabled or
> unsupported.  This won't work unless there's an entry point for
> KUP support before the feature magic happens, so relocate
> setup_kup() earlier in setup.
> 
> Signed-off-by: Russell Currey <ruscur@russell.cc>

I squashed it in my RFC v2

Christophe

> ---
>   arch/powerpc/kernel/setup_64.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
> index 0f4e06ab70a5..cc20dc3e7b69 100644
> --- a/arch/powerpc/kernel/setup_64.c
> +++ b/arch/powerpc/kernel/setup_64.c
> @@ -331,6 +331,12 @@ void __init early_setup(unsigned long dt_ptr)
>   	 */
>   	configure_exceptions();
>   
> +	/*
> +	 * Configure Kernel Userspace Protection. This needs to happen before
> +	 * feature fixups for platforms that implement this using features.
> +	 */
> +	setup_kup();
> +
>   	/* Apply all the dynamic patching */
>   	apply_feature_fixups();
>   	setup_feature_keys();
> @@ -372,7 +378,6 @@ void __init early_setup(unsigned long dt_ptr)
>   	 */
>   	btext_map();
>   #endif /* CONFIG_PPC_EARLY_DEBUG_BOOTX */
> -	setup_kup();
>   }
>   
>   #ifdef CONFIG_SMP
> 
