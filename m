MIME-Version: 1.0
In-Reply-To: <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
References: <20180227111532.1144-1-ppandit@redhat.com> <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
From: Nick Kralevich <nnk@google.com>
Date: Fri, 2 Mar 2018 11:52:41 -0800
Message-ID: <CAFJ0LnFEtcWjTf5v1oBK_FC6VTdORpOLyKzzENL3B1bCHz1ySw@mail.gmail.com>
Subject: Re: [PATCH 0/1] Zero initialise kernel stack variables
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: P J P <ppandit@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 27, 2018 at 11:28 AM, Kees Cook <keescook@chromium.org> wrote:
>> This same kernel is running on my F27 test machine as I write this.
>> There is no slowness or notice-able performance impact as such.
>
> Unfortunately "noticeable" isn't going to be a viable metric. You'll
> need to do some real-world benchmarks (i.e. kernel builds, hackbench,
> etc), and compare the results. Even just initializing
> passed-by-reference variables (GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) had
> measurable performance impact.
>
> It would be nice to have four options/features available from the
> compiler, from least to most performance impact:

One of the recurring themes I've noticed from the kernel-hardening
mailing list is that someone will propose a valuable compile time
feature (such as this one), people will ask for performance
measurements, some specific use case will be found which has adverse
performance impact, and the entire change will be rejected. It's
silly.

The beautiful thing about compile time features is that they can be
enabled / disabled per compilation unit. If there's a performance
problem in a certain chunk of code, figure out a way to opt that code
out of the protections. 95% of the performance of the kernel is likely
only dependent on 5% of the code, and even if we opt out that code, we
still protect the remaining 95% of the code. If you assume that bugs
are evenly distributed throughout the code base, a 95% reduction is
HUGE.

Strategically, we shouldn't let the perfect be the enemy of the good.
Let's move away from fixating on benchmarks, and just enable easy
opt-out for the folks who demonstrate performance bottlenecks.

I suspect that many kernel-hardening features would have an easier
time being accepted if it wasn't presented as an all or nothing
feature.

My $0.02.

-- Nick
