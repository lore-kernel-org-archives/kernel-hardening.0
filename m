Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151126171706.GB32190@chrystal.uk.oracle.com>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
	<20151125234542.GA10324@chrystal>
	<20151126171706.GB32190@chrystal.uk.oracle.com>
Date: Fri, 27 Nov 2015 12:18:55 -0800
Message-ID: <CAGXu5j+ttTK5w-i7wituvrrkSXexta-3VWktBi1t5GC82iBQFw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 26, 2015 at 9:17 AM, Quentin Casasnovas
<quentin.casasnovas@oracle.com> wrote:
> On Thu, Nov 26, 2015 at 12:45:42AM +0100, Quentin Casasnovas wrote:
>> On Tue, Nov 24, 2015 at 11:10:09AM -0800, Kees Cook wrote:
>> > Hi,
>> >
>>
>> Hi Kees,
>>
>> > I just wanted to check in and see how progress was going on the stack
>> > overflow feature. Anything we can help with?
>> >
>>
>> Sorry for not following up on this, I've been busy and haven't had the time
>> to finish it properly.  I've pushed an initial WIP break up of the
>> KSTACK_OVERFLOW feature on my github:
>>
>>   https://github.com/casasnovas/linux/tree/quentin-split-kstackoverflow
>>
>> This is far from being complete though, and hasn't been cleaned at all.  I
>> didn't share it earlier because I don't think I fully understand it and
>> haven't tested it yet.  In "short", there's mention of guard pages in the
>> Kconfig help:
>>
>>   If you say Y here, the kernel's process stacks will be allocated with
>>   vmalloc instead of the kernel's default allocator.  This introduces guard
>>                                                                       ^^^^^
>>   pages that in combination with the alloca checking of the STACKLEAK
>>   ^^^^^
>>   feature prevents all forms of kernel process stack overflow abuse.  Note
>>   that this is different from kernel stack buffer overflows. """
>>
>> And I couldn't find anything about it in the code.  Maybe it's just coming
>> from a mis-interpretation of the above text, but I was expecting this to
>> mean there would be a PROT_NONE guard page after the end of the stack, so
>> that read/writes below it could be trapped.  It could also be that I missed
>> some parts in my initial break-up or simply am missing something.
>>
>
> Alright, there's a guard page by default when using vmap() unless
> VM_NO_GUARD is in the flags.  I had a feeling I was missing some bits.. ;)

Is this documented anywhere in Documentation? Reading the code
quickly, I don't understand what actually makes this a guard page. It
looks like the requested size is just grown. Is it actually set up in
a way that'll trap if it that page gets touched?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
