Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5694407C.8000006@iogearbox.net>
Date: Tue, 12 Jan 2016 00:53:32 +0100
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
References: <2236FBA76BA1254E88B949DDB74E612B41A361EA@IRSMSX102.ger.corp.intel.com>	<CAGXu5j+pt1x9AntHM3Z4O8V=5-So0tWj=9aoJ-kP1q0p3-s=Vw@mail.gmail.com>	<2236FBA76BA1254E88B949DDB74E612B41A38ED3@IRSMSX102.ger.corp.intel.com> <CAGXu5jLw=VcwPAmg3ttjkgb3+SxDDVNPthsu8ErTH88LZfTALg@mail.gmail.com> <568C5BB8.1050705@iogearbox.net> <2236FBA76BA1254E88B949DDB74E612B41A4B945@IRSMSX102.ger.corp.intel.com>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41A4B945@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Introduction and task request
To: kernel-hardening@lists.openwall.com
Cc: "keescook@chromium.org" <keescook@chromium.org>, elena.reshetova@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On 01/11/2016 10:44 AM, Reshetova, Elena wrote:
>> On 01/06/2016 12:57 AM, Kees Cook wrote:
>> On Mon, Dec 21, 2015 at 3:16 AM, Reshetova, Elena
>> <elena.reshetova@intel.com> wrote:
>>>>> What would be the reasonable task for me to do?
>>>
>>>> I always suggest people work on stuff that interests them. Do you
>>>> have any specific areas you like working on, or exploits you'd like to see
>>>> stopped?
>>>
>>> I guess ideally people subscribed to this list want all exploits to
>>> be stopped
>>> :) But seriously I don't have any preference at least for now. Since
>>> I will have to learn a lot in this area I want to start from
>>> something which would be a reasonable and useful for this project
>>> piece of work, that's why I was asking for suggestions.
>>>
>>>>> I am quite a newbie in proper kernel development work (but not a
>>>>> newbie in platform security), so please as initial task do not
>>>>> through to me the biggest dead animal out there with the task to revive
>>>>> it.
>>>
>>>> Heh, understood. We'll be happy to assist you through whatever parts
>>>> you might want help with.
>>>
>>> Thank you!
>>>
>>>>> It is going to be a learning exercise for me at least at the
>>>>> beginning, but I am hoping to learn fast and start bringing value
>>>>> to the project.
>>>
>>>> I had mentioned PAX_USERCOPY earlier. I'm not sure how much work
>>>> that'll be, but extracting it would be the first step, and you can
>>>> go from there. There's no one actively working on it at the moment,
>>>> and it would be very nice to have.
>>>
>>> Casey is taking care of that, so I will leave it to him.
>>>
>>>> Or perhaps looking into the prior BPF_HARDEN work (currently this
>>>> just disables eBPF, but it used to try to defend against trivial
>>>> heap-sprays).
>>>
>>>    This sounds smth that I can look into. I will be back when I have
>>> something reasonable ready or researched enough for sensible
>>> questions/discussion points. I will be away for long holidays until
>>> Jan 10, but hoping to return with plenty of energy :)
>>
>> The original name was JIT_HARDEN, prior to grsecurity's 3.16 patches
>> (which just disable JIT entirely):
>> https://github.com/slashbeast/grsecurity-scrape/blob/master/test/grsec
>> urity-3.0-3.15.5-201407170639.patch
>>
>> I think it'd be nice to have the the JIT hardening feature, since it
>> does block heap-sprayed immediate values and probably other stuff, but
>> I haven't studied it.
>
>> Was on my todo list as well for some time, but if you have some cycles in
>> spare, go for it. We recently discussed that it would be nice if it could be
>> done on a more generic level, in the sense to do [e]BPF insns rewrite for
>> blinding, so that each JIT would not >need to add up even more complexity
>> and/or duplicate efforts.
>
> Do you have any pointers for this discussion that I can read it also?

Sorry, this was just a private conversation during Plumbers, iirc. We agreed
that the way to go would be to try mitigating it on a BPF bytecode level iff
feasible. For example, by expanding/rewriting things like loading constants
into a i) load where the constant is xored with a (each time newly generated)
prandom_u32()/.. value followed by ii) xor on the same reg with that prandom
value itself. And that functionality would be enabled f.e. via sysctl switch.
That would be a first direction to look into, and could help also some more
"exotic" archs like the jit on mips, etc.

Thanks,
Daniel
