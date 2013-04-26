Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <517AF6A5.7070507@zytor.com>
Date: Fri, 26 Apr 2013 14:50:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1367003005-5560-1-git-send-email-keescook@chromium.org> <1367003005-5560-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1367003005-5560-5-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/6] x86: kaslr: select random base offset
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/26/2013 12:03 PM, Kees Cook wrote:
> +
> +static unsigned long get_random_long(void)
> +{
> +	if (has_cpuflag(X86_FEATURE_RDRAND)) {
> +		unsigned long random;
> +
> +		debug_putstr("KASLR using RDRAND...\n");
> +		if (rdrand(&random))
> +			return random;
> +	}
> +
> +	if (has_cpuflag(X86_FEATURE_TSC)) {
> +		uint32_t raw;
> +		unsigned long timer;
> +
> +		debug_putstr("KASLR using RDTSC...\n");
> +		rdtscl(raw);
> +
> +		/* Repeat the low bits of rdtsc. */
> +		timer = raw & 0xffff;
> +		timer |= (timer << 16);
> +#ifdef CONFIG_X86_64
> +		timer |= (timer << 32) | (timer << 48);
> +#endif
> +

This seems like a very odd thing to do.  If you want to scramble bits,
it would make more sense to do a multiply -- or much better, a
*circular* multiply -- with a large constant.

> +		return timer;
> +	}
> +
> +	debug_putstr("KASLR found no entropy source...\n");
> +	return 0;
> +}
>  

It might be safe to assume that anything old enough to lack RDTSC
(basically a 486) will have an 8254, and reading back the 8254 counter
register.

	-hpa
