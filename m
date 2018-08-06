MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <31443e6a-56b4-c4fb-82b1-b8eb5d7eebe1@arm.com>
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
 <7529eedf-af56-2e94-261e-bc5c86abadaa@arm.com> <CAKv+Gu9X1CDpy+XvrmbSdjBjMb45eBW7JVsvsK_JQdUt2Dbvgw@mail.gmail.com>
 <b0c974a2-4e81-7855-7d4e-22834c5d8997@arm.com> <CAKv+Gu_ZzDbWwHVwOuoheXeN-ta_FjOT4Aj15=r56QZVTUK0FA@mail.gmail.com>
 <CAKv+Gu_wGk2Gdzd6WuOMZqz1tKHAWHL7pWm2Szyt0DZwPTCmOw@mail.gmail.com> <31443e6a-56b4-c4fb-82b1-b8eb5d7eebe1@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 Aug 2018 11:49:34 -0700
Message-ID: <CAGXu5jLj=KP038d-c+xzCx=Oogn1prH__oryQjNZZwNaAHaAAw@mail.gmail.com>
Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
Content-Type: text/plain; charset="UTF-8"
To: Robin Murphy <robin.murphy@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>, Julien Thierry <julien.thierry@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 6, 2018 at 10:45 AM, Robin Murphy <robin.murphy@arm.com> wrote:
> I guess what I'm getting at is that if the protection mechanism is "always
> return with SP outside TTBR1", there seems little point in going through the
> motions if SP in TTBR0 could still be valid and allow an attack to succeed
> anyway; this is basically just me working through a justification for saying
> the proposed scheme needs "depends on ARM64_PAN || ARM64_SW_TTBR0_PAN",
> making it that much uglier for v8.0 CPUs...

I think anyone with v8.0 CPUs interested in this mitigation would also
very much want PAN emulation. If a "depends on" isn't desired, what
about "imply" in the Kconfig?

-Kees

-- 
Kees Cook
Pixel Security
