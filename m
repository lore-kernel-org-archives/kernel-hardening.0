Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 11:11:18 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170119111117.GB11176@leverpostej>
References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
 <1484789346-21012-3-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484789346-21012-3-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] security: Change name of CONFIG_DEBUG_SET_MODULE_RONX
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Wed, Jan 18, 2017 at 05:29:06PM -0800, Laura Abbott wrote:
> 
> Despite the word 'debug' in CONFIG_DEBUG_SET_MODULE_RONX, this kernel
> option provides key security features that are to be expected on a
> modern system. Change the name to CONFIG_HARDENED_MODULE_MAPPINGS which
> more accurately describes what this option is intended to do.

This looks good; my naming comments from the DEBUG_RODATA also apply
here -- the proposed name is fine.

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 06fed56..2fe0e98 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -12,6 +12,7 @@ config ARM64
>  	select ARCH_HAS_GCOV_PROFILE_ALL
>  	select ARCH_HAS_GIGANTIC_PAGE
>  	select ARCH_HAS_HARDENED_MAPPINGS
> +	select ARCH_HAS_HARDENED_MODULE_MAPPINGS
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_SG_CHAIN
>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index a26d27f..1eebe1f 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -71,17 +71,6 @@ config DEBUG_WX
>  
>  	  If in doubt, say "Y".
>  
> -config DEBUG_SET_MODULE_RONX
> -	bool "Set loadable kernel module data as NX and text as RO"
> -	depends on MODULES
> -	default y
> -	help
> -	  Is this is set, kernel module text and rodata will be made read-only.
> -	  This is to help catch accidental or malicious attempts to change the
> -	  kernel's executable code.
> -
> -	  If in doubt, say Y.
> -

> +config ARCH_HAS_HARDENED_MODULE_MAPPINGS
> +	def_bool n
> +
> +config HARDENED_MODULE_MAPPINGS
> +	bool "Mark module mappings with stricter permissions (RO/W^X)"
> +	default y
> +	depends on ARCH_HAS_HARDENED_MODULE_MAPPINGS
> +	help
> +	  If this is set, module text and rodata memory will be made read-only,
> +	  and non-text memory will be made non-executable. This provides
> +	  protection against certain security vulnerabilities (e.g. modifying
> +	  code)
> +
> +	  Unless your system has known restrictions or performance issues, it
> +	  is recommended to say Y here.
> +

I was hoping that we'd make this mandatory, as we'd already done for
DEBUG_RODATA.

Takahiro-san did a bit of work towards that in commit 39290b389ea2654f
("module: extend 'rodata=off' boot cmdline parameter to module
mappings").

It would be good to know if there's any reason we can't do that.

Otherwise, this looks fine.

Thanks,
Mark.
