Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1366926860-26776-5-git-send-email-keescook@chromium.org>
References: <1366926860-26776-1-git-send-email-keescook@chromium.org>
	<1366926860-26776-5-git-send-email-keescook@chromium.org>
Date: Fri, 26 Apr 2013 08:13:53 +0200
Message-ID: <CA+rthh9QuQ-V+=Of8GB-SwqX-Z8SUEz48YLyBfbng5j3wd23Jw@mail.gmail.com>
From: Mathias Krause <minipli@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] [PATCH 4/6] x86: kaslr: select random base offset
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 25, 2013 at 11:54 PM, Kees Cook <keescook@chromium.org> wrote:
> Select a random location when CONFIG_RANDOMIZE_BASE is used, bounded
> by CONFIG_RANDOMIZE_BASE_MAX_OFFSET. Sources of randomness currently
> include RDRAND and RDTSC.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/Kconfig                |   29 +++++++++++++--
>  arch/x86/boot/compressed/aslr.c |   75 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 100 insertions(+), 4 deletions(-)
>
> [snip]
>
> diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
> index d5331ee..11a91c6 100644
> --- a/arch/x86/boot/compressed/aslr.c
> +++ b/arch/x86/boot/compressed/aslr.c
> @@ -2,18 +2,89 @@
>
>  #ifdef CONFIG_RANDOMIZE_BASE
>
> +#include <asm/archrandom.h>
> +static inline int rdrand(unsigned long *v)
> +{
> +       int ok;
> +       asm volatile("1: " RDRAND_LONG "\n\t"
> +                    "jc 2f\n\t"
> +                    "decl %0\n\t"
> +                    "jnz 1b\n\t"
> +                    "2:"
> +                    : "=r" (ok), "=a" (*v)
> +                    : "0" (RDRAND_RETRY_LOOPS));
> +       return ok;
> +}
> +
> +static inline uint32_t rdtsc(void)
> +{
> +       uint32_t timer;
> +
> +       asm volatile("rdtsc\n" : "=a" (timer));

'\n' in the assembly statement is not needed. Also, RDTSC trashes
edx/rdx as well so it should be mentioned in the clobber list, at
least.
Maybe using rdtscl() from <asm/msr.h> instead is an option?

> +
> +       return timer;
> +}
> +
> +static unsigned long get_random_long(void)
> +{
> +       if (has_cpuflag(X86_FEATURE_RDRAND)) {
> +               unsigned long random;
> +
> +               debug_putstr("KASLR using RDRAND...\n");
> +               if (rdrand(&random))
> +                       return random;
> +       }
> +
> +       if (has_cpuflag(X86_FEATURE_TSC)) {
> +               uint32_t raw;
> +               unsigned long timer;
> +
> +               debug_putstr("KASLR using RDTSC...\n");
> +               raw = rdtsc();
> +
> +               /* Repeat the low bits of rdtsc. */
> +               timer = raw & 0xffff;
> +               timer |= (timer << 16);
> +#ifdef CONFIG_X86_64
> +               timer |= (timer << 32) | (timer << 48);
> +#endif
> +
> +               return timer;
> +       }
> +
> +       debug_putstr("KASLR found no entropy source...\n");
> +       return 0;
> +}
> +
>  unsigned char *choose_kernel_location(unsigned char *hint, unsigned long size)
>  {
>         unsigned char *choice = hint;
> -       unsigned long random;
> +       unsigned long random, mask;
>
>         if (cmdline_find_option_bool("noaslr")) {
>                 debug_putstr("KASLR disabled...\n");
>                 goto out;
>         }
>
> -       /* XXX: choose random location. */
> +       random = get_random_long();
> +
> +       /* Clip off top of the range. */
> +       mask = CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1;
> +       random &= mask;
> +
> +       /* XXX: Find an appropriate E820 hole, instead of adding hint. */
> +       random += (unsigned long)hint;
> +
> +       /* XXX: Clip to E820 hole, instead of just using hint. */
> +       mask = (unsigned long)hint + CONFIG_RANDOMIZE_BASE_MAX_OFFSET;
> +       while (random + size > mask)
> +               random >>= 1;
> +
> +       /* Clip off bottom of range (via alignment). */
> +       mask = CONFIG_PHYSICAL_ALIGN - 1;
> +       random &= ~mask;
>
> +       choice = (unsigned char *)random;
>  out:
>         return choice;
>  }
> --
> 1.7.9.5
>
