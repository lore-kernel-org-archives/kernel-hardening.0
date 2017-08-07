References: <b1ddb305-bffd-0bbe-e38d-8213bbb1f9ee@embeddedor.com>
 <CAJcbSZEWZm3umjDF8wvnbih-nkwoBH4hQkFmnbAhHbREnBPYew@mail.gmail.com>
 <992b014d-3421-c9f8-33bf-334e06a58ca2@embeddedor.com>
 <CAGXu5jJfwmqifHkyminEKNOcmeC8_5x0dVajD+bSgQmUSG3WyA@mail.gmail.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <20156f2a-6171-6a90-d4bc-f384f9c9247a@embeddedor.com>
Date: Mon, 7 Aug 2017 18:35:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJfwmqifHkyminEKNOcmeC8_5x0dVajD+bSgQmUSG3WyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] I want to help out
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Garnier <thgarnie@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 08/07/2017 04:42 PM, Kees Cook wrote:
> Welcome to the list!
>

Thank you, Kees. :)

> On Mon, Aug 7, 2017 at 1:52 PM, Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>> On 08/07/2017 10:31 AM, Thomas Garnier wrote:
>>> You can take a look at this page [1] to get an idea on things to do.
>>> You can also look at the difference patches coming and going on the
>>> mailing list to see if anything interest you.
>>>
>>> Anything in particular you wanted to prototype?
>>>
>>
>> I'm interested in mitigation efforts towards control flow infection, as
>> function pointer poisoning for both .init_array (I know there is some
>> ongoing work here) and .fini_array.
>
> I'd be curious to hear more about this work.
>

Yeah, this has to do with the use __ro_after_init for the case of .ctors 
(.init_array) ELF section.

The case of .dtors or .fini_array ELF section is similar. A heap 
overflow could overwrite a .fini_array function pointer. But I guess 
this could be detected by guard pages.

>> From the TODO list I think the following tasks are interesting:
>>
>> * Split thread_info off of kernel stack.
>> * Move kernel stack to vmap area.
>> * Implement kernel relocation and KASLR for ARM
>
> All three of these are needed on 32-bit arm. The last is a tricky one,
> since kernel relocation is needed before KASLR can happen on ARM.
>

After reading this https://lwn.net/Articles/692208/ those first two 
tasks seem to be very challenging and even more interesting.

So, I guess the idea would be to follow this same approach:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e37e43a497d5a8b7c0cc1736d56986f432c394c9
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=13d4ea097d18b419ad2a2b696063d44bf59acec0
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c65eacbe290b8141554c71b2c94489e73ade8c8d

right?

Is this already working for arm64?

What would be a good strategy to start tackling those tasks?

>> If there is already some work in progress and there are some small tasks
>> pending to be completed, I'd like to help.
>
> More testing on arm64 VMAP_STACK would be great, if you have hardware available.
>

Oh, I guess this answer one of my questions above...

I'm sorry. I have a Beagle Bone Black, which is 32-bit.

>> Recently, I've been using Coccinelle to constify structures, and fixing a
>> variety of Coverity issues (API usage errors, NULL pointer dereferences,
>> control flow and code maintainability issues, etc..). I'm also using
>> Coccinelle to identify lock/unlock issues.
>
> This is good work to be getting done too!
>

Yeah, I've been doing this over the last three months and, the plan is 
to continue fixing similar issues for a whole year. :)

Thanks
-- 
Gustavo A. R. Silva
