MIME-Version: 1.0
In-Reply-To: <CAGXu5j+Ynmp3Z29_Zw6BG33P2RVi0eRtOiZR0incfoZBWF=7hg@mail.gmail.com>
References: <20170129184316.GA31184@athena> <2d6c7a51-3de3-1d95-37aa-c53c2caa9968@oracle.com>
 <CAGXu5j+Ynmp3Z29_Zw6BG33P2RVi0eRtOiZR0incfoZBWF=7hg@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu, 9 Feb 2017 08:06:08 +0100
Message-ID: <CAEiveUeEHvJ2sKTce0KwndX=rKNyb7E13ccvkK7a3S-wR-T5kA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Getting started
To: Kees Cook <keescook@chromium.org>
Cc: Vaishali Thakkar <vaishali.thakkar@oracle.com>, Eddie Kovsky <ewk@edkovsky.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 30, 2017 at 10:44 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jan 30, 2017 at 5:41 AM, Vaishali Thakkar
> <vaishali.thakkar@oracle.com> wrote:
>> On Monday 30 January 2017 12:13 AM, Eddie Kovsky wrote:
>>>
>>> Hi
>>
>>
>> Hi,
>>
>>> I'm interested in helping out with this project.
>>>
>>> I have a few small patches in the kernel. I just finished the Eudyptula
>>> Challenge and I'm looking for places where I can continue to contribute.
>
> Hi! Welcome to the list. :)
>
>>> I've been reading the list for several months now. I think I have a
>>> general
>>> understanding of the development process. Is there a specific TODO item I
>>> could start off with?
>
> What areas of the kernel are you the most familiar with, and/or what
> things are you interested in working on? That could help me tailor
> some suggestions.
>
>> Here, is one TODO list:
>>
>> https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project
>>
>> Although I think few people are already working on some of these things.
>> May be you can also check the archives of a mailing list.
>
> The list is a bit terse (it's mostly been a brain dump as things come
> up), but yeah, if you see something there and want to know more, just
> ask. I'm happy to expand on any of them.

In that context, could you please Kees update the kernsec.org wiki
about GRKERNSEC_MODHARDEN and Timgad module [1] (name may change...),
the proposed solution supports both a global sysctl and a per
processes/container settings.

Thank you!

[1] http://www.openwall.com/lists/kernel-hardening/2017/02/02/21

-- 
tixxdz
