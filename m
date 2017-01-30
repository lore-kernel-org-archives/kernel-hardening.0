MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEk6tEwVF5mLgo4JX+jkX+zuhe6_hZYKBzTCsFYrmAgZVthcCw@mail.gmail.com>
References: <CAEk6tExvL7NCB8P-YP7MwT6Ysi8S08H+RgsvBfRXp336noTfxg@mail.gmail.com>
 <CAGXu5j+KYYRvWC1MmMyn3w1N5DsXeAnHR3wZvjpUfUaqd3L2Rw@mail.gmail.com>
 <CAEk6tEyquWE2HS=Nrtzx4RS_GXRMNBBXVtac1dFP2Py17cN_MQ@mail.gmail.com>
 <CAGXu5jL=W0WVNU7LC8j_A1o=dnP0KwiU+Qp=Wu1bzR_FnCtEuw@mail.gmail.com> <CAEk6tEwVF5mLgo4JX+jkX+zuhe6_hZYKBzTCsFYrmAgZVthcCw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Jan 2017 12:02:27 -0800
Message-ID: <CAGXu5jKS2z1vfom6+5AnO1-92VukfUw8Q67UJBhxQErhycz_Jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction
To: Jessica Frazelle <me@jessfraz.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 27, 2017 at 11:14 AM, Jessica Frazelle <me@jessfraz.com> wrote:
> Cool! Have already started looking into it! Super excited :D
>
> On Thu, Jan 26, 2017 at 1:42 PM Kees Cook <keescook@chromium.org> wrote:
>>
>> On Wed, Jan 25, 2017 at 8:12 PM, Jessica Frazelle <me@jessfraz.com> wrote:
>> > Honestly I'm open to working on whatever no one else wants too :)
>>
>> You said the magic words! ;) Looking at the TODO, I'll pick this
>> semi-randomly:
>>
>> - expand use of __ro_after_init, especially in arch/arm64
>>
>> It'd be nice to look through arch/arm64 to find anything that is close
>> to be able to be declared as const, but can't due to some post-boot
>> but pre-init changes. This is needs some manual examination currently,
>> but you can look at other uses of __ro_after_init in arch/x86 and
>> arch/arm. Of course, there's no reason to limit yourself to arch/arm64
>> if you find similar things in the core kernel code too.

I had someone point out that the IRQ subsystem has a lot of ops-type
structures that could be either const or __ro_after_init, for example
msi_domain_ops. That might be another area to look at.

-Kees

-- 
Kees Cook
Pixel Security
