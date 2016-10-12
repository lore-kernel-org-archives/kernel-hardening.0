Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1476260730.19479.3.camel@cvidal.org>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
 <1476115319.2329.108.camel@cvidal.org> <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
 <1476260730.19479.3.camel@cvidal.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 12 Oct 2016 15:35:37 -0700
Message-ID: <CAGXu5jJEfVn_EGQhZ5Jc8kEUsG2EfN3FmaGvjD9rjK_TBPZbFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] self introduction
To: Colin Vidal <colin@cvidal.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 12, 2016 at 1:25 AM, Colin Vidal <colin@cvidal.org> wrote:
>> > So, I will try to start to port PAX_REFCOUNT arm-specific features
>> > to hardened_atomic_on_next, and keep you in touch. Is there a
>> > deadline?  (4.10 / 5.0 merge window?)
>>
>> You may want to compare notes with Takahiro (CCed) who may have
>> started to look at arm64 (and maybe arm too).
>
> Thanks, I would be grateful!

Here's a thread Takahiro replied to:

http://www.openwall.com/lists/kernel-hardening/2016/10/12/2

>> As for a deadline, as Elena says, we have no specific target. ("As
>> soon as possible.") The only thing around timing that I like to see
>> is persistent progress: if a patch series goes up for review,
>> getting people to take a look at it, ask questions, make comments,
>> and then hopefully within a week or so, the next version comes
>> up. Momentum is easier to maintain than to build. ;)
>
> OK, good! I will have more time to work on it this WE, still I began to
> familiarize myself with atomic_t internals (and PaX patch).
>
> I noticed the build is broken for non-x86 architecture (at least
> arm/arm64), since basically each arch needs to provide atomic_*_wrap()
> functions. Is there plans to have (probably dummies) functions in case
> the architecture does not implements this functionality? I noticed the
> list of define atomic_*_wrap at the end of atomic-long.h, but it does
> not seems to works (they are defined after the call sites in the
> expansion of previous macros).

Yeah, I think this has already come up in the other thread and folks
are fixing (have fixed?) it. I expect to see a v2 RFC soon.

> Apart from that, in case of over-/underflow, hardened_atomic_overflow()
> is called to hang the system if CONFIG_HARDENED_ATOMIC is set. I don't

No, not hang the system, but rather stop further kernel execution and
kill the userspace process.

> get why the test in arch/x86/include/kernel/traps.c
>
>         if (trapnr == X86_TRAP_OF)
>                 hardened_atomic_overflow(regs);
>
> is not guarded by CONFIG_HARDENED_ATOMIC: the trap cannot occurs if
> CONFIG_HARDENED_ATOMIC is unset (since "int" instructions in
> arch/x86/include/asm/atomic.h are guarded by it), and it would avoid
> the other implementation of hardened_atomic_overflow in
> include/asm-generic/bug.h.

The implementation is a static inline with no body, so the compiler
will automatically eliminate the entire "if" statement, since it's a
no-op. This is standard kernel coding style, to make the .c code as
readable as possible. Having it littered with #ifdefs makes things
harder to read.

>> > [1] https://pax.grsecurity.net/pax-linux-3.6-201210022100.patch
>>
>> This is a quite old version of PaX. (Note the date.) If you want to
>> examine PaX separately from Grsecurity (noting differences can be
>> enlightening), check here:
>>
>> https://www.grsecurity.net/~paxguy1/?C=M;O=D
>
> Thanks!

Sure thing! I'm glad to have another set of eyes on this -- it's a
pretty big set of changes. :)

-Kees

-- 
Kees Cook
Nexus Security
