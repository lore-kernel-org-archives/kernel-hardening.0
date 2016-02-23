Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160223203131.GA1797@davidb.org>
References: <20160216214904.GA23723@www.outflux.net>
	<56C59DC5.19217.28FA99@pageexec.freemail.hu>
	<CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
	<56C63747.819.280B3F5@pageexec.freemail.hu>
	<CAGXu5jKM5RZeTgTonscuLRg-+62S8UWcPbJABWqT4=7HOwb2bA@mail.gmail.com>
	<20160223203131.GA1797@davidb.org>
Date: Tue, 23 Feb 2016 12:51:44 -0800
Message-ID: <CAGXu5jKFB6b_fdK4Pg19cyGcpfjmN4SdJR3638T-7QXxntA+8A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: David Brown <david.brown@linaro.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 23, 2016 at 12:31 PM, David Brown <david.brown@linaro.org> wrote:
> On Mon, Feb 22, 2016 at 12:46:28PM -0800, Kees Cook wrote:
>>
>> On Thu, Feb 18, 2016 at 1:27 PM, PaX Team <pageexec@freemail.hu> wrote:
>>>
>>> On 18 Feb 2016 at 12:34, Ard Biesheuvel wrote:
>>>
>>>> However, that does not fix the issue Kees is trying to solve, where a
>>>> .rodata section is emitted with the "x" bit set, which causes the
>>>> linker to complain:
>>>>
>>>> /tmp/cc50ffWw.s: Assembler messages:
>>>> /tmp/cc50ffWw.s:2: Warning: setting incorrect section attributes for
>>>> .rodata.text
>>>
>>>
>>> in that case why not use a top-level asm statement to set the section
>>> and its attributes (and compile the file with fno-toplevel-reorder)?
>>
>>
>> GCC really wants to declare the section. :(
>
>
> Why not then just use its mechanism to set the section on the code?

It's noted in the quoted section above. :) The problem is that gcc emits:

.section ".rodata","ax",@progbits

But we need the flags to be "a" not "ax". (And I'd note that even "@"
is arch-specific. % is used when @ is a comment start character.)

objcopy can get me the "a", but it seems to require renaming lkdtm.c,
which I really don't want to do.

-Kees

>
> static void do_nothing_rodata(void)
>         __attribute__((section(".rodata")))
> {
>         return;
> }
>
> David



-- 
Kees Cook
Chrome OS & Brillo Security
