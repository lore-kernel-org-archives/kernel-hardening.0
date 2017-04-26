MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAG48ez0udSMcD2GhgVj4amsqwVJ8qEw31A8SDnDjzgjMjAsHbg@mail.gmail.com>
References: <1493160997-126108-1-git-send-email-keescook@chromium.org>
 <1493160997-126108-3-git-send-email-keescook@chromium.org> <CAG48ez0udSMcD2GhgVj4amsqwVJ8qEw31A8SDnDjzgjMjAsHbg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 25 Apr 2017 20:52:26 -0700
Message-ID: <CAGXu5j+e8u82zjcmhMhvhwgDMyJ4pAsi5vz-Z7J_i42d5nZq3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/2] x86, refcount: Implement fast refcount overflow protection
To: Jann Horn <jannh@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 25, 2017 at 5:25 PM, Jann Horn <jannh@google.com> wrote:
> On Wed, Apr 26, 2017 at 12:56 AM, Kees Cook <keescook@chromium.org> wrote:
>> This protection is a modified version of the x86 PAX_REFCOUNT
>> implementation from PaX/grsecurity. This speeds up the refcount_t API by
>> duplicating the existing atomic_t implementation with a single instruction
>> added to detect if the refcount has wrapped past INT_MAX (or below 0)
>> resulting in a signed value.
> [...]
>> +static __always_inline void refcount_dec(refcount_t *r)
>> +{
>> +       asm volatile(LOCK_PREFIX "decl %0\n\t"
>> +               REFCOUNT_CHECK_UNDERFLOW(4)
>> +               : [counter] "+m" (r->refs.counter)
>> +               : : "cc", "cx");
>> +}
>
> What purpose do checks on decrement now have? The mitigation is only
> intended to deal with (positive) overflows, right? AFAICS if you hit this code,
> similar to the inc-from-0 case, you're already in a UAF situation?

Yeah, I think that's true, but as Peter has mentioned: it's better
than not having it. The inc path can be deterministic, and the dec
path can be lucky? :)

-Kees

-- 
Kees Cook
Pixel Security
