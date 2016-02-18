Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 18 Feb 2016 11:32:37 +0100
MIME-Version: 1.0
Message-ID: <56C59DC5.19217.28FA99@pageexec.freemail.hu>
In-reply-to: <CAGXu5j+P=8HnkJA895wuKrEb6n+hK4RqFJhFSQqUhRWbxhpoag@mail.gmail.com>
References: <20160216214904.GA23723@www.outflux.net>, <56C3C796.7050206@redhat.com>, <CAGXu5j+P=8HnkJA895wuKrEb6n+hK4RqFJhFSQqUhRWbxhpoag@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: Laura Abbott <labbott@redhat.com>, Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 17 Feb 2016 at 12:29, Kees Cook wrote:

> >> +static void __attribute__((__section__(".rodata,\"a\",@progbits#")))
> >> +do_nothing_rodata(void)
> >> +{
> >> +       return;
> >> +}
> >> +
> >
> >
> >>
> >
> > This doesn't cross compile for me on arm64 with two different toolchains
> >
> > CC drivers/misc/lkdtm.o
> > /tmp/ccHzIWIx.s: Assembler messages:
> > /tmp/ccHzIWIx.s:21: Error: junk at end of line, first unrecognized character
> > is `#'
> > /tmp/ccHzIWIx.s: Error: unaligned opcodes detected in executable segment
> > scripts/Makefile.build:258: recipe for target 'drivers/misc/lkdtm.o' failed
> > make[2]: *** [drivers/misc/lkdtm.o] Error 1
> > scripts/Makefile.build:407: recipe for target 'drivers/misc' failed
> > make[1]: *** [drivers/misc] Error 2
> > Makefile:950: recipe for target 'drivers' failed
> > make: *** [drivers] Error 2
> >
> > I don't know the assembler well enough to give any insight.
> 
> Hm, bummer. I was trying to get fancy with the function forced into
> .rodata by trying to force the bits. Looks like "#" is not seen as a
> comment character by the toolchain you're using.
> 
> Anyone else successfully done tricks like this?

wouldn't it be a better and more generic/reusable approach to

#define __ro_text __attribute__((__section__(".rodata.text")))

and move this function there by the linker script similar to how it's done
for other code that goes into special sections?
