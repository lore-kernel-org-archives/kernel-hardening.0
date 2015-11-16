Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <564A529A.2040005@gmail.com>
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
	<CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
	<56496AB0.5070905@gmail.com>
	<56496D65.8030903@gmail.com>
	<CAEXv5_g-VJJweZKNuw5ozMfiVxMrfhw4biEkSu4A29-uuEmD6A@mail.gmail.com>
	<564A529A.2040005@gmail.com>
Date: Mon, 16 Nov 2015 15:20:22 -0800
Message-ID: <CAGXu5jL+UxUB65y29-N_Zazab2g4PVMBkcB+ianZnXSXSp=LAA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening]
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 16, 2015 at 2:03 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> On 16/11/15 01:38 AM, David Windsor wrote:
>> I'm currently in the process of preparing my earlier PAX_REFCOUNT patch
>> set for resubmission, and I tend to agree with you - I'm not very
>> hopeful of Linus, et al accepting them.  But, we will try again.
>>
>> With respect to the issue of having a refcount_t type, PAX_REFCOUNT adds
>> overflow protection to the already existing atomic_t type, and creates a
>> new type, atomic_unchecked_t, for non-reference-counter types (i.e.
>> statistical counters).
>
> Yeah, I'm aware it does it that way. The problem is that it would have
> to be done the other way around for it to land upstream (realistically).

I may be proven wrong in the end, but I totally disagree with you. :)
I think it is valuable to _start_ from a position of protecting the
atomics and then marking those that don't care about overflow (they
are the minority). We should take a stance of whitelist not blacklist
for these features.

> Doing it the only way around would be involve too many changes so it
> wouldn't be feasible to land everything, but the positive side of it is
> that the changes could be landed bit by bit (i.e. one set of refcount
> fields at a time).

We'll see what it looks like, but I think we start by gaining the
protection and people that don't want it can fix it on a case-by-case
basis. I may be naive, but I think it's probably the best place to
work from initially.

-Kees

-- 
Kees Cook
Chrome OS Security
