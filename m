References: <CABeRdtq0BY8Hi=9hHCx7YAfc=wTfVds3feN3p0BdLySjnwc1ng@mail.gmail.com>
 <CAGXu5jJf_Vi=O7SLpiMRjdjgAzhkPF+bfjddoBsgSkLz+yw+Yg@mail.gmail.com>
 <CABeRdtobtD7C3AeY01RTe6ChJnOMYLyWRrubWD0mwGQYANzfpQ@mail.gmail.com>
 <CAGXu5jL1rSp1xVEa4aD=vzOb9Me5BEUoxO=c5f40jSYuxDSUPw@mail.gmail.com>
 <CABeRdto9-vPTXT59waFZDHUfeCjhjqecdVhL04zbm6kD4LP=0g@mail.gmail.com>
From: Richard Weinberger <richard@nod.at>
Message-ID: <1f780e7e-5d9f-d39f-b454-06a4ffb2b42e@nod.at>
Date: Fri, 27 Jan 2017 20:05:42 +0100
MIME-Version: 1.0
In-Reply-To: <CABeRdto9-vPTXT59waFZDHUfeCjhjqecdVhL04zbm6kD4LP=0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] I'd like to contribute to this project.
To: Hoeun Ryu <hoeun.ryu@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Am 27.01.2017 um 20:03 schrieb Hoeun Ryu:
> On Fri, Jan 27, 2017 at 6:36 AM Kees Cook <keescook@chromium.org> wrote:
>>
>> On Thu, Jan 26, 2017 at 6:49 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>>> On Thu, Jan 26, 2017 at 4:41 AM, Kees Cook <keescook@chromium.org> wrote:
>>>> On Wed, Jan 25, 2017 at 6:01 AM, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>>>>> Hi. I'm Hoeun Ryu.
>>>>
>>>> Hi! Nice to meet you!
>>>>
>>>>> I've been reading arm/arm64 and mm/fs kernel code for the last few years.
>>>>> I stumbled upon the wiki page for this project and found this project seems
>>>>> very interesting.
>>>>> I think I can start to contibute to this project from porting small parts of
>>>>> PAX/GRSEC features that you guys haven't worked on yet.
>>>>
>>>> Sure, that would be very welcome. Are there features you're especially
>>>> interested in?
>>>>
>>>
>>> I tried to find out what features PAX/GRKERNSEC provides reading
>>> grsecurity wiki pages and the patch file today.
>>> It might take a week or two to find adequate features for me to tackle.
>>> But my guess after few hours of a brief investigation is `Deter
>>> exploit bruteforcing (GRKERNSEC_BRUTE)`
>>> Do you think the feature is worth it to you guys ? If not, please
>>> recommend others.
>>
>> I'd really like to see this, yes. There have been attempts in the past
>> that got derailed. I strongly think it should be part of the kernel
>> (and not glibc, as got proposed):
>>
>> https://lkml.org/lkml/2014/12/24/306
>>
>> I think it's worth trying it again.
> 
> Ok. I will start to investigate the history of Richard's try for the
> feature and GRKERNSEC_BRUTE itself and how I can narrow the gap
> between the opinions.

Please go ahead. :-)
I simply didn't had the time to come up with another approach.

Thanks,
//richard
