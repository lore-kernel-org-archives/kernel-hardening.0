Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <11539877.krH4qBJsp9@wuerfel>
References: <1451301654-32019-1-git-send-email-ard.biesheuvel@linaro.org>
	<1451301654-32019-2-git-send-email-ard.biesheuvel@linaro.org>
	<11539877.krH4qBJsp9@wuerfel>
Date: Mon, 28 Dec 2015 13:07:44 +0100
Message-ID: <CAKv+Gu9nFaPES8u6fc7SQ0WFJVgV3O4uM2wNNoVWz8iaajyqTQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 01/10] arm64: introduce KIMAGE_VADDR as the virtual
 base of the kernel region
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Stuart Yoder <stuart.yoder@freescale.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 28 December 2015 at 12:50, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 28 December 2015 12:20:45 Ard Biesheuvel wrote:
>> @@ -75,8 +76,13 @@
>>   * private definitions which should NOT be used outside memory.h
>>   * files.  Use virt_to_phys/phys_to_virt/__pa/__va instead.
>>   */
>> -#define __virt_to_phys(x)      (((phys_addr_t)(x) - PAGE_OFFSET + PHYS_OFFSET))
>> +#define __virt_to_phys(x) ({                                           \
>> +       phys_addr_t __x = (phys_addr_t)(x);                             \
>> +       __x >= PAGE_OFFSET ? (__x - PAGE_OFFSET + PHYS_OFFSET) :        \
>> +                            (__x - KIMAGE_VADDR + PHYS_OFFSET); })
>> +
>>  #define __phys_to_virt(x)      ((unsigned long)((x) - PHYS_OFFSET + PAGE_OFFSET))
>> +#define __phys_to_kimg(x)      ((unsigned long)((x) - PHYS_OFFSET + KIMAGE_VADDR))
>
> Having a conditional here is a bit unfortunate.
>

Yes. Unfortunately, the assumption that kernel symbols live in the
same address space as dynamic allocations in the linear mapping is
widespread throughout the code base, otherwise we could strictly
separate the two, and this would not be necessary. I played around
with adding another sparse address space for kernel addresses, but
that gives a lot of hits in generic code as well.

> IIRC KASLR means something different depending on the architecture, we either randomize
> the physical address, or the virtual address, or both, and that addresses different
> attack scenarios. You seem to leave the physical address unchanged, which means that
> an attacker that has gained access to a DMA master device can potentially still modify
> the kernel without knowing the virtual address.

Indeed. I did not mention it in the cover letter, but this work is
somewhat related to series I proposed which allows the kernel Image to
reside anywhere (i.e., at any 2 MB aligned offset + TEXT_OFFSET) in
physical memory. This is fairly straight forward once we have moved
the kernel virtual mapping out of the linear mapping, but since this
series has enough moving parts as it is, I omitted those pieces for
now.
http://thread.gmane.org/gmane.linux.ports.arm.kernel/455151

After Mark Rutland proposed his pagetable rework series, a lot of
those changes became much easier to implement, but did require rework,
and because of queries I received personally regarding KASLR, I
decided to focus on that part first.

> Similarly, you seem to leave the kernel mapped at the original virtual address and
> just add a second map (or your __phys_to_virt is wrong), so if someone has the
> ability to access a kernel virtual memory address from user space, they also don't
> need the relocated address because they can potentially access the kernel .text
> and .data through the linear mapping.
>

True. Catalin mentioned this as well in response to the series
mentioned above. Unmapping the kernel text in the linear mapping is an
important enhancement from security pov, but not essential from a
functionality pov.

> How about a different approach that keeps the relocatable kernel, but moves it in
> physical memory with the same random offset as the virtual address? That way, both
> would be random, and you can keep the simple virt_to_phys() function.
>
> I suppose the downside of that is that the number of random bits is then limited
> by the size of the first memblock, which is smaller than the vmalloc area.
>

I don't see a reason to use the same virtual and physical offset
(other than the conditional). On arm64, it would be up to the
bootloader to decide where to put the Image in physical memory, and it
would be up to the kernel to decide whether or not to virtually remap
itself.

Regards,
Ard.
