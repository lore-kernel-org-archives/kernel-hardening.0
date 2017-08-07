References: <b1ddb305-bffd-0bbe-e38d-8213bbb1f9ee@embeddedor.com>
 <CAJcbSZEWZm3umjDF8wvnbih-nkwoBH4hQkFmnbAhHbREnBPYew@mail.gmail.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <992b014d-3421-c9f8-33bf-334e06a58ca2@embeddedor.com>
Date: Mon, 7 Aug 2017 15:52:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAJcbSZEWZm3umjDF8wvnbih-nkwoBH4hQkFmnbAhHbREnBPYew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] I want to help out
To: Thomas Garnier <thgarnie@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Thomas,

On 08/07/2017 10:31 AM, Thomas Garnier wrote:
> Hey Gustavo, welcome!
>

Thanks!

> That's a lot of changes, thanks for sharing.
>

I'm glad to help. :)

> You can take a look at this page [1] to get an idea on things to do.
> You can also look at the difference patches coming and going on the
> mailing list to see if anything interest you.
>
> Anything in particular you wanted to prototype?
>

I'm interested in mitigation efforts towards control flow infection, as 
function pointer poisoning for both .init_array (I know there is some 
ongoing work here) and .fini_array.

 From the TODO list I think the following tasks are interesting:

* Split thread_info off of kernel stack.
* Move kernel stack to vmap area.
* Implement kernel relocation and KASLR for ARM

If there is already some work in progress and there are some small tasks 
pending to be completed, I'd like to help.

I might need someone to point me out to the work already in place and, 
after reading some code and asking some questions I might be able to 
take it from there.

I have to say that by no means I'm an expert in any of those areas, but 
I'm willing to learn and become a long term contributor.

Recently, I've been using Coccinelle to constify structures, and fixing 
a variety of Coverity issues (API usage errors, NULL pointer 
dereferences, control flow and code maintainability issues, etc..). I'm 
also using Coccinelle to identify lock/unlock issues.

Thank you!
-- 
Gustavo A. R. Silva

> Thanks,
>
> [1] https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work
>
> On Sun, Aug 6, 2017 at 9:22 PM, Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>> Hello everybody,
>>
>> I'm new in the mailing list.
>>
>> I've been working on kernel hardening activities during the last three
>> months
>> https://github.com/GustavoARSilva/linux-hardening/blob/master/cii/2017/reports/mayjunjul_detailed
>>
>> I'd be more than happy to dedicate time and help out with any coding
>> activities you may need help with. In particular related to x86 and ARM
>> architectures (that's the hardware I have at hand).
>>
>> Thank you
>> --
>> Gustavo A. R. Silva
>> @embeddedgus
>
>
>
