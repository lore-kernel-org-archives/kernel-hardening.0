MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486144343-24998-3-git-send-email-labbott@redhat.com>
References: <1486144343-24998-1-git-send-email-labbott@redhat.com> <1486144343-24998-3-git-send-email-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Feb 2017 12:03:16 -0800
Message-ID: <CAGXu5j+BX_+ymWQztqtOQE-A8yFuR5sdL++46wOvi-iBGLEK-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2 2/2] arch: Rename CONFIG_DEBUG_RODATA and CONFIG_DEBUG_MODULE_RONX
To: Laura Abbott <labbott@redhat.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Helge Deller <deller@gmx.de>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Rob Herring <robh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Mark Rutland <mark.rutland@arm.com>, Jessica Yu <jeyu@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-parisc <linux-parisc@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Robin Murphy <robin.murphy@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 3, 2017 at 9:52 AM, Laura Abbott <labbott@redhat.com> wrote:
>
> Both of these options are poorly named. The features they provide are
> necessary for system security and should not be considered debug only.
> Change the name to something that accurately describes what these
> options do.

It may help to explicitly call out the name change from/to in the
commit message.

>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> [...]
> diff --git a/arch/arm/configs/aspeed_g4_defconfig b/arch/arm/configs/aspeed_g4_defconfig
> index ca39c04..beea2cc 100644
> --- a/arch/arm/configs/aspeed_g4_defconfig
> +++ b/arch/arm/configs/aspeed_g4_defconfig
> @@ -25,7 +25,6 @@ CONFIG_MODULE_UNLOAD=y
>  # CONFIG_ARCH_MULTI_V7 is not set
>  CONFIG_ARCH_ASPEED=y
>  CONFIG_MACH_ASPEED_G4=y
> -CONFIG_DEBUG_RODATA=y
>  CONFIG_AEABI=y
>  CONFIG_UACCESS_WITH_MEMCPY=y
>  CONFIG_SECCOMP=y

Are these defconfig cases correct (dropping DEBUG_RODATA without
adding STRICT_KERNEL_RWX)?

Who should carry this series, btw?

-Kees

-- 
Kees Cook
Pixel Security
