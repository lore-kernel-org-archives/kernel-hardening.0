Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1467132211.24287.31.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 28 Jun 2016 09:43:31 -0700
In-Reply-To: <20160628133645.8f3cac0df4fc363e308426ac@gmail.com>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
	 <20160628133645.8f3cac0df4fc363e308426ac@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v1 2/2] Mark functions with the __nocapture attribute
To: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2016-06-28 at 13:36 +0200, Emese Revfy wrote:
> The nocapture gcc attribute can be on functions only.
> The attribute takes one or more unsigned integer constants as parameters
> that specify the function argument(s) of const char* type to initify.

Perhaps this should be const <type>*
> diff --git a/arch/arm/include/asm/string.h b/arch/arm/include/asm/string.h
[]
> @@ -7,19 +7,19 @@
[]
>  #define __HAVE_ARCH_MEMCPY
> -extern void * memcpy(void *, const void *, __kernel_size_t);
> +extern void * memcpy(void *, const void *, __kernel_size_t) __nocapture(2);
