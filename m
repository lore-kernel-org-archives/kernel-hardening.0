Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5j+P=8HnkJA895wuKrEb6n+hK4RqFJhFSQqUhRWbxhpoag@mail.gmail.com>
References: <20160216214904.GA23723@www.outflux.net>
	<56C3C796.7050206@redhat.com>
	<CAGXu5j+P=8HnkJA895wuKrEb6n+hK4RqFJhFSQqUhRWbxhpoag@mail.gmail.com>
Date: Wed, 17 Feb 2016 13:06:12 -0800
Message-ID: <CAGXu5jJk8vvUWuB5a=3+mdbUXT=BxsNfemd6MBPVLDyuCx=KiQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] lkdtm: add test for executing .rodata
To: Laura Abbott <labbott@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mark Rutland <mark.rutland@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 17, 2016 at 12:29 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Feb 16, 2016 at 5:06 PM, Laura Abbott <labbott@redhat.com> wrote:
>>
>>
>> On 02/16/2016 01:49 PM, Kees Cook wrote:
>>>
>>> Make sure that the read-only data section isn't executable.
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>   drivers/misc/lkdtm.c | 28 +++++++++++++++++++++-------
>>>   1 file changed, 21 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
>>> index 11fdadc68e53..9835fcc0506e 100644
>>> --- a/drivers/misc/lkdtm.c
>>> +++ b/drivers/misc/lkdtm.c
>>> @@ -100,6 +100,7 @@ enum ctype {
>>>         CT_EXEC_STACK,
>>>         CT_EXEC_KMALLOC,
>>>         CT_EXEC_VMALLOC,
>>> +       CT_EXEC_RODATA,
>>>         CT_EXEC_USERSPACE,
>>>         CT_ACCESS_USERSPACE,
>>>         CT_WRITE_RO,
>>> @@ -137,6 +138,7 @@ static char* cp_type[] = {
>>>         "EXEC_STACK",
>>>         "EXEC_KMALLOC",
>>>         "EXEC_VMALLOC",
>>> +       "EXEC_RODATA",
>>>         "EXEC_USERSPACE",
>>>         "ACCESS_USERSPACE",
>>>         "WRITE_RO",
>>> @@ -315,6 +317,12 @@ static int recursive_loop(int remaining)
>>>                 return recursive_loop(remaining - 1);
>>>   }
>>>
>>> +static void __attribute__((__section__(".rodata,\"a\",@progbits#")))
>>> +do_nothing_rodata(void)
>>> +{
>>> +       return;
>>> +}
>>> +
>>
>>
>>>
>>
>> This doesn't cross compile for me on arm64 with two different toolchains
>>
>> CC drivers/misc/lkdtm.o
>> /tmp/ccHzIWIx.s: Assembler messages:
>> /tmp/ccHzIWIx.s:21: Error: junk at end of line, first unrecognized character
>> is `#'
>> /tmp/ccHzIWIx.s: Error: unaligned opcodes detected in executable segment
>> scripts/Makefile.build:258: recipe for target 'drivers/misc/lkdtm.o' failed
>> make[2]: *** [drivers/misc/lkdtm.o] Error 1
>> scripts/Makefile.build:407: recipe for target 'drivers/misc' failed
>> make[1]: *** [drivers/misc] Error 2
>> Makefile:950: recipe for target 'drivers' failed
>> make: *** [drivers] Error 2
>>
>> I don't know the assembler well enough to give any insight.
>
> Hm, bummer. I was trying to get fancy with the function forced into
> .rodata by trying to force the bits. Looks like "#" is not seen as a
> comment character by the toolchain you're using.

/me cries: the comment character is arch-specific (# on x86, @ on arm).

Looks like "//" works, but only at the start of a new line, and ";" is
seen as a new line start, so ";//" should work everywhere... I'll send
a v2, build and runtested on x86 and arm, and we'll see if the
buildbot kicks out any other cross compile failures...

-Kees

> Anyone else successfully done tricks like this?
>
> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security



-- 
Kees Cook
Chrome OS & Brillo Security
