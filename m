Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161027103143.GB27135@leverpostej>
References: <1476802761-24340-1-git-send-email-colin@cvidal.org> <20161027103143.GB27135@leverpostej>
From: David Windsor <dave@progbits.org>
Date: Thu, 27 Oct 2016 08:45:33 -0400
Message-ID: <CAEXv5_iLo5ezNBFiMbQ91Nj_dh41uWZiMtxCynAsCZhO+2wHpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC 0/2] arm: implementation of HARDENED_ATOMIC
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Colin Vidal <colin@cvidal.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Mark,

On Thu, Oct 27, 2016 at 6:32 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Tue, Oct 18, 2016 at 04:59:19PM +0200, Colin Vidal wrote:
>> Hi,
>>
>> This is the first attempt of HARDENED_ATOMIC port to arm arch.
>
> As a general note, please Cc relevant lists and people, as per
> get_maintainer.pl. For these patches that should tell you to Cc
> linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, and
> a number of people familiar with the atomics.
>
> Even if things are far from perfect, and people don't reply (or reply
> but not too kindly), having them on Cc earlier makes it far more likely
> that issues are spotted and addressed earlier, minimizes repeatedly
> discussing the same issues, and also minimizes the potential for future
> arguments about these things being developed in isolation.
>
> Unless you do that, critical review for core code and arch code will
> come very late, and that could potentially delay this being merged for a
> very long time, which would be unfortunate.
>
>> About the fault handling I have some questions (perhaps some arm
>> expert are reading?):
>>
>>    - As the process that made the overflow is killed, the kernel will
>>      not try to go to a fixup address when the exception is raised,
>>      right ? Therefore, is still mandatory to add an entry in the
>>      __extable section?
>>
>>    - In do_PrefetchAbort, I am unsure the code that follow the call to
>>      hardened_atomic_overflow is needed: the process will be killed
>>      anyways.
>
> Unfortunately, I'm only somewhat familiar with the ARM atomics, and I
> have absolutely no familiarity with the existing PaX patchset.
>
> For both of these, some background rationale would be helpful. e.g. what
> does the fixup entry do? When is it invoked?
>

For your reference, documentation on the original PaX protection
(known there a PAX_REFCOUNT) can be found here:
https://forums.grsecurity.net/viewtopic.php?f=7&t=4173

With respect to documentation, there is a patch in this series that
adds Documentation/security/hardened-atomic.txt, which references the
above-mentioned forum post.

Although, for long-term maintenance, maybe forum posts aren't the most
reliable thing in the world...

> I'll see what I can reverse-engineer from the patches.
>
>> I take some freedom compared to PaX patch, especially by adding some
>> macro to expand functions in arm/include/asm/atomic.h.
>>
>> The first patch is the modification I have done is generic part to
>> make it work.
>
> If you're relying on a prior patch series, please refer to that in the
> cover, to make it possible for reviewers to find.
>
> If you have a public git repo, placing this in a branch (or a tagged
> commit), and referring to that in the cover messages would make it much
> easier for people to review and/or test.
>
> Thanks,
> Mark.
