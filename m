Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 18 Feb 2016 13:07:24 +0100
Message-ID: <3013719.NTkGVd5eeC@wuerfel>
In-Reply-To: <CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
References: <20160216214904.GA23723@www.outflux.net> <56C59DC5.19217.28FA99@pageexec.freemail.hu> <CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: PaX Team <pageexec@freemail.hu>, Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thursday 18 February 2016 12:34:50 Ard Biesheuvel wrote:
> 
> We have __section() as an alias for __attribute__((__section__())), so
> we could use that instead.
> 
> However, that does not fix the issue Kees is trying to solve, where a
> .rodata section is emitted with the "x" bit set, which causes the
> linker to complain:
> 
> /tmp/cc50ffWw.s: Assembler messages:
> /tmp/cc50ffWw.s:2: Warning: setting incorrect section attributes for
> .rodata.text
> 
> I wonder if we could get away with doing something like
> 
> AFLAGS_lkdtm.o += -Wa,-W
> 
> here? This just hides the warnings, but may result in the .rodata
> section in the vmlinux file to have X permissions as well. I don't
> think anyone uses an ELF loader to load their kernel, but who knows
> ...

Don't we also get a warning when we link objects with conflicting
section attributes?

Maybe a solution would be to define a separate section for this one
function, and then use a linker script to move it into .rodata?
Or maybe "objcopy --set-section-flags  --rename-section"?

	Arnd
