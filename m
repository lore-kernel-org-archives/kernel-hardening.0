Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 10:56:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170119105646.GA11176@leverpostej>
References: <1484789346-21012-1-git-send-email-labbott@redhat.com>
 <1484789346-21012-2-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484789346-21012-2-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] security: Change name of CONFIG_DEBUG_RODATA
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Wed, Jan 18, 2017 at 05:29:05PM -0800, Laura Abbott wrote:
> 
> Despite the word 'debug' in CONFIG_DEBUG_RODATA, this kernel option
> provides key security features that are to be expected on a modern
> system. Change the name to CONFIG_HARDENED_PAGE_MAPPINGS which more
> accurately describes what this option is intended to do.

This generally sounds good. Thanks for attacking this!

On the bikeshedding front, *maybe* it would be nice to mention
permissions in the name, something like STRICT_KERNEL_RWX. That might
also prevent the reading of 'hardened' as 'optional overhead'.

That said, the proposed name is fine by me -- I'm happy so long as
'DEBUG' goes.

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1117421..06fed56 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -11,6 +11,7 @@ config ARM64
>  	select ARCH_HAS_ELF_RANDOMIZE
>  	select ARCH_HAS_GCOV_PROFILE_ALL
>  	select ARCH_HAS_GIGANTIC_PAGE
> +	select ARCH_HAS_HARDENED_MAPPINGS
>  	select ARCH_HAS_KCOV
>  	select ARCH_HAS_SG_CHAIN
>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
> @@ -123,9 +124,6 @@ config ARCH_PHYS_ADDR_T_64BIT
>  config MMU
>  	def_bool y
>  
> -config DEBUG_RODATA
> -	def_bool y
> -

> diff --git a/security/Kconfig b/security/Kconfig
> index 118f454..ad6ce82 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -158,6 +158,22 @@ config HARDENED_USERCOPY_PAGESPAN
>  	  been removed. This config is intended to be used only while
>  	  trying to find such users.
>  
> +config ARCH_HAS_HARDENED_MAPPINGS
> +	def_bool n
> +
> +config HARDENED_PAGE_MAPPINGS
> +	bool "Mark kernel mappings with stricter permissions (RO/W^X)"
> +	default y
> +	depends on ARCH_HAS_HARDENED_MAPPINGS
> +	help
> +          If this is set, kernel text and rodata memory will be made read-only,
> +	  and non-text memory will be made non-executable. This provides
> +	  protection against certain security attacks (e.g. executing the heap
> +	  or modifying text).
> +
> +	  Unless your system has known restrictions or performance issues, it
> +	  is recommended to say Y here.

It's somewhat unfortunate that this means the feature is no longer
mandatory on arm64 (and s390+x86). We have a boot-time switch to turn
the protections off, so I was hoping we could make this mandatory on all
architectures with support.

It would be good to see if we could make this mandatory for arm and
parisc, or if it really needs to be optional for either of those.

Thanks,
Mark.
