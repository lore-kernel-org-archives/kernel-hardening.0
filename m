Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1455141142-6838-1-git-send-email-david.brown@linaro.org>
References: <1455141142-6838-1-git-send-email-david.brown@linaro.org>
Date: Thu, 11 Feb 2016 15:19:20 +0100
Message-ID: <CAKv+Gu8ArOYqxDGKb=Tv3NsiB2qWWCdD_zMx55m6+hEwLJR4CA@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] arm64: vdso: Mark vDSO code as read-only
To: kernel-hardening@lists.openwall.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, David Brown <david.brown@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi David,

Nice find!

On 10 February 2016 at 22:52, David Brown <david.brown@linaro.org> wrote:
> Although the arm64 vDSO is cleanly separated by code/data with the
> code being read-only in userspace mappings, the code page is still
> writable from the kernel.  There have been exploits (such as
> http://itszn.com/blog/?p=21) that take advantage of this on x86 to go
> from a bad kernel write to full root.
>
> Prevent this specific exploit on arm64 by putting the vDSO code page
> in read-only memory as well.
>
> Before the change:
> [    3.138366] vdso: 2 pages (1 code @ ffffffc000a71000, 1 data @ ffffffc000a70000)
> ---[ Kernel Mapping ]---
> 0xffffffc000000000-0xffffffc000082000         520K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc000082000-0xffffffc000200000        1528K     ro x  SHD AF            UXN MEM/NORMAL
> 0xffffffc000200000-0xffffffc000800000           6M     ro x  SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc000800000-0xffffffc0009b6000        1752K     ro x  SHD AF            UXN MEM/NORMAL
> 0xffffffc0009b6000-0xffffffc000c00000        2344K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc000c00000-0xffffffc008000000         116M     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc00c000000-0xffffffc07f000000        1840M     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc800000000-0xffffffc840000000           1G     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc840000000-0xffffffc87ae00000         942M     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc87ae00000-0xffffffc87ae70000         448K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87af80000-0xffffffc87af8a000          40K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87af8b000-0xffffffc87b000000         468K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87b000000-0xffffffc87fe00000          78M     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc87fe00000-0xffffffc87ff50000        1344K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87ff90000-0xffffffc87ffa0000          64K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87fff0000-0xffffffc880000000          64K     RW NX SHD AF            UXN MEM/NORMAL
>
> After:
> [    3.138368] vdso: 2 pages (1 code @ ffffffc0006de000, 1 data @ ffffffc000a74000)
> ---[ Kernel Mapping ]---
> 0xffffffc000000000-0xffffffc000082000         520K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc000082000-0xffffffc000200000        1528K     ro x  SHD AF            UXN MEM/NORMAL
> 0xffffffc000200000-0xffffffc000800000           6M     ro x  SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc000800000-0xffffffc0009b8000        1760K     ro x  SHD AF            UXN MEM/NORMAL
> 0xffffffc0009b8000-0xffffffc000c00000        2336K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc000c00000-0xffffffc008000000         116M     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc00c000000-0xffffffc07f000000        1840M     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc800000000-0xffffffc840000000           1G     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc840000000-0xffffffc87ae00000         942M     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc87ae00000-0xffffffc87ae70000         448K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87af80000-0xffffffc87af8a000          40K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87af8b000-0xffffffc87b000000         468K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87b000000-0xffffffc87fe00000          78M     RW NX SHD AF        BLK UXN MEM/NORMAL
> 0xffffffc87fe00000-0xffffffc87ff50000        1344K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87ff90000-0xffffffc87ffa0000          64K     RW NX SHD AF            UXN MEM/NORMAL
> 0xffffffc87fff0000-0xffffffc880000000          64K     RW NX SHD AF            UXN MEM/NORMAL
>
> Inspired by https://lkml.org/lkml/2016/1/19/494 based on work by the
> PaX Team, Brad Spengler, and Kees Cook.
>
> Signed-off-by: David Brown <david.brown@linaro.org>
> ---
>  arch/arm64/kernel/vdso/vdso.S | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/kernel/vdso/vdso.S b/arch/arm64/kernel/vdso/vdso.S
> index 60c1db5..db7c0f2 100644
> --- a/arch/arm64/kernel/vdso/vdso.S
> +++ b/arch/arm64/kernel/vdso/vdso.S
> @@ -24,6 +24,7 @@
>         __PAGE_ALIGNED_DATA

^^ You can get rid of this now as well

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

>
>         .globl vdso_start, vdso_end
> +       .section .rodata
>         .balign PAGE_SIZE
>  vdso_start:
>         .incbin "arch/arm64/kernel/vdso/vdso.so"
> --
> 2.7.1
>
