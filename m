References: <cf7e6840-1019-020f-ad4a-0adbe0ee79cf@huawei.com>
 <CAGXu5jK+YQoDofEJa_1Ai9anKpQ836sQ=RVOCD-Ny_pfAVmkgw@mail.gmail.com>
From: Li Kun <hw.likun@huawei.com>
Message-ID: <45296d18-bbc3-c527-0060-b44cbff66d93@huawei.com>
Date: Fri, 23 Jun 2017 12:21:38 +0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jK+YQoDofEJa_1Ai9anKpQ836sQ=RVOCD-Ny_pfAVmkgw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [kernel hardening]Could we do something for KSPP?
To: Kees Cook <keescook@chromium.org>
Cc: "Wangkai (Morgan, Euler)" <morgan.wang@huawei.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi

在 2017/6/23 0:51, Kees Cook 写道:
> On Thu, Jun 22, 2017 at 6:25 AM, Li Kun <hw.likun@huawei.com> wrote:
>> Hi Kees,
>>
>> My name is Li Kun, from a new formed Huawei kernel security team.
> Hi! Thanks for the email. Feel free to email the
> kernel-hardening@lists.openwall.com list to make a similar
> introduction.
>
>> My companion and me have been working on kernel and arm64 for sevral
>> years,but don't have much experiences in kernel security yet.
>>
>> We have studied Pax&Grsecurity for few months , and have seen that there is
>> much progress in KSPP recently.
>>
>> I'm wondering that if there is something we can do for KSPP? Maybe we can
>> implement the "vmalloc kernel stack for arm64" or
>>
>> "fast refcount overflow protection for arm64" or if you have some
>> suggestions ,please let me know.
> I think either of these would be great. Mark Rutland mentioned in
> private to me that AKASHI Takahiro had been working a bit on
> VMAP_STACK for arm64, but that they had issues with catching
> over/under-flows. Perhaps send an email to the public list with them
> CCed asking on the status and how you can help?
  Thank you for the information :)
  I will send another email to discuss this and see what can i do.
>> The vmapping itself is simple, and we don't need to do anything special
>> there. IIRC Takahiro-san had done some tests with HAVE_ARCH_VMAP_STACK,
>> and there weren't any obvious problems.
> As for refcount overflow protection, the starting point is likely the
> arm protection in the last public grsecurity patch, which is discussed
> here:
> https://forums.grsecurity.net/viewtopic.php?f=7&t=4173#ARM
>
> For the refcount implementation, though, it'll likely need tweaking to
> be a _refcount_ protection rather than a generalized atomic_t
> protection, which is what grsecurity uses. Since upstream is splitting
> out refcount_t from atomic_t, we can actually be a little bit tighter
> in how the checks are performed.
I noticed that you have send a patch set of fast refcount overflow 
protection as below.

http://kernel-hardening.openwall.narkive.com/qTKqEF4F/patch-v5-0-3-implement-fast-refcount-overflow-protection

I think it is nearing accomplishment if i haven't get it wrong. Maybe i 
can do the job on arm64 based on your latest patch set?

Thank you very much!
>
> Please follow up on the public mailing list; the more people involved
> the better. :)
>
> Thanks for reaching out!
>
> -Kees
>

-- 
Best Regards
Li Kun
