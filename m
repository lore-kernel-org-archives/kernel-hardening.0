Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 10:19:48 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128091948.q4d5oolkpuw4cbts@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703974000.26578.2874964402485950653.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151703974000.26578.2874964402485950653.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 05/12] x86, __get_user: use __uaccess_begin_nospec
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


* Dan Williams <dan.j.williams@intel.com> wrote:

> Quoting Linus:
> 
>     I do think that it would be a good idea to very expressly document
>     the fact that it's not that the user access itself is unsafe. I do
>     agree that things like "get_user()" want to be protected, but not
>     because of any direct bugs or problems with get_user() and friends,
>     but simply because get_user() is an excellent source of a pointer
>     that is obviously controlled from a potentially attacking user
>     space. So it's a prime candidate for then finding _subsequent_
>     accesses that can then be used to perturb the cache.
> 
> '__uaccess_begin_nospec' covers '__get_user' and 'copy_from_iter' where
> the limit check is far away from the user pointer de-reference. In those
> cases an 'lfence' prevents speculation with a potential pointer to
> privileged memory.

(Same style comments as for the previous patches)

> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Andi Kleen <ak@linux.intel.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: x86@kernel.org
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/include/asm/uaccess.h    |    6 +++---
>  arch/x86/include/asm/uaccess_32.h |    6 +++---
>  arch/x86/include/asm/uaccess_64.h |   12 ++++++------
>  arch/x86/lib/usercopy_32.c        |    8 ++++----
>  4 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
> index 626caf58183a..a930585fa3b5 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -450,7 +450,7 @@ do {									\
>  ({									\
>  	int __gu_err;							\
>  	__inttype(*(ptr)) __gu_val;					\
> -	__uaccess_begin();						\
> +	__uaccess_begin_nospec();					\
>  	__get_user_size(__gu_val, (ptr), (size), __gu_err, -EFAULT);	\
>  	__uaccess_end();						\
>  	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
> @@ -557,7 +557,7 @@ struct __large_struct { unsigned long buf[100]; };
>   *	get_user_ex(...);
>   * } get_user_catch(err)
>   */
> -#define get_user_try		uaccess_try
> +#define get_user_try		uaccess_try_nospec
>  #define get_user_catch(err)	uaccess_catch(err)
>  
>  #define get_user_ex(x, ptr)	do {					\
> @@ -591,7 +591,7 @@ extern void __cmpxchg_wrong_size(void)
>  	__typeof__(ptr) __uval = (uval);				\
>  	__typeof__(*(ptr)) __old = (old);				\
>  	__typeof__(*(ptr)) __new = (new);				\
> -	__uaccess_begin();						\
> +	__uaccess_begin_nospec();					\

>  	else
>  		n = __copy_user_intel(to, from, n);
> -	clac();
> +	__uaccess_end();

>  	return n;
>  }
>  EXPORT_SYMBOL(__copy_user_ll);
> @@ -344,7 +344,7 @@ EXPORT_SYMBOL(__copy_user_ll);
>  unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *from,
>  					unsigned long n)
>  {
> -	stac();
> +	__uaccess_begin_nospec();
>  #ifdef CONFIG_X86_INTEL_USERCOPY
>  	if (n > 64 && static_cpu_has(X86_FEATURE_XMM2))
>  		n = __copy_user_intel_nocache(to, from, n);
> @@ -353,7 +353,7 @@ unsigned long __copy_from_user_ll_nocache_nozero(void *to, const void __user *fr
>  #else
>  	__copy_user(to, from, n);
>  #endif
> -	clac();
> +	__uaccess_end();
>  	return n;
>  }
>  EXPORT_SYMBOL(__copy_from_user_ll_nocache_nozero);
> 

These three chunks appears to be unrelated changes changing open-coded clac()s to 
__uaccess_end() calls correctly: please split these out into a separate patch.

Thanks,

	Ingo
