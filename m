Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160929213257.30505-1-labbott@redhat.com>
References: <20160929213257.30505-1-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 29 Sep 2016 18:29:22 -0700
Message-ID: <CAGXu5jKamEFzkR+iVxfZKJ_YK41E8a8ta1mQRY7tHfcz-NFwOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH 0/3] WX Checking for arm64
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Laura Abbott <labbott@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 29, 2016 at 2:32 PM, Laura Abbott <labbott@redhat.com> wrote:
>
> Hi,
>
> This is an implementation to check for writable and executable pages on arm64.
> This is heavily based on the x86 version which uses the existing page table
> dumping code to do the checking. Some notes:
>
> - The W^X checking is important so this option should become defaut eventually.
>   To make this feasible, the debugfs functionality has been split out as a
>   separate option. I didn't see a good way to make it modular like x86 but
>   an option should be good enough.
> - This checks all page tables registered with ptdump_register. I don't see this
>   being called elsewhere right now though.
> - Once this is merged, I'd like to see about moving DEBUG_WX to the top level
>   instead of having each arch call it in mark_rodata.

Awesome!

Yeah, I think we should take a look at refactoring x86, arm, and arm64
to use a common infrastructure with callbacks. That way other
architectures can gain all these features with just a few callbacks
implemented.

-Kees

>
> Laura Abbott (3):
>   arm64: dump: Make ptdump debugfs a separate option
>   arm64: dump: Make the page table dumping seq_file optional
>   arm64: dump: Add checking for writable and exectuable pages
>
>  arch/arm64/Kconfig.debug        | 34 ++++++++++++++-
>  arch/arm64/include/asm/ptdump.h | 25 ++++++++++-
>  arch/arm64/mm/Makefile          |  3 +-
>  arch/arm64/mm/dump.c            | 92 ++++++++++++++++++++++++++++-------------
>  arch/arm64/mm/mmu.c             |  2 +
>  arch/arm64/mm/ptdump_debugfs.c  | 33 +++++++++++++++
>  6 files changed, 157 insertions(+), 32 deletions(-)
>  create mode 100644 arch/arm64/mm/ptdump_debugfs.c
>
> --
> 2.10.0
>



-- 
Kees Cook
Nexus Security
