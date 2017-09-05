Date: Tue, 5 Sep 2017 09:45:48 -0700
From: Tony Lindgren <tony@atomide.com>
Message-ID: <20170905164547.GA5024@atomide.com>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

* Ard Biesheuvel <ard.biesheuvel@linaro.org> [170903 05:08]:
> This series implements randomization of the placement of the core ARM kernel
> inside the lowmem region. It consists of the following parts:
> 
> - changes that allow us to build vmlinux as a PIE executable which retains
>   the metadata required to fix up all absolute symbol references at runtime
> - changes that eliminate absolute references from low-level code that may
>   execute with the MMU off: this removes the need to perform explicit cache
>   maintenance after the absolute references have been fixed up at runtime with
>   the caches enabled
> - changes to the core kernel startup code to take the physical offset into
>   account when creating the virtual mapping (the pa-to-va mapping remains
>   unchanged)
> - changes to the decompressor to collect some pseudo-entropy, and randomize
>   the physical offset of the decompressed kernel, taking placement of DTB,
>   initrd and reserved regions into account
> - changes to the UEFI stub code to choose the KASLR offset and communicate
>   it to the decompressor
> 
> To test these changes, boot a multi_v7_defconfig+CONFIG_RANDOMIZE_BASE=y

I gave a quick try using your arm-kaslr-v3 branch, hopefully that's
the right one.

The good news is that now omap3 boots with omap2plus_defconfig with
and without CONFIG_RANDOMIZE_BASE=y and I did not see any compiler
errors with my gcc 6.2.0 like earlier :)

I did see boot attempts fail with randomize enable where no output
was produced. It seems this is happening for me maybe 1 out of 5 boots.
Enabling DEBUG_LL did not show anything either.

Then loading modules with CONFIG_RANDOMIZE_BASE=y seems to fail with:

$ sudo modprobe rtc-twl
rtc_twl: disagrees about version of symbol module_layout
modprobe: ERROR: could not insert 'rtc_twl': Exec format error

Regards,

Tony
