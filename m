Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170113082347.GJ20972@linaro.org>
References: <CAErMHp-W=zcX-D10dbhzRG41-mjfVcKb2_+p4dxdXsnfizZuag@mail.gmail.com>
 <20170112160602.GA12583@leverpostej> <20170113082347.GJ20972@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 13 Jan 2017 09:54:26 -0800
Message-ID: <CAGXu5jLUCH9S98YFV3Db4q4r1aTsxbF_v0JeivH01pBYWM-Qzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction
To: "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, PaX Team <pageexec@freemail.hu>
Cc: Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 13, 2017 at 12:23 AM, AKASHI, Takahiro
<takahiro.akashi@linaro.org> wrote:
> On Thu, Jan 12, 2017 at 04:06:02PM +0000, Mark Rutland wrote:
>> On Fri, Jan 13, 2017 at 12:06:31AM +0900, park jinbum wrote:
>> > Hello All,
>>
>> Hi,
>>
>> > I'd like to contribute to kernel self protection project.
>> > I've experienced ARM kernel, security solution on production.
>> > (kernel memory protection, contents protection, ...)
>> >
>> > I'm interested in following topics.
>> > - Move kernel stack to vmap area (done on x86, other archs still need it)
>>
>> FWIW, I'm looking at this for arm64 (and Takahiro-san is also looking at
>> this area). Making the stacks virtually mapped is fairly trivial, but
>> implementing reliable {under,over}flow handling is fairly involved.
>>
>> 32-bit ARM is also somewhat starved for vmalloc space, so ignoring the
>> difficulties in exception handling changes, I'm not sure that's going to
>> be widely deployable.
>>
>> I believe it should be possible to implement THREAD_INFO_IN_TASK for arm
>> similarly to arm64, which would bring some benefit regardless.
>>
>> Takahiro-san, were you looking into that at all?
>
> No, never.
> I'm currently taking a quick look at PAX_MEMORY_STACKLEAK and
> PAX_MEMORY_STRUCTLEAK (on both arm64 and x86 though arch-specific
> portion of code is quite small).

I've spent a little time looking at STRUCTLEAK -- it shouldn't be too
hard to upstream (I have it extracted in one of my trees).

PaX Team, the heuristic for STRUCTLEAK appears to be "does the struct
contain anything marked __user". Is this actually a meaningful
information exposure case? It seems like there are a lot more cases
for exposures where there is nothing marked __user. Is that the
meaning of "much smaller coverage" compared to STACKLEAK in the
Kconfig?

Very little in my build testing actually triggered the "userspace
variable will be forcibly initialized" warning from the plugin, but
perhaps I didn't port something correctly.

-Kees

-- 
Kees Cook
Nexus Security
