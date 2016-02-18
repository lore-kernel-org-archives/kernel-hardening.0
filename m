Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 18 Feb 2016 22:27:35 +0100
MIME-Version: 1.0
Message-ID: <56C63747.819.280B3F5@pageexec.freemail.hu>
In-reply-to: <CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
References: <20160216214904.GA23723@www.outflux.net>, <56C59DC5.19217.28FA99@pageexec.freemail.hu>, <CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 18 Feb 2016 at 12:34, Ard Biesheuvel wrote:

> However, that does not fix the issue Kees is trying to solve, where a
> .rodata section is emitted with the "x" bit set, which causes the
> linker to complain:
> 
> /tmp/cc50ffWw.s: Assembler messages:
> /tmp/cc50ffWw.s:2: Warning: setting incorrect section attributes for
> .rodata.text

in that case why not use a top-level asm statement to set the section
and its attributes (and compile the file with fno-toplevel-reorder)?
