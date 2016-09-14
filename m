Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 14 Sep 2016 11:13:33 +0100
Message-ID: <CAKv+Gu-zHmExwk-YqXVg2ZuVi1M8L4BbJb6-iARxQ7b_2eH-rA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 0/7] arm64: Privileged Access Never using TTBR0_EL1 switching
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 13 September 2016 at 18:46, Catalin Marinas <catalin.marinas@arm.com> wrote:
> This is the third version of the arm64 PAN emulation using TTBR0_EL1
> switching. The series has not yet included the alternative nop patches
> from Mark Rutland, nor the empty_zero_page from Ard B. This will be done
> in a subsequent version once 4.9-rc1 is out (which will include Mark's
> alternative nop patches).
>
> Changes since v2:
>
> - efi_set_pgd() reworked to update the saved ttbr0 during run-time
>   services as this value is used during exception return
>
> - uaccess_(enable|disable) C macros no longer take an 'alt' parameter
>   Instead, uaccess_(enable|disable)_not_uao are introduced for the case
>   where hardware PAN switching is not required when UAO is present
>
> - post_ttbr0_update_workaround macro no longer takes a 'ret' parameter
>
> - system_supports_ttbr0_pan renamed to system_uses_ttbr0_pan
>
> - init_thread_info.ttbr0 moved towards the end of the setup_arch()
>   function and comment updated
>
> - vmlinux.lds.S fixed to use RESERVED_TTBR0_SIZE
>
> - Config option changed to ARM64_SW_TTBR0_PAN
>
> - Some comment clean-ups and commit log updates
>

Given that every __get_user() call now incurs the PAN switch overhead,
I wonder if it would be worth it to stash the real TTBR0_EL1 value in,
e.g., TPIDRRO_EL0 rather than load it from memory each time. We'd have
to reload the real value of TPIDRRO_EL0 at kernel exit every time, but
only for compat tasks, and not nearly as often, obviously.
