Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 19 Oct 2016 10:31:10 +0200
From: Greg KH <greg@kroah.com>
Message-ID: <20161019083110.GD6447@kroah.com>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org>
 <1476802761-24340-2-git-send-email-colin@cvidal.org>
 <2236FBA76BA1254E88B949DDB74E612B41BE01A7@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BE01A7@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] RE: [RFC 1/2] Reordering / guard definition
 on atomic_*_wrap function in order to avoid implicitly defined / redefined
 error on them, when CONFIG_HARDENED_ATOMIC is unset.
To: kernel-hardening@lists.openwall.com
Cc: Colin Vidal <colin@cvidal.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 19, 2016 at 08:21:06AM +0000, Reshetova, Elena wrote:
> Signed-off-by: Colin Vidal <colin@cvidal.org>

No changelog at all?

> ---
>  include/asm-generic/atomic-long.h | 55 +++++++++++++++++++++------------------
>  include/linux/atomic.h            | 55 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 85 insertions(+), 25 deletions(-)
> 
> diff --git a/include/asm-generic/atomic-long.h b/include/asm-generic/atomic-long.h
> index 790cb00..94d712b 100644
> --- a/include/asm-generic/atomic-long.h
> +++ b/include/asm-generic/atomic-long.h
> @@ -46,6 +46,30 @@ typedef atomic_t atomic_long_wrap_t;
>  
>  #endif
>  
> +#ifndef CONFIG_HARDENED_ATOMIC
> +#define atomic_read_wrap(v) atomic_read(v) #define atomic_set_wrap(v, 
> +i) atomic_set((v), (i)) #define atomic_add_wrap(i, v) atomic_add((i), 
> +(v)) #define atomic_add_unless_wrap(v, i, j) atomic_add_unless((v), 
> +(i), (j)) #define atomic_sub_wrap(i, v) atomic_sub((i), (v)) #define 
> +atomic_inc_wrap(v) atomic_inc(v) #define atomic_inc_and_test_wrap(v) 
> +atomic_inc_and_test(v) #ifndef atomic_inc_return_wrap #define 
> +atomic_inc_return_wrap(v) atomic_inc_return(v) #endif #ifndef 
> +atomic_add_return_wrap #define atomic_add_return_wrap(i, v) 
> +atomic_add_return((i), (v)) #endif #define atomic_dec_wrap(v) 
> +atomic_dec(v) #ifndef atomic_xchg_wrap #define atomic_xchg_wrap(v, i) 
> +atomic_xchg((v), (i)) #endif #define atomic_long_inc_wrap(v) 
> +atomic_long_inc(v) #define atomic_long_dec_wrap(v) atomic_long_dec(v) 
> +#define atomic_long_xchg_wrap(v, n) atomic_long_xchg(v, n) #define 
> +atomic_long_cmpxchg_wrap(l, o, n) atomic_long_cmpxchg(l, o, n) #endif 
> +/* CONFIG_HARDENED_ATOMIC */

That doesn't look correct to me at all, does it to you?

thanks,

greg k-h
