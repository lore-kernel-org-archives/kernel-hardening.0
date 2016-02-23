Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 23 Feb 2016 13:31:31 -0700
From: David Brown <david.brown@linaro.org>
Message-ID: <20160223203131.GA1797@davidb.org>
References: <20160216214904.GA23723@www.outflux.net>
 <56C59DC5.19217.28FA99@pageexec.freemail.hu>
 <CAKv+Gu_ABQa4L7ZzHMD+-BPLtJf_UO9TfLy0jKFLfCsyQE6dLQ@mail.gmail.com>
 <56C63747.819.280B3F5@pageexec.freemail.hu>
 <CAGXu5jKM5RZeTgTonscuLRg-+62S8UWcPbJABWqT4=7HOwb2bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jKM5RZeTgTonscuLRg-+62S8UWcPbJABWqT4=7HOwb2bA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing
 .rodata
To: kernel-hardening@lists.openwall.com
Cc: PaX Team <pageexec@freemail.hu>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 22, 2016 at 12:46:28PM -0800, Kees Cook wrote:
>On Thu, Feb 18, 2016 at 1:27 PM, PaX Team <pageexec@freemail.hu> wrote:
>> On 18 Feb 2016 at 12:34, Ard Biesheuvel wrote:
>>
>>> However, that does not fix the issue Kees is trying to solve, where a
>>> .rodata section is emitted with the "x" bit set, which causes the
>>> linker to complain:
>>>
>>> /tmp/cc50ffWw.s: Assembler messages:
>>> /tmp/cc50ffWw.s:2: Warning: setting incorrect section attributes for
>>> .rodata.text
>>
>> in that case why not use a top-level asm statement to set the section
>> and its attributes (and compile the file with fno-toplevel-reorder)?
>
>GCC really wants to declare the section. :(

Why not then just use its mechanism to set the section on the code?

static void do_nothing_rodata(void)
	__attribute__((section(".rodata")))
{
	return;
}

David
