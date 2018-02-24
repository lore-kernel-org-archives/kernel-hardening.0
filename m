Subject: Re: [PATCH 2/2] gcc-plugins: stackleak: Update for gcc-8
References: <20180222231442.29507-1-labbott@redhat.com>
 <20180222231442.29507-3-labbott@redhat.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <b579d073-7d7a-366c-77fa-08ad170e1913@linux.com>
Date: Sat, 24 Feb 2018 17:04:06 +0300
MIME-Version: 1.0
In-Reply-To: <20180222231442.29507-3-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: Will Deacon <will.deacon@arm.com>, richard.sandiford@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hello Laura,

Thanks for the cooperation!

On 23.02.2018 02:14, Laura Abbott wrote:
> +#if BUILDING_GCC_VERSION >= 8000
> +bool check_frame_size()
> +{
> +	return maybe_ge(get_frame_size(), track_frame_size);

After looking through this guide
https://gcc.gnu.org/onlinedocs//gccint/Guidelines-for-using-poly_005fint.html#Guidelines-for-using-poly_005fint
it seems to me that we should better use something like that:

poly_int64 frame_size = get_frame_size();

if (frame_size.to_constant() >= track_frame_size)
	return 0;

May I ask for your opinion?

> +}
> +#else
> +bool check_frame_size()
> +{
> +	return get_frame_size() >= track_frame_size;
> +}
> +#endif
>  /*
>   * Work with the RTL representation of the code.
>   * Remove the unneeded track_stack() calls from the functions which don't
> @@ -215,7 +237,7 @@ static unsigned int stackleak_final_execute(void)
>  	if (cfun->calls_alloca)
>  		return 0;
>  
> -	if (get_frame_size() >= track_frame_size)
> +	if (check_frame_size())
>  		return 0;
>  

Best regards,
Alexander
