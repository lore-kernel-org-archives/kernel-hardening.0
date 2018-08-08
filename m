MIME-Version: 1.0
In-Reply-To: <CAN+XpFTbqMXiX=dYpK_ExvctkaJjZL9q=n06goujPht35Bieqg@mail.gmail.com>
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
 <7529eedf-af56-2e94-261e-bc5c86abadaa@arm.com> <CAKv+Gu9X1CDpy+XvrmbSdjBjMb45eBW7JVsvsK_JQdUt2Dbvgw@mail.gmail.com>
 <b0c974a2-4e81-7855-7d4e-22834c5d8997@arm.com> <CAKv+Gu_ZzDbWwHVwOuoheXeN-ta_FjOT4Aj15=r56QZVTUK0FA@mail.gmail.com>
 <CAKv+Gu_wGk2Gdzd6WuOMZqz1tKHAWHL7pWm2Szyt0DZwPTCmOw@mail.gmail.com>
 <31443e6a-56b4-c4fb-82b1-b8eb5d7eebe1@arm.com> <CAGXu5jLj=KP038d-c+xzCx=Oogn1prH__oryQjNZZwNaAHaAAw@mail.gmail.com>
 <CAKv+Gu-9M0yO-rSXiREs11feEro0mJFcNN3Wkp_LSOGrKKd5dg@mail.gmail.com>
 <CAGXu5j+Tddmp_VgyvwTd+StEGtx=oGofeY+KpLD4OuPw+2=S2Q@mail.gmail.com>
 <CAKv+Gu-5ERHvqgXHR626QzKCZJPc0Cp5Ktv+gwucep5ZGvu9Vw@mail.gmail.com>
 <CAN+XpFQCO1nr5tQ4oyPPaSfvnQSvwx-=JCtba2xJXrEN+6=LZg@mail.gmail.com>
 <CAKv+Gu_jNh7vLfGEdi2BpA42rPJrNr8qV-Xss_toV2fJzUV5jQ@mail.gmail.com> <CAN+XpFTbqMXiX=dYpK_ExvctkaJjZL9q=n06goujPht35Bieqg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Aug 2018 15:02:26 -0700
Message-ID: <CAGXu5jJrB89-egt6n5qC88Hj5Oi4UOQO=cBO6vD7MZwgdjwHyA@mail.gmail.com>
Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
Content-Type: text/plain; charset="UTF-8"
To: Mark Brand <markbrand@google.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Julien Thierry <julien.thierry@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>, Robin Murphy <robin.murphy@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 8, 2018 at 9:09 AM, Mark Brand <markbrand@google.com> wrote:
> (1) chaining through the mempool_free function, I found this really
> quickly when searching for useful gadgets based off x0
>
> void mempool_free(void *element, mempool_t *pool)
> {
>   unsigned long flags;
>
>   if (unlikely(element == NULL))
>     return;
>
>   /* snip */
>   smp_rmb();
>
>   /* snip */
>   if (unlikely(pool->curr_nr < pool->min_nr)) {
>     spin_lock_irqsave(&pool->lock, flags);
>     if (likely(pool->curr_nr < pool->min_nr)) {
>       add_element(pool, element);
>       spin_unlock_irqrestore(&pool->lock, flags);
>       wake_up(&pool->wait);
>       return;
>     }
>     spin_unlock_irqrestore(&pool->lock, flags);
>   }
>
>   pool->free(element, pool->pool_data);
> }
>
> Since the callsites for this function usually load the arguments
> through some registers, and the function to call gets pulled out of
> one of those arguments, it's easy to get a couple of registers loaded
> here and then the chain continue.
>
> (2) loading complete register state using kernel_exit macro.
>
> Since the kernel_exit macro actually loads spsr_el1 and elr_el1 from
> registers, I think that you can let the eret return to anywhere in el1
> without dropping to el0, since the same handler is used for "exiting
> the kernel" when a hardware interrupt interrupts the kernel itself. I
> didn't fill out the necessary register values in the chain below,
> since I don't anyway have a device around to test this on right now.
>
> I'm not sure that you could really robustly protect this eret; I
> suppose that you could try and somehow validate the saved register
> state, but given that it would be happening on every exception return,
> I suspect it would be expensive.

This is a wonderful example, thanks! Yeah, Call-Oriented Programming?
:P mempool_free() is quite a nice gadget.

-Kees

-- 
Kees Cook
Pixel Security
