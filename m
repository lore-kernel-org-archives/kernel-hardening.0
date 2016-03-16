Reply-To: kernel-hardening@lists.openwall.com
References: <20160310173144.GA25532@www.outflux.net>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <56E9B860.2060802@de.ibm.com>
Date: Wed, 16 Mar 2016 20:47:44 +0100
MIME-Version: 1.0
In-Reply-To: <20160310173144.GA25532@www.outflux.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] s390: disable postinit-readonly for now
To: Kees Cook <keescook@chromium.org>, Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/10/2016 06:31 PM, Kees Cook wrote:
> This is a temporary fix to let lkdtm run again on s390, though it'll
> still fail the ro_after_init tests. Until rodata and ro_after_init
> sections can be split on s390, disable special handling of ro_after_init.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> for -next ...

Given that the other patches are already merged in linus master via Ingo,
do you want this to go via Ingo as well?

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
> 
