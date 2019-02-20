Date: Wed, 20 Feb 2019 09:14:51 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] x86/asm: Pin sensitive CR4 bits
Message-ID: <20190220081451.GA2254@light.dominikbrodowski.net>
References: <20190220005449.GA25243@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220005449.GA25243@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 04:54:49PM -0800, Kees Cook wrote:
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index cb28e98a0659..7e0ea4470f8e 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -312,10 +312,16 @@ static __init int setup_disable_smep(char *arg)
>  }
>  __setup("nosmep", setup_disable_smep);
>  
> +volatile unsigned long cr4_pin __ro_after_init;
> +EXPORT_SYMBOL_GPL(cr4_pin);

Where is this export needed?

Thanks,
	Dominik
