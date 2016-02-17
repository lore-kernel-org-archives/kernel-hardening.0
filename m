Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 17 Feb 2016 22:44:12 +0100
Message-ID: <4143845.Jr27FPv8XS@wuerfel>
In-Reply-To: <20160216214904.GA23723@www.outflux.net>
References: <20160216214904.GA23723@www.outflux.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Laura Abbott <laura@labbott.name>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tuesday 16 February 2016 13:49:04 Kees Cook wrote:
>  }
>  
> +static void __attribute__((__section__(".rodata,\"a\",@progbits#")))
> +do_nothing_rodata(void)
> +{
> +       return;
> +}
> +
>  static void do_nothing(void)
>  {
> 

I think this also needs to be marked "noinline" to ensure that the
function does not get eliminated. I've seen clang do that on
execute_location() recently and submitted a patch for that.

	Arnd
