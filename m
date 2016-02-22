Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Tue, 23 Feb 2016 00:21:18 +0100
MIME-Version: 1.0
Message-ID: <56CB97EE.29381.17824260@pageexec.freemail.hu>
In-reply-to: <CAGXu5jKM5RZeTgTonscuLRg-+62S8UWcPbJABWqT4=7HOwb2bA@mail.gmail.com>
References: <20160216214904.GA23723@www.outflux.net>, <56C63747.819.280B3F5@pageexec.freemail.hu>, <CAGXu5jKM5RZeTgTonscuLRg-+62S8UWcPbJABWqT4=7HOwb2bA@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 22 Feb 2016 at 12:46, Kees Cook wrote:

> GCC really wants to declare the section. :(

hmm, i see, so how about going about it another way. instead of trying
to do this at compile/link time, do it an load/runtime. one way of doing
it would be to preserve a page in .rodata then map in a code page underneath
that holds your empty function (which you can generate from C). it'd be
somewhat similar to how the vsyscall page on amd64 is mapped (or used to
be mapped) from the kernel image into its userland visible place.
