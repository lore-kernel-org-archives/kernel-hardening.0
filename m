Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <fef98ede-efe4-eaf2-f314-07b623e9800e@redhat.com>
Date: Mon, 6 Aug 2018 12:07:48 +0200
MIME-Version: 1.0
In-Reply-To: <20180802132133.23999-1-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, christoffer.dall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, mark.rutland@arm.com, labbott@fedoraproject.org, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On 08/02/2018 03:21 PM, Ard Biesheuvel wrote:
> The idea is that we can significantly limit the kernel's attack surface
> for ROP based attacks by clearing the stack pointer's sign bit before
> returning from a function, and setting it again right after proceeding
> from the [expected] return address. This should make it much more difficult
> to return to arbitrary gadgets, given that they rely on being chained to
> the next via a return address popped off the stack, and this is difficult
> when the stack pointer is invalid.

Doesn't this break stack unwinding?

Thanks,
Florian
