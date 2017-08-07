MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <992b014d-3421-c9f8-33bf-334e06a58ca2@embeddedor.com>
References: <b1ddb305-bffd-0bbe-e38d-8213bbb1f9ee@embeddedor.com>
 <CAJcbSZEWZm3umjDF8wvnbih-nkwoBH4hQkFmnbAhHbREnBPYew@mail.gmail.com> <992b014d-3421-c9f8-33bf-334e06a58ca2@embeddedor.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 7 Aug 2017 14:42:23 -0700
Message-ID: <CAGXu5jJfwmqifHkyminEKNOcmeC8_5x0dVajD+bSgQmUSG3WyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] I want to help out
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Thomas Garnier <thgarnie@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Welcome to the list!

On Mon, Aug 7, 2017 at 1:52 PM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> On 08/07/2017 10:31 AM, Thomas Garnier wrote:
>> You can take a look at this page [1] to get an idea on things to do.
>> You can also look at the difference patches coming and going on the
>> mailing list to see if anything interest you.
>>
>> Anything in particular you wanted to prototype?
>>
>
> I'm interested in mitigation efforts towards control flow infection, as
> function pointer poisoning for both .init_array (I know there is some
> ongoing work here) and .fini_array.

I'd be curious to hear more about this work.

> From the TODO list I think the following tasks are interesting:
>
> * Split thread_info off of kernel stack.
> * Move kernel stack to vmap area.
> * Implement kernel relocation and KASLR for ARM

All three of these are needed on 32-bit arm. The last is a tricky one,
since kernel relocation is needed before KASLR can happen on ARM.

> If there is already some work in progress and there are some small tasks
> pending to be completed, I'd like to help.

More testing on arm64 VMAP_STACK would be great, if you have hardware available.

> Recently, I've been using Coccinelle to constify structures, and fixing a
> variety of Coverity issues (API usage errors, NULL pointer dereferences,
> control flow and code maintainability issues, etc..). I'm also using
> Coccinelle to identify lock/unlock issues.

This is good work to be getting done too!

-Kees

-- 
Kees Cook
Pixel Security
