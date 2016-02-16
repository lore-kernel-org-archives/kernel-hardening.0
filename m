Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160216213659.GA47194@davidb.org>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
	<20160216213659.GA47194@davidb.org>
Date: Tue, 16 Feb 2016 13:52:33 -0800
Message-ID: <CAGXu5j+H63jhcDpHpXK5aWvgUBz=5vB0FK_zRoc+wZEk32B2fg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] ARM: vdso: Mark vDSO code as read-only
To: David Brown <david.brown@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 16, 2016 at 1:36 PM, David Brown <david.brown@linaro.org> wrote:
> Although the arm vDSO is cleanly separated by code/data with the code
> being read-only in userspace mappings, the code page is still writable
> from the kernel.  There have been exploits (such as
> http://itszn.com/blog/?p=21) that take advantage of this on x86 to go
> from a bad kernel write to full root.
>
> Prevent this specific exploit on arm by putting the vDSO code page in
> post-init read-only memory as well.

Is the vdso dynamically built at init time like on x86, or can this
just use .rodata directly?

-Kees

>
> Before:
> vdso: 1 text pages at base 80927000
> root@Vexpress:/ cat /sys/kernel/debug/kernel_page_tables
> ---[ Modules ]---
> ---[ Kernel Mapping ]---
> 0x80000000-0x80100000           1M     RW NX SHD
> 0x80100000-0x80600000           5M     ro x  SHD
> 0x80600000-0x80800000           2M     ro NX SHD
> 0x80800000-0xbe000000         984M     RW NX SHD
>
> After:
> vdso: 1 text pages at base 8072b000
> root@Vexpress:/ cat /sys/kernel/debug/kernel_page_tables
> ---[ Modules ]---
> ---[ Kernel Mapping ]---
> 0x80000000-0x80100000           1M     RW NX SHD
> 0x80100000-0x80600000           5M     ro x  SHD
> 0x80600000-0x80800000           2M     ro NX SHD
> 0x80800000-0xbe000000         984M     RW NX SHD
>
> Inspired by https://lkml.org/lkml/2016/1/19/494 based on work by the
> PaX Team, Brad Spengler, and Kees Cook.
>
> Signed-off-by: David Brown <david.brown@linaro.org>
> ---
> This patch depends on Kees Cook's series
> https://lkml.org/lkml/2016/1/19/497 which adds the ro_after_init
> section.
>
> arch/arm/vdso/vdso.S | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/arch/arm/vdso/vdso.S b/arch/arm/vdso/vdso.S
> index b2b97e3..a62a7b6 100644
> --- a/arch/arm/vdso/vdso.S
> +++ b/arch/arm/vdso/vdso.S
> @@ -23,9 +23,8 @@
> #include <linux/const.h>
> #include <asm/page.h>
>
> -       __PAGE_ALIGNED_DATA
> -
>         .globl vdso_start, vdso_end
> +       .section .data..ro_after_init
>         .balign PAGE_SIZE
> vdso_start:
>         .incbin "arch/arm/vdso/vdso.so"
> --
> 2.7.1
>



-- 
Kees Cook
Chrome OS & Brillo Security
