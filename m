MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170424104539.qa2jva2jytwboeam@hirez.programming.kicks-ass.net>
References: <20170421220939.GA65363@beast> <20170424104539.qa2jva2jytwboeam@hirez.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Apr 2017 13:19:24 -0700
Message-ID: <CAGXu5jJY2cD=nTVdv9PsAgBaJ-9KMnR5NWFScWmc_KQSSWY01Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/refcount: Implement fast refcount_t handling
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jann Horn <jann@thejh.net>, "David S. Miller" <davem@davemloft.net>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 24, 2017 at 3:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Apr 21, 2017 at 03:09:39PM -0700, Kees Cook wrote:
>> +static __always_inline __must_check bool refcount_inc_not_zero(refcount_t *r)
>> +{
>> +     const int a = 1;
>> +     const int u = 0;
>> +     int c, old;
>> +
>> +     c = atomic_read(&(r->refs));
>> +     for (;;) {
>> +             if (unlikely(c == (u)))
>> +                     break;
>> +             old = atomic_cmpxchg(&(r->refs), c, c + (a));
>
> Please use atomic_try_cmpxchg(), that generates saner code.

Ah-ha, thanks. I actually copied this directly out of the existing
atomic_t function, so we should probably update it there too.

-Kees

>
>> +             if (likely(old == c))
>> +                     break;
>> +             c = old;
>> +     }
>> +     return c != u;
>> +}



-- 
Kees Cook
Pixel Security
