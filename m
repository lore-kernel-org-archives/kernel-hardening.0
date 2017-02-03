Date: Fri, 3 Feb 2017 18:26:49 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170203182648.GB26578@leverpostej>
References: <1486144343-24998-1-git-send-email-labbott@redhat.com>
 <1486144343-24998-3-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1486144343-24998-3-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCHv2 2/2] arch: Rename CONFIG_DEBUG_RODATA and
 CONFIG_DEBUG_MODULE_RONX
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jessica Yu <jeyu@redhat.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 03, 2017 at 09:52:22AM -0800, Laura Abbott wrote:
> 
> Both of these options are poorly named. The features they provide are
> necessary for system security and should not be considered debug only.
> Change the name to something that accurately describes what these
> options do.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>

As with patch 1, this looks good to me. FWIW:

Acked-by: Mark Rutland <mark.rutland@arm.com>

> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 939815e..560a8d8 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -72,7 +72,7 @@ config DEBUG_WX
>  	  If in doubt, say "Y".
>  
>  config DEBUG_ALIGN_RODATA
> -	depends on DEBUG_RODATA
> +	depends on STRICT_KERNEL_RWX
>  	bool "Align linker sections up to SECTION_SIZE"
>  	help
>  	  If this option is enabled, sections that may potentially be marked as
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 94b62c1..67f9cb9 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -93,7 +93,7 @@ static void __kprobes *patch_map(void *addr, int fixmap)
>  	bool module = !core_kernel_text(uintaddr);
>  	struct page *page;
>  
> -	if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
> +	if (module && IS_ENABLED(CONFIG_STRICT_MODULE_RWX))
>  		page = vmalloc_to_page(addr);
>  	else if (!module)
>  		page = pfn_to_page(PHYS_PFN(__pa(addr)));

Since CONFIG_STRICT_MODULE_RWX is mandatory for arm64, we should be able
to simplify this, but that can wait for a later patch.

Thanks,
Mark.
