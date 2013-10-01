Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524B34B9.4020504@zytor.com>
Date: Tue, 01 Oct 2013 13:46:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1380656245-29975-1-git-send-email-keescook@chromium.org> <1380656245-29975-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1380656245-29975-5-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/7] x86, kaslr: select random base offset
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kernel-hardening@lists.openwall.com, adurbin@google.com, Eric Northup <digitaleric@google.com>, jln@google.com, wad@google.com, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10/01/2013 12:37 PM, Kees Cook wrote:
> +
> +#include <asm/archrandom.h>
> +static inline int rdrand(unsigned long *v)
> +{
> +	int ok;
> +	asm volatile("1: " RDRAND_LONG "\n\t"
> +		     "jc 2f\n\t"
> +		     "decl %0\n\t"
> +		     "jnz 1b\n\t"
> +		     "2:"
> +		     : "=r" (ok), "=a" (*v)
> +		     : "0" (RDRAND_RETRY_LOOPS));
> +	return ok;
> +}
> +

This looks just like rdrand_long() in arch/x86/kernel/cpu/rdrand.c and
could move into the header file, no?

	-hpa
