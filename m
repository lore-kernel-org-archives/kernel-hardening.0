Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160914102659.GC14330@leverpostej>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <CAKv+Gu-zHmExwk-YqXVg2ZuVi1M8L4BbJb6-iARxQ7b_2eH-rA@mail.gmail.com> <20160914102659.GC14330@leverpostej>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 14 Sep 2016 11:30:05 +0100
Message-ID: <CAKv+Gu_ww5+_vcKfnFsUgG6h1v87-CWhLp_o7qHS6=3nd6-cow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 0/7] arm64: Privileged Access Never using TTBR0_EL1 switching
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 14 September 2016 at 11:27, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Sep 14, 2016 at 11:13:33AM +0100, Ard Biesheuvel wrote:
>> On 13 September 2016 at 18:46, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> > This is the third version of the arm64 PAN emulation using TTBR0_EL1
>> > switching.
>
>> Given that every __get_user() call now incurs the PAN switch overhead,
>> I wonder if it would be worth it to stash the real TTBR0_EL1 value in,
>> e.g., TPIDRRO_EL0 rather than load it from memory each time. We'd have
>> to reload the real value of TPIDRRO_EL0 at kernel exit every time, but
>> only for compat tasks, and not nearly as often, obviously.
>
> FWIW, my plan for vmap'd stacks involves clobbering TPIDRRO_EL0 early
> upon kernel entry to reliably detect/handle stack overflow (as we need
> to free up GPR to detect overflow, and we need to detect that before we
> try to store to the stack).
>
> For non-compat tasks we must restore zero, so either way we'll end up
> with a load (to determine compat-ness or to load the precise value).
>

Are you saying that with vmapped stacks, we'll end up clobbering it
(and thus restoring it) anyway when entering the kernel, and so we
could use it for free afterwards while running in the kernel,
potentially for the real value of TTBR0_EL1?
