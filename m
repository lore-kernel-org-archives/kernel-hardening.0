Reply-To: kernel-hardening@lists.openwall.com
References: <bf475a29-58cc-7b87-0821-9d23f01851b3@gmail.com>
 <CAJcbSZFq_r+bpzyU3VVdukHW3SXsD7EPHkobh7anPVvBgfXtqA@mail.gmail.com>
 <af8a6c3c-08b9-a354-d984-2428fdeebb8f@gmail.com>
 <CAJcbSZH2H2rd8f8Mg2NBxfTUdSWLyU_KrZbdZ=imKZNTjJjGSQ@mail.gmail.com>
From: zerons <zeronsaxm@gmail.com>
Message-ID: <c10d2176-d6ec-d71c-a60f-f55bbeb9fffb@gmail.com>
Date: Mon, 21 Nov 2016 07:21:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAJcbSZH2H2rd8f8Mg2NBxfTUdSWLyU_KrZbdZ=imKZNTjJjGSQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] get NULL pointer dereferences or #GP fault to
 infomation leakage
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Yes, thanks for your reply, I didn't think that through.:)

On 11/21/2016 12:49 AM, Thomas Garnier wrote:
> I agree that restricting access / filtering dmesg or equivalents is a good
> thing.
> 
> An oops highlights that something went wrong and the OS should not continue
> in this state. If you allow oops then an attacker might bruteforce KASLR
> offsets for the kernel base, have multiple attempts at an heap overflow or
> against a stack cookie. Many mitigations rely on the fact that the attacker
> have only one attempt.
> 
> Taking your example on NULL pointer deref. It can be a simple pointer not
> checked for NULL or a corrupted object. Not panicing leaves more room for
> an attacker to reliably exploit a vulnerability.
> 
> Btw, Kees wrote this list of recommended settings:
> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_
> Project#Recommended_settings
> 
> On Sat, Nov 19, 2016 at 6:12 PM, zerons <zeronsaxm@gmail.com> wrote:
> 
>> If kernel panic on oops, then NULL pointer deref and others may cause a
>> DoS.
>> Maybe restrict user access to dmesg and other log files so that
>> unprivileged
>> users couldn't read log messages, or something like /proc/kallsyms(output
>> 0000
>> if no permission). Then those faults stll be useless.
>>
>> On 11/20/2016 12:36 AM, Thomas Garnier wrote:
>>> It is an issue because having KASLR enable without panic on oops is not
>>> really useful. Same apply to other mitigations that rely on randomness.
>>>
>>> On Sat, Nov 19, 2016 at 3:50 AM, zerons <zeronsaxm@gmail.com> wrote:
>>>
>>>> I wonder if this could be an issue.
>>>>
>>>> Test on Ubuntu 16.04 with linux kernel 4.4.x, x86_64.
>>>>
>>>> When a NULL-pointer-deref or a #GP fault
>>>> (e.g: access to 0xdead0000-xxxxxxxx) happens in kernel space,
>>>> it seems that the kernel would kill the current process, then
>>>> output the Oops message or "general protection fault" message.
>>>>
>>>> So we can get these messages via `dmesg` or reading the /var/log/...
>>>>
>>>> I think this may be a way to bypass the KASLR, could it be?
>>>>
>>>
>>>
>>>
>>
> 
> 
> 
