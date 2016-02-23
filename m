Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56CB97EE.29381.17824260@pageexec.freemail.hu>
References: <20160216214904.GA23723@www.outflux.net>
	<56C63747.819.280B3F5@pageexec.freemail.hu>
	<CAGXu5jKM5RZeTgTonscuLRg-+62S8UWcPbJABWqT4=7HOwb2bA@mail.gmail.com>
	<56CB97EE.29381.17824260@pageexec.freemail.hu>
Date: Tue, 23 Feb 2016 12:53:25 -0800
Message-ID: <CAGXu5jLhZMMS_StwD_2yDPoF1tL1OwfBrfo3n217RYnrHkwMww@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: PaX Team <pageexec@freemail.hu>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 22, 2016 at 3:21 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 22 Feb 2016 at 12:46, Kees Cook wrote:
>
>> GCC really wants to declare the section. :(
>
> hmm, i see, so how about going about it another way. instead of trying
> to do this at compile/link time, do it an load/runtime. one way of doing
> it would be to preserve a page in .rodata then map in a code page underneath
> that holds your empty function (which you can generate from C). it'd be
> somewhat similar to how the vsyscall page on amd64 is mapped (or used to
> be mapped) from the kernel image into its userland visible place.

I prefer using all the "regular" mechanisms so that I really know I'm
exercising the actual case I want to be testing. (i.e. I don't want to
bypass the linker.)

If only there were some way to filter gcc output, like with plugins. ;)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
