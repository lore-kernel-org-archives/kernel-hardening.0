MIME-Version: 1.0
In-Reply-To: <CAGXu5jKbZZJxu0U_cy_UzxG9NtkEtTw2va7X=8AuwzQwAvkbjw@mail.gmail.com>
References: <20170225003232.GA123380@beast> <1488011791.1141.1.camel@gmail.com>
 <CAGXu5jKbZZJxu0U_cy_UzxG9NtkEtTw2va7X=8AuwzQwAvkbjw@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Mon, 27 Mar 2017 16:24:37 +0530
Message-ID: <CAPDLWs_osmX=Rd_=bthrbf2zL=561LnJF+9ox7tP-+ANAhs+kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC] mm: enable sanitizing via CONFIG
To: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

> I'd love to see someone step up and create this for upstream. I think
> it'd make a lot of sense instead of trying to shoe-horn things into
> SLUB...
>
Ok, am unsure if I clearly understand all the issues involved; but of
course it's always better to make a start and then evolve. So, how
exactly can this be tackled? Do we go down the "new SLUB for security"
path? And, if yes, then how exactly does one get started? I'll need
some pointers pl...

Regards,
Kaiwan.

On Thu, Mar 2, 2017 at 12:46 AM, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Feb 25, 2017 at 12:36 AM, Daniel Micay <danielmicay@gmail.com> wrote:
>> On Fri, 2017-02-24 at 16:32 -0800, Kees Cook wrote:
>>> This enables page and slab poisoning by default under
>>> CONFIG_MEMORY_SANITIZE.
>>> Based on work by Kaiwan N Billimoria.
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>> This is more what I had in mind. This is based on the latest patch,
>>> but
>>> handles slab and slub. I tested slub with lkdtm's READ_AFTER_FREE and
>>> READ_BUDDY_AFTER_FREE which both trip the poisoning tests.
>>>
>>> While doing this, I noticed one major issue with slub/slab poisoning:
>>> it performs poisoning both on alloc and free, which is a rather large
>>> performance hit, so the next step is likely to find a way to split the
>>> poisoning into alloc and free halves so that CONFIG_MEMORY_SANITIZE
>>> poisoning will only happen on the free.
>>
>> It also still fills with a value that will make pointers point to
>> userspace, right? Rather than a better value or zeroing (and relying on
>> mmap_min_addr, although that's pretty small and easy to index past).
>
> Correct. We have to get there in pieces, though I continue to think it
> would still be easier to make the sanitization feature separate from
> debugging.
>
> In PaX, the poison value on x86_64 is 0xfe (to make addresses aim into
> the noncanonical range), otherwise 0xff (to point at the top of
> memory).
>
>> It also verifies the poisoning is still there, which can be wanted but
>> is more expensive. It increases allocations by the size of a pointer
>> which PaX doesn't do anymore, and there's the whole losing the fast path
>> which seems to mean losing CPU caching too since it's just hitting the
>> global stuff. The debug infrastructure could also be a risk, that would
>> not be present in normal builds up to this point.
>
> Gathering the reasons against this being part of the debug path would
> be a nice thing to collect; it might be convincing to the allocator
> maintainers.
>
>> I would like to be able to use upstream features but I think case it
>> seems that anyone not willing to unnecessarily lose performance and
>> security properties will need to keep carrying ~15 line of code out of
>> tree or using the PaX features.
>
> The simple form (without the SLAB_NO_SANITIZE) is alarmingly small. :)
>
>> Is there a path to doing it properly from here? I really don't see the
>> point in it being upstreaming if it's such a hack. It's frustrating...
>>
>> Not to mention that real allocator hardening like not having inline free
>> lists and being able to reliably detect double-free would be nice. Maybe
>> there should just be a security-oriented slab allocator, freeing it from
>> needing to avoid stepping on other people's toes. It just needs to pick
>> a performance target and then the design can shift away from the current
>> one within that target over time. *shrug*
>
> I'd love to see someone step up and create this for upstream. I think
> it'd make a lot of sense instead of trying to shoe-horn things into
> SLUB...
>
> -Kees
>
> --
> Kees Cook
> Pixel Security
>
