Subject: Re: [PATCH v3 1/3] lkdtm: Check for SMEP clearing protections
References: <20190618045503.39105-1-keescook@chromium.org>
 <20190618045503.39105-2-keescook@chromium.org>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <580611da-fd97-e82e-b604-581f105416ee@rasmusvillemoes.dk>
Date: Tue, 18 Jun 2019 09:10:13 +0200
MIME-Version: 1.0
In-Reply-To: <20190618045503.39105-2-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 18/06/2019 06.55, Kees Cook wrote:

> +#else
> +	pr_err("FAIL: this test is x86_64-only\n");
> +#endif
> +}

Why expose it at all on all other architectures? If you wrap the
CRASHTYPE() in an #ifdef, you can also guard the whole lkdtm_UNSET_SMEP
definition (the declaration in lkdtm.h can stay, possibly with a comment
saying /* x86-64 only */).

> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index b51cf182b031..58cfd713f8dc 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -123,6 +123,7 @@ static const struct crashtype crashtypes[] = {
>  	CRASHTYPE(CORRUPT_LIST_ADD),
>  	CRASHTYPE(CORRUPT_LIST_DEL),
>  	CRASHTYPE(CORRUPT_USER_DS),
> +	CRASHTYPE(UNSET_SMEP),
>  	CRASHTYPE(CORRUPT_STACK),
>  	CRASHTYPE(CORRUPT_STACK_STRONG),
>  	CRASHTYPE(STACK_GUARD_PAGE_LEADING),
> diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
> index b69ee004a3f7..d7eb5a8f1da4 100644
> --- a/drivers/misc/lkdtm/lkdtm.h
> +++ b/drivers/misc/lkdtm/lkdtm.h
> @@ -26,6 +26,7 @@ void lkdtm_CORRUPT_LIST_DEL(void);
>  void lkdtm_CORRUPT_USER_DS(void);
>  void lkdtm_STACK_GUARD_PAGE_LEADING(void);
>  void lkdtm_STACK_GUARD_PAGE_TRAILING(void);
> +void lkdtm_UNSET_SMEP(void);
>  
>  /* lkdtm_heap.c */
>  void lkdtm_OVERWRITE_ALLOCATION(void);
Rasmus
