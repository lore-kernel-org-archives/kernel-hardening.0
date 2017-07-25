MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <7e7918c6-7186-47f4-4b37-2fc55db1e678@huawei.com>
References: <1500921349-10803-1-git-send-email-keescook@chromium.org>
 <1500921349-10803-4-git-send-email-keescook@chromium.org> <7e7918c6-7186-47f4-4b37-2fc55db1e678@huawei.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Jul 2017 12:11:08 -0700
Message-ID: <CAGXu5jLD-ju_XHppVgDgUo1eSPoYKMqrzKS0PguvMAt5ddOoOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH v8 3/3] x86/refcount: Implement fast
 refcount overflow protection
To: Li Kun <hw.likun@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 25, 2017 at 5:03 AM, Li Kun <hw.likun@huawei.com> wrote:
> Hi Kees,
>
>
> on 2017/7/25 2:35, Kees Cook wrote:
>>
>> +static __always_inline __must_check
>> +int __refcount_add_unless(refcount_t *r, int a, int u)
>> +{
>> +       int c, new;
>> +
>> +       c = atomic_read(&(r->refs));
>> +       do {
>> +               if (unlikely(c == u))
>> +                       break;
>> +
>> +               asm volatile("addl %2,%0\n\t"
>> +                       REFCOUNT_CHECK_LT_ZERO
>> +                       : "=r" (new)
>> +                       : "0" (c), "ir" (a),
>> +                         [counter] "m" (r->refs.counter)
>> +                       : "cc", "cx");
>> +
>> +       } while (!atomic_try_cmpxchg(&(r->refs), &c, new));
>> +
>> +       return c;
>> +}
>
> here when the result LT_ZERO, you will saturate the r->refs.counter and make
> the
>
> atomic_try_cmpxchg(&(r->refs), &c, new) bound to fail first time.
>
> maybe we can just saturate the value of variable "new" ?

Oh, good catch! Thanks. Actually, it's even worse than that: we'll
exit this function without the refcount being correctly saturated. The
final result will be INT_MIN / 2 + a. It's not terrible, but I should
have noticed this in testing. (There was a gap in my testing for the
_not_zero() overflows, which I've fixed now...)

I'll figure this out or revert to the logic I was using in v6...

-Kees

-- 
Kees Cook
Pixel Security
