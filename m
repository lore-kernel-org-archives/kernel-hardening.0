Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160620055836.GA3266@osiris>
References: <cover.1466036668.git.luto@kernel.org> <20160616060538.GA3923@osiris>
 <CALCETrVD6aLzvgHxTji0mm5Fzkqq_h-bxWqF1bv+7z33UrgYgA@mail.gmail.com>
 <20160617072737.GA3960@osiris> <CALCETrVh+w1Bj2K5QGvJwsbrGrrD_=zz1vWPC2zXUai6YB9dBA@mail.gmail.com>
 <20160620055836.GA3266@osiris>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 19 Jun 2016 23:01:48 -0700
Message-ID: <CALCETrUgpbTXnvkmLNZz9sSq8fgz1g8eoGv=1Lif2dhyB6GrSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brian Gerst <brgerst@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 19, 2016 at 10:58 PM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Fri, Jun 17, 2016 at 10:38:24AM -0700, Andy Lutomirski wrote:
>> > A disassembly looks like this (r15 is the stackpointer):
>> >
>> > 0000000000000670 <setup_arch>:
>> >      670:       eb 6f f0 48 00 24       stmg    %r6,%r15,72(%r15)
>> >      676:       c0 d0 00 00 00 00       larl    %r13,676 <setup_arch+0x6>
>> >      67c:       a7 f1 3f 80             tmll    %r15,16256  <--- test if enough space left
>> >      680:       b9 04 00 ef             lgr     %r14,%r15
>> >      684:       a7 84 00 01             je      686 <setup_arch+0x16> <--- branch to illegal op
>> >      688:       e3 f0 ff 90 ff 71       lay     %r15,-112(%r15)
>> >
>> > The branch jumps actually into the branch instruction itself since the 0001
>> > part of the "je" instruction is an illegal instruction.
>> >
>> > This catches at least wild stack overflows because of two many functions
>> > being called.
>> >
>> > Of course it doesn't catch wild accesses outside the stack because e.g. the
>> > index into an array on the stack is wrong.
>> >
>> > The runtime overhead is within noise ratio, therefore we have this always
>> > enabled.
>> >
>>
>> Neat!  What exactly does tmll do?  I assume this works by checking the
>> low bits of the stack pointer.
>>
>> x86_64 would have to do:
>>
>> movl %esp, %r11d
>> shll %r11d, $18
>> cmpl %r11d, <threshold>
>> jg error
>>
>> Or similar.  I think the cmpl could be eliminated if the threshold
>> were a power of two by simply testing the low bits of the stack
>> pointer.
>
> The tmll instruction tests if any of the higher bits within the 16k
> stackframe address are set. In this specific case that would be bits 7-15
> (mask 0x3f80). If no bit would be set we know that only up to 128 bytes
> would be left on the stack, and thus trigger an exception.
>
> This check does of course only work if a 16k stack is also 16k aligned,
> which is always the case.
>

Oh, interesting.  How do you handle the case of a single function that
uses more than 128 bytes of stack?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
