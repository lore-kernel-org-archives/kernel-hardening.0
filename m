Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 28 Dec 2015 12:50:03 +0100
Message-ID: <11539877.krH4qBJsp9@wuerfel>
In-Reply-To: <1451301654-32019-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org> <1451301654-32019-2-git-send-email-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [RFC PATCH 01/10] arm64: introduce KIMAGE_VADDR as the virtual base of the kernel region
To: linux-arm-kernel@lists.infradead.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, leif.lindholm@linaro.org, keescook@chromium.org, linux-kernel@vger.kernel.org, bhupesh.sharma@freescale.com, stuart.yoder@freescale.com
List-ID: <kernel-hardening.lists.openwall.com>

On Monday 28 December 2015 12:20:45 Ard Biesheuvel wrote:
> @@ -75,8 +76,13 @@
>   * private definitions which should NOT be used outside memory.h
>   * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
>   */
> -#define __virt_to_phys(x)      (((phys_addr_t)(x) - PAGE_OFFSET + PHYS_OFFSET))
> +#define __virt_to_phys(x) ({                                           \
> +       phys_addr_t __x = (phys_addr_t)(x);                             \
> +       __x >= PAGE_OFFSET ? (__x - PAGE_OFFSET + PHYS_OFFSET) :        \
> +                            (__x - KIMAGE_VADDR + PHYS_OFFSET); })
> +
>  #define __phys_to_virt(x)      ((unsigned long)((x) - PHYS_OFFSET + PAGE_OFFSET))
> +#define __phys_to_kimg(x)      ((unsigned long)((x) - PHYS_OFFSET + KIMAGE_VADDR))

Having a conditional here is a bit unfortunate.

IIRC KASLR means something different depending on the architecture, we either randomize
the physical address, or the virtual address, or both, and that addresses different
attack scenarios. You seem to leave the physical address unchanged, which means that
an attacker that has gained access to a DMA master device can potentially still modify
the kernel without knowing the virtual address.
Similarly, you seem to leave the kernel mapped at the original virtual address and
just add a second map (or your __phys_to_virt is wrong), so if someone has the
ability to access a kernel virtual memory address from user space, they also don't
need the relocated address because they can potentially access the kernel .text
and .data through the linear mapping.

How about a different approach that keeps the relocatable kernel, but moves it in
physical memory with the same random offset as the virtual address? That way, both
would be random, and you can keep the simple virt_to_phys() function.

I suppose the downside of that is that the number of random bits is then limited
by the size of the first memblock, which is smaller than the vmalloc area.

	Arnd
