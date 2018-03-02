Subject: Re: [PATCH 0/1] Zero initialise kernel stack variables
References: <20180227111532.1144-1-ppandit@redhat.com>
 <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
 <CAFJ0LnFEtcWjTf5v1oBK_FC6VTdORpOLyKzzENL3B1bCHz1ySw@mail.gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <a5ac51e9-b0ab-ed1b-c820-ab9379d62427@schaufler-ca.com>
Date: Fri, 2 Mar 2018 13:01:50 -0800
MIME-Version: 1.0
In-Reply-To: <CAFJ0LnFEtcWjTf5v1oBK_FC6VTdORpOLyKzzENL3B1bCHz1ySw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Nick Kralevich <nnk@google.com>, Kees Cook <keescook@chromium.org>
Cc: P J P <ppandit@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 3/2/2018 11:52 AM, Nick Kralevich wrote:
> On Tue, Feb 27, 2018 at 11:28 AM, Kees Cook <keescook@chromium.org> wrote:
>>> This same kernel is running on my F27 test machine as I write this.
>>> There is no slowness or notice-able performance impact as such.
>> Unfortunately "noticeable" isn't going to be a viable metric. You'll
>> need to do some real-world benchmarks (i.e. kernel builds, hackbench,
>> etc), and compare the results. Even just initializing
>> passed-by-reference variables (GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) had
>> measurable performance impact.
>>
>> It would be nice to have four options/features available from the
>> compiler, from least to most performance impact:
> One of the recurring themes I've noticed from the kernel-hardening
> mailing list is that someone will propose a valuable compile time
> feature (such as this one), people will ask for performance
> measurements, some specific use case will be found which has adverse
> performance impact, and the entire change will be rejected. It's
> silly.

A security developers we *must* consider performance to be
critical at all times. There is no easier way to get something
rejected out of hand than for it to have serious performance
impact. On the other hand, if I had a nickel for every time I
saw something really stoopid done to improve performance I'd
have a big pile of nickels. One of the performance issues your
changed caused was in the common case of network packet delivery.
The people who work on that code are fanatical about performance.
Just as the security people might flame an obvious buffer overflow,
the networking people will stomp on an unnecessary performance hit.


> The beautiful thing about compile time features is that they can be
> enabled / disabled per compilation unit. If there's a performance
> problem in a certain chunk of code, figure out a way to opt that code
> out of the protections. 95% of the performance of the kernel is likely
> only dependent on 5% of the code, and even if we opt out that code, we
> still protect the remaining 95% of the code. If you assume that bugs
> are evenly distributed throughout the code base, a 95% reduction is
> HUGE.

For good or ill there is a strong tradition that a 95% security
solution is broken. You don't need all the code to be penetrated,
just a teeny bit. And what about the code that couldn't be
penetrated anyway, but now has to be slower to protect that little
bit?

> Strategically, we shouldn't let the perfect be the enemy of the good.
> Let's move away from fixating on benchmarks, and just enable easy
> opt-out for the folks who demonstrate performance bottlenecks.

The problem is not that people will choose performance over security,
or the other way around. It's that they don't consider both to be
important in the first place.

>
> I suspect that many kernel-hardening features would have an easier
> time being accepted if it wasn't presented as an all or nothing
> feature.

You're up against the notion that you can ignore one aspect of
the system to enhance another. 

>
> My $0.02.
>
> -- Nick
>
