Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56C63747.819.280B3F5@pageexec.freemail.hu>
References: <20160216214904.GA23723@www.outflux.net>
	<56C59DC5.19217.28FA99@pageexec.freemail.hu>
	<CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
	<56C63747.819.280B3F5@pageexec.freemail.hu>
Date: Mon, 22 Feb 2016 12:46:28 -0800
Message-ID: <CAGXu5jKM5RZeTgTonscuLRg-+62S8UWcPbJABWqT4=7HOwb2bA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: PaX Team <pageexec@freemail.hu>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 18, 2016 at 1:27 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 18 Feb 2016 at 12:34, Ard Biesheuvel wrote:
>
>> However, that does not fix the issue Kees is trying to solve, where a
>> .rodata section is emitted with the "x" bit set, which causes the
>> linker to complain:
>>
>> /tmp/cc50ffWw.s: Assembler messages:
>> /tmp/cc50ffWw.s:2: Warning: setting incorrect section attributes for
>> .rodata.text
>
> in that case why not use a top-level asm statement to set the section
> and its attributes (and compile the file with fno-toplevel-reorder)?

GCC really wants to declare the section. :(

asm(".pushsection .rodata");
static void do_nothing_rodata(void)
{
        return;
}
asm(".popsection");

With -fno-toplevel-reorder, this produces:

#APP
        .pushsection .rodata
#NO_APP
        .section        .text.unlikely
.LCOLDB42:
        .text
.LHOTB42:
        .p2align 4,,15
        .type   do_nothing_rodata, @function
do_nothing_rodata:
.LFB2756:
        .loc 1 323 0
        .cfi_startproc
        pushq   %rbp
...

So I either need to define "ret" for every architecture, define the
linker comment character for every architecture, or do some generated
file. I'll try the latter next...

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
