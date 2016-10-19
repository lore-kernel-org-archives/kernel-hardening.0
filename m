Reply-To: kernel-hardening@lists.openwall.com
References: <58061416.7020209@oracle.com>
 <20161018131300.GM14666@pc.thejh.net>
 <CACXcFmnOjbxXf9ek2mwgyYSXvf=aUY5FcOsgNC8GbA2at=D9tQ@mail.gmail.com>
 <CAEXv5_gS-rS_31DoDFGu3YaknLpK654+S5-d=KXAHa8+ziPjYA@mail.gmail.com>
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Message-ID: <5806E8EE.1060104@oracle.com>
Date: Wed, 19 Oct 2016 09:00:54 +0530
MIME-Version: 1.0
In-Reply-To: <CAEXv5_gS-rS_31DoDFGu3YaknLpK654+S5-d=KXAHa8+ziPjYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Use-after-free and management of reference
 counts
To: David Windsor <dave@progbits.org>, kernel-hardening@lists.openwall.com
Cc: Julia Lawall <julia.lawall@lip6.fr>
List-ID: <kernel-hardening.lists.openwall.com>



On Wednesday 19 October 2016 05:49 AM, David Windsor wrote:
> On Tue, Oct 18, 2016 at 6:56 PM, Sandy Harris <sandyinchina@gmail.com> wrote:
>> On Tue, Oct 18, 2016 at 9:13 AM, Jann Horn <jann@thejh.net> wrote:
>>
>>> Use-after-frees are really hard to deal with.
>>
>> I want to ask a possibly naive questions -- why can't we avoid the
>> whole class of bugs in the first place? I can think of only two main
>> sources for use-after-free bugs, both avoidable.
>>
>> One is allocating something within a function, then returning a
>> pointer to it. I know I've done that on occasion, got a warning from
>> lint(1) or the compiler, & fixed it; I have forgotten details. Surely
>> current static analysis tools can catch nearly all of these. If not,
>> writing one looks fairly straightforward. Sure, complex code with a
>> lot of indirection might fool such tools, but in general such code
>> should not be used anyway.
>>
> 
> The main use case in the kernel of reference counters is garbage
> collection: the kernel manages a particular object that has multiple
> users.  It cannot safely delete this object until all users of the
> object have finished using it.   Users acquire and release references
> to this object via a get()/put() API.  When all users have called
> put(), the reference counter becomes 0 (or -1, or some other
> sentinel), and the kernel frees the object.
> 
> Things go wrong when the reference counter gets overflowed.  If the
> reference counter is represented with a signed integer type,
> overflowing the reference counter causes it to go from INT_MAX to
> INT_MIN, then approach 0.  Depending on the logic, the transition to
> INT_MIN may be enough to trigger the bug, but when the reference
> counter becomes 0, the kernel will free the underlying object guarded
> by the reference counter while it still has valid users.

One of the other case is when users forget to call put() functions.
I think we have seen many such missing put() cases in the kernel.
Sometimes in some cases it is also possible that users may call put()
little early. 

>> The other is misusing malloc()/free() or their kernel code analogs, &
>> the obvious solution is to avoid using those wherever possible. There
>> are some kernel data structures that need to grow dynamically, but I
>> do not think there need to be a lot. Code the few very carefully and
>> refuse to accept patches elsewhere that use dynamic allocation; the
>> problem may not vanish, but it looks like this reduces it to
>> manageable size.
>>
>> I have the feeling I might be missing something here. Pointers welcome.
> 

-- 
Vaishali
