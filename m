Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161018235835.GB1210@laptop.thejh.net>
References: <58061416.7020209@oracle.com> <20161018131300.GM14666@pc.thejh.net>
 <CACXcFmnOjbxXf9ek2mwgyYSXvf=aUY5FcOsgNC8GbA2at=D9tQ@mail.gmail.com> <20161018235835.GB1210@laptop.thejh.net>
From: Sandy Harris <sandyinchina@gmail.com>
Date: Mon, 24 Oct 2016 18:16:47 -0400
Message-ID: <CACXcFm=hqQQWGfQcZtMUkL82S12M9eksBtf_fjyq0J+bNKbxWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Use-after-free and management of reference counts
To: Jann Horn <jann@thejh.net>
Cc: kernel-hardening@lists.openwall.com, Vaishali Thakkar <vaishali.thakkar@oracle.com>, Julia Lawall <julia.lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 18, 2016 at 7:58 PM, Jann Horn <jann@thejh.net> wrote:
> On Tue, Oct 18, 2016 at 06:56:24PM -0400, Sandy Harris wrote:
>> On Tue, Oct 18, 2016 at 9:13 AM, Jann Horn <jann@thejh.net> wrote:
>>
>> > Use-after-frees are really hard to deal with.
>>
>> ...
>>
>> One is allocating something within a function, then returning a
>> pointer to it. I know I've done that on occasion, got a warning from
>> lint(1) or the compiler, & fixed it; I have forgotten details. Surely
>> current static analysis tools can catch nearly all of these. If not,
>> writing one looks fairly straightforward. Sure, complex code with a
>> lot of indirection might fool such tools, but in general such code
>> should not be used anyway.
>
> I'm pretty sure the kernel does that in a lot of places, actually.

I meant code that allocates things on the stack & then returns a
pointer to them. That memory is guaranteed invalid since the
function's stack area is invalid after return. Surely such errors
are rare & can be caught by static analysis. Their frequency
should be near zero in any well-written code and zero once it
has gone through the sort of testing kernel code gets.

I think you meant calling something from the malloc() family
of functions, doing some error checking or initialisation, &
then returning the pointer. That is valid code; it just requires
great care to balance *alloc()s and free()s,
