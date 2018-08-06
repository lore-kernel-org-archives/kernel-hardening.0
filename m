MIME-Version: 1.0
In-Reply-To: <fef98ede-efe4-eaf2-f314-07b623e9800e@redhat.com>
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org> <fef98ede-efe4-eaf2-f314-07b623e9800e@redhat.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 6 Aug 2018 12:31:04 +0200
Message-ID: <CAKv+Gu9p59qXHFa_dOAxExc-TdPUGf3Py07jxYaVYfY4ugQNJQ@mail.gmail.com>
Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
Content-Type: text/plain; charset="UTF-8"
To: Florian Weimer <fweimer@redhat.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, Christoffer Dall <christoffer.dall@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@fedoraproject.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 August 2018 at 12:07, Florian Weimer <fweimer@redhat.com> wrote:
> On 08/02/2018 03:21 PM, Ard Biesheuvel wrote:
>>
>> The idea is that we can significantly limit the kernel's attack surface
>> for ROP based attacks by clearing the stack pointer's sign bit before
>> returning from a function, and setting it again right after proceeding
>> from the [expected] return address. This should make it much more
>> difficult
>> to return to arbitrary gadgets, given that they rely on being chained to
>> the next via a return address popped off the stack, and this is difficult
>> when the stack pointer is invalid.
>
>
> Doesn't this break stack unwinding?
>

Any exception that is taken between clearing and setting the SP bit
will first reset the bit. Since arm64 does not rely on hardware to
preserve the exception context, we can do this in code before
preserving the registers (which is why we need the 'little dance' in
the last patch)

So any time the stack unwinding code runs, the stack pointer should be valid.
