MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180312054450.GF8631@eros>
References: <20180312052639.GE8631@eros> <861efe7a-e51f-e004-5979-aef0ed9ff1fe@embeddedor.com>
 <20180312054450.GF8631@eros>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 12 Mar 2018 21:05:36 -0700
Message-ID: <CAGXu5j+U2kyuSoDyg214HcDfkwCTytWR77EbnoDj0n2=rG70LA@mail.gmail.com>
Subject: Re: VLA commit log
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@apporbit.com>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Tycho Andersen <tycho@tycho.ws>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2018 at 10:44 PM, Tobin C. Harding <tobin@apporbit.com> wrote:
> On Mon, Mar 12, 2018 at 12:38:04AM -0500, Gustavo A. R. Silva wrote:
>>
>>
>> On 03/12/2018 12:26 AM, Tobin C. Harding wrote:
>> >Hi,
>> >
>> >I got some push back on the commit log we have all started to use
>> >(copying Kees' initial commit log).  If we are going to do hundreds of
>> >these patches should we write a perfectly correct commit log that can be
>> >included as the start of the 'why' of each VLA removal patch?  Here is
>> >my attempt, I am quite bad at writing commit logs so would love someone
>> >to fix it up.
>> >
>>
>> The same thing happened to me once and then I wrote this:
>
> I had a feeling this had happened to you but I couldn't find the patch
> that made me think that when writing this.
>
>> In preparation to enabling -Wvla, remove VLA and replace it
>> with a fixed-length array instead.
>
> ---
>
>> From a security viewpoint, the use of Variable Length Arrays can be

I avoid starting lines with "From" due to age-old mbox-format email
hilarity. Also, if we're going to be pedantic, we should say "stack
VLA".

>> a vector for stack overflow attacks. Also, in general, as the code

Many people confused "stack buffer overflow" with "stack exhaustion".
In this case, we should use the latter terminology.

>> evolves it is easy to lose track of how big a VLA can get. Thus, we
>> can end up having segfaults that are hard to debug.
>>
>> Also, fixed as part of the directive to remove all VLAs from
>> the kernel: https://lkml.org/lkml/2018/3/7/621
>
> ---
>
> Cool, I like this (between ---).  Kees can you ack this since I'm going
> to cut and paste it about 300 times :)

We've got two cases we're dealing with:

1) Actual VLA in use, etc.

2) -Wvla warns about a non-constant-expression, but it's a
constant-value ("const int foo = 5"). In this case, it appears no VLA
is generated, but we get the warning. So we're fixing VLA warnings
that aren't real. But we still want the coverage of -Wvla, so we need
to refactor these cases too.


So, for 1, sure:

---
The use of stack Variable Length Arrays needs to be avoided, as they
can be a vector for stack exhaustion, which can be both a runtime bug
(kernel Oops) or a security flaw (overwriting memory beyond the
stack). Also, in general, as code evolves it is easy to lose track of
how big a VLA can get. Thus, we can end up having runtime failures
that are hard to debug. As part of the directive[1] to remove all VLAs
from the kernel, and build with -Wvla, this patch [does whatever, with
analysis of alternatives, runtime impact, or memory usage].

[1] https://lkml.org/lkml/2018/3/7/621
---

For 2, how about something like this:

---
As part of the directive[1] to remove all VLAs from the kernel, it
would be nice to build with -Wvla. This warning is, however, overly
pessimistic in that it warns about not using constant expressions when
declaring stack array size: it still warns about constant values, even
though those do not appear to generate actual VLAs. This patch adjusts
the stack array declarations to use a constant expression to remove
this false positive by [whatever, with analysys of alternatives, etc].

[1] https://lkml.org/lkml/2018/3/7/621
---


What do you think?

-Kees

-- 
Kees Cook
Pixel Security
