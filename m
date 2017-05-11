MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5913BD52.2305.3F7C9B7B@pageexec.freemail.hu>
References: <1494356483-81678-1-git-send-email-keescook@chromium.org>
 <1494356483-81678-3-git-send-email-keescook@chromium.org> <5913BD52.2305.3F7C9B7B@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 11 May 2017 11:16:14 -0700
Message-ID: <CAGXu5jJK-O91uei8bJeuS7jW5-h0QNsEeCvUXe0+RMuB4Ye7Vw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v4 2/2] x86/refcount: Implement fast refcount overflow protection
To: PaX Team <pageexec@freemail.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 10, 2017 at 6:24 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 9 May 2017 at 12:01, Kees Cook wrote:
>> Various differences from PaX:
>> - uses earlier value reset implementation in assembly
>> - uses UD0 and refcount exception handler instead of new int vector
>> - uses .text.unlikely instead of custom named text sections
>
> all the above together result in bloating .text.unlikely and thus the
> kernel image in general.

O_o how is this any less of a problem than filling a different .text
section with "lea" instructions?

> the much bigger problem is that you introduced
> a vulnerability because now refcount underflow bugs can not only trigger
> a UAF but also a subsequent double-free since decrementing the saturation
> value will not trigger any checks until 0 is reached a second time.

This isn't an "introduced" vulnerability. With or without this patch,
an atomic_t would never stop wrapping. Without a fast refcount_t, most
of the critical parts of the kernel will not convert to refcount_t, so
they'd still be atomic_t. Regardless, you have a valid point about
this where it could be a _better_ protection, but it's not
"introducing" a vulnerability.

>> - applied only to refcount_t, not atomic_t (single size, only overflow)
>
> this description doesn't seem to be in sync with the code as the refcount
> decrementing functions are also instrumented (and introduce the problem
> mentioned above).

Hunh? Decrementing is instrumented to notice the "below 0" cases. It
gives late notification of UAF. Without instrumentation there would be
no notification at all. Neither case protects underflow, just as
you've talked about underflow not be a bug class that can be protected
against.

>> - reorganized refcount error handler
>> - uses "js" instead of "jo" to trap all negative results instead of
>>   just under/overflow transitions
>
> if you're describing differences to PaX in such detail you might as well
> specify which version of PaX it is different from and credit the above idea
> to me lest someone get the impression that it was yours.

I am in a constant no-win situation with regard to giving credit. If I
give too much credit, it's still not specific enough, if I give too
little credit, I'm "stealing". The "v2" delta history (go see the 0/2
email) mentions where "js" came from:

v2:
...
- switch to js; pax-team

>> +static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
>> +{
>> +     int c;
>> +
>> +     c = atomic_read(&(r->refs));
>> +     do {
>> +             if (unlikely(c <= 0))
>> +                     break;
>> +     } while (!atomic_try_cmpxchg(&(r->refs), &c, c + 1));
>> +
>> +     /* Did we start or finish in an undesirable state? */
>> +     if (unlikely(c <= 0 || c + 1 < 0)) {
>
> while -fno-strict-overflow should save you in linux it's still not
> prudent programming to rely on signed overflow, especially in security
> related checks. it's just too fragile and sets a bad example...

Now you're telling me your own suggestion was not prudent? What we
have now and for the foreseeable future is refcount_t being
implemented with int, and that we'll have signed overflow. If that
ever changes, refcount_t would hardly be the only thing affected.

-Kees

-- 
Kees Cook
Pixel Security
