Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKLxyH4AS7SjLEb6C0kNCUC+zCjH5ZaMy1tycDe=Un5NQ@mail.gmail.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <20161110203749.GV3117@twins.programming.kicks-ass.net> <20161110204838.GE17134@arm.com>
 <CAGXu5jL0m8_x-eBPQPBvj_O_JRXmh=nc87L0rpPkYUEo+jK97A@mail.gmail.com>
 <CAEXv5_i3Ju5JNs6g-jA-WkMR38g43Aj5we0+GXeHcuUAM3nziQ@mail.gmail.com> <CAGXu5jKLxyH4AS7SjLEb6C0kNCUC+zCjH5ZaMy1tycDe=Un5NQ@mail.gmail.com>
From: David Windsor <dave@progbits.org>
Date: Thu, 10 Nov 2016 16:39:49 -0500
Message-ID: <CAEXv5_gQ4D5ys3_SbXTLG73h+5GrXcZRmfVCr2tCGZ2Z6YruHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, Peter Zijlstra <peterz@infradead.org>, Elena Reshetova <elena.reshetova@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 10, 2016 at 4:27 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Nov 10, 2016 at 1:23 PM, David Windsor <dave@progbits.org> wrote:
>> On Thu, Nov 10, 2016 at 4:01 PM, Kees Cook <keescook@chromium.org> wrote:
>>> On Thu, Nov 10, 2016 at 12:48 PM, Will Deacon <will.deacon@arm.com> wrote:
>>>> On Thu, Nov 10, 2016 at 09:37:49PM +0100, Peter Zijlstra wrote:
>>>>> On Thu, Nov 10, 2016 at 10:24:35PM +0200, Elena Reshetova wrote:
>>>>> > This series brings the PaX/Grsecurity PAX_REFCOUNT
>>>>> > feature support to the upstream kernel. All credit for the
>>>>> > feature goes to the feature authors.
>>>>> >
>>>>> > The name of the upstream feature is HARDENED_ATOMIC
>>>>> > and it is configured using CONFIG_HARDENED_ATOMIC and
>>>>> > HAVE_ARCH_HARDENED_ATOMIC.
>>>>> >
>>>>> > This series only adds x86 support; other architectures are expected
>>>>> > to add similar support gradually.
>>>>> >
>>>>> > More information about the feature can be found in the following
>>>>> > commit messages.
>>>>>
>>>>> No, this should be here. As it stands this is completely without
>>>>> content.
>>>>>
>>>>> In any case, NAK on this approach. Its the wrong way around.
>>>>>
>>>>> _IF_ you want to do a non-wrapping variant, it must not be the default.
>>>>>
>>>>> Since you need to audit every single atomic_t user in the kernel anyway,
>>>>> it doesn't matter. But changing atomic_t to non-wrap by default is not
>>>>> robust, if you forgot one, you can then trivially dos the kernel.
>>>>
>>>> Completely agreed.
>>>>
>>>> Whilst I understand that you're addressing an important and commonly
>>>> exploited vulnerability, this really needs to be opt-in rather than
>>>> opt-out given the prevalence of atomic_t users in the kernel. Having a
>>>> "hardened" kernel that does the wrong thing is useless.
>>>
>>> I (obviously) disagree. It's not useless. Such a kernel is totally
>>> safe against refcount errors and would be exposed to DoS issues only
>>> where mistakes were made. This is the fundamental shift here:
>>>
>>> - we already have exploitable privilege escalation refcount flaws on a
>>> regular basis
>>> - this changes things to have zero exploitable refcount flaws now and
>>> into the future
>>> - the risk is bugs leading to DoS instead of the risk of exploitable flaws
>>>
>>> That's the real trade.
>>>
>>>>> That said, I still don't much like this.
>>>>>
>>>>> I would much rather you make kref useful and use that. It still means
>>>>> you get to audit all refcounts in the kernel, but hey, you had to do
>>>>> that anyway.
>>>>
>>>> What needs to happen to kref to make it useful? Like many others, I've
>>>> been guilty of using atomic_t for refcounts in the past.
>>>
>>
>> Discussions have been occurring since KSPP has begun: do we need a
>> specialized type for reference counters?  Oh, wait, we do: kref.
>> Wait!  kref is implemented with atomic_t.
>>
>> So, what?  We obviously need an atomicity for a reference counter
>> type.  So, do we simply implement the HARDENED_ATOMIC protected
>> version of atomic_t "inside" of kref and leave atomic_t alone?
>>
>> That would certainly reduce the number of users using atomic_t when
>> they don't need a refcounter: kernel users using kref probably meant
>> to use it as a reference counter, so wrap protection wouldn't cause a
>> DoS.
>
> But it leaves all the newly added drivers that get it wrong (by not
> using wrap-protected kref) exposed to privilege escalation. We have to
> kill the entire class of vulnerability. It needs to be impossible to
> get refcounting wrong from a pragmatic approach: we can't educate
> everyone, so the infrastructure must be safe.
>

I completely agree with you: I'm just bringing to light now the
arguments that were voiced about this (particularly by someone from
the PaX/grsecurity team; I forget which thread).

To address Peter's concerns about trivially DoS-ing a kernel, would it
be feasible to still use atomic_t as a protected type, but change
hardened_atomic_overflow() to not kill the process?  Just for a time:
we let this bake in distros for a while, fix all of the
yet-to-be-identified wrappable users of atomic_t, then re-enable
process killing?

>>> That's the point: expecting everyone to get this right and not miss
>>> mistake from now into the future is not a solution. This solves the
>>> privilege escalation issue for refcounts now and forever.
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
