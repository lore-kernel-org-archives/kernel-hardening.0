Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <56C59DC5.19217.28FA99@pageexec.freemail.hu>
References: <20160216214904.GA23723@www.outflux.net>
	<56C3C796.7050206@redhat.com>
	<CAGXu5j+P=8HnkJA895wuKrEb6n+hK4RqFJhFSQqUhRWbxhpoag@mail.gmail.com>
	<56C59DC5.19217.28FA99@pageexec.freemail.hu>
Date: Thu, 18 Feb 2016 12:34:50 +0100
Message-ID: <CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: PaX Team <pageexec@freemail.hu>
Cc: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 18 February 2016 at 11:32, PaX Team <pageexec@freemail.hu> wrote:
> On 17 Feb 2016 at 12:29, Kees Cook wrote:
>
>> >> +static void __attribute__((__section__(".rodata,\"a\",@progbits#")))
>> >> +do_nothing_rodata(void)
>> >> +{
>> >> +       return;
>> >> +}
>> >> +
>> >
>> >
>> >>
>> >
>> > This doesn't cross compile for me on arm64 with two different toolchains
>> >
>> > CC drivers/misc/lkdtm.o
>> > /tmp/ccHzIWIx.s: Assembler messages:
>> > /tmp/ccHzIWIx.s:21: Error: junk at end of line, first unrecognized character
>> > is `#'
>> > /tmp/ccHzIWIx.s: Error: unaligned opcodes detected in executable segment
>> > scripts/Makefile.build:258: recipe for target 'drivers/misc/lkdtm.o' failed
>> > make[2]: *** [drivers/misc/lkdtm.o] Error 1
>> > scripts/Makefile.build:407: recipe for target 'drivers/misc' failed
>> > make[1]: *** [drivers/misc] Error 2
>> > Makefile:950: recipe for target 'drivers' failed
>> > make: *** [drivers] Error 2
>> >
>> > I don't know the assembler well enough to give any insight.
>>
>> Hm, bummer. I was trying to get fancy with the function forced into
>> .rodata by trying to force the bits. Looks like "#" is not seen as a
>> comment character by the toolchain you're using.
>>
>> Anyone else successfully done tricks like this?
>
> wouldn't it be a better and more generic/reusable approach to
>
> #define __ro_text __attribute__((__section__(".rodata.text")))
>
> and move this function there by the linker script similar to how it's done
> for other code that goes into special sections?
>

We have __section() as an alias for __attribute__((__section__())), so
we could use that instead.

However, that does not fix the issue Kees is trying to solve, where a
.rodata section is emitted with the "x" bit set, which causes the
linker to complain:

/tmp/cc50ffWw.s: Assembler messages:
/tmp/cc50ffWw.s:2: Warning: setting incorrect section attributes for
.rodata.text

I wonder if we could get away with doing something like

AFLAGS_lkdtm.o += -Wa,-W

here? This just hides the warnings, but may result in the .rodata
section in the vmlinux file to have X permissions as well. I don't
think anyone uses an ELF loader to load their kernel, but who knows
...

That only matters when lkdtm is a module, btw
