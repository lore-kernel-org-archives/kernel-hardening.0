Reply-To: kernel-hardening@lists.openwall.com
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <57F2B105.9050400@intel.com>
Date: Mon, 3 Oct 2016 12:27:01 -0700
MIME-Version: 1.0
In-Reply-To: <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation for
 HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/02/2016 11:41 PM, Elena Reshetova wrote:
>  static __always_inline void atomic_add(int i, atomic_t *v)
>  {
> -	asm volatile(LOCK_PREFIX "addl %1,%0"
> +	asm volatile(LOCK_PREFIX "addl %1,%0\n"
> +
> +#ifdef CONFIG_HARDENED_ATOMIC
> +		     "jno 0f\n"
> +		     LOCK_PREFIX "subl %1,%0\n"
> +		     "int $4\n0:\n"
> +		     _ASM_EXTABLE(0b, 0b)
> +#endif
> +
> +		     : "+m" (v->counter)
> +		     : "ir" (i));
> +}

Rather than doing all this assembly and exception stuff, could we just do:

static __always_inline void atomic_add(int i, atomic_t *v)
{
	if (atomic_add_unless(v, a, INT_MAX))
		BUG_ON_OVERFLOW_FOO()...
}

That way, there's also no transient state where somebody can have
observed the overflow before it is fixed up.  Granted, this
cmpxchg-based operation _is_ more expensive than the fast-path locked addl.
