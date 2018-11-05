MIME-Version: 1.0
In-Reply-To: <nycvar.YSQ.7.76.1811041519100.1498@knanqh.ubzr>
References: <20181104162845.16938-1-ard.biesheuvel@linaro.org> <nycvar.YSQ.7.76.1811041519100.1498@knanqh.ubzr>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 5 Nov 2018 11:42:29 +0100
Message-ID: <CAKv+Gu9XMu5hrjp51bOu0gh4hc5F=1F6oVH2esYnbuEfR-23MQ@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] ARM: smp: add support for per-task stack canaries
Content-Type: text/plain; charset="UTF-8"
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Russell King - ARM Linux <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 4 November 2018 at 21:36, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Sun, 4 Nov 2018, Ard Biesheuvel wrote:
>
>> On ARM, we currently only change the value of the stack canary when
>> switching tasks if the kernel was built for UP. On SMP kernels, this
>> is impossible since the stack canary value is obtained via a global
>> symbol reference, which means
>> a) all running tasks on all CPUs must use the same value
>> b) we can only modify the value when no kernel stack frames are live,
>>    which is effectively never.
>>
>> So instead, use a GCC plugin to add a RTL pass that replaces each
>> reference to the address of the __stack_chk_guard symbol with an
>> expression that produces the address of the 'stack_canary' field
>> that is added to struct thread_info. This way, each task will use
>> its own randomized value.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> Known issues:
>> - The plugin requires the values of THREAD_SIZE and the offset of
>>   stack_canary in struct thread_info at a really early stage in the
>>   build, so I had to redefine them in the plugin source.
>
> Can't you rely on the asm-offsets.c mechanism before the plugin is used?
>

Not currently, no. The plugins are built with the host compiler before
the target compiler is invoked, and asm-offsets is built with the
target compiler.

Kees: any ideas on how to resolve this?

>> Questions:
>> - Are there any execution contexts except for the decompressor and the
>>   EFI stub where we should disable this? KVM perhaps?
>
> Most certainly head-inflate-data.c... who knows if someone will use an
> XIP kernel on an SMP system someday.
>

That is a bit tricky, unfortunately: building head-inflate-data.c with
the stack protector disabled is easy, but we'll also need to build
zlib_inflate() in the same way.

> [...]
>> +#ifdef CONFIG_STACKPROTECTOR_PER_TASK
>> +     BUILD_BUG_ON(offsetof(struct thread_info, stack_canary) != 100);
>> +     BUILD_BUG_ON(THREAD_SIZE != 0x2000);
>
> You should at least define those values in a header file that gets
> included by both this code and the plugin source. But asm-offsets.c
> would be best.
>

Sure. I will put the right hand sides in a shared header as #defines
and use those in the plugin source.
