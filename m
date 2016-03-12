Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 12 Mar 2016 12:15:40 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Message-ID: <20160312111540.GA17395@osiris>
References: <20160310173144.GA25532@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160310173144.GA25532@www.outflux.net>
Subject: [kernel-hardening] Re: [PATCH] s390: disable postinit-readonly for now
To: Kees Cook <keescook@chromium.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 10, 2016 at 09:31:44AM -0800, Kees Cook wrote:
> This is a temporary fix to let lkdtm run again on s390, though it'll
> still fail the ro_after_init tests. Until rodata and ro_after_init
> sections can be split on s390, disable special handling of ro_after_init.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> for -next ...
> ---
>  arch/s390/include/asm/cache.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/s390/include/asm/cache.h b/arch/s390/include/asm/cache.h
> index 4d7ccac5fd1d..22da3b34c655 100644
> --- a/arch/s390/include/asm/cache.h
> +++ b/arch/s390/include/asm/cache.h
> @@ -15,4 +15,7 @@
> 
>  #define __read_mostly __attribute__((__section__(".data..read_mostly")))
> 
> +/* Read-only memory is marked before mark_rodata_ro() is called. */
> +#define __ro_after_init __read_mostly
> +
>  #endif

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
