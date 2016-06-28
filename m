Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 13:57:49 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160628125748.GK31744@leverpostej>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
Subject: Re: [kernel-hardening] [PATCH v1 0/2] Introduce the initify gcc
 plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28, 2016 at 01:34:07PM +0200, Emese Revfy wrote:
> I would like to introduce the initify gcc plugin. The kernel already has
> a mechanism to free up code and data memory that is only used during kernel
> or module initialization.
> This plugin will teach the compiler to find more such code and data that
> can be freed after initialization. It reduces memory usage.
> The initify gcc plugin can be useful for embedded systems.
> 
> It is a CII project supported by the Linux Foundation.
> 
> This plugin is the part of grsecurity/PaX.
> 
> The plugin supports all gcc versions from 4.5 to 6.0.
> 
> I made some changes on top of the PaX version (since March 6.). These are
> the important ones:
>  * move all local strings to init.rodata.str and exit.rodata.str
>    (not just __func__)
>  * report all initified strings and functions
>    (GCC_PLUGIN_INITIFY_VERBOSE config option)
>  * automatically discover init/exit functions and apply the __init or
>    __exit attributes on them
> 
> You can find more about the changes here:
> https://github.com/ephox-gcc-plugins/initify
> 
> This patch set is based on the "Add support for complex gcc plugins that
> don't fit in a single file" patch set (git/kees/linux.git#kspp HEAD:
> e5d4798b284cd192c8b).

I was hoping to give this a spin on arm/arm64, but I couldn't find the
prerequisite branch/tag/commit in that tree:

https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?id=e5d4798b284cd192c8b

Where should I be looking?

Thanks,
Mark.
