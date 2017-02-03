References: <20170129184316.GA31184@athena>
 <2d6c7a51-3de3-1d95-37aa-c53c2caa9968@oracle.com>
 <CAGXu5j+Ynmp3Z29_Zw6BG33P2RVi0eRtOiZR0incfoZBWF=7hg@mail.gmail.com>
 <20170203031151.GA15897@athena>
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Message-ID: <a329157c-2fd3-3eba-1d97-19c456e90cde@oracle.com>
Date: Fri, 3 Feb 2017 09:58:23 +0530
MIME-Version: 1.0
In-Reply-To: <20170203031151.GA15897@athena>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Getting started
To: Eddie Kovsky <ewk@edkovsky.org>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Friday 03 February 2017 08:41 AM, Eddie Kovsky wrote:
> On 01/30/17, Kees Cook wrote:
>> On Mon, Jan 30, 2017 at 5:41 AM, Vaishali Thakkar
>> <vaishali.thakkar@oracle.com> wrote:
>>> On Monday 30 January 2017 12:13 AM, Eddie Kovsky wrote:
>>>
>>>> I'm interested in helping out with this project.
>>>>
>>>> I have a few small patches in the kernel. I just finished the Eudyptula
>>>> Challenge and I'm looking for places where I can continue to contribute.
>>
>> Hi! Welcome to the list. :)
>>
>>>> I've been reading the list for several months now. I think I have a
>>>> general
>>>> understanding of the development process. Is there a specific TODO item I
>>>> could start off with?
>>
>> What areas of the kernel are you the most familiar with, and/or what
>> things are you interested in working on? That could help me tailor
>> some suggestions.
>>
>>> Here, is one TODO list:
>>>
>>> https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project
>>>
>>> Although I think few people are already working on some of these things.
>>> May be you can also check the archives of a mailing list.
>>
>> The list is a bit terse (it's mostly been a brain dump as things come
>> up), but yeah, if you see something there and want to know more, just
>> ask. I'm happy to expand on any of them.
>>
>
> I noticed there's been some activity recently with HARDENED_USERCOPY.
> And I looked over how mm/usercopy.c was merged in from the grsecurity
> patch. I'm curious about this TODO item:
>
>      Identify and extend HARDENED_USERCOPY to other usercopy functions
>      (e.g. maybe csum_partial_copy_from_user, csum_and_copy_from_user,
>      csum_and_copy_to_user, csum_partial_copy_nocheck?)
>
> It doesn't look like anyone is working on this task right now. But it's not
> obvious (to me) what needs to happen to make progress with this. Would this
> be a good task to start off with?

Hi,

You may want to read this thread:
https://patchwork.kernel.org/patch/9409557/

Kees, may be we should remove this item from the TODO list?

> Thanks
>
> Eddie
>
>> Thanks!
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Pixel Security
