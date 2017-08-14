MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <20170814125411.22604-2-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org> <20170814125411.22604-2-ard.biesheuvel@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 14 Aug 2017 16:26:32 +0200
Message-ID: <CAK8P3a3EArx1gEE=1WigMpBXHOKDkiBz+qudkyEKeO13jxxJ0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 01/30] asm-generic: add .data.rel.ro sections to __ro_after_init
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 2:53 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> When running in PIC mode, the compiler will emit const structures
> containing runtime relocatable quantities into .data.rel.ro.* sections,
> so that the linker can be smart about placing them together in a segment
> that is read-write initially, and is remapped read-only afterwards. This
> is exactly what __ro_after_init aims to provide, so move these sections
> together.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
