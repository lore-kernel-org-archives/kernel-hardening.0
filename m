MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486144343-24998-2-git-send-email-labbott@redhat.com>
References: <1486144343-24998-1-git-send-email-labbott@redhat.com> <1486144343-24998-2-git-send-email-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Feb 2017 11:45:56 -0800
Message-ID: <CAGXu5jK6_y=dWHUDBto7ykN_sSOQ6Gx+sZs_gQ1Hoh5DjP-fTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2 1/2] arch: Move CONFIG_DEBUG_RODATA and
 CONFIG_SET_MODULE_RONX to be common
To: Laura Abbott <labbott@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-parisc <linux-parisc@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 3, 2017 at 9:52 AM, Laura Abbott <labbott@redhat.com> wrote:
> There are multiple architectures that support CONFIG_DEBUG_RODATA and
> CONFIG_SET_MODULE_RONX. These options also now have the ability to be
> turned off at runtime. Move these to an architecture independent
> location and make these options def_bool y for almost all of those
> arches.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v2: This patch is now doing just the refactor of the existing config options.
> ---
>  arch/Kconfig              | 28 ++++++++++++++++++++++++++++
>  arch/arm/Kconfig          |  3 +++
>  arch/arm/Kconfig.debug    | 11 -----------
>  arch/arm/mm/Kconfig       | 12 ------------
>  arch/arm64/Kconfig        |  5 ++---
>  arch/arm64/Kconfig.debug  | 11 -----------
>  arch/parisc/Kconfig       |  1 +
>  arch/parisc/Kconfig.debug | 11 -----------
>  arch/s390/Kconfig         |  5 ++---
>  arch/s390/Kconfig.debug   |  3 ---
>  arch/x86/Kconfig          |  5 ++---
>  arch/x86/Kconfig.debug    | 11 -----------
>  12 files changed, 38 insertions(+), 68 deletions(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 99839c2..22ee01e 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -781,4 +781,32 @@ config VMAP_STACK
>           the stack to map directly to the KASAN shadow map using a formula
>           that is incorrect if the stack is in vmalloc space.
>
> +config ARCH_NO_STRICT_RWX_DEFAULTS
> +       def_bool n
> +
> +config ARCH_HAS_STRICT_KERNEL_RWX
> +       def_bool n
> +
> +config DEBUG_RODATA
> +       def_bool y if !ARCH_NO_STRICT_RWX_DEFAULTS
> +       prompt "Make kernel text and rodata read-only" if ARCH_NO_STRICT_RWX_DEFAULTS

Ah! Yes, perfect. I totally forgot about using conditional "prompt" lines. Nice!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
Pixel Security
