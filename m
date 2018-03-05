MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <a5ac51e9-b0ab-ed1b-c820-ab9379d62427@schaufler-ca.com>
References: <20180227111532.1144-1-ppandit@redhat.com> <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
 <CAFJ0LnFEtcWjTf5v1oBK_FC6VTdORpOLyKzzENL3B1bCHz1ySw@mail.gmail.com> <a5ac51e9-b0ab-ed1b-c820-ab9379d62427@schaufler-ca.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 5 Mar 2018 12:42:38 -0800
Message-ID: <CAGXu5jL-rr9YcRzPJFRd7wSk82-9WB-NToe4T5dTBcAGw9UEug@mail.gmail.com>
Subject: Re: [PATCH 0/1] Zero initialise kernel stack variables
Content-Type: text/plain; charset="UTF-8"
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Nick Kralevich <nnk@google.com>, P J P <ppandit@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 2, 2018 at 1:01 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 3/2/2018 11:52 AM, Nick Kralevich wrote:
>> On Tue, Feb 27, 2018 at 11:28 AM, Kees Cook <keescook@chromium.org> wrote:
>>>> This same kernel is running on my F27 test machine as I write this.
>>>> There is no slowness or notice-able performance impact as such.
>>> Unfortunately "noticeable" isn't going to be a viable metric. You'll
>>> need to do some real-world benchmarks (i.e. kernel builds, hackbench,
>>> etc), and compare the results. Even just initializing
>>> passed-by-reference variables (GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) had
>>> measurable performance impact.
>>>
>>> It would be nice to have four options/features available from the
>>> compiler, from least to most performance impact:
>>
>> One of the recurring themes I've noticed from the kernel-hardening
>> mailing list is that someone will propose a valuable compile time
>> feature (such as this one), people will ask for performance
>> measurements, some specific use case will be found which has adverse
>> performance impact, and the entire change will be rejected. It's
>> silly.

The way I think about adding security hardening to upstream is that we
have to consider a number of conflicting interests. I would say the
primary principle is "secure by default", which comes with lots of
caveats, namely in the form of performance impact, maintainability
impact, and false positive rate. If something has zero performance and
maintenance impact and zero false positive rate, then this is a
slam-dunk and there's no problem. This is rarely the case, of course.
Frequently the maintainability and false positive rate can be seen or
inferred from the content of the patches, so the explicit question,
when not answered in a commit log or documentation, becomes "what is
the performance impact?"

When something can't be always-on, then we have to look at asking "can
this be a _runtime_ toggle?" rather than a compile-time option, since
many of the end-users of the kernel are getting it through distros,
and distros are allergic to making many different kernel packages with
different compile-time options. They just want _one_ kernel binary.

Now, speaking to "the entire change will be rejected", this usually
happens in two cases. Either the added complexity is seen as not worth
the hardening (in which case, better evidence is needed to support the
hardening, or refactoring to reduce maintenance burdens), or we bump
up against what I'll call "security absolutism" ways of thinking from
some maintainers. Dealing with the latter is much more difficult,
since they don't see pragmatic security improvements as having value
compared to "perfect protection". Obviously perfect is preferred, but
it can't always be done. (e.g. see "an unpowered computer is safest",
etc.)

I want hardening features to _actually_ get used by the widest
possible audience of end users. That means trying to balance all the
things above, and get the best possible approach for upstream and
downstream.

In this specific case, we can't have a runtime toggle, which means we
need to get the performance impact as low as possible if we want to
see distros using it. We may not get down to a level were a distro
wants to enable it, then that's fine, other people who do their own
kernel builds will still have it available as a compile-time option,
but then at least we've tried, and we'll have evidence to show for
what kinds of improvements would be needed in the future to gain wider
roll-out.

> A security developers we *must* consider performance to be
> critical at all times. There is no easier way to get something
> rejected out of hand than for it to have serious performance
> impact. On the other hand, if I had a nickel for every time I
> saw something really stoopid done to improve performance I'd
> have a big pile of nickels. One of the performance issues your
> changed caused was in the common case of network packet delivery.
> The people who work on that code are fanatical about performance.
> Just as the security people might flame an obvious buffer overflow,
> the networking people will stomp on an unnecessary performance hit.

The networking folks are especially unhappy about doing (what they see
as) redundant memory initialization, even when it kills classes of
bugs. I personally find this rather frustrating, but I understand that
performance is critical to them. In these cases, having a generalized
approach (such as a compiler flag or plugin) provides a way for the
general public to benefit from killing bug classes and for the
perf-critical users to disable the protection. I don't like having to
face these trade-offs, but as we're seeing, the corner-cutting by CPUs
and kernels continue to haunt us, and we need to find efficient ways
to initialize memory, avoid side-channels, etc.

>> The beautiful thing about compile time features is that they can be
>> enabled / disabled per compilation unit. If there's a performance
>> problem in a certain chunk of code, figure out a way to opt that code
>> out of the protections. 95% of the performance of the kernel is likely
>> only dependent on 5% of the code, and even if we opt out that code, we
>> still protect the remaining 95% of the code. If you assume that bugs
>> are evenly distributed throughout the code base, a 95% reduction is
>> HUGE.
>
> For good or ill there is a strong tradition that a 95% security
> solution is broken. You don't need all the code to be penetrated,
> just a teeny bit. And what about the code that couldn't be
> penetrated anyway, but now has to be slower to protect that little
> bit?

Yeah, and it's specifically the networking code that has had many of
the flaws in leaking memory contents due to drivers not fully
initializing some structure here or there. So we'd leave ourselves
open to a known source of regular bugs.

I think the best use of per-compilation-unit protections is for things
that have high false-positive rates, and it can be used as a way to
start building up coverage over time across the entire kernel with the
goal of 100% coverage (e.g. runtime integer overflow detection like
Clang's -fsanitize=integer).

>> Strategically, we shouldn't let the perfect be the enemy of the good.
>> Let's move away from fixating on benchmarks, and just enable easy
>> opt-out for the folks who demonstrate performance bottlenecks.

I agree that opt-out is desired, but upstream conservatism tends to
dictate opt-in initially. Having performance numbers (like I talk
about above) is just part of the larger piece for trying to figure out
a strategy for upstreaming. Once it's in, then distros enable it by
default, then the kernel does too. This can span years, though.

> The problem is not that people will choose performance over security,
> or the other way around. It's that they don't consider both to be
> important in the first place.
>
>>
>> I suspect that many kernel-hardening features would have an easier
>> time being accepted if it wasn't presented as an all or nothing
>> feature.

The largest constraint, IMO, is the maintainability one. Having
complex code with lots of #ifdefs for the compile-time toggles creates
code that bit-rots, gets less testing, etc. Perf is part of the
picture, but one that gets discussed more explicitly since it can
impact the other areas of concern.

> You're up against the notion that you can ignore one aspect of
> the system to enhance another.
>
>>
>> My $0.02.

Thanks for bringing it up! I wish things were easier, but this is what
we have. :) I'd also like to think that if we can hammer out all the
concerns for a patch series on this list, then we can avoid flame-wars
and auto-ignore when presenting things for merging.

-Kees

-- 
Kees Cook
Pixel Security
