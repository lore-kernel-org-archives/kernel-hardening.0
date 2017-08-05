References: <2feb9661-9236-cdaf-a371-2fea80372aff@huawei.com>
 <CAGXu5jJwCx=LhvJGgNxD9Wu1NCTBb=yn0MQW05GSdocvqZf2Gg@mail.gmail.com>
 <0eb1d2c0-79ae-b2c9-4802-9104ec3db8ee@huawei.com>
From: Joao Moreira <jmoreira@suse.de>
Message-ID: <5d2fd950-98ec-440d-bed2-3f3f60c4c4f6@suse.de>
Date: Fri, 4 Aug 2017 21:30:49 -0300
MIME-Version: 1.0
In-Reply-To: <0eb1d2c0-79ae-b2c9-4802-9104ec3db8ee@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening][RFD] Is there any plan to port the RAP feature
 from PAX/Grsecurity to main line ?
To: Li Kun <hw.likun@huawei.com>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

hi, I'm Joao, I talk for kCFI :)

On 08/04/2017 07:31 AM, Li Kun wrote:
> 
> 
> 在 2017/8/4 13:13, Kees Cook 写道:
>> On Thu, Aug 3, 2017 at 9:23 PM, Li Kun <hw.likun@huawei.com> wrote:
>>> Is there any plan to port the RAP feature from PAX/Grsecurity to main 
>>> line ?
>>> I think that will be a realy effective approach to protect against 
>>> ROP/JOP.
>> Yeah, RAP is pretty great! I'm not aware of anyone working on
>> upstreaming the plugin (and its many function declaration fixes and
>> other adjustments) currently, though.
> I will try to upstream it.
> If i have any progress or trouble, i will show it here:)
>>
>> I've also been interested to see if kCFI[1] will be published soon,
>> which would be another option (it needs fewer kernel changes, but has
>> limitations like needing to build the kernel twice). While the code
>> isn't released yet, they did provide a comparison[2] to RAP which is
>> an interesting read.

So, we wanted to have it released some time ago, but life happened and 
unfortunately, I had to share my time between this and other projects.

As you are speaking of "upstreamability", I see kCFI as an interesting 
start-point, but it is blurry to believe that it would be mergeable into 
the kernel. kCFI was/is a research project, willing to enable CFI 
experimentation in the kernel space. It never was understood as a 
product. Because of that, we took many decisions in the past that would 
benefit this aspect of the work, instead of making it super maintainable 
or attachable. Some of these decisions were: 1st, kCFI is implemented on 
top of LLVM; 2nd, some of the most interesting features of kCFI require 
two compilation rounds (and we didn't even care about it, because we 
were just trying to prove a point in making achievable kernel CFI more 
fine-grained); 3rd, we never ported it to newer kernel versions, instead 
we preferred to evaluate different approaches and solutions in that very 
same code-base (Linux kernel 3.19); 4th, kCFI requires many external 
tools (which perform binary analyses, CFG fixes, etc).

Just to illustrate why we took these paths think about, for example, not 
tagging all functions uniquely based on their prototype. I mean, if you 
have a function FOO and a function BAR, both with the same prototype, 
but such prototype never appears in a pointer declaration throughout 
source code, why do you need them having the same tags? This would allow 
FOO returning to a BAR's call-site, and BAR returning to a FOO's 
call-site. Yet, to know that such function pointer does not exist, we 
had to run a full compilation round before instrumenting, performing a 
source-code analysis.

Given all the above I would say that someone interested in making CFI 
upstream, should not get demotivated by kCFI.

> That looks awsome. Does it have any schedule to release the code?

No, we don't have a release schedule. Our current plans are to finish 
some final tests that we are doing, run some more benchmarks/use-cases 
so we can extend a bit our false-positive coverage, and then have it out 
as soon as possible... but well, tbh, it may take some time.

If someone wants to make CFI “upstreamable”, I'm in for helping in any 
way I can. I would suggest that anyone willing to achieve it should 
first try to implement a coarse-grained scheme, have it booting and 
running, and only after that, think about the best way of organizing the 
tags so you minimize/cease the false-positives.

If there is anything I can do, I’m lvwr in ##kernel-hardened or, just 
reach me through mail.

Tks,
Joao

>>
>> -Kees
>>
>> [1] https://github.com/kcfi/docs
>> [2] https://github.com/kcfi/docs/blob/master/kcfi_vs_rap.txt
>>
> 
